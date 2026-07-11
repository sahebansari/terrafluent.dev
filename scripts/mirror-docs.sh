#!/usr/bin/env bash
# Convert downloaded GitHub docs into Jekyll pages under docs/html/ and docs/docx/,
# generate _data/docs.yml and llms-full.txt.
set -euo pipefail

SCRATCH="${TMPDIR:-/tmp}/terrafluent-docs"  # downloaded repo docs go here (see download step below)
SITE="$(cd "$(dirname "$0")/.." && pwd)"
HTML_REPO="https://github.com/sahebansari/TerraFluent.Html.Reporting"
DOCX_REPO="https://github.com/sahebansari/TerraFluent.Docx.Reporting"

mkdir -p "$SITE/docs/html" "$SITE/docs/docx"

DATA_YML="$SITE/_data/docs.yml"
LLMS_FULL="$SITE/llms-full.txt"

echo "# Docs navigation — generated from the library repos' docs folders." > "$DATA_YML"
echo "html:" >> "$DATA_YML"

cat > "$LLMS_FULL" <<'EOF'
# TerraFluent — Full Documentation
# Fluent report generation for .NET: print-ready paginated HTML (TerraFluent.Html.Reporting)
# and native Word .docx documents (TerraFluent.Docx.Reporting). MIT licensed.
# Site: https://terrafluent.dev/

EOF

# ---------- helpers ----------
extract_title () { # first H1
  grep -m1 '^# ' "$1" | sed 's/^# //; s/"/\\"/g'
}

extract_desc () { # first prose paragraph, joined to one line
  awk '
    /^# /        { seen=1; next }
    !seen        { next }
    inpara && /^\s*$/ { exit }
    /^\s*$/      { next }
    /^#/         { if (inpara) exit; next }
    /^```/       { if (inpara) exit; next }
    /^\|/        { if (inpara) exit; next }
    /^\[Documentation Home\]/ { next }
    /^>/         { if (inpara) exit; next }
    /^[-*] /     { if (inpara) exit; next }
    { inpara=1; printf "%s ", $0 }
  ' "$1" | sed 's/\\/\\\\/g; s/`//g; s/\[\([^]]*\)\]([^)]*)/\1/g; s/"/\\"/g; s/ *$//' | cut -c1-230
}

# ---------- HTML Reporting docs ----------
declare -A HTML_FILES=(
  [01-getting-started]=getting-started
  [02-core-concepts]=core-concepts
  [03-content-elements]=content-elements
  [04-styling]=styling
  [05-tables]=tables
  [06-rows-and-columns]=rows-and-columns
  [07-pagination-and-layout]=pagination-and-layout
  [08-rendering]=rendering
  [09-text-measurement]=text-measurement
  [10-cookbook]=cookbook
  [11-extending]=extending
  [12-faq-troubleshooting]=faq-troubleshooting
)
HTML_ORDER=(01-getting-started 02-core-concepts 03-content-elements 04-styling 05-tables 06-rows-and-columns 07-pagination-and-layout 08-rendering 09-text-measurement 10-cookbook 11-extending 12-faq-troubleshooting)

