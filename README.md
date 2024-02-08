# ITCR_Tables

## General description of repo

# Overview

This repo uses the [OTTR template](https://github.com/jhudsl/OTTR_Template) to [build the ITCR tools/resources table website](https://jhudatascience.org/ITCR_Tables/index.html). 

There are 6 tables that are generated:

- data resources
- clinical tools
- imaging tools
- multi-data type tools
- omics tools
- and all tools

These are generated using 5 input files (data resources, clinical, imaging, multi-data, and omics). The data resources table needs to be generated first so that a file with identifier acronyms is written that can be used in building the rest of the tables. Within each R Markdown file building the tables, the input file is read-in and then the table is formatted to add hyperlinks, rearrange columns, etc. 

Rather than saving these modified tables (clinical, imaging, multi-data, and omics) as output files, `knitr::knit_child` is used to force rendering the clinical, imaging, multi-data, and omics R Markdowns within the `allTables.Rmd`. This then allows the `allTables.Rmd` to inherit the modified table variables. Since the resources table has to be generated first, `knitr::knit_child` is used with the `resourcesTable.Rmd` first. The rows of these tables are joined together to form the all tools table (data resources are not included in this). 
      

## Adding to or editing the Resource Table

The resource table has different information for each resource compared to the tools in the other tables.

### Adding a new data resource to the tables

When adding a Data Resources Platform to the resources table, you will edit the first code block (which reads in the original `.csv` file) in [`resourcesTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/resourceTable.Rmd).

  * First, create a tibble for the new resource, including the following information:
    * "Name"
    * "Funding" ("Yes" or "No" --> If "Yes", then the ITCR logo will be displayed with the name)
    * "Subcategories"
    * "Data Type"
    * "Unique Factors"
    * "Price"
    * "Link"
    * "Summary"
    * "identifier" (an acronym)
  * Second, use the `dplyr::rows_insert` function with the `conflict = ignore` argument to add the new resource to the table. If the resource is already there, the `conflict = ignore` argument ensures that the addition will be skipped rather than causing an error.

<details>

<summary>Example:</summary>

```
new_PCDC <- tibble(
  Name = "Pediatric Cancer Data Commons (PCDC)",
  Funding = "Yes",
  Subcategories = "Clinical",
  `Data Type` = "ALL Data Commons, C3P, CHIC, FA Data Commons, Global REACH, HIBiSCus, INRG, INSPiRE, INSTRuCT, INTERACT, MaGIC, NOBLE, NODAL, Reproductive HOPE",
  `Unique Factors` = "Uses consensus-based data dictionaries and maps all clinical data in the portal to standardized terms; provides a data portal and analysis tools to assess study feasibility" ,
  Price = "Free",
  Link = "https://portal.pedscommons.org/login",
  Summary = "The PCDC Data Portal offers a unified platform where researchers can use the cohort explorer and other analysis tools to explore available data and assess study feasibility; if a user wishes to perform research with data from the PCDC, the proposed project undergoes review and approval by the relevant disease consortium.",
  identifier = "PCDC"
)

resource <- dplyr::rows_insert(resource, new_PCDC, conflict="ignore")
```
</details>

### Editing an existing data resource in the tables

When editing an existing entry in the resources table, you will edit the first code block (which reads in the original `itcr_table_resources.csv` file) in [`resourcesTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/resourceTable.Rmd).

* First, make a tibble with the name of the entry you want to edit as well as the column/info you want to edit. The column/info you want to edit should be one of the following columns:
  * "Name"
  * "Funding"
  * "Subcategories"
  * "Data Type"
  * "Unique Factors"
  * "Price"
  * "Link"
  * "Summary"
* Second, use the `dplyr::rows_update` function, with the `by="Name"` argument to update the resource, matching the update with the table entry by the matching name. If the name is wrong/needs updated, you'll have to update by some other unique information and specify it with the `by` argument.
* Note, that if it's a resource that was listed in `itcr_table_resources.csv`, its `identifier` acronym is listed/added in the `mutate` function within the first code block that loads the `.csv` file. Therefore, if you need to edit an identifier, either edit the identifier there in the mutate statement, or later with a `rows_update` function.

<details>

<summary>Example</summary>

```
tibbleTOPAS <- tibble(
  Name = "TOPAS",
  Price = '<a href="http://www.topasmc.org/licensing" style="color: #be3b2a" target="_blank"<div title="Pricing Link"> </div>Paid/Free</a>'
)

resource <- dplyr::rows_update(resource, tibbleTOPAS, by="Name") #this will update the existing TOPAS entry
```
</details>

## Adding to or editing the Clinical, Imaging, Multi-data type, and Omics Tables

Changes made to each of these tables will automatically propagate to the full table.

All of these tables need the same info for each tool:
* "Name"
* "Link (Hyperlinked Over Name)" (this link will be hyperlinked over the name in the displayed table)
* "Subcategories"
* "Unique Factor" (what makes it unique)
* "Data Types (Clean)"
* "Price" (Free, paid, etc?)
* "Documentation" (NA, or Documentation link for the tool)
* "Data Provided" ("No Data Provided" or acronyms comma separated, or something like "Curated Data Sources" --> if they're comma separated acronyms, they'll be linked in the formatted/displayed table using information from the resource table and the matching acronym)
* "Publications" (NA, or links to publications or blogs)
* "Summary"
* "Funding" ("Yes" or "No" --> If "Yes", then the ITCR logo will be displayed with the name)
* "PLink" (this link will be hyperlinked over the price information)


### Clinical table edits, specifically

When editing an existing entry in or adding a new tool to the clinical table, you will edit the first code block (which reads in the original `itcr_table_clinical.csv` file) in [`clinicalTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/clinicalTable.Rmd).

### Imaging table edits, specifically

When editing an existing entry in or adding a new tool to the imaging table, you will edit the first code block (which reads in the original `itcr_table_imaging.csv` file) in [`imagingTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/imagingTable.Rmd).

### Multi-data type table edits, specifically

When editing an existing entry in or adding a new tool to the Multi-data type table, you will edit the first code block (which reads in the original `itcr_table_general.csv` file) in [`omicsTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/multiTable.Rmd). You'll want to make any additions or edits after the `rename` function (that syncs the tool column names).

### Omics table edits, specifically

When editing an existing entry in or adding a new tool to the omics table, you will edit the first code block (which reads in the original `itcr_table_omics.csv` file) in [`omicsTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/omicsTable.Rmd).

### Adding a new tool to the tables

* First, create a tibble for the new tool, including the following information (see above for explanations of these tool columns):
  * "Name"
  * "Link (Hyperlinked Over Name)"
  * "Subcategories"
  * "Unique Factor"
  * "Data Types (Clean)"
  * "Price"
  * "Documentation"
  * "Data Provided"
  * "Publications"
  * "Summary"
  * "Funding"
  * "PLink"
* Second, use the `dplyr::rows_insert` function with the `conflict = ignore` argument to add the new tool to the table. If the tool is already there, the `conflict = ignore` argument ensures that the addition will be skipped rather than causing an error.

<details>
<summary>Example</summary>

```
new_imaging_CaPTk <- tibble(
  Name = "The Cancer Imaging Phenomics Toolkit (CaPTk)",
  `Link (Hyperlinked Over Name)` = "https://www.med.upenn.edu/cbica/captk/",
  Subcategories = "Radiomics",
  `Unique Factor` = "CaPTk is a stand-alone software client that allows for free image analysis through the Image Processing Portal (IPP) that offers compute power through CaPTk's supporting high performance computing cluster.",
  `Data Types (Clean)` = "Radiographic Imaging",
  Price = "Free",
  Documentation = "https://cbica.github.io/CaPTk/",
  `Data Provided` = "Sample Data available within CaPTk",
  Publications = "https://doi.org/10.1117/1.jmi.5.1.011018",
  `Summary` = "CaPTk is a software platform for analysis of radiographic cancer images, currently focusing on brain, breast, and lung cancer that integrates advanced, validated tools performing various aspects of medical image analysis, that have been developed in the context of active clinical research studies and collaborations toward addressing real clinical needs. CaPTk aims to facilitate the swift translation of advanced computational algorithms into routine clinical quantification, analysis, decision making, and reporting workflow.",
  Funding = "Yes",
  PLink = "https://github.com/CBICA/CaPTk/#downloads")

## Add new rows to the existing dataset
imaging <- dplyr::rows_insert(imaging, new_imaging_CaPTk, conflict = "ignore")
```

</details>

### Editing an existing tool in the tables

* First, make a tibble with the name of the entry you want to edit as well as the column(s)/info you want to edit. Make sure to use the correct column name. Possibilities include:
  * "Name"
  * "Link (Hyperlinked Over Name)"
  * "Subcategories"
  * "Unique Factor"
  * "Data Types (Clean)"
  * "Price"
  * "Documentation"
  * "Data Provided"
  * "Publications"
  * "Summary"
  * "Funding"
  * "PLink"
* Second, use the `dplyr::rows_update` function, with the `by="Name"` argument to update the resource, matching the update with the table entry by the matching name. If the name is wrong/needs updated, you'll have to update by some other unique information and specify it with the `by` argument.

<details>
<summary>Example</summary>

```
tibbleCGC <- tibble(
  Name = "Cancer Genome Collaboratory",
  `Data Provided` = "ICGC, PCAWG, DCC"
)

generalData <- dplyr::rows_update(generalData, tibbleCGC, by = "Name")
```

</details>

## Important files in the repo
### Rendered files

* [`resourcesTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/resourceTable.Rmd) -- renders the ["Data Resources" page](https://jhudatascience.org/ITCR_Tables/allTables.html)
* [`clinicalTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/clinicalTable.Rmd) -- renders the ["Computing Resources --> Clinical Platforms" page](https://jhudatascience.org/ITCR_Tables/clinicalTable.html)
* [`imagingTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/imagingTable.Rmd) -- renders the ["Computing Resources --> Imaging Platforms" page](https://jhudatascience.org/ITCR_Tables/imagingTable.html)
* [`multiTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/multiTable.Rmd) -- renders the ["Computing Resources --> Multi-data type Platforms" page](https://jhudatascience.org/ITCR_Tables/multiTable.html)
* [`omicsTable.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/omicsTable.Rmd) -- renders the ["Computing Resources --> Omics Platforms" page](https://jhudatascience.org/ITCR_Tables/omicsTable.html)
* [`allTables.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/allTables.Rmd) -- renders the ["Computing Resources --> All platforms" page](https://jhudatascience.org/ITCR_Tables/allTables.html)
* [`contact.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/contact.Rmd) -- renders the ["Contact" page](https://jhudatascience.org/ITCR_Tables/contact.html)
* [`feedback.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/feedback.Rmd) -- renders the ["Feedback Form" page](https://jhudatascience.org/ITCR_Tables/feedback.html)
* [`index.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/index.Rmd) -- renders the [home page](https://jhudatascience.org/ITCR_Tables/index.html)
* [`platformsOverview.Rmd`](https://github.com/jhudsl/ITCR_Tables/blob/main/platformsOverview.Rmd) -- renders the ["Computing Resources --> Platforms overview" page](https://jhudatascience.org/ITCR_Tables/platformsOverview.html)

### Other files, not rendered

* [`scripts/format-tables.R`](https://github.com/jhudsl/ITCR_Tables/blob/main/format-tables.R) -- functions that can be used to format the tables for the various `Table.Rmd` files. This script is sourced within the Rmarkdown files after loading libraries so the functions are available.
* [`contributing.md`](https://github.com/jhudsl/ITCR_Tables/blob/main/contributing.md) -- contributing guidelines (e.g., opening an issue or pull request)
* [`_site.yml`](https://github.com/jhudsl/ITCR_Tables/blob/main/_site.yml) -- which files are rendered and how the site is structured
