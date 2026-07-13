# Enterprise-readiness checklist — repo-side steps

The site-side work (support/security/releases/enterprise/privacy pages, version
single-sourcing via `_data/versions.yml`, self-hosted fonts, footer links) is done in
this repo. These remaining steps live in the three library repositories or on external
services, roughly in order of impact. Verified state as of 2026-07-14.

## Governance files

1. **SECURITY.md in the Html repo** — Pdf and Docx have one; `TerraFluent.Html.Reporting`
   does not. Copy the Docx one and adjust. The site's /security/ page currently points
   Html reporters at the GitHub private-advisory form only — update that page's last
   section once the file exists.
2. **CODE_OF_CONDUCT.md in all three repos** — none have one (GitHub community health:
   Pdf 71%, Html 42%, Docx 71%). Contributor Covenant is the standard choice.
3. **CONTRIBUTING.md in the Html repo** — Pdf and Docx have one; Html does not.

## GitHub settings

4. **Enable GitHub Discussions** on all three repos (Settings → Features). Then update
   `/support/` on this site to route questions to Discussions and keep Issues for bugs.
5. **Investigate the failed "Publish NuGet" workflow run** in the Pdf repo (tag v2.0.2,
   conclusion: failure — the package did reach NuGet, so likely a partial rerun, but a
   red latest-run is a bad look for evaluators browsing the Actions tab).

## NuGet metadata (takes effect on next package publish)

6. **Reserve the `TerraFluent.` package ID prefix** on nuget.org
   (<https://learn.microsoft.com/en-us/nuget/nuget-org/id-prefix-reservation>) — gets
   the verified checkmark on all three listings.
7. **`PackageProjectUrl` → terrafluent.dev** — all three packages currently point
   `projectUrl` at their GitHub repo. Point them at the product pages
   (`https://terrafluent.dev/pdf/`, `/html/`, `/docx/`); carried over from
   SEO-CHECKLIST.md item 4.
8. **Pdf repo: embed the source commit in the package** — the published Pdf nuspec has
   `<repository url>` but no `commit` attribute (Html and Docx have it). Ensure the
   Pdf publish builds with SourceLink / `PublishRepositoryUrl` so the commit lands in
   the metadata; consider symbol packages (`.snupkg`) for all three while at it.
   The /enterprise/ page currently says only Html and Docx embed the commit — update
   it when Pdf does.

## Upstream doc fixes (mirrored into this site by scripts/mirror-docs.sh)

9. **Pdf repo `docs/getting-started.md`** — said "TerraFluent.Pdf.Reporting 1.4.0
   brings…" while the package is at 2.0.2. Reworded locally on the site 2026-07-14,
   but the next mirror run will overwrite it — make the same edit upstream (drop the
   version number from the sentence entirely so it can't go stale again).

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
