# terrafluent.dev

Corporate site for TerraFluent's open-source .NET reporting and data
visualization solutions:

- [TerraFluent.Pdf.Reporting](https://github.com/sahebansari/TerraFluent.Pdf.Reporting) — true PDF files, zero dependencies
- [TerraFluent.Html.Reporting](https://github.com/sahebansari/TerraFluent.Html.Reporting) — paginated, print-ready HTML reports
- [TerraFluent.Docx.Reporting](https://github.com/sahebansari/TerraFluent.Docx.Reporting) — native Word documents via Open XML
- [TerraFluent.Chart.Reporting](https://github.com/sahebansari/TerraFluent.Chart.Reporting) — server-side SVG charts, zero JavaScript

## Stack

Jekyll, built and deployed automatically by GitHub Pages on every push to `main`
(no CI configuration required). Custom domain via `CNAME`.

## Structure

```
_config.yml          Site settings, repo/NuGet URLs (repos.*, nuget.*)
_data/nav.yml        Header menu — the single source of truth for navigation,
                      including the Solutions dropdown's children
_data/versions.yml   Current released version of each package
_data/docs.yml       Generated docs navigation (see scripts/mirror-docs.sh)
_layouts/default.html   Page shell (head/SEO, header, content, footer)
_layouts/doc.html    Docs page shell with the per-library sidebar
_includes/           header.html, footer.html, install-row.html, logo-mark.svg
assets/css/main.css  Design tokens (light/dark) + all components
assets/js/main.js    Theme toggle, copy buttons, mobile nav
index.html           Home page
solutions/           Solutions overview (all four packages)
pdf/ html/ docx/ chart/   Per-solution product pages
getting-started/ compare/ samples/ docs/   Section pages
enterprise/ support/ security/ releases/ privacy/   Trust & company pages
```

## Local preview (optional)

Requires Ruby + Bundler:

```
bundle install
bundle exec jekyll serve
```

Otherwise, push to `main` and GitHub Pages builds it.
