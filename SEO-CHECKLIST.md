# SEO / AI-visibility checklist — manual steps

The site-side work (titles, structured data, on-domain docs, llms.txt) is done in this
repo. These remaining steps need accounts or access that live outside the repo, roughly
in order of impact:

## Do once, right after deploying

1. **Google Search Console** — <https://search.google.com/search-console>
   - Add property `terrafluent.dev` (Domain property, DNS TXT verification).
   - Submit `https://terrafluent.dev/sitemap.xml`.
   - Use "URL Inspection → Request indexing" on the home page and both product pages.

2. **Bing Webmaster Tools** — <https://www.bing.com/webmasters>
   - Add the site (can import straight from Search Console).
   - Submit the sitemap. Bing's index feeds ChatGPT search and Microsoft Copilot.

3. **GitHub repo backlinks** (`gh` CLI is not installed on this machine):
   - Set the **Website** field of both repos to `https://terrafluent.dev`:
     `gh repo edit sahebansari/TerraFluent.Html.Reporting --homepage https://terrafluent.dev`
     `gh repo edit sahebansari/TerraFluent.Docx.Reporting --homepage https://terrafluent.dev`
     (or repo Settings → About → Website in the GitHub UI)
   - Link the site prominently near the top of both READMEs, e.g.
     `Docs & guides: https://terrafluent.dev`

4. **NuGet backlinks** — in both `.csproj`/`.nuspec` files set
   `<PackageProjectUrl>https://terrafluent.dev</PackageProjectUrl>` and mention the
   query phrases in `<Description>` ("create Word documents in C# without interop",
   "paginated HTML reports without a PDF engine"). Takes effect on the next package
   publish; no need to push a release just for this.

## Ongoing (what actually moves rankings)

5. **Long-tail content** — add guide pages targeting real queries, one at a time:
   "create an invoice in C#", "generate Word documents in .NET on Linux/Docker",
   "C# report with page numbers", "QuestPDF vs TerraFluent for Word output".
   The `/docs/` layout is ready for more markdown pages.

6. **Docs freshness** — the `/docs/` pages are mirrored from the library repos
   (script: `scripts/mirror-docs.sh`, mapping recorded in `_data/docs.yml`).
   Re-run the mirror when repo docs change, or move the docs source of truth here.

7. **Community signals** — answer relevant Stack Overflow questions
   (docx-without-interop, HTML-report questions) linking the docs pages; a
   Show HN / r/dotnet / dev.to launch post each create crawlable, LLM-visible links.

## Verify after deploy

- `https://terrafluent.dev/llms.txt` and `/llms-full.txt` return 200.
- Rich results test on `/` and `/compare/`: <https://search.google.com/test/rich-results>
  should show FAQ + Breadcrumb + SoftwareApplication.
- `site:terrafluent.dev` in Google after a few days — expect ~25 pages.
