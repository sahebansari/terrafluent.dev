#!/usr/bin/env bash
# Convert downloaded GitHub docs into Jekyll pages under docs/html/, docs/docx/,
# and docs/pdf/, generate _data/docs.yml and llms-full.txt.
set -euo pipefail

SCRATCH="${TMPDIR:-/tmp}/terrafluent-docs"  # downloaded repo docs go here (see README)
SITE="$(cd "$(dirname "$0")/.." && pwd)"
HTML_REPO="https://github.com/sahebansari/TerraFluent.Html.Reporting"
DOCX_REPO="https://github.com/sahebansari/TerraFluent.Docx.Reporting"
PDF_REPO="https://github.com/sahebansari/TerraFluent.Pdf.Reporting"
CHART_REPO="https://github.com/sahebansari/TerraFluent.Chart.Reporting"

mkdir -p "$SITE/docs/html" "$SITE/docs/docx" "$SITE/docs/pdf" "$SITE/docs/chart"

DATA_YML="$SITE/_data/docs.yml"
LLMS_FULL="$SITE/llms-full.txt"

echo "# Docs navigation — generated from the library repos' docs folders." > "$DATA_YML"
echo "html:" >> "$DATA_YML"

cat > "$LLMS_FULL" <<'EOF'
# TerraFluent — Full Documentation
# Fluent report generation for .NET: print-ready paginated HTML (TerraFluent.Html.Reporting),
# native Word .docx documents (TerraFluent.Docx.Reporting), and true PDF files
# (TerraFluent.Pdf.Reporting). MIT licensed.
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
  ' "$1" | sed 's/\\/\\\\/g; s/`//g; s/\*\*//g; s/__//g; s/\[\([^]]*\)\]([^)]*)/\1/g; s/"/\\"/g; s/ *$//' | awk '{ if (length($0) <= 155) print; else { s = substr($0, 1, 155); sub(/ [^ ]*$/, "", s); print s } }'
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
  [15-composition-patterns]=composition-patterns
)
HTML_ORDER=(01-getting-started 02-core-concepts 03-content-elements 04-styling 05-tables 06-rows-and-columns 07-pagination-and-layout 08-rendering 09-text-measurement 10-cookbook 11-extending 12-faq-troubleshooting 15-composition-patterns)

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
    printf 'title: "%s — HTML Report Docs"\n' "$title"
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
    printf 'title: "%s — C# Word DOCX Docs"\n' "$title"
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

# ---------- PDF Reporting docs (repo default branch: main; slugs match filenames) ----------
echo "pdf:" >> "$DATA_YML"

PDF_ORDER=(getting-started text-and-spans layout row-and-column-layout decorators images page-sizes-and-units colors templates custom-fonts encryption vector-graphics table-of-contents bookmarks components-and-templates metadata unicode-and-encoding)

for slug in "${PDF_ORDER[@]}"; do
  src="$SCRATCH/docs-pdf/$slug.md"
  out="$SITE/docs/pdf/$slug.md"
  title="$(extract_title "$src")"
  title="${title% with TerraFluent.Pdf.Reporting}"
  title="${title% in TerraFluent.Pdf.Reporting}"
  desc="$(extract_desc "$src")"

  body="$(sed -E \
    -e 's|\]\(([a-z0-9-]+)\.md(#[^)]*)?\)|](/docs/pdf/\1/\2)|g' \
    -e "s|\]\(\.\./|]($PDF_REPO/blob/main/|g" \
    "$src")"

  {
    printf -- '---\n'
    printf 'layout: doc\n'
    printf 'title: "%s — C# PDF Docs"\n' "$title"
    printf 'description: "%s"\n' "$desc"
    printf 'permalink: /docs/pdf/%s/\n' "$slug"
    printf 'doc_section: PDF Reporting docs\n'
    printf 'doc_section_url: /docs/\n'
    printf 'doc_nav: pdf\n'
    printf 'source_url: %s/blob/main/docs/%s.md\n' "$PDF_REPO" "$slug"
    printf -- '---\n\n'
    printf '%s\n' "$body"
  } > "$out"

  printf '  - title: "%s"\n    url: /docs/pdf/%s/\n' "$title" "$slug" >> "$DATA_YML"

  {
    printf '\n\n====================================================================\n'
    printf 'TerraFluent.Pdf.Reporting — %s\n' "$title"
    printf 'URL: https://terrafluent.dev/docs/pdf/%s/\n' "$slug"
    printf '====================================================================\n\n'
    printf '%s\n' "$body"
  } >> "$LLMS_FULL"

  echo "pdf: $slug ('$title')"
done

# ---------- Chart Reporting docs (repo default branch: master; slugs match filenames) ----------
echo "chart:" >> "$DATA_YML"

CHART_ORDER=(getting-started showcase chart-types themes-and-styling advanced api-reference troubleshooting)

for slug in "${CHART_ORDER[@]}"; do
  src="$SCRATCH/docs-chart/$slug.md"
  out="$SITE/docs/chart/$slug.md"
  title="$(extract_title "$src")"
  desc="$(extract_desc "$src")"

  body="$(sed -E \
    -e 's|\]\(([a-z0-9-]+)\.md(#[^)]*)?\)|](/docs/chart/\1/\2)|g' \
    -e 's|\]\(showcase\.html\)|](/chart/showcase/)|g' \
    -e "s|\]\(\.\./|]($CHART_REPO/blob/master/|g" \
    "$src")"

  # The showcase used to be a 2.9 MB standalone page, so the rendered doc opened
  # it in a new tab. split_showcase.py has since broken it into a ~27 KB index
  # plus 36 spoke pages, all carrying the site's own chrome, so it is now an
  # ordinary in-site link and keeps the reader in the same tab.
  page_body="$body"

  {
    printf -- '---\n'
    printf 'layout: doc\n'
    printf 'title: "%s — SVG Chart Docs"\n' "$title"
    printf 'description: "%s"\n' "$desc"
    printf 'permalink: /docs/chart/%s/\n' "$slug"
    printf 'doc_section: Chart Reporting docs\n'
    printf 'doc_section_url: /docs/\n'
    printf 'doc_nav: chart\n'
    printf 'source_url: %s/blob/master/docs/%s.md\n' "$CHART_REPO" "$slug"
    printf -- '---\n\n'
    printf '%s\n' "$page_body"
  } > "$out"

  printf '  - title: "%s"\n    url: /docs/chart/%s/\n' "$title" "$slug" >> "$DATA_YML"

  {
    printf '\n\n====================================================================\n'
    printf 'TerraFluent.Chart.Reporting — %s\n' "$title"
    printf 'URL: https://terrafluent.dev/docs/chart/%s/\n' "$slug"
    printf '====================================================================\n\n'
    printf '%s\n' "$body"
  } >> "$LLMS_FULL"

  echo "chart: $slug ('$title')"
done

# ---------- Chart interactive showcase (hosted locally instead of linking to GitHub) ----------
# Upstream ships one 2.9 MB page holding every specimen. Landing it whole would
# put ~102 chart types, features and recipes on a single URL, so it is staged
# here and split_showcase.py fans it out into the hub-and-spoke pages under
# /chart/. The staged copy is what the splitter reads, which keeps the split
# re-runnable without re-downloading.
CHART_SHOWCASE_SRC="$SCRATCH/docs-chart/showcase.html"
CHART_SHOWCASE_OUT="$SITE/_showcase-source/showcase.html"
if [ -f "$CHART_SHOWCASE_SRC" ]; then
  mkdir -p "$SITE/_showcase-source"
  # Strip a leading UTF-8 BOM if present (the upstream file has one; a BOM
  # before <!DOCTYPE html> is technically valid but pointless to keep).
  sed '1s/^\xef\xbb\xbf//' "$CHART_SHOWCASE_SRC" > "$CHART_SHOWCASE_OUT"
  echo "chart: showcase.html -> _showcase-source/showcase.html ($(wc -c < "$CHART_SHOWCASE_OUT") bytes)"
else
  echo "NOTE: $CHART_SHOWCASE_SRC not found — keeping the staged _showcase-source/showcase.html. Download it (see scripts/README.md) to refresh the specimens." >&2
fi

# ---------- Split the showcase into the hub-and-spoke pages ----------
# Must run after the chart docs above: it lifts each type's C# snippet out of
# the docs/chart/chart-types.md this script just wrote, so the code on every
# landing page is the library's own documented API rather than a paraphrase.
# It fails loudly if upstream adds a specimen that is not yet classified.
if [ -f "$SITE/_showcase-source/showcase.html" ]; then
  python "$SITE/scripts/split_showcase.py"
else
  echo "WARNING: no _showcase-source/showcase.html — chart hub-and-spoke pages NOT regenerated." >&2
fi

echo "DONE. _data/docs.yml + $(ls "$SITE"/docs/html | wc -l) html docs + $(ls "$SITE"/docs/docx | wc -l) docx docs + $(ls "$SITE"/docs/pdf | wc -l) pdf docs + $(ls "$SITE"/docs/chart | wc -l) chart docs + $(ls -d "$SITE"/chart/types/*/ 2>/dev/null | wc -l) chart type pages + llms-full.txt ($(wc -l < "$LLMS_FULL") lines)"
