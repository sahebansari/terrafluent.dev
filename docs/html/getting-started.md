---
layout: doc
title: "Getting Started — C# HTML Report Generator Docs"
description: "TerraFluent.Html.Reporting targets both netstandard2.0 and net10.0 and has zero third-party dependencies. Add the package to your project:"
permalink: /docs/html/getting-started/
doc_section: HTML Reporting docs
doc_section_url: /docs/
doc_nav: html
source_url: https://github.com/sahebansari/TerraFluent.Html.Reporting/blob/master/docs/01-getting-started.md
---

# Getting Started

## Installation

TerraFluent.Html.Reporting targets both `netstandard2.0` and `net10.0` and has zero
third-party dependencies. Add the package to your project:

```
dotnet add package TerraFluent.Html.Reporting
```

## The four-step pipeline

Every report follows the same shape:

```csharp
using TerraFluent.Html.Reporting.Model;
using TerraFluent.Html.Reporting.Model.Elements;

var report = ReportDocument.Create(PageSize.A4, PageOrientation.Portrait)  // 1. start
    .SetMargins(40, 40, 60, 60)
    .Header(h => h.AddText("Monthly Sales Report").AlignCenter().Bold())   // 2. configure
    .Footer(f => f.AddPageNumber("Page {page} of {totalPages}"))
    .Content(c =>
    {
        c.AddHeading("Sales Summary", HeadingLevel.H1);
        c.AddParagraph("This report summarizes sales activity for the period.");
        c.AddImage("logo.png", widthPx: 120, heightPx: 60);
        c.AddTable(table =>
        {
            table.AddColumns("Product", "Qty", "Revenue");
            table.AddRow("Widget A", "120", "$2,400");
        });
    })
    .Build();                                                              // 3. build

string html = report.RenderHtml();                                        // 4. render
```

1. **`ReportDocument.Create(pageSize, orientation)`** returns a
   [`ReportDocumentBuilder`](https://github.com/sahebansari/TerraFluent.Html.Reporting/blob/master/src/TerraFluent.Html.Reporting/Fluent/ReportDocumentBuilder.cs)
   - despite living on `ReportDocument`, this is the fluent entry point, not
   the document itself.
2. **`.SetMargins(...)`, `.Header(...)`, `.Footer(...)`, `.Content(...)`**
   configure the builder. `Header`/`Footer`/`Content` each take an
   `Action<TBuilder>` callback - calling any of them more than once *appends*
   to the same section rather than replacing it.
3. **`.Build()`** produces an immutable [`ReportDocument`](https://github.com/sahebansari/TerraFluent.Html.Reporting/blob/master/src/TerraFluent.Html.Reporting/Model/ReportDocument.cs).
   Nothing is measured or paginated yet.
4. **`.RenderHtml(...)`** (or one of its siblings - see
   [Rendering](/docs/html/rendering/)) paginates the document and returns a single,
   self-contained HTML string: inline `<style>`, `@page` sizing, and one
   absolutely-positioned `<div>` per page. Open it directly in a browser, or
   use the browser's "Print to PDF" to get a paginated PDF with the same fixed
   page geometry and computed breaks.

## Anatomy of the example above

- **`PageSize.A4`** is one of three built-in sizes (`A4`, `Letter`, `Legal`);
  you can also build a custom size from millimeters, inches, or raw pixels.
  See [Core Concepts: Page geometry](/docs/html/core-concepts/#page-geometry-pagesize-margins-orientation).
- **`SetMargins(40, 40, 60, 60)`** sets top/right/bottom/left margins in
  pixels (there's also a `SetMargins(allEdgesPx)` overload for a uniform
  margin).
- **`Header`/`Footer`** are fixed-height sections repeated on every page. Their
  height is the sum of their elements' measured heights - there's no way to
  set an explicit header/footer height directly.
- **`Content`** is the paginated flow: the engine measures each element in
  order and starts a new page whenever the current one runs out of room,
  splitting at a line boundary (text) or row boundary (tables) where
  possible. See [Pagination and Layout](/docs/html/pagination-and-layout/).
- **`AddPageNumber("Page {page} of {totalPages}")`** is resolved per page
  after the whole document has been paginated, so the total page count is
  always correct even though you write the template before pagination
  happens.

## Running the sample project

The fastest way to see the library in action is the bundled sample project:

```
dotnet run --project samples/TerraFluent.Html.Reporting.Sample
```

This writes thirteen HTML files (one per scenario, e.g.
`01-getting-started.html`, `04-table-styling.html`,
`10-sales-invoice.html`, `12-invoice-with-barcode.html`,
`13-table-spans.html`) to the build output directory and prints how many
pages each one produced, plus any `LayoutWarning`s. Open any of them in a
browser - the fixed page geometry is what "Print to PDF" will produce. See
[`samples/TerraFluent.Html.Reporting.Sample/Program.cs`](https://github.com/sahebansari/TerraFluent.Html.Reporting/blob/master/samples/TerraFluent.Html.Reporting.Sample/Program.cs)
for the full scenario list, and the [Cookbook](/docs/html/cookbook/) for some of
them adapted into standalone recipes.

## Where to go next

- [Core Concepts](/docs/html/core-concepts/) for the document model and the
  immutability pattern you'll see on every element.
- [Content Elements](/docs/html/content-elements/) for the full list of `Add*`
  methods available in a header, footer, or the main content.
- [Cookbook](/docs/html/cookbook/) to copy a complete, working report.
