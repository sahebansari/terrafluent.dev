---
layout: doc
title: "Templates — C# PDF Docs"
description: "Every PDF starts as a blank page — PageDescriptor gives you a solid PageColor(), and three empty layout slots (Header(), Content(), Footer()). Templates"
permalink: /docs/pdf/templates/
doc_section: PDF Reporting docs
doc_section_url: /docs/
doc_nav: pdf
source_url: https://github.com/sahebansari/TerraFluent.Pdf.Reporting/blob/main/docs/templates.md
---

# Templates

Every PDF starts as a blank page — `PageDescriptor` gives you a solid
`PageColor()`, and three empty layout slots (`Header()`, `Content()`,
`Footer()`). Templates are a thin, opt-in layer on top of that: predefined,
professionally-styled combinations of page background, decorative artwork,
and header/footer that you apply in one call, so you get a branded-looking
document instantly and only write the content that's actually unique to your
document.

Every predefined template treats its color/gradient/pattern as **one
continuous design covering the whole page** — not a colored rectangle at the
top with a plain page underneath it. A soft-tinted background, a full-page
gradient, decorative accent shapes (rounded panels, corner-bleeding circles,
a frame) all read as a single seamless piece of art, the same way a
professionally-designed page-background template does; your content is then
composed on top of it in `page.Content()`.

A template never touches `Content()` — it only configures the page
background/decoration, `Header()`, `Footer()`, margins, and the default text
style. Your content always goes into `page.Content()` exactly as it does today.

---

## Quick start

```csharp
using TerraFluent.Pdf.Reporting.Core;
using TerraFluent.Pdf.Reporting.Helpers;
using TerraFluent.Pdf.Reporting.Templating;

PdfDocument.Create(doc =>
{
    doc.Page(page =>
    {
        page.Size(PageSize.A4);
        page.UseTemplate(Templates.Corporate, opts =>
        {
            opts.Title       = "Q3 Financial Report";
            opts.Subtitle    = "Prepared for the Board of Directors";
            opts.AccentColor = Color.Teal.Darken2;
            opts.LogoPath    = "logo.png";
            opts.FooterText  = "Confidential — Acme Inc.";
        });

        page.Content().Padding(30).Column(col =>
        {
            col.Spacing(12);
            col.Item().Text("Executive summary...").Justify();
        });
    });
})
.PublishPdf("report.pdf");
```

`UseTemplate` returns the `PageDescriptor`, so you can keep chaining
(`.Margin(...)`, etc.) afterward — a template's settings are just a
starting point a later call can still override.

---

## Predefined templates

| Template | Look | Best for |
|---|---|---|
| `Templates.Corporate` | A light brand-tinted page (no plain-white gap), solid accent header band with logo/title/subtitle, a thin accent rule, and a pair of ribbon sweeps bleeding off the bottom edge | Reports, invoices, company profiles |
| `Templates.Modern` | Near-white page organized by a full-bleed, two-tone accent rail down the left edge with a quiet dot-grid texture in the bottom-right corner; logo, title, subtitle, body, and footer all sit in one column to the rail's right | Product briefs, startup/tech-leaning documents |
| `Templates.Minimal` | Near-plain white page, small title over a thin top rule, generous margins, and one pale arc grazing the bottom-right corner | Whitepapers, editorial documents |
| `Templates.Elegant` | Soft page-wide tint of the accent color inside a classic double-rule frame, serif title framed by its own rules | Certificates, formal proposals |
| `Templates.Cover` | Full-bleed diagonal gradient with ribbon sweeps framing the top and bottom edges, large centered title/subtitle in white | Cover pages, section dividers |

All five are built from the same public fluent API you already use
(`Background`, `BackgroundGradient`, `DecoratePage`, `Padding`, `Row`,
`Column`, `Text`, `Image`, `LineHorizontal`, page numbers) — nothing about
them is special or inaccessible to your own code.

### `Templates.Cover` is a cover-page template, not a body template

