#!/usr/bin/env bash
# Database helper for several environments (SQL Server via sqlcmd). Credentials come from
# environments.local.conf next to this file (or the file named in DB_ENV_CONF) and are never printed.
#
#   bash .claude/skills/db-access/db.sh <env|all> [flags] <command> [args]
#   bash .claude/skills/db-access/db.sh dev "SELECT TOP 5 Id, Name FROM dbo.Items WITH (NOLOCK)"
#   bash .claude/skills/db-access/db.sh staging -f scripts/patch.sql --write --confirm-env staging
#
# Commands: whoami | tables [pattern] | columns <table> | procs [pattern] | params <proc> | proc <name>
#           find <pattern> | refs <object> | count <table> | sample <table> <cols> [n] | compare <object>
#           or raw SQL text.
# Flags:    --db <name>          database (default: the environment's own)
#           -f <file.sql>        run a script file
#           --write              allow statements that change data or schema
#           --confirm-env <env>  needed with --write when the environment's policy is confirm
#           --allow-sensitive    let sample select password, token, secret, phone, email, config columns
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${DB_ENV_CONF:-$HERE/environments.local.conf}"

die()   { echo "[db] $1" >&2; exit "${2:-2}"; }
usage() { sed -n '2,17p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' >&2; exit 2; }

[ -f "$CONF" ] || die "missing $CONF. Copy environments.example.conf to environments.local.conf and fill it in."

conf_get() { # alias key
  grep -E "^$1\.$2=" "$CONF" | head -1 | sed -E "s/^$1\.$2=//" | sed -E 's/[[:space:]]+#.*$//' | tr -d '\r'
}
env_names() { grep -E '^[A-Za-z0-9_-]+\.server=' "$CONF" | sed -E 's/\.server=.*//' | tr '\n' ' '; }

load_conn() {
  ENV_NAME="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  SRV="$(conf_get "$ENV_NAME" server)"; USR="$(conf_get "$ENV_NAME" user)"
  PW="$(conf_get "$ENV_NAME" password)"; DBDEF="$(conf_get "$ENV_NAME" database)"
  POLICY="$(conf_get "$ENV_NAME" write)"; POLICY="${POLICY:-confirm}"
  [ -n "$SRV" ] && [ -n "$USR" ] && [ -n "$PW" ] || die "environment '$1' is not fully configured. Known: $(env_names)"
}

guard() { # sql text
  local up writes=0; up="$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]')"
  printf '%s' "$up" | grep -Eq '\b(INSERT|UPDATE|DELETE|DROP|ALTER|TRUNCATE|CREATE|MERGE|GRANT|REVOKE|DENY|XP_CMDSHELL|SHUTDOWN)\b' && writes=1
  if printf '%s' "$up" | grep -Eq '\bEXEC(UTE)?\b'; then
    # read-style procedures; adjust to your naming
    printf '%s' "$up" | grep -Eq '\bEXEC(UTE)?[[:space:]]+([A-Z0-9_]+\.)?([A-Z]+_)?(GET|FIND|SEARCH|LIST|SP_HELP|SP_COLUMNS|SP_TABLES)' || writes=1
  fi
  [ "$writes" = 1 ] || return 0
  [ "$POLICY" != never ] || die "writes are refused on '$ENV_NAME' (policy: never)." 5
  [ "$WRITE" = 1 ] || die "this looks like a write. Read-only by default. Re-run with --write only if the user asked for it." 3
  if [ "$POLICY" = confirm ] && [ "$CONFIRM" != "$ENV_NAME" ]; then
    die "writes on '$ENV_NAME' need --confirm-env $ENV_NAME, passed only after the user confirms." 4
  fi
}

mode_label() { [ "$WRITE" = 1 ] && echo write || echo read-only; }
dbname()     { echo "${DB_OVERRIDE:-$DBDEF}"; }

run_sql() { # env sql [extra sqlcmd flags]
  load_conn "$1"; guard "$2"
  >&2 echo "[db] env=$ENV_NAME server=$SRV db=$(dbname) mode=$(mode_label)"
  # shellcheck disable=SC2086
  SQLCMDPASSWORD="$PW" sqlcmd -S "$SRV" -d "$(dbname)" -U "$USR" -C -l 15 -b -W -w 400 ${3:-} -Q "SET NOCOUNT ON; $2" | tr -d '\r'
}

run_file() { # env file
  local file="$2"; [ -f "$file" ] || die "file not found: $file"
  load_conn "$1"; guard "$(cat "$file")"
  >&2 echo "[db] env=$ENV_NAME server=$SRV db=$(dbname) mode=$(mode_label) file=$(basename "$file")"
  ( cd "$(dirname "$file")" && SQLCMDPASSWORD="$PW" sqlcmd -S "$SRV" -d "$(dbname)" -U "$USR" -C -l 15 -b -w 400 -i "$(basename "$file")" ) | tr -d '\r'
}

ident() { printf '%s' "$1" | grep -Eq '^[][A-Za-z0-9_.%]+$' || die "unsafe name: $1"; printf '%s' "$1"; }

[ $# -ge 1 ] || usage
TARGET="$1"; shift
DB_OVERRIDE=""; WRITE=0; CONFIRM=""; FILE=""; SENSITIVE=0; POS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --db) DB_OVERRIDE="$2"; shift 2 ;;
    -f) FILE="$2"; shift 2 ;;
    --write) WRITE=1; shift ;;
    --confirm-env) CONFIRM="$(echo "$2" | tr '[:upper:]' '[:lower:]')"; shift 2 ;;
    --allow-sensitive) SENSITIVE=1; shift ;;
    -h|--help) usage ;;
    *) POS+=("$1"); shift ;;
  esac
done

