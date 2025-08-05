Introduction
===

This proposal template will generate a CRC proposal including all required (funding) tables with values taken from metadata files. Read this manual carefully for successful document compilation with Typst, a novel typesetting language alternative to LaTeX. If you don't have Typst installed, you can still compile the document since a `typst` executable binary is provided with this package.

File structure
===

```bash
crc-2025/
├─ bib/                         # bibliography files for the main project and the subprojects
│  ├─ <project1-id>.bib
│  ├─ <project2-id>.bib
│  ├─ [...]
├─ contents/                    # the document contents, separated into single files for larger/important parts of the document
│  ├─ subprojects/              # the content files for the subprojects 
│  │  ├─ <03-project1-id>.typ
│  │  ├─ <03-project2-id>.typ
│  │  ├─ [...]
│  ├─ 00-titlepage-addon.typ      # the page that contains basic information about the CRC and is signed by the spokesperson and rector of the crc's host university
│  ├─ 01-0-general-info.typ       # the main sections of the "General information" part of the document as specified by the DFG
│  ├─ [...]
│  ├─ 01-6-third-party-funding.typ
│  ├─ 02-funding.typ
│  ├─ 03-project-details.typ
│  ├─ 04-bylaws.typ               # the bylaws of the CRC containing enumerated lists, automatically formatted into paragraphs and articles
│  ├─ 05-declaration-working-space.typ # the declaration on working space as specified by the DFG
│  ├─ 06-declaration-pubs.typ     # the declaration on lists of publications as specified by the DFG
│  ├─ colophon.typ                # colophon containing license information about the document template and contents
├─ img/                           # the directory to put image and graphics files
├─ metadata/                      # the metadata files read by the document to fill tables and other parts of the document
│  ├─ crc-aux.yaml                # see "Metadata => aux"
│  ├─ crc-data.yaml               # see "Metadata => data"
│  ├─ crc-metadata.xlsx           # the .xlsx file to be filled beforehand, see "Metadata => Spreadsheet"
│  ├─ crc-funding.yaml            # see "Metadata => funding"
│  ├─ crc-persons.yaml            # see "Metadata => persons"
│  ├─ crc-projects.yaml           # see "Metadata => projects"
├─ project-templates/             # contains project template files for each project type and status: 
│  ├─ <project-type>-<status>.typ #   project-type: {inf, mgk, research, transfer, wiko, z}
│  ├─ ...                         #   status: {C (cont'd), E (ending), N (new)}
├─ styles/                        # contains the style definitions for this proposal
│  ├─ cd-defs.typ                 # specify colors, fonts, logos and table style defaults
├─ template/                      # contains the template files for the document
│  ├─ img/                        # contains icons and other image files that are used throughout the template
│  ├─ styles/                     # contains style files, e.g. a modified version of the chicago-author-date.csl file
│  │  ├─ chicago-aut.....typ      # allows to add the variable "annote" to a bibkey which results in boldfacing the title to highlight important publications
│  ├─ tmpl-cover.typ              # the template for the cover of the printed version of the proposal
│  ├─ tmpl-crc-misc.typ           # contains helper functions, state definitions, etc.
│  ├─ tmpl-crc-proposal.typ       # contains the templates for the title page, proposal document and subproject parts
│  ├─ tmpl-crc-tables.typ         # contains the functions for the tables, which are automatically filled from the metadata files
├─ crc-2025.typ                   # the main document which calls the main template and includes the other content files
├─ crc-imports.typ                # the document's imports and proposal setup, see "Imports"
├─ Makefile                       # the main executive for the setup and compilation of the document, see "Document setup"
├─ read-metadata.py               # a python script to extract metadata from the .xlsx document into YAML files
├─ README.md                      # this document
├─ typst                          # an executable binary file to run Typst for document compilation
```

Document setup
=== 

