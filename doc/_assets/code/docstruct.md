typst-crc/
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
    │  ├─ crc-<type>.yaml             # see "Metadata => {aux,data,funding,persons,projects}", will only appear after calling `make prepare`
    │  ├─ crc-metadata.xlsx           # the .xlsx file to be filled beforehand, see "Metadata => Spreadsheet"
    │  ├─ read-metadata.py            # a python script to extract metadata from the .xlsx document into YAML files
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
    ├─ README.md                      # this document
    ├─ typst-linux                    # an executable binary file to run Typst for document compilation on linux-based OS
    ├─ typst-darwin                   # an executable binary file to run Typst for document compilation on Darwin (MAC) OS
    ├─ typst.exe                      # an executable binary file to run Typst for document compilation on Windows OS