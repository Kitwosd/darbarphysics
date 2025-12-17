# durbar_physics – Repository & CI/CD Documentation

This document explains how the `durbar_physics` repository is structured, how CI/CD works, and what rules developers must follow when contributing. It is designed for developers, QA, and maintainers.

## 1. Project Overview
*   **Purpose**: An e-learning platform to deliver high-quality physics courses to students.
*   **Tech Stack**:
    *   **Framework**: Flutter
    *   **State Management**: Bloc / Cubit
    *   **Architecture**: Clean Architecture
    *   **CI/CD**: GitHub Actions

## 2. Repository Structure
*   `lib/` -> Application source code (Features, Core, etc.)
*   `test/` -> Unit & widget tests
*   `.github/` -> CI/CD workflows & GitHub configs
*   `.env.example` -> Environment variable template (Copy to `.env`)
*   `analysis_options.yaml` -> Linter rules configuration

## 3. Branching Strategy
We strictly follow a feature-branch workflow to ensure stability.

### Branches Used
*   `main` -> **Stable / Production**. Protected branch. No direct pushes allowed.
*   `feature/*` -> Feature-specific work (e.g., `feature/login-screen`, `feature/video-player`).
*   `fix/*` -> Bug fixes (e.g., `fix/login-crash`).

### Rules
*   **No direct push to `main`**.
*   All changes must go through a **Pull Request (PR)**.
*   **CI must pass** before merging.

## 4. Commit Message Convention
We use semantic commit messages to keep the history clear and readable.

### Format Examples
*   `feat: add video player controls` (New features)
*   `fix: resolve login crash` (Bug fixes)
*   `ui: improve course card layout` (Visual changes only)
*   `chore: update CI configuration` (Maintenance, deps, config)

## 5. Environment Variables & Secrets
### Local Development
1.  Copy `.env.example`.
2.  Rename it to `.env`.
3.  Fill in the required values (Base URL, etc.).

### CI/CD
*   Secrets (like API keys) are stored in **GitHub Repository Secrets**.
*   The `.env` file is generated securely during the CI build process.

## 6. CI/CD Pipeline
Our CI pipeline helps us catch bugs automatically before code is merged.

### When CI Runs
*   On **Pull Requests** targeting `main`.
*   On **Code Merge** to `main`.

### Steps
1.  **Analyze**: verification (`flutter analyze`) to find bugs & lint issues.
2.  **Format**: style check (`dart format`) to enforce code style.
3.  **Test**: verification (`flutter test`) to ensure app stability.
4.  **Build**: checks for build errors (Runs only on `main` OR if PR title has `[build]`).

## 7. Pull Request Workflow
### How to raise a PR
1.  Create a feature branch from `main`.
2.  Push your changes to origin.
3.  Open a Pull Request (PR) to `main`.
4.  Wait for CI to pass.
5.  Request review (or self-approve if you are the owner).
6.  Merge after approval and CI success.

### Review Rules
*   **Self-approval** is allowed for solo developers.
*   **CI must pass** (Green checkmark) before merging.

## 8. Code Quality Rules
We enforce a pragmatic set of lint rules to keep code clean without slowing you down.

### Linter Rules Used
*   `avoid_print`: true (Use `Logger` instead of print)
*   `sort_imports`: true (Keeps file headers clean)
*   *Note: Stricter rules (like `prefer_const`) will be added later.*

## 9. Testing Strategy
### Current Scope
*   **Smoke Test**: Minimal testing (e.g., App Launch).
*   **No Coverage Target**: We focus on development velocity right now.

### Why
*   Ensures the pipeline works and the app builds, without burdening the early-stage development with heavy test maintenance.

## 10. Security Practices
### What is Protected
*   `.env` is ignored in git.
*   Force-push is **disabled** on `main`.
*   Branch deletion is **disabled** on `main`.

### What NOT to do
*   **Never** commit API keys or secrets to the repo.
*   **Never** bypass CI checks.

## 11. Common Mistakes & Notes
*   **Formatting**: If CI fails on "Format", run `dart format .` locally.
*   **Imports**: If CI fails on "Analyze", check your import sorting.

## 12. Future Improvements
*   Release Pipeline (Auto-build APKs).
*   Stricter Lints (`very_good_analysis`).
*   Multiple Reviewers requirement.