The document relies on a couple of metadata files to fill parts of the document such as the front page, the headers/footers and the (funding) tables. Collect the data for these files in the `crc-metadata.xlsx`, which can, for example, be shared with the proposal's contributors/PIs via Google Docs. Make sure to follow the instructions given by the DFG (see the hints in the spreadsheet file) carefully, to prevent erroneous data in the calculations. More information about the different sheets of the document can be found below.

Spreadsheet
---

There are sheets that should only be edited by the admin, some that should be edited only by those who are in charge of the financial planning of the CRC and some that should be edited by contributors (such as project PIs or postdocs/phd's who are involved in the proposal writing). It is therefore advised to alter this document in 3 steps:

1. the `admin` fills the `AUX` and `crcData` sheets to setup the overall value ranges for the remaining sheets. Hide these sheets afterwards to prevent unauthorized manipulations of these information.
2. the `planner` fills sheets `overview`, `oeverviewBIG`, `staffRequestedAmount`, `staffOverviewRequested`, `staffOverviewExisting`, `directCostsOverviewExisting`, `earlyCareerGenderEquality`, and `genderEqualityStaff`. Hide certain sheets afterwards to prevent unauthorized manipulations of these information and confusion about what information to enter.
3. the `contributors` only add information to the remaining sheets such as `PIs`, `projects` and project-related funding details. 

Generally
- do not touch the columns called `EXPORT` (typically grey background)
- if there is an empty column A in front of a table, single rows can typically be ignored in the generation of the export commands by entering an `x`. This can be used when positions requested by the subprojects have to be cancelled for some reason without messing up the entire table.

The functions and usage of the sheets are detailed in the following. For more information, refer to the respective application template for the continuation of a Collaborative Research Centre (here: [DFG Form 60.200 – 09/24](https://www.dfg.de/de/formulare-60-200-246904)). Guide the contributors in filling out the tables using the information below.

### `EXPORT` ###

The very first sheet `EXPORT` is the most important sheet for the metadata extraction. It collects all information from the remaining sheets and combines them into YAML-structured strings, that are then extracted and written to separate YAML files by the python script provided. 

#### What to Edit ####

nothing! Do not touch this sheet, unless you know exactly what you are doing!

### `AUX` ###

This is the very last sheet that should only be edited by the administrator (consider hiding this sheet when having filled all information and publishing the document to contributors).

#### What to Edit ####

- column A: the list of projects in this CRC
- column C: the current personnel funding rates of the DFG (if necessary); currently based on the rates for [the year 2025](https://www.dfg.de/resource/blob/345094/31cd4b597ee7a1fc711a8f2566010783/60-12-2025-de-data.pdf).
- columns L-N: the universities and their abbreviations as well as departments or institutes involved in the CRC
- column R: the species of laboratory animals (if applicable)

Caution! All other categories should be treated _very_ carefully, as they are created based on previous DFG CRC proposal guides and are used in several tables/parts of the document that are automatically generated. Make sure only update these values if you understand where/how they are used throughout the generation of the document. 

### `overview` and `overviewBIG` ###

These sheets show overviews of the overall costs of the CRC sorted by projects, funding years and type of costs (staff, direct costs, instrumentation, ...), respectively (consider hiding this sheet when having filled all information and publishing the document to contributors).

#### What to Edit ####

- the funding information for the previous funding period in sheet `overview` (the funding for the applying period is filled automatically!)
- column B (project) in sheet `overviewBIG` -> the values for the remaining table are then filled automatically. Select each project exactly once in column B from the dropdown menu.

### `crcData` ###

Contains the general information about the CRC as for example printed on the front page of the document. 

#### What to Edit ####

- columns A-G: number, name, funding years of the CRC, ...
- columns H-K: the targeted _percentage_ of female PIs in different positions (postdoc, group leader, etc)

### `PIs` ###

Contains the personal information about each _person_ relevant to this proposal. This also includes persons not directly involved in the writing of the document, such as the dean or rector of the applying university. 

#### What to Edit ####

- columns B-E: name of the PI, special role within the CRC (and optional: special role text. This is used e.g. for the dean and rector to be printed below the signature fields of the declarations), column A is generated automatically from column B. Only edit if necessary, e.g. if there are multiple persons with the same generated `id`. 
- columns F-G: whether this person is a PI in the CRC or has a special status. The VIP status is typically true for everyone with a special role. 
- columns H-T: mostly self-explanatory information about the PIs. The location/contact information refer to the institutional address/phone number. The university can only be selected from a dropdown, to ensure consistent spelling (data for this dropdown comes from `AUX` sheet). 
- column U: select _all_ projects this PI is involved in from the multiple-choice dropdown.
- column V: comma-separated list of numbers 1-3, indicating during which funding period(s) this PI was involved in the CRC.
- columns W-Z: nationality/gender of the PI as well as their position and a position description (e.g. Head of Institute XY)
- columns AA-AF: The questions as displayed in the "General information about Project" of each project, see the comments of the respective column.

### `projects` ###

Contains all information about the projects in the CRC.

#### What to Edit ####

- columns A-C: the id, number and name/title of the project.
- column D: the status (C=continued, N=new, E=ending) of the project.
- column E: the project type as specified by the DFG (research/service, infrastructure, MGK, WIKO, transfer, administrative); column F is filled automatically from sheet `PIs`. 
- column G: the research areas this project is involved in (list of values of the dropdown generated from sheet research areas; see `researchareas`.)
- columns H-R: questions concerning legal issues such as vertebraes and recombinant DNA being involved in experiments, see the comments of the respective column.

### `staffRequestedAmount` ###

Contains the funding requested from the DFG for staff for each project (per year).

#### What to Edit ####

- only fill columns C, D, G and H (I, K, M, O, Q are automatically copied from column G but can be altered if necessary)

### `staffOverviewRequested` ###

Contains an overview of the information entered in `staffRequestedAmount`. Do not touch the numbers, as they are automatically calculated.

#### What to Edit ####

- only column A: select each project exactly once to generate a complete overview over all projects

### `staffExistingRequestedDetails` ###

This table contains detailed information about the personnel in the CRC. Here, not only requested staff is listed, but also existing, which may be funded by other funding sources. These information play a role in different parts of the document, e.g. the funding for staff tables in the subprojects including the job descriptions.

#### What to Edit ####

- column A: projects may be selected multiple times here, each row corresponds to one person
- column B: there are six categories to choose from: 
  - ExistingResearchStaff: research staff that is working in one or more projects of the CRC but is not funded by this CRC
  - ExistingNonResearchStaff: non-research staff that is working in one or more projects of the CRC but is not funded by this CRC
  - RequestedResearchStaff: research staff that is planned to work in one or more projects of the CRC and whose funding by the DFG is requested in this proposal
  - RequestedNonResearchStaff: non-research staff that is planned to work in one or more projects of the CRC and whose funding by the DFG is requested in this proposal
  - ApprovedResearchStaff: research staff that worked in one or more projects of the CRC and was funded in the previous funding period (they will be listed in the staff tables in the ending projects)
  - ApprovedNonResearchStaff: non-research staff that worked in one or more projects of the CRC and was funded in the previous funding period (they will be listed in the staff tables in the ending projects)
- column C-H: the personal information of the staff; if this person is listed in the `PIs` sheet, simply enter the `id`, the rest will be filled automatically (in the document, not this sheet). If the name of the person for a requested position is not yet determined, use "N.N." as name and leave the `nameFirst` empty. 
- columns I-L: the project commitment (h/wk), employment category of the person and its funding institution and source (where the person is funded from if not by the CRC, e.g. some scholarship X at University Y, only necessary for existing staff)
- column M: the description of the work planned for this position (existing, requested)/what the person has worked on in the previous funding period (approved)

### `staffOverviewExisting` ###

Contains an overview of the _existing_ staff for each institution. Do not alter the numbers. 

#### What to Edit ####

- only the institutions in row 3. If more than 7 institutions are involved in the CRC, you will need to extend the table and make sure, that the formulas in column J are updated.

### `directCostsRequested` ###

Contains the requested direct costs for each project. Each position as required for the justification tables in the document corresponds to one line in this sheet, i.e. there _may_ be multiple lines for each project-category combination. 

#### What to Edit ####

- columns B-I: the requested funding per year for each position of each project-category combination. See the DFG hints for the allowed categories.

### `directCostsByInstitutions` ###

Contains information about _existing_ direct costs (either provided by the applicant institution or requested from partner institutions) along with their respective funding source.

#### What to Edit ####

- columns B-I: the existing funding provided by the `category` institution through some `source` for each year. 

### `directCostsOverviewExisting` ###

Contains an overview of the information entered in `directCostsByInstitutions` sorted by applicant/non-applicant institution.

#### What to Edit ####

- rows 4-8 in the green part of the table: the funding provided in the previous funding period. The funding for the applying period will be automatically extracted from sheet `directCostsByInstitutions`.

### `listExistingInstrumentation` ###

Contains information about equipment with a (gross) cost exceeding 10,000 euros that is available or planned to be procured by the start of the requested funding period as listed in "2.1.3 List of existing instrumentation" in the proposal.

#### What to Edit ####

- columns B-H: the project that uses this equipment, the number, type and vendor of the equipment as well as purchase information

### `instrumentation`, `globalfunds` and `fellowships` ###

Contain funding information about requested instrumentation, global funds and fellowships (the latter is only relevant for MGK).

#### What to Edit ####

- columns B-I: the positions requested. The descriptions will be shown in the respective justification tables of the projects, the positions will be collated according to the categories in the tables for "Requested funding". See the DFG hints for the allowed categories and additional information.

### `earlyCareerSupport` ###

Contains the information about early career support (as listed in the first talbe of "1.4.1 Researchers in early career phases") of the proposal. 

#### What to Edit ####

- columns A-G: the funding source and topic for the early career support of some person

### `earlyCareerGenderEquality` ###

Contains contract durations of all academic staff employed in the CRC (as listed in the second table of "1.4.1 Researchers in early career phases")

#### What to Edit ####

- columns B-E: the number of female and male PhD/PostDocs with the respective contract durations in column A

### `genderEqualityStaff` ###

Contains information about the "Objectives for the participation of female researchers" (table A in 1.4.2 Promotion of equity and diversity)

#### What to Edit ####

- columns B-E: the current targeted percentage of female PhD's and postdocs as well as the actual number of males and females, where "current" refers to the current situation, i.e. as resulting from the previous funding period, and the _next_ targeted female percentage (i.e. for the applying period)
  
### `otherFundingSource` ###

Contains information about other funding sources of the PIs as listed in "1.6 Other sources of third-party funding for project leaders" of the proposal. 

#### What to Edit ####

- columns B-F: the `id` of he pi, the title of the project this PI is funded by and the periods and agency of the funding

### `upkeepLabAnimals` ###

Contains information about laboratory animals upkeep -- if applicable. 

#### What to Edit ####

- columns A-G: the project conducting experiments with animals, the involved species and their quantity and duration/costs

### `researchareas` ###

Contains DFG Classification of Scientific Disciplines, Research Areas, Review Boards and Subject Areas (2024-2028): https://www.dfg.de/resource/blob/331950/85717c3edb9ea8bd453d5110849865d3/fachsystematik-2024-2028-en-data.pdf.

Contributors can look up their respective research areas here since the dropdown in the `projects` sheet only shows the number code. 

#### What to Edit ####

- Update table once the DFG releases new classifications

Read metadata
---

Once the .xlsx file is fully filled, run the command 

`$ make prepare`

to generate the YAML metadata files. These files are used heavily in the Typst functions of the document's template. 

Update project files
---

!!! Generally, keep the document's file structure as is and only add/modify/delete files if you know what you are doing !!!

For each subproject in your CRC, add a file in `crc-2025/contents/subprojects` named `03-<projectid>.typ`. Use the templates of the respective project type and status provided in `crc-2025/templates` to make sure they have the correct structure.
If the subproject part of the document has (a) reference list(s), add a bibliography file in `crc-2025/bib` named `projectid>.bib`. Make sure that the `<projectid>` exists in the list of projects in the .xlsx file (and thus in the generated YAML files). 

The bibliography file for the main part of the document is called `crc-2025/bib/main.bib`. 

Compile
---

If necessary, make the `typst` binary executable by running 

`$ chmod +x ./typst`

Once all the necessary files are created, try to compile the document by calling 

`$ make all`

which will compile the document once and generate a PDF file called `crc-2025.pdf`. For continuing to work on the document and instantly seeing the document changes, run 

`$ make watch`

which will incrementally compile the document whenever any of the project files change. 

Main file
===

The main file `crc-2025.typ` initializes the entire template structure and includes the upper level files for the document. 
In particular, it calls the templates for the title page and imports everything from the `crc-imports.typ` file, triggering the initialization of the overall proposal template. This is moved to the imports file to make the variables available to other files, too. 

The main file includes
    - the titlepage
    - the colophon
    - the titlepage addon (which is signed by the applying university's rector as well as the spokesperson of the crc)
    - the content files of the main part
    - the project details file, which itself includes the subprojects
    - the formal contents as required by the DFG with 
        - the bylaws
        - the declaration on working space (signed by the person with role `dean`)
        - the declaration on publication lists (signed by the person with role `spokesperson` and the person with role `rector` as provided by the metadata)


Imports
===

The file `crc-2025/crc-imports.typ` contains all necessary package imports to compile this document at the time of shipping. If you want to use other packages in your subprojects, e.g. for drawing plots, import them here to appropriate the import to all document content files and avoid unnecessary and redundant imports.  

The `crc-proposal-setup` call within this file is used to make the metadata available to project content files, that do not have access to the metadata states (i.e. the ones that are included _before_ showing the `crc-proposal` template).

Metadata
===

Reading the spreadsheet metadata file, the `prepare` command generates 5 YAML files to structure the metadata. These files need to be passed to the proposal setup (`crc-proposal-setup` in `crc-imports.typ`), since they contain all the necessary information for filling the tables and other contents of the document. Internally, the information will be represented as typst `states`, and can therefore be accessed (and *ATTENTION*: _modified_) from anywhere* in the document. (*after the `show: proposal` call in the main document). Do **not** alter the data within these states during runtime, since this may cause undesired side effects and the calculations may not be valid anymore. 

In the following, the purpose of the 5 generated YAML files will be described:

crc-aux.yaml
---

The `auxiliary` metadata contains information about salaries of different positions as well as different kinds of categories one comes across in the document (such as project types, projects, genders, species, etc). There are also predefined questions that are printed in the general information part of each project and names (+ abbreviations) of universities and departments involved in the writing of this proposal. 

crc-data.yaml
---

The `crc` metadata includes general information about the CRC such as its name, number, funding period ect. These information are used throughout the document, e.g. on the title page, several (funding) tables and so on.

crc-funding.yaml
---

The `funding` metadata contains all information about existing and requested funding as entered in the spreadsheet. The funding information is used to calculate overall or project-specific funding and fill the respective tables accordingly. These tables are maintained carefully but may of course be subject to errors. Please make sure that all the numbers and information in the tables are correct before submitting!

crc-persons.yaml
---

The `persons` metadata contains information about (mostly) the PIs of the project but also other persons with special roles, e.g. the rector of the university, the dean, etc. The information us used in the overview tables of the PIs, the general information of each project, the headers in the subproject parts and the signature parts of the declarations/addons. 

crc-projects.yaml
---

Similarly to the `persons` metadata, the `projects` metadata contains all information about the subprojects, such as their id, title, assigned PIs, research areas and so on. 

