# QA Handover: <feature name>

Filled in by the developer (or developer agent) when a change is ready to test. The `browser-qa` skill runs exactly what is written here and returns a pass/fail checklist, so write every case so that someone who did not build the feature can run it. Do not put passwords in this document.

## 1. Summary
| Field | Value |
|---|---|
| Feature | <one line: what it does for the user> |
| Branch | <branch name> |
| Commit(s) | <short SHAs or pull request number> |
| Developer | <name or agent> |
| Date | <yyyy-mm-dd> |
| Type | Enhancement / Bug Fix / Hotfix / Patch / Feature / UIUX |

**What changed, in plain words** (3 to 5 lines): <what the user will now see or be able to do, and what stays the same>.

## 2. Environment and setup
- **Run on:** local dev (<frontend URL>, <API URL>, dev database).
- **Database scripts that must already be applied on dev:** <script names in run order, or none>.
- **Configuration or feature flags needed:** <settings, or none>.
- **Other services needed:** <cache, queue, third-party services, or none>.
- **Real outbound messages:** <may the test send real email, SMS or chat messages? yes or no; if yes, to which test recipient>.

## 3. Accounts and roles
Logins are held by the QA skill. List which role each case needs; do not write credentials here.

| Role | Scope (brand, tenant, team) | What this role should be able to do in this feature |
|---|---|---|
| <role> | <scope> | <for example: see all, add, edit, delete> |
| <lower role> | <scope> | <for example: own scope only, view only> |

If a case needs another role or an account in a specific state, say so under Test data.

## 4. Test data
| Item | Where / how to find it | Notes |
|---|---|---|
| <item> | <menu path or id> | <state it must be in> |

- **Created by the tests:** prefix names with the test prefix so they can be found and removed.
- **Must not be touched:** <records that must stay unchanged>.
- **Clean up:** <what to remove afterwards, or leave in place>.

## 5. Test cases
One block per case, numbered TC-01, TC-02, and so on, in the order to run them. One thing per case. Put the exact expected result, not just works.

### TC-01: <short name>
- **Role:** <role>
- **Priority:** High / Medium / Low
- **Depends on:** <TC id, or none>
- **Preconditions:** <state required before step 1>
- **Steps:**
  1. <go to menu > page, or URL path>
  2. <click, enter or select exactly this, with the exact value>
  3. <...>
- **Expected result:**
  - <what is shown: exact text, count, order, state, colour, URL>
  - <what is saved or changed, and where to see it>
- **Not expected:** <what must NOT happen, for example no error message, no other tenant's rows>
- **Notes:** <optional hints, known quirks>

Cover, where they apply: the normal path; each role in section 3 including what is hidden or disabled for a lower role; validation and error messages (empty, too long, duplicate, invalid); empty, loading and error states; each filter or option alone and combined, and clearing them; saving, editing, deleting, and that the change shows after a reload; unchanged behavior next to the change (section 6).

## 6. Regression checks
| # | Check | Expected |
|---|---|---|
| R-01 | <existing behavior this change could break> | <result> |

## 7. Out of scope and known issues
- **Not part of this change:** <what not to test>.
- **Known issues or limits:** <already known, so not reported again>.
- **Cannot be tested in the browser:** <needs a real device, production data, and so on>.

## 8. Developer checks already done
<build, type-check, unit tests, manual checks, with the result of each>.

## 9. Open questions for QA
<anything the developer wants looked at>.
