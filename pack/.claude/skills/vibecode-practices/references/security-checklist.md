# Extended security checklist

Use when designing or reviewing anything that touches auth, money, uploads or third-party input. The MUST rules are in `SKILL.md` section 4.

**Web attacks:** SQL Injection, XSS, CSRF, CORS, SSRF, IDOR, Path Traversal, Mass Assignment, Clickjacking, Content Security Policy, Security Headers, Input Validation, Server-Side Authorization

**Access control and secrets:** Row-Level Security, Least Privilege, RBAC, Secrets Management, `.env` in `.gitignore`, API Key Rotation, Secret Scanning

**Passwords and crypto:** Hashing vs Encryption, Password Salting, bcrypt and Argon2, Encryption at Rest, TLS Certificate Expiry, HSTS

**Sessions and identity:** JWT Expiry, Refresh Tokens, OAuth 2.0, OpenID Connect, Session Fixation, MFA, Brute Force Protection, Account Enumeration, Timing Attacks

**Uploads and integrations:** File Upload Validation, Webhook Signature Verification (required for Stripe)

**Supply chain and planning:** Dependency Vulnerabilities, Supply Chain Attacks, Threat Modeling
