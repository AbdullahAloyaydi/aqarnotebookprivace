# Aqar Notebook Support Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish an Arabic-first support and privacy mini-site for Aqar Notebook at the repository's GitHub Pages URL.

**Architecture:** Use two semantic static HTML documents with one shared CSS file and one local app-icon asset. Keep the site dependency-free and JavaScript-free so it has no tracking surface, remains fast on old phones, and can be hosted directly from the `main` branch root.

**Tech Stack:** HTML5, CSS3, Bash verification, Python standard-library HTTP server, GitHub Pages.

---

## File map

- `index.html`: official Arabic support page, usage guide, FAQ, and contact action.
- `privacy.html`: full Arabic privacy policy plus concise English summary.
- `styles.css`: shared RTL-first responsive visual system and accessibility states.
- `assets/aqar-notebook-icon.png`: self-hosted 1024 px application icon copied from the released iOS asset.
- `.nojekyll`: forces direct static-file serving.
- `tests/verify_site.sh`: deterministic content, link, privacy, and dependency checks.
- `README.md`: public repository purpose and final App Store URLs.

### Task 1: Add a failing static-site contract

**Files:**
- Create: `tests/verify_site.sh`

- [ ] **Step 1: Write the executable verification script**

```bash
#!/usr/bin/env bash
set -euo pipefail

for file in index.html privacy.html styles.css .nojekyll assets/aqar-notebook-icon.png; do
  test -f "$file" || { echo "Missing $file"; exit 1; }
done

grep -q '<html lang="ar" dir="rtl">' index.html
grep -q '<html lang="ar" dir="rtl">' privacy.html
grep -q 'دفتر العقار' index.html
grep -q 'سياسة الخصوصية' privacy.html
grep -q 'abdullah.aloyaydi.cs@gmail.com' index.html
grep -q 'abdullah.aloyaydi.cs@gmail.com' privacy.html
grep -q 'privacy.html' index.html
grep -q 'index.html' privacy.html
grep -q 'لا يجمع' privacy.html
grep -q 'محلي' privacy.html
grep -q 'الموقع' privacy.html
grep -q 'الصور' privacy.html
grep -q 'المشاركة' privacy.html
grep -q 'النسخ الاحتياطي' privacy.html

if grep -REn '<script|https?://[^"[:space:]]+\.(js|css|woff2?)' index.html privacy.html styles.css; then
  echo 'Unexpected executable or remote dependency'
  exit 1
fi

echo 'Static-site contract passed.'
```

- [ ] **Step 2: Make it executable**

Run: `chmod +x tests/verify_site.sh`

- [ ] **Step 3: Run it and verify the contract fails before implementation**

Run: `bash tests/verify_site.sh`

Expected: `Missing index.html` and exit code 1.

- [ ] **Step 4: Commit the failing contract**

```bash
git add tests/verify_site.sh
git commit -m "test: define support site contract"
```

### Task 2: Build the shared visual foundation

**Files:**
- Create: `styles.css`
- Create: `assets/aqar-notebook-icon.png`
- Create: `.nojekyll`

- [ ] **Step 1: Copy the released application icon**

Run:

```bash
mkdir -p assets
cp /Users/abdullah/aqar-notebook/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png assets/aqar-notebook-icon.png
```

Expected SHA-256: `fce94cf843ec68cb8b5a55183c53d5420d53a27c9dcf2ce2327d1d2155879a65`.

- [ ] **Step 2: Add the static-hosting marker**

Create the empty `.nojekyll` file.

- [ ] **Step 3: Implement the shared stylesheet**

Define these exact design tokens and component responsibilities in `styles.css`:

```css
:root {
  color-scheme: light;
  --ink: #17352a;
  --muted: #5d6d66;
  --green: #0e5a3a;
  --green-dark: #08452c;
  --gold: #c49a45;
  --paper: #f7f4ee;
  --surface: #ffffff;
  --line: #dbe4df;
  --shadow: 0 18px 55px rgba(14, 90, 58, 0.10);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Tahoma, Arial, sans-serif;
}
```

Use a centered `72rem` shell, a two-column hero that collapses below `760px`, `1.75rem` section headings, minimum `48px` links/buttons, visible `:focus-visible` outlines, readable `1.8` Arabic line height, and a `prefers-reduced-motion` rule that removes transitions. Do not hide overflow, clamp font scaling, load web fonts, or add gradients/glow.

- [ ] **Step 4: Commit the foundation**

