# SEO / AI-visibility checklist — manual steps

The site-side work (titles, structured data, on-domain docs, llms.txt, FAQ schema on
every product page, og-card) is done in this repo. These remaining steps need accounts
or access that live outside the repo, roughly in order of impact:

## Do once, right after deploying

1. **Google Search Console** — <https://search.google.com/search-console>
   - Add property `terrafluent.dev` (Domain property, DNS TXT verification).
   - Submit `https://terrafluent.dev/sitemap.xml`.
   - Use "URL Inspection → Request indexing" on the home page and all three product
     pages (`/pdf/`, `/html/`, `/docx/`), plus `/compare/` and
     `/docs/pdf/getting-started/` after the 2026-07-13 PDF launch.

2. **Bing Webmaster Tools** — <https://www.bing.com/webmasters>
   - Add the site (can import straight from Search Console).
   - Submit the sitemap. Bing's index feeds ChatGPT search and Microsoft Copilot.

3. **GitHub repo backlinks** — ✅ DONE (verified 2026-07-13): all three repos
   (`TerraFluent.Pdf.Reporting`, `TerraFluent.Html.Reporting`,
   `TerraFluent.Docx.Reporting`) have their Website field set to
   `https://terrafluent.dev`, and the Pdf README links the site near the top.
   Keep the site link near the top of the Html/Docx READMEs too.

4. **NuGet backlinks** — in all three `.csproj`/`.nuspec` files set
   `<PackageProjectUrl>` to the package's page on this site
   (`https://terrafluent.dev/pdf/`, `/html/`, `/docx/`) and mention the query phrases
   in `<Description>` ("free C# PDF library, zero dependencies", "create Word documents
   in C# without interop", "paginated HTML reports without a PDF engine").
   Takes effect on the next package publish; no need to push a release just for this.
   Status 2026-07-13: TerraFluent.Pdf.Reporting's Project website still points to the
   GitHub repo, not the site.

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
   Note: Html/Docx repos use the `master` branch; the Pdf repo uses `main`.

7. **Community signals** — answer relevant Stack Overflow questions
   (pdf-generation, docx-without-interop, HTML-report questions) linking the docs
   pages; a Show HN / r/dotnet / dev.to launch post for the PDF package each create
   crawlable, LLM-visible links.

## Verify after deploy

- `https://terrafluent.dev/llms.txt` and `/llms-full.txt` return 200.
- Rich results test on `/`, `/compare/`, and `/pdf/`:
  <https://search.google.com/test/rich-results> should show FAQ + Breadcrumb +
  SoftwareApplication.
- Share the home page in Slack/X and confirm the og-card shows the three-output
  headline (True PDF · HTML · DOCX), not the old two-output card.
- `site:terrafluent.dev` in Google after a few days — expect ~41 pages.
