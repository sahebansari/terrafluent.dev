---
layout: doc
title: "Getting Started — C# PDF Docs"
description: "Install TerraFluent.Pdf.Reporting from NuGet and generate your first PDF in C# — namespaces, quick start, and core concepts of the fluent API."
permalink: /docs/pdf/getting-started/
doc_section: PDF Reporting docs
doc_section_url: /docs/
doc_nav: pdf
source_url: https://github.com/sahebansari/TerraFluent.Pdf.Reporting/blob/main/docs/getting-started.md
---

# Getting Started with TerraFluent.Pdf.Reporting

## Installation

```sh
dotnet add package TerraFluent.Pdf.Reporting
```

## Namespaces

| Namespace | Contents |
|-----------|----------|
| `TerraFluent.Pdf.Reporting.Core` | Fluent API entry points, descriptors, extension methods |
| `TerraFluent.Pdf.Reporting.Infra` | `IContainer`, `IDocument`, `IComponent` interfaces |
| `TerraFluent.Pdf.Reporting.Helpers` | `Color`, `PageSize`, `Unit`, `TextStyle` |

---

TerraFluent.Pdf.Reporting includes everything document authorship needs out of the box: AES-256 encryption by default, images supplied from bytes or streams, anchor-based bookmarks that track rendered content automatically, and a multi-span text API with immutable `TextStyle` callbacks.

## Minimal Example

```csharp
using TerraFluent.Pdf.Reporting.Core;
using TerraFluent.Pdf.Reporting.Helpers;

PdfDocument.Create(container =>
{
    container.Page(page =>
    {
        page.Size(PageSize.A4);
        page.Margin(2, Unit.Centimetre);
        page.PageColor(Color.White);
        page.DefaultTextStyle(s => s.FontSize(11));

        page.Header().Text("My First PDF").Bold().FontSize(20);

        page.Content().Column(col =>
        {
            col.Spacing(8);
            col.Item().Text("Hello, TerraFluent.Pdf.Reporting!");
            col.Item().Text("A second paragraph.").Italic();
        });

        page.Footer().AlignCenter().Text(t =>
        {
            t.Span("Page ");
            t.CurrentPageNumber();
            t.Span(" / ");
            t.TotalPages();
        });
    });
})
.PublishPdf("output.pdf");
```

---

## Document Entry Points

```csharp
// Inline callback
PdfDocument.Create(container => { ... }).PublishPdf("output.pdf");

// Reusable IDocument class
PdfDocument.Create(new MyReport(data)).PublishPdf("output.pdf");
```

---

## Page Configuration

Every page is configured through `PageDescriptor`:

```csharp
container.Page(page =>
{
    // Size
    page.Size(PageSize.A4);                        // standard size
    page.Size(PageSize.Landscape(PageSize.A4));    // landscape
    page.Size(210, 297, Unit.Millimetre);          // explicit dimensions

    // Margins
    page.Margin(2, Unit.Centimetre);               // all sides
    page.MarginVertical(1, Unit.Centimetre);       // top + bottom
    page.MarginHorizontal(1.5, Unit.Centimetre);   // left + right
    page.Margin(top: 72, right: 54, bottom: 72, left: 54); // individual (points)

    // Appearance
    page.PageColor(Color.White);
    page.DefaultTextStyle(s => s.FontSize(11).FontColor(Color.Grey.Darken2));

    // Layout slots
    page.Header()   // IContainer — drawn above content on every page
    page.Content()  // IContainer — main scrollable area
    page.Footer()   // IContainer — drawn below content on every page
});
```

---

## Output Methods

```csharp
var composer = PdfDocument.Create(...);

// Write to file
composer.PublishPdf("report.pdf");

// Return as byte array (API responses, email attachments)
byte[] bytes = composer.PublishPdf();

// Write to any stream
using var stream = new MemoryStream();
composer.PublishPdf(stream);
```

---

## Next Steps

- [Text & Spans](/docs/pdf/text-and-spans/) — styling, underline, line-height, multi-span, page numbers
- [Layout](/docs/pdf/layout/) — Column, Row, Table
- [Decorators](/docs/pdf/decorators/) — Padding, Margin, Background, Border, Rounded Border, Per-Edge Borders, Alignment, Lines, PageBreak, Hyperlink, ShowIf
- [Vector Graphics](/docs/pdf/vector-graphics/) — Canvas API, lines, shapes, Bézier paths, polygons, grids, charts
- [Images](/docs/pdf/images/) — PNG and JPEG embedding
- [Encryption](/docs/pdf/encryption/) — AES-256 by default, plus AES-128 compatibility mode and permission flags
- [Table of Contents](/docs/pdf/table-of-contents/) — headings, automatic TOC generation, internal links
- [Bookmarks](/docs/pdf/bookmarks/) — PDF outlines / hierarchical navigation tree
- [Unicode & Character Encoding](/docs/pdf/unicode-and-encoding/) — WinAnsiEncoding coverage, Windows-1252 specials, Latin-1 Supplement, avoiding `?` characters
- [Metadata](/docs/pdf/metadata/) — document properties (Title, Author, Subject, Keywords, Creator)
- [Colors](/docs/pdf/colors/) — full built-in palette reference
- [Page Sizes & Units](/docs/pdf/page-sizes-and-units/) — all standard sizes and unit conversions
- [Components & Templates](/docs/pdf/components-and-templates/) — reusable `IComponent` and `IDocument`
- [Row & Column Layout](/docs/pdf/row-and-column-layout/) — deep dive with diagrams
