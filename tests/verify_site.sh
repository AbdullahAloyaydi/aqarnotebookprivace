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
