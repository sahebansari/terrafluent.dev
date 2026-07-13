---
layout: doc
title: "Document Metadata — C# PDF Docs"
description: "TerraFluent.Pdf.Reporting allows you to set standard PDF document metadata properties that appear in the document properties dialog of PDF viewers (File"
permalink: /docs/pdf/metadata/
doc_section: PDF Reporting docs
doc_section_url: /docs/
doc_nav: pdf
source_url: https://github.com/sahebansari/TerraFluent.Pdf.Reporting/blob/main/docs/metadata.md
---

# Document Metadata

TerraFluent.Pdf.Reporting allows you to set standard PDF document metadata properties that appear in the document properties dialog of PDF viewers (File → Properties in Adobe Reader, Preview, etc.). These include Title, Author, Subject, Keywords, and Creator.

Metadata is set via methods on `IDocumentContainer` (the object passed to `PdfDocument.Create`).

---

## Supported Fields

| Method | PDF Key | Description |
|--------|---------|-------------|
| `MetadataTitle(string?)` | `/Title` | Document title |
| `MetadataAuthor(string?)` | `/Author` | Author name(s) |
| `MetadataSubject(string?)` | `/Subject` | Subject line / topic |
| `MetadataKeywords(string?)` | `/Keywords` | Comma- or semicolon-separated keywords |
| `MetadataCreator(string?)` | `/Creator` | Software that generated the PDF |

All methods accept `null` or whitespace strings to clear/omit that field.

---

## Basic Usage

Set metadata before adding pages (or after — order doesn't matter):

```csharp
using TerraFluent.Pdf.Reporting.Core;
using TerraFluent.Pdf.Reporting.Helpers;

PdfDocument.Create(c =>
{
    // Set metadata first (optional order)
    c.MetadataTitle("Quarterly Report Q1 2025");
    c.MetadataAuthor("Acme Finance Division");
    c.MetadataSubject("Financial Performance Review");
    c.MetadataKeywords("finance, quarterly, report, 2025");
    c.MetadataCreator("Acme Reporting Engine v3.2");

    // Add at least one page
    c.Page(p =>
    {
        p.Size(PageSize.A4);
        p.Margin(2, Unit.Centimetre);
        p.Content().Text("Report content goes here...");
    });
})
.PublishPdf("report.pdf");
```

The resulting PDF will contain an **Info dictionary**:

```pdf
<< /Title (Quarterly Report Q1 2025)
   /Author (Acme Finance Division)
   /Subject (Financial Performance Review)
   /Keywords (finance, quarterly, report, 2025)
   /Creator (Acme Reporting Engine v3.2)
   /Producer (TerraFluent.Pdf.Reporting)          % added automatically by TerraFluent.Pdf.Reporting? No
   /CreationDate (D:202505031...) % PDF viewers may add
>>
```

> **Note:** TerraFluent.Pdf.Reporting does not currently set `/Producer` or `/CreationDate` automatically. Only the fields you explicitly set appear in the Info dictionary.

---

## Null / Whitespace Handling

Passing `null`, empty, or whitespace-only strings omits that field from the Info dictionary:

```csharp
c.MetadataAuthor("");         // Author key not included
c.MetadataKeywords(null);    // Keywords key not included
c.MetadataTitle("   ");      // Title key not included
```

If **no metadata fields are set**, the Info dictionary is omitted entirely and the Catalog contains no `/Info` entry.

---

## Special Character Escaping

PDF string literals require escaping for:
- Backslash `\` → `\\`
- Opening parenthesis `(` → `\(`
- Closing parenthesis `)` → `\)`

TerraFluent.Pdf.Reporting handles this escaping automatically for all metadata values:

```csharp
c.MetadataTitle("Report (Final) \\ 2025");
// Escapes to: /Title (Report \(Final\) \\ 2025)
```

---

## API Reference

All metadata methods have the signature:

```csharp
void MetadataXxx(string? value);
```

They are chainable (though they return `void` — they are called for side effects on the composer, not for fluent chaining on the `IDocumentContainer`):

```csharp
c.MetadataTitle("My Doc");
c.MetadataAuthor("Jane Smith");
// Not chainable: c.MetadataTitle("...").MetadataAuthor("...") won't compile
```

If you need conditional setting:

```csharp
if (includeAuthor)
    c.MetadataAuthor(userName);
```

---

## PDF Structure Details

### Info Dictionary Object

When metadata is present, TerraFluent.Pdf.Reporting allocates a PDF object like:

```pdf
5 0 obj
<< /Title (My Document)
   /Author (John Smith)
   /CreationDate (D:20250503153000-05'00')
>>
endobj
```

### Catalog Reference

The Catalog object gains an `/Info` entry pointing to this dictionary:

```pdf
7 0 obj
<< /Type /Catalog
   /Pages 6 0 R
   /Info 5 0 R
>>
endobj
```

If no metadata is set, the `/Info` entry is omitted from the Catalog.

---

## Best Practices

### Set metadata early

Call metadata methods at the start of your `PdfDocument.Create` block to keep configuration together:

```csharp
PdfDocument.Create(c =>
{
    // Metadata first
    c.MetadataTitle("Invoice #12345");
    c.MetadataAuthor("Acme Billing");
    c.MetadataKeywords("invoice; billing; 2025");

    // Then pages
    c.Page(...);
})
```

### Use consistent keywords

PDF viewers use the Keywords field for search and filtering. Separate with commas or semicolons:

```
keywords: "quarterly, finance, board, q1"      // ← OK
keywords: "annual report; 2025; audit"          // ← OK
```

Avoid extremely long keyword strings.

### Include author when distributing externally

For documents that leave your organization, setting the `/Author` field aids traceability and professionalism.

### Combine with `Bookmark` for complete navigation

Metadata provides document identity; bookmarks provide in-document navigation:

```csharp
PdfDocument.Create(c =>
{
    c.MetadataTitle("User Guide");
    c.MetadataAuthor("Tech Writers Ltd");
    c.Bookmark("Introduction", 1);
    c.Bookmark("Installation", 2);
    c.Bookmark("Configuration", 3);
    // ...
});
```

---

## Limitations

- No support for custom metadata keys beyond the five standard fields. For advanced use cases (XMP metadata, custom XMP properties), you'd need to extend `PdfWriter` directly.
- No automatic population of `/CreationDate` or `/ModDate`. You can suggest a `Creator` string (e.g., app name + version), but PDF viewers show their own creation timestamp.
- All values are **text strings** — no date type parsing or numeric types. If you need a date field, format it yourself and put it into `Subject` or `Keywords`.
- Unicode beyond Latin-1 may not display correctly in older PDF viewers; TerraFluent.Pdf.Reporting uses ISO-8859-1 encoding for Info strings (same as content streams).

---

## Sample

A full working example is in the TerraFluent.Pdf.Reporting sample application:

```
samples/TerraFluent.Pdf.Reporting.Sample/Program.cs
```

Look for `Metadata` in the code or add the calls to any sample to produce a PDF with document properties filled in.

---

## Related

- [Getting Started](/docs/pdf/getting-started/) — basic document structure
- [Bookmarks](/docs/pdf/bookmarks/) — hierarchical outline entries for navigation
- [Page Sizes & Units](/docs/pdf/page-sizes-and-units/) — page configuration
