---
layout: doc
title: "Samples — C# Word DOCX Docs"
description: "The sample project creates several realistic .docx files and writes them to Desktop\\SampleDocs."
permalink: /docs/docx/samples/
doc_section: DOCX Reporting docs
doc_section_url: /docs/
doc_nav: docx
source_url: https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/docs/SAMPLES.md
---

# Samples


The sample project creates several realistic `.docx` files and writes them to `Desktop\SampleDocs`.

## Run All Samples

```powershell
dotnet run --project samples\TerraFluent.Docx.Reporting.Sample\TerraFluent.Docx.Reporting.Sample.csproj
```

## Sample Files

| Sample | Source | Demonstrates |
| --- | --- | --- |
| Feature showcase | [FeatureShowcaseSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/FeatureShowcaseSample.cs) | Headings, text, headers, footers, images, barcodes, hyperlinks, and general document structure. |
| Barcode showcase | [BarcodeShowcaseSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/BarcodeShowcaseSample.cs) | Shipping manifest with barcodes in a header, a table column, and standalone printable labels. |
| Market analysis | [MarketAnalysisSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/MarketAnalysisSample.cs) | Auto-numbered figure/table captions, table of figures and list of tables, sized/stacked/labeled charts, and comments-only document protection. |
| Invoice | [InvoiceSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/InvoiceSample.cs) | Invoice layout, branding, totals, and tables. |
| Long invoice | [LongInvoiceSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/LongInvoiceSample.cs) | Multi-page invoice behavior and repeated tabular content. |
| Annual report | [AnnualReportSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/AnnualReportSample.cs) | Realistic business report with sections, images, tables, and rich formatting. |
| Layout features | [LayoutFeaturesSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/LayoutFeaturesSample.cs) | Page size, orientation, margins, columns, watermarks, and layout behavior. |
| Template replacement | [TemplateReplacementSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/TemplateReplacementSample.cs) | Placeholder and content-control replacement. |
| API reference document | [ApiReferenceSample.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/ApiReferenceSample.cs) | Broad tour of the public descriptor API in generated document form. |

Support files:

- [InvoiceBranding.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/InvoiceBranding.cs)
- [SampleImage.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/SampleImage.cs)
- [SampleOutput.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/SampleOutput.cs)
- [Program.cs](https://github.com/sahebansari/TerraFluent.Docx.Reporting/blob/master/samples/TerraFluent.Docx.Reporting.Sample/Program.cs)

## Copy A Sample Pattern

For a new report, start with this structure:

```csharp
using TerraFluent.Docx.Reporting;

public static class ReportSample
{
    public static string Generate(string outputDirectory)
    {
        var path = Path.Combine(outputDirectory, "report.docx");

        Document.Create(doc =>
        {
            doc.MetadataTitle("Report")
               .MetadataAuthor("Reporting Team")
               .Theme(theme => theme.DefaultFont("Aptos", 10.5f));

            doc.Page(page =>
            {
                page.Size(PageSize.A4);
                page.Margin(Unit.Centimetre(2));
                page.Content().H1("Report");
                page.Content().Text("Add report content here.");
            });
        }).PublishDocx(path);

        return path;
    }
}
```

## Visual QA Checklist

After running samples:

- Open each generated `.docx` in Microsoft Word.
- Confirm there are no repair prompts.
- Refresh fields if you use a table of contents.
- Open or convert the same files in LibreOffice when cross-application compatibility matters.
- Check images, charts, page numbers, watermarks, and table layout.
