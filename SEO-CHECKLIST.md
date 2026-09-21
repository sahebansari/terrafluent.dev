# SEO / AI-visibility checklist — manual steps

The site-side work (titles, structured data, on-domain docs, llms.txt, FAQ schema on
every product page, og-card) is done in this repo. These remaining steps need accounts
or access that live outside the repo, roughly in order of impact:

## Do once, right after deploying

1. **Google Search Console** — <https://search.google.com/search-console>
   - Add property `terrafluent.dev` (Domain property, DNS TXT verification).
   - Submit `https://terrafluent.dev/sitemap.xml`.
   - Use "URL Inspection → Request indexing" on the home page and all four solution
     pages (`/pdf/`, `/html/`, `/docx/`, `/chart/`), plus `/solutions/`, `/compare/`
     and `/docs/pdf/getting-started/` after the 2026-07-13 PDF launch, and
     `/docs/chart/getting-started/` after the 2026-09-14 Chart launch.

2. **Bing Webmaster Tools** — <https://www.bing.com/webmasters>
   - Add the site (can import straight from Search Console).
   - Submit the sitemap. Bing's index feeds ChatGPT search and Microsoft Copilot.

3. **GitHub repo backlinks** — ✅ DONE for the first three repos (verified
   2026-07-13): `TerraFluent.Pdf.Reporting`, `TerraFluent.Html.Reporting`,
   `TerraFluent.Docx.Reporting` have their Website field set to
   `https://terrafluent.dev`, and the Pdf README links the site near the top.
   `TerraFluent.Chart.Reporting`'s Website field is already set to
   `https://terrafluent.dev/chart/` (verified 2026-09-14) — confirm the README
   links the site near the top too.

4. **NuGet backlinks** — in all four `.csproj`/`.nuspec` files set
   `<PackageProjectUrl>` to the package's page on this site
   (`https://terrafluent.dev/pdf/`, `/html/`, `/docx/`, `/chart/`) and mention the
   query phrases in `<Description>` ("free C# PDF library, zero dependencies",
   "create Word documents in C# without interop", "paginated HTML reports without a
   PDF engine", "C# SVG chart library, zero JavaScript").
   Takes effect on the next package publish; no need to push a release just for this.
   Status 2026-07-13: TerraFluent.Pdf.Reporting's Project website still points to the
   GitHub repo, not the site. Status 2026-09-14: TerraFluent.Chart.Reporting 2.0.0's
   `<projectUrl>` also still points to the GitHub repo, not `/chart/`.

## Ongoing (what actually moves rankings)

5. **Long-tail content** — add guide pages targeting real queries, one at a time.
   PDF (highest volume): "free C# PDF library", "iTextSharp free alternative",
   "QuestPDF license alternative", "generate invoice PDF in C#".
   Word/HTML: "create an invoice in C#", "generate Word documents in .NET on
   Linux/Docker", "C# report with page numbers".
   The `/docs/` layout is ready for more markdown pages.

6. **Docs freshness** — the `/docs/` pages are mirrored from the library repos
   (script: `scripts/mirror-docs.sh`, mapping recorded in `_data/docs.yml`).
   Re-run the mirror when repo docs change, or move the docs source of truth here.
   Note: Html/Docx/Chart repos use the `master` branch; the Pdf repo uses `main`.

7. **Community signals** — answer relevant Stack Overflow questions
   (pdf-generation, docx-without-interop, HTML-report questions) linking the docs
   pages; a Show HN / r/dotnet / dev.to launch post for the PDF package each create
   crawlable, LLM-visible links.

## Verify after deploy

- `https://terrafluent.dev/llms.txt` and `/llms-full.txt` return 200.
- Rich results test on `/`, `/compare/`, and `/pdf/`:
  <https://search.google.com/test/rich-results> should show FAQ + Breadcrumb +
  SoftwareApplication.
- Share the home page in Slack/X and confirm the og-card shows the current headline
  (True PDF · HTML · DOCX · Charts), not a stale card — the og-card image itself
  (`assets/img/og-card.png`) still needs regenerating to mention Charts.
- `site:terrafluent.dev` in Google after a few days — expect 95 pages per
  `sitemap.xml` (59 before 2026-09-21; the chart showcase split added 27
  `/chart/types/*`, 8 `/chart/features/*` and `/chart/cookbook/`).
- The chart showcase is now a hub-and-spoke set, not one page. `/chart/showcase/`
  is a ~27 KB index carrying the site layout, a self-canonical and a meta
  description; the 102 SVG specimens moved out to the 36 spoke pages, each
  specimen at exactly one URL. `scripts/split_showcase.py` generates all of it
  from `_showcase-source/showcase.html` — never hand-edit the generated pages.
- Check the type pages are ranking for their own query rather than the hub:
  "sankey diagram in c#", "gantt chart .net", "candlestick chart c#". Each has a
  matching `<title>`, `<h1>`, URL slug and meta description. If the hub outranks
  a type page for a type query, the hub's copy is probably too specific — keep it
  generic and let the spokes carry the intent.
- All specimens are inline `<svg>` with `<title>` and `<desc>`, not images. That
  is the crawlable-text advantage over competitors who ship screenshots — do not
  let a future change convert any of them to `<img>` or PNG.