```bash
git add .nojekyll assets/aqar-notebook-icon.png styles.css
git commit -m "style: add Aqar Notebook web identity"
```

### Task 3: Implement the support page

**Files:**
- Create: `index.html`

- [ ] **Step 1: Add semantic metadata and header**

Use `lang="ar"`, `dir="rtl"`, UTF-8, responsive viewport, title `دعم دفتر العقار`, description `الدعم الرسمي لتطبيق دفتر العقار` and the local app icon. Header navigation must link to `#guide`, `#faq`, `#contact`, and `privacy.html`.

- [ ] **Step 2: Add the support content**

Include visible Arabic sections for:

- A hero stating `سجّل العقار. ارجع له بسرعة. وشارك نسخة مرتبة.`
- Trust facts: `يعمل بدون حساب`, `بياناتك على جهازك`, and `مصمم للجوال`.
- Five usage steps: add a property, let autosave work, search later, open the saved location, and share text/PDF.
- FAQ answers covering autosave, offline operation, location denial, image storage, changing phones, backup safety, and deletion.
- A prominent `mailto:abdullah.aloyaydi.cs@gmail.com?subject=دعم%20تطبيق%20دفتر%20العقار` contact button, plus a request to include device type, OS version, app version, and a concise problem description.
- A short privacy summary and link to `privacy.html`.

Use semantic `<header>`, `<nav>`, `<main>`, `<section>`, `<details>`, and `<footer>` elements. Every icon image must have useful Arabic alt text.

- [ ] **Step 3: Confirm the support assertions pass**

Run: `bash tests/verify_site.sh`

Expected: it advances past the support assertions and fails only if `privacy.html` is still missing.

- [ ] **Step 4: Commit the support page**

```bash
git add index.html
git commit -m "feat: add Arabic support page"
```

### Task 4: Implement the privacy page and public documentation

**Files:**
- Create: `privacy.html`
- Create: `README.md`

- [ ] **Step 1: Add the privacy policy**

Use the title `سياسة خصوصية دفتر العقار` and effective date `٣ سبتمبر ٢٠٢٦`. State explicitly that V1 has no account, advertising, analytics, tracking, or developer server; describe local property/contact/note/image storage; just-in-time foreground location; user-triggered camera/library access; locally generated PDFs and backups; OS share-sheet disclosure; retention/deletion; OS-level device backup; children; future changes; and contact at `abdullah.aloyaydi.cs@gmail.com`.

Include an English summary that conveys the same collection, local-storage, permissions, sharing, backup, deletion, and contact facts without adding promises absent from the Arabic policy.

- [ ] **Step 2: Add repository documentation**

`README.md` must identify the repository as the official static support/privacy site and list:

```text
Support: https://abdullahaloyaydi.github.io/aqarnotebookprivace/
Privacy: https://abdullahaloyaydi.github.io/aqarnotebookprivace/privacy.html
```

- [ ] **Step 3: Run the complete contract**

Run: `bash tests/verify_site.sh`

Expected: `Static-site contract passed.`

- [ ] **Step 4: Commit the privacy page and documentation**

```bash
git add privacy.html README.md
git commit -m "feat: add Aqar Notebook privacy policy"
```

### Task 5: Validate visual behavior and publish

**Files:**
- Modify only files found defective during verification.

- [ ] **Step 1: Run a local static server**

Run: `python3 -m http.server 4173 --bind 127.0.0.1`

Expected: both `/` and `/privacy.html` return HTTP 200.

- [ ] **Step 2: Inspect mobile and desktop rendering**

Verify both pages at 320×700, 430×932, and desktop width. Confirm no horizontal overflow, clipped Arabic, inaccessible focus state, missing image, broken internal link, or console error.

- [ ] **Step 3: Run final repository checks**

Run:

```bash
bash tests/verify_site.sh
git diff --check
git status --short --branch
```

Expected: the contract passes, no whitespace errors exist, and the worktree is clean after any final fix commit.

- [ ] **Step 4: Push the `main` branch**

Run: `git push -u origin main`

Expected: GitHub accepts the new branch and commits.

- [ ] **Step 5: Enable GitHub Pages**

Configure Pages to build from branch `main`, path `/`, then wait for deployment completion.

- [ ] **Step 6: Verify the public URLs**

Run:

```bash
curl -I https://abdullahaloyaydi.github.io/aqarnotebookprivace/
curl -I https://abdullahaloyaydi.github.io/aqarnotebookprivace/privacy.html
```

Expected: both return HTTP 200 over HTTPS. Open both URLs and verify the published page content matches the committed version.