for f in "${HTML_ORDER[@]}"; do
  slug="${HTML_FILES[$f]}"
  src="$SCRATCH/docs-html/$f.md"
  out="$SITE/docs/html/$slug.md"
  title="$(extract_title "$src")"
  desc="$(extract_desc "$src")"

  body="$(sed -E \
    -e 's|\]\(([0-9]{2})-([a-z0-9-]+)\.md(#[^)]*)?\)|](/docs/html/\2/\3)|g' \
    -e "s|\]\(\.\./|]($HTML_REPO/blob/master/|g" \
    "$src")"

  {
    printf -- '---\n'
    printf 'layout: doc\n'
    printf 'title: "%s — C# HTML Report Generator Docs"\n' "$title"
    printf 'description: "%s"\n' "$desc"
    printf 'permalink: /docs/html/%s/\n' "$slug"
    printf 'doc_section: HTML Reporting docs\n'
    printf 'doc_section_url: /docs/\n'
    printf 'doc_nav: html\n'
    printf 'source_url: %s/blob/master/docs/%s.md\n' "$HTML_REPO" "$f"
    printf -- '---\n\n'
    printf '%s\n' "$body"
  } > "$out"

  printf '  - title: "%s"\n    url: /docs/html/%s/\n' "$title" "$slug" >> "$DATA_YML"

  {
    printf '\n\n====================================================================\n'
    printf 'TerraFluent.Html.Reporting — %s\n' "$title"
    printf 'URL: https://terrafluent.dev/docs/html/%s/\n' "$slug"
    printf '====================================================================\n\n'
    printf '%s\n' "$body"
  } >> "$LLMS_FULL"

  echo "html: $slug <- $f ('$title')"
done

# ---------- DOCX Reporting docs ----------
echo "docx:" >> "$DATA_YML"

declare -A DOCX_FILES=(
  [GETTING_STARTED]=getting-started
  [CORE_CONCEPTS]=core-concepts
  [FEATURES]=features
  [API]=api
  [SAMPLES]=samples
  [TROUBLESHOOTING]=troubleshooting
)
DOCX_ORDER=(GETTING_STARTED CORE_CONCEPTS FEATURES API SAMPLES TROUBLESHOOTING)

for f in "${DOCX_ORDER[@]}"; do
  slug="${DOCX_FILES[$f]}"
  src="$SCRATCH/docs-docx/$f.md"
  out="$SITE/docs/docx/$slug.md"
  title="$(extract_title "$src")"
  desc="$(extract_desc "$src")"

  body="$(sed -E \
    -e '/^\[Documentation Home\]/d' \
    -e 's|\]\(GETTING_STARTED\.md(#[^)]*)?\)|](/docs/docx/getting-started/\1)|g' \
    -e 's|\]\(CORE_CONCEPTS\.md(#[^)]*)?\)|](/docs/docx/core-concepts/\1)|g' \
    -e 's|\]\(FEATURES\.md(#[^)]*)?\)|](/docs/docx/features/\1)|g' \
    -e 's|\]\(API\.md(#[^)]*)?\)|](/docs/docx/api/\1)|g' \
    -e 's|\]\(SAMPLES\.md(#[^)]*)?\)|](/docs/docx/samples/\1)|g' \
    -e 's|\]\(TROUBLESHOOTING\.md(#[^)]*)?\)|](/docs/docx/troubleshooting/\1)|g' \
    -e 's|\]\(README\.md\)|](/docs/)|g' \
    -e "s|\]\(RELEASE\.md\)|]($DOCX_REPO/blob/master/docs/RELEASE.md)|g" \
    -e "s|\]\(\.\./|]($DOCX_REPO/blob/master/|g" \
    "$src")"

  {
    printf -- '---\n'
    printf 'layout: doc\n'
    printf 'title: "%s — C# Word Document Library Docs"\n' "$title"
    printf 'description: "%s"\n' "$desc"
    printf 'permalink: /docs/docx/%s/\n' "$slug"
    printf 'doc_section: DOCX Reporting docs\n'
    printf 'doc_section_url: /docs/\n'
    printf 'doc_nav: docx\n'
    printf 'source_url: %s/blob/master/docs/%s.md\n' "$DOCX_REPO" "$f"
    printf -- '---\n\n'
    printf '%s\n' "$body"
  } > "$out"

  printf '  - title: "%s"\n    url: /docs/docx/%s/\n' "$title" "$slug" >> "$DATA_YML"

  {
    printf '\n\n====================================================================\n'
    printf 'TerraFluent.Docx.Reporting — %s\n' "$title"
    printf 'URL: https://terrafluent.dev/docs/docx/%s/\n' "$slug"
    printf '====================================================================\n\n'
    printf '%s\n' "$body"
  } >> "$LLMS_FULL"

  echo "docx: $slug <- $f ('$title')"
done

echo "DONE. _data/docs.yml + $(ls "$SITE"/docs/html | wc -l) html docs + $(ls "$SITE"/docs/docx | wc -l) docx docs + llms-full.txt ($(wc -l < "$LLMS_FULL") lines)"
