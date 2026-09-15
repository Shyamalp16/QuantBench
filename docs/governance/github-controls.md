# GitHub Repository Controls

Apply a repository ruleset to `master` after the Phase 1 acceptance merge:

- require pull requests with one approving review and CODEOWNER approval;
- dismiss stale approvals and require all conversations resolved;
- require signed commits and linear history;
- require `quality`, `security`, `contract-compatibility`, and `signed-msi` checks;
- block force pushes and branch deletion;
- do not grant a routine bypass role;
- protect `phase-*` and `v*` tag creation/deletion;
- enable secret scanning, push protection, Dependabot alerts/updates, and private vulnerability reporting.

With the approved solo pre-live model, these settings intentionally block later protected merges until an independent collaborator is added. Emergency changes cannot weaken these settings without an approved change request.

