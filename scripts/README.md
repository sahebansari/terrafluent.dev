# scripts

`mirror-docs.sh` — regenerates `docs/html/*.md`, `docs/docx/*.md`, `_data/docs.yml`,
and `llms-full.txt` from the library repos' docs folders.

Usage:
```bash
# 1. download the source docs
SCRATCH="${TMPDIR:-/tmp}/terrafluent-docs"
mkdir -p "$SCRATCH/docs-html" "$SCRATCH/docs-docx"
for f in 01-getting-started 02-core-concepts 03-content-elements 04-styling 05-tables 06-rows-and-columns 07-pagination-and-layout 08-rendering 09-text-measurement 10-cookbook 11-extending 12-faq-troubleshooting; do
  curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Html.Reporting/master/docs/$f.md" -o "$SCRATCH/docs-html/$f.md"
done
for f in GETTING_STARTED CORE_CONCEPTS FEATURES API SAMPLES TROUBLESHOOTING; do
  curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Docx.Reporting/master/docs/$f.md" -o "$SCRATCH/docs-docx/$f.md"
done
# 2. convert
bash scripts/mirror-docs.sh
```