`PageDescriptor.Content()` always returns the same underlying container —
whatever your own `page.Content()...` calls draw there completely replaces
anything a template could have pre-drawn *inside that container*. A template
therefore can't reliably wrap `Content()` in a decoration (the very next line
of your code would overwrite it) — but it *can* reliably reserve the visual
*space* content will occupy, because margins are geometry, not something
your `.Content()...` call ever touches. `Templates.Modern` uses exactly this
trick: it draws a full-height accent rail with `DecoratePage` at a fixed
position along the left edge and sets `page.Margin(...)` to clear it, so
whatever you put in `Header()`/`Content()`/`Footer()` always lands to its
right — see [Page decoration](#page-decoration) below.

`Templates.Cover` deliberately doesn't do this: its full-bleed gradient sits
directly behind whatever you put in `Content()`, styled for a short,
large-type cover page (title + subtitle) — not a paragraph of body text. For
a multi-page document, use a Cover template on the first page and a body
template (`Corporate`, `Modern`, `Minimal`, `Elegant`) on the rest, in the
same document:

```csharp
PdfDocument.Create(doc =>
{
    doc.Page(page => // page 1: cover
    {
        page.Size(PageSize.A4);
        page.UseTemplate(Templates.Cover, o =>
        {
            o.Title    = "Annual Report 2026";
            o.Subtitle = "Building for the next decade";
        });
    });

    doc.Page(page => // page 2+: body
    {
        page.Size(PageSize.A4);
        page.UseTemplate(Templates.Corporate, o => o.Title = "Annual Report 2026");
        page.Content().Text("Financial summary...");
    });
})
.PublishPdf("annual-report.pdf");
```

---

## `TemplateOptions` reference

| Property | Type | Default | Used by |
|---|---|---|---|
| `Title` | `string?` | `null` | All templates — main header/cover title |
| `Subtitle` | `string?` | `null` | All templates — line under `Title` |
| `AccentColor` | `string` | `Color.Blue.Darken2` | All templates — brand color |
| `SecondaryColor` | `string?` | darker shade of `AccentColor` | `Modern` — rail's lower tone; `Cover` — gradient end color |
| `LogoPath` | `string?` | `null` | `Corporate`, `Modern` — header logo (ignored if the file doesn't exist) |
| `LogoBytes` | `byte[]?` | `null` | Same as `LogoPath`, from in-memory bytes |
| `ShowPageNumbers` | `bool` | `true` | All templates — footer "Page X of Y" |
| `FooterText` | `string?` | `null` | Templates with a footer band |

---

## Gradient and image backgrounds

Templates are built on general-purpose primitives you can use directly,
without going through a template at all.

**Full-page background** (`PageDescriptor`, mutually exclusive — the last
one you call wins):

```csharp
page.PageColor("#FFFFFF");                                     // solid
page.PageBackgroundGradient("#1976D2", "#0D47A1", GradientDirection.TopToBottom);
page.PageBackgroundImage("background.jpg", ImageFit.Cover);    // or Stretch
```

**In-layout gradient band** (any container — header, footer, a card):

```csharp
container.BackgroundGradient("#1976D2", "#0D47A1", GradientDirection.LeftToRight)
    .Padding(16)
    .Text("Banner text").FontColor(Color.White);
```

> This library has no native PDF shading support, so gradients are
> approximated as ~48 thin solid-color bands rather than a true smooth
> blend. At normal viewing sizes the banding is not visually distinct — on
> `Templates.Cover`'s diagonal gradient it even reads as an intentional
> subtle stripe texture.

## Page decoration

`page.DecoratePage(canvas => ...)` draws arbitrary vector artwork — the same
`VectorCanvas` API `.Canvas(height, draw)` already gives you inside a layout
(rectangles, rounded rectangles, circles/ellipses, and arbitrary Bézier
`Path(...)`s) — as a layer over the page's background and under
`Header()`/`Content()`/`Footer()`. Coordinates are page-relative, top-left
origin, spanning the full page (`canvas.AllocatedWidth`/`AllocatedHeight`)
regardless of margins. This is how the predefined templates build their
corner-bleeding accent circles, `Elegant`'s frame, and `Modern`'s accent
rail and dot-grid:

```csharp
page.DecoratePage(canvas =>
{
    double w = canvas.AllocatedWidth, h = canvas.AllocatedHeight;

    // A soft accent circle bleeding off a corner — center it AT the corner
    // so only a quarter of it is actually visible on the page.
    canvas.FillCircle(w, h, Math.Min(w, h) * 0.15, "#BBDEFB");

    // A refined frame inset from the page edges.
    canvas.StrokeRoundedRect(18, 18, w - 36, h - 36, 6, "#1976D2", 1);
});
```

### Ribbon sweeps

The sweeping bands the predefined templates use are just a **cubic Bézier
stroked at a large line width** — the band's two edges are the stroke's own
offsets, so there's no offset-curve geometry to compute:

```csharp
page.DecoratePage(canvas =>
{
    double w = canvas.AllocatedWidth, h = canvas.AllocatedHeight;

    canvas.Path(p => p
        .MoveTo(-40, h * 0.26)                                   // start off-page…
        .CurveTo(w * 0.16, h * 0.02, w * 0.42, -26, w + 40, -40) // …end off-page
        .Stroke("#1976D2", 30));                                 // thickness = band width
});
```

Two details matter: push the end points *past* the page edges (PDF's default
flat line cap would otherwise show as a blunt edge mid-page), and remember a
stroke can't be clipped — to make a ribbon stop at a shape, draw the ribbon
first and paint an opaque shape (e.g. a content panel or card) over it.

**Reserving space for a decorated content panel**: because `DecoratePage`
runs before `Content()` draws and margins are geometry your later
`.Content()...` call never overwrites, you can draw a shape (e.g. a rounded
white panel) and set `page.Margin(...)` to match its bounds so your content
always lands inside it. `Templates.Modern` uses the same underlying idea in
its simpler form — a fixed-position accent rail with the left margin set to
clear it — but the technique generalizes to any shape:

```csharp
const double top = 50, side = 45, bottom = 50, pad = 20;
page.Margin(top, side, bottom, side);
page.DecoratePage(canvas =>
{
    double w = canvas.AllocatedWidth, h = canvas.AllocatedHeight;
    canvas.FillRoundedRect(side - pad, top - pad, w - (side - pad) * 2,
        h - (top - pad) - (bottom - pad), 20, Color.White);
});
```

> Call `page.Size(...)` before `page.DecoratePage(...)`/`page.Margin(...)` in
> a template: the decoration callback itself always sees the page's final
> size (it runs at render time), but margin math you compute inline needs
> the final `page.PageWidth`/`PageHeight` already set.

---

## Custom templates

A template is just a page-configuration callback — build your own with
`PdfTemplate.Create` using the exact same API the predefined templates use:

```csharp
var brandTemplate = PdfTemplate.Create((page, opts) =>
{
    page.PageColor(Color.White);

    page.Header().Background(opts.AccentColor).Padding(16)
        .Text(opts.Title ?? string.Empty).Bold().FontSize(20).FontColor(Color.White);

    page.Footer().AlignCenter().Text(t =>
    {
        t.Span("Page ");
        t.CurrentPageNumber();
    });
});

page.UseTemplate(brandTemplate, opts => opts.Title = "Custom Report");
```

Nothing about `PdfTemplate` is special — it's a reusable `Action<PageDescriptor,
TemplateOptions>`, so anything you could write directly in `doc.Page(page => ...)`
you can factor into a template and reuse across documents.
