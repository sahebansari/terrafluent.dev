# scripts

`mirror-docs.sh` — regenerates `docs/html/*.md`, `docs/docx/*.md`, `docs/pdf/*.md`,
`docs/chart/*.md`, `_data/docs.yml` and `llms-full.txt` from the library repos'
docs folders, stages the Chart repo's showcase page in `_showcase-source/`, and
then runs `split_showcase.py`.

`split_showcase.py` — splits that one 2.9 MB showcase page into the hub-and-spoke
set under `/chart/`: the gallery index at `/chart/showcase/`, 27 chart-type
landing pages at `/chart/types/<slug>/`, 8 feature galleries at
`/chart/features/<slug>/`, and `/chart/cookbook/`. Every specimen SVG is *moved*,
so each one lives at exactly one URL and is never re-rendered — the renderer is
the C# library, not this repo. Each type page's C# snippet is lifted from the
`docs/chart/chart-types.md` that `mirror-docs.sh` just wrote, so the code is
always the library's documented API. The prose (headings, meta descriptions and
the when-to-use guidance) is hand-written in `_data/chart_types.yml`; edit it
there, then re-run the script.

If upstream adds a chart to the showcase, the script **fails** and names the
unclassified card rather than dropping its specimen. Add it to `TYPES`,
`FEATURES` or `RECIPES` at the top of `split_showcase.py` — and to
`_data/chart_types.yml` if it is a new chart type. Run `python
scripts/split_showcase.py --check` to validate without writing.

Requires Python 3 with PyYAML (`pip install pyyaml`).

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
# the interactive showcase gallery (a standalone HTML page, not markdown) — staged
# in _showcase-source/ by the script below (BOM stripped), then split into the
# /chart/ hub-and-spoke pages by split_showcase.py
curl -sf "https://raw.githubusercontent.com/sahebansari/TerraFluent.Chart.Reporting/master/docs/showcase.html" -o "$SCRATCH/docs-chart/showcase.html"
# 2. convert
bash scripts/mirror-docs.sh
```
