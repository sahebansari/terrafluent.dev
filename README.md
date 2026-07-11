# terrafluent.dev

Product website for the TerraFluent open-source .NET reporting libraries:

- [TerraFluent.Html.Reporting](https://github.com/sahebansari/TerraFluent.Html.Reporting) — paginated, print-ready HTML reports
- [TerraFluent.Docx.Reporting](https://github.com/sahebansari/TerraFluent.Docx.Reporting) — native Word documents via Open XML

## Stack

Jekyll, built and deployed automatically by GitHub Pages on every push to `main`
(no CI configuration required). Custom domain via `CNAME`.

## Structure

```
_config.yml          Site settings, repo/NuGet URLs
_data/nav.yml        Header menu — the single source of truth for navigation
_layouts/default.html   Page shell (head/SEO, header, content, footer)
_includes/           header.html, footer.html, install-row.html, logo-mark.svg
assets/css/main.css  Design tokens (light/dark) + all components
assets/js/main.js    Theme toggle, copy buttons, mobile nav
index.html           Home page
html/ docx/ getting-started/   Section pages
```

## Local preview (optional)

Requires Ruby + Bundler:

```
bundle install
bundle exec jekyll serve
```

Otherwise, push to `main` and GitHub Pages builds it.
