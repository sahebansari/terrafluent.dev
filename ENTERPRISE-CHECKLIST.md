# Enterprise-readiness checklist — repo-side steps

The site-side work (support/security/releases/enterprise/privacy pages, version
single-sourcing via `_data/versions.yml`, self-hosted fonts, footer links) is done in
this repo. These remaining steps live in the four library repositories or on external
services, roughly in order of impact. Verified state as of 2026-07-14; Chart repo
added 2026-09-14.

## Governance files

1. **SECURITY.md in the Html repo** — Pdf and Docx have one; `TerraFluent.Html.Reporting`
   does not. Copy the Docx one and adjust. The site's /security/ page currently points
   Html reporters at the GitHub private-advisory form only — update that page's last
   section once the file exists.
2. **CODE_OF_CONDUCT.md in all four repos** — none have one (GitHub community health:
   Pdf 71%, Html 42%, Docx 71%, Chart not yet checked). Contributor Covenant is the
   standard choice.
3. **CONTRIBUTING.md in the Html repo** — Pdf and Docx have one; Html does not.
4. **SECURITY.md and CONTRIBUTING.md in the new Chart repo** — neither exists yet
   (verified 2026-09-14, checked via the GitHub contents API). Private vulnerability
   reporting was enabled on the repo directly 2026-09-14 so the
   `/security/advisories/new` link on the site's /security/ page works, but there is
   still no SECURITY.md file to link to — same situation the site already handles for
   Html by pointing at the reporting form only.

## GitHub settings

5. **Enable GitHub Discussions** on all four repos (Settings → Features). Then update
   `/support/` on this site to route questions to Discussions and keep Issues for bugs.
6. **Investigate the failed "Publish NuGet" workflow run** in the Pdf repo (tag v2.0.2,
   conclusion: failure — the package did reach NuGet, so likely a partial rerun, but a
   red latest-run is a bad look for evaluators browsing the Actions tab).

## NuGet metadata (takes effect on next package publish)

7. **Reserve the `TerraFluent.` package ID prefix** on nuget.org
   (<https://learn.microsoft.com/en-us/nuget/nuget-org/id-prefix-reservation>) — gets
   the verified checkmark on all four listings, including the newly published
   TerraFluent.Chart.Reporting.
8. **`PackageProjectUrl` → terrafluent.dev** — all four packages currently point
   `projectUrl` at their GitHub repo (verified for Chart 2.0.0 on 2026-09-14). Point
   them at the product pages (`https://terrafluent.dev/pdf/`, `/html/`, `/docx/`,
   `/chart/`); carried over from SEO-CHECKLIST.md item 4.
9. **Pdf repo: embed the source commit in the package** — the published Pdf nuspec has
   `<repository url>` but no `commit` attribute (Html and Docx have it). Ensure the
   Pdf publish builds with SourceLink / `PublishRepositoryUrl` so the commit lands in
   the metadata; consider symbol packages (`.snupkg`) for all four while at it.
   The /enterprise/ page currently says only Html and Docx embed the commit — update
   it when Pdf and Chart do.

## Upstream doc fixes (mirrored into this site by scripts/mirror-docs.sh)

10. **Pdf repo `docs/getting-started.md`** — said "TerraFluent.Pdf.Reporting 1.4.0
   brings…" while the package is at 2.0.2. Reworded locally on the site 2026-07-14,
   but the next mirror run will overwrite it — make the same edit upstream (drop the
   version number from the sentence entirely so it can't go stale again).
11. **Chart repo `docs/showcase.md` and `docs/showcase.html` both have a leading
   UTF-8 BOM** — the `.md` one broke `scripts/mirror-docs.sh`'s title extraction
   (`grep -m1 '^# '` doesn't match a line starting with a BOM) on the first mirror
   run 2026-09-14; the `.html` one is harmless (browsers tolerate a BOM before
   `<!DOCTYPE html>`) but pointless. The mirror script now strips both BOMs itself
   (`sed '1s/^\xef\xbb\xbf//'`) when converting, so this no longer blocks a mirror
   run — but strip the BOM from both files upstream anyway so the repo's own
   copies are clean.
12. **Chart repo `docs/showcase.html` is now hosted directly on the site** at
   `/chart/showcase/` (2026-09-14 — see `scripts/mirror-docs.sh`'s "Chart
   interactive showcase" step) instead of linking out to the GitHub blob view.
   It's a ~2.9 MB static file copied verbatim, with no Jekyll front matter, so it
   renders standalone (no site header/footer). Every doc's `showcase.html` link
   was repointed at `/chart/showcase/` in the same change. Keep re-running the
   mirror script (not a manual copy) whenever the upstream file changes, so this
   copy and the doc links stay in sync.

## Policy statements to keep true

The site now publicly commits to these (on /releases/ and /enterprise/):
semantic versioning with breaking changes only in majors; `[Obsolete]` for at least one
minor release before removal; security fixes target the latest release of each package.
If any of these ever change, update `/releases/`, `/security/`, and `/enterprise/`.

## When versions bump

Update `_data/versions.yml` — it drives the product-page hero badges, JSON-LD
`softwareVersion`, and the /releases/ and /enterprise/ pages. The "What's new" chips on
/html/ and /docx/ are intentionally hardcoded to the release they describe; refresh
those sections (chip + bullets together) when shipping notable features.
