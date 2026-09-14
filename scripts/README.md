# scripts

`mirror-docs.sh` — regenerates `docs/html/*.md`, `docs/docx/*.md`, `docs/pdf/*.md`,
`docs/chart/*.md`, `_data/docs.yml`, `llms-full.txt`, and `chart/showcase/index.html`
(a full local copy of the Chart repo's interactive showcase page — hosted here
instead of linking out to GitHub) from the library repos' docs folders.

Usage:
```bash
# 1. download the source docs
SCRATCH="${TMPDIR:-/tmp}/terrafluent-docs"
mkdir -p "$SCRATCH/docs-html" "$SCRATCH/docs-docx" "$SCRATCH/docs-pdf" "$SCRATCH/docs-chart"
for f in 01-getting-started 02-core-concepts 03-content-elements 04-styling 05-tables 06-rows-and-columns 07-pagination-and-layout 08-rendering 09-text-measurement 10-cookbook 11-extending 12-faq-troubleshooting 15-composition-patterns; do
  curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Html.Reporting/master/docs/$f.md" -o "$SCRATCH/docs-html/$f.md"
done
for f in GETTING_STARTED CORE_CONCEPTS FEATURES API SAMPLES TROUBLESHOOTING; do
  curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Docx.Reporting/master/docs/$f.md" -o "$SCRATCH/docs-docx/$f.md"
done
# note: the Pdf repo's default branch is main (not master)
for f in getting-started text-and-spans layout row-and-column-layout decorators images page-sizes-and-units colors templates custom-fonts encryption vector-graphics table-of-contents bookmarks components-and-templates metadata unicode-and-encoding; do
  curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Pdf.Reporting/main/docs/$f.md" -o "$SCRATCH/docs-pdf/$f.md"
done
# note: the Chart repo's default branch is master, same as Html/Docx
for f in getting-started showcase chart-types themes-and-styling advanced api-reference troubleshooting; do
  curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Chart.Reporting/master/docs/$f.md" -o "$SCRATCH/docs-chart/$f.md"
done
# the interactive showcase gallery (a standalone HTML page, not markdown) — copied
# verbatim into chart/showcase/index.html by the script below, BOM stripped
curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Chart.Reporting/master/docs/showcase.html" -o "$SCRATCH/docs-chart/showcase.html"
# 2. convert
bash scripts/mirror-docs.sh
```