if [ -n "$FILE" ]; then
  [ "$TARGET" != all ] || die "-f needs one environment, not all"
  run_file "$TARGET" "$FILE"; exit $?
fi
[ ${#POS[@]} -ge 1 ] || usage
CMD="${POS[0]}"; A1="${POS[1]:-}"; A2="${POS[2]:-}"; A3="${POS[3]:-}"

sql_for() {
  case "$CMD" in
    whoami)  echo "SELECT @@SERVERNAME AS server, DB_NAME() AS db, SUSER_SNAME() AS login_name, CONVERT(varchar(19), GETDATE(), 120) AS server_time" ;;
    tables)  local p; p="$(ident "${A1:-}")"
             echo "SELECT s.name + '.' + t.name AS [table], SUM(p.rows) AS [rows] FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1) WHERE t.name LIKE N'%$p%' GROUP BY s.name, t.name ORDER BY 1" ;;
    columns) local t; t="$(ident "${A1:?columns needs a table name}")"
             echo "SELECT c.column_id AS [#], c.name, TYPE_NAME(c.user_type_id) + CASE WHEN c.max_length = -1 THEN '(max)' WHEN TYPE_NAME(c.user_type_id) LIKE '%char' THEN '(' + CAST(CASE WHEN TYPE_NAME(c.user_type_id) LIKE 'n%' THEN c.max_length/2 ELSE c.max_length END AS varchar(10)) + ')' ELSE '' END AS type, c.is_nullable AS nullable FROM sys.columns c WHERE c.object_id = OBJECT_ID(N'$t') ORDER BY c.column_id" ;;
    procs)   local p; p="$(ident "${A1:-}")"
             echo "SELECT name, CONVERT(varchar(19), modify_date, 120) AS modified FROM sys.procedures WHERE name LIKE N'%$p%' ORDER BY name" ;;
    params)  local n; n="$(ident "${A1:?params needs a procedure name}")"
             echo "SELECT p.parameter_id AS [#], p.name, TYPE_NAME(p.user_type_id) AS type, p.is_output AS output FROM sys.parameters p WHERE p.object_id = OBJECT_ID(N'$n') ORDER BY p.parameter_id" ;;
    proc)    local n; n="$(ident "${A1:?proc needs a procedure name}")"
             echo "SELECT OBJECT_DEFINITION(OBJECT_ID(N'$n')) AS definition" ;;
    find)    local p; p="$(ident "${A1:?find needs a pattern}")"
             echo "SELECT 'object' AS kind, name, type_desc AS detail FROM sys.objects WHERE name LIKE N'%$p%' AND type IN ('U','P','FN','IF','TF') UNION ALL SELECT 'column', OBJECT_NAME(c.object_id) + '.' + c.name, TYPE_NAME(c.user_type_id) FROM sys.columns c JOIN sys.objects o ON o.object_id = c.object_id AND o.type = 'U' WHERE c.name LIKE N'%$p%' ORDER BY 1, 2" ;;
    refs)    local n; n="$(ident "${A1:?refs needs an object name}")"
             echo "SELECT o.name AS referenced_by, o.type_desc FROM sys.objects o WHERE o.type IN ('P','FN','IF','TF') AND OBJECT_DEFINITION(o.object_id) LIKE N'%$n%' ORDER BY o.name" ;;
    count)   local t; t="$(ident "${A1:?count needs a table name}")"
             echo "SELECT COUNT(*) AS n FROM $t WITH (NOLOCK)" ;;
    sample)  local t c n; t="$(ident "${A1:?sample needs a table name}")"
             c="${A2:?sample needs a column list, for example Id,Name}"; n="${A3:-5}"
             printf '%s' "$c" | grep -Eq '^[][A-Za-z0-9_,. ]+$' || die "unsafe column list (no * and no expressions)"
             if [ "$SENSITIVE" != 1 ] && printf '%s' "$c" | grep -Eiq 'password|passwd|token|secret|apikey|api_key|configuration|phone|email|hash|salt'; then
               die "column list includes sensitive columns. Pick other columns, or add --allow-sensitive only if the user asked."
             fi
             printf '%s' "$n" | grep -Eq '^[0-9]{1,3}$' || die "row count must be a number up to 999"
             echo "SELECT TOP ($n) $c FROM $t WITH (NOLOCK) ORDER BY 1 DESC" ;;
    *)       echo "${POS[*]}" ;;
  esac
}

compare_sql() {
  local n; n="$(ident "${A1:?compare needs an object name}")"
  echo "SELECT o.name, o.type_desc, CONVERT(varchar(19), o.modify_date, 120) AS modified, CONVERT(varchar(12), HASHBYTES('SHA2_256', REPLACE(REPLACE(REPLACE(OBJECT_DEFINITION(o.object_id), CHAR(13), ''), CHAR(10), ''), ' ', '')), 2) AS def_hash FROM sys.objects o WHERE o.name = N'$n'"
}

if [ "$TARGET" = all ]; then
  case "$CMD" in whoami|compare) ;; *) die "all works only with whoami and compare" ;; esac
  for e in $(env_names); do
    echo "== $e =="
    if [ "$CMD" = compare ]; then out="$(run_sql "$e" "$(compare_sql)" 2>/dev/null)"; else out="$(run_sql "$e" "$(sql_for)" 2>/dev/null)"; fi
    [ -n "$out" ] && echo "$out" || echo "(nothing returned: object missing or not reachable)"
  done
  exit 0
fi

EXTRA=""; [ "$CMD" = proc ] && EXTRA="-y 0"
if [ "$CMD" = compare ]; then run_sql "$TARGET" "$(compare_sql)"; else run_sql "$TARGET" "$(sql_for)" "$EXTRA"; fi
