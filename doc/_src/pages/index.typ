/* _src/pages/index.typ */
#let this = "_src/pages/index.typ"
#let highlight = "_src/common/highlight.typ"

// #set document(title: "BayRoB Docs")

#import "/_src/mod.typ": css, struct, excerpt, js, orcid
#import struct: text, box, table, align

#include "/_src/common/common.typ"

//=============================================================================

= typst-crc

== About

This repository provides a template for the continuation of a Collaborative Research Centre (CRC) written in the modern typesetting language Typst.

//=============================================================================

== System requirements

  - the proposal document building process was tested to compile on Ubuntu, Windows and MacOS. The respective binaries for the building process are shipped with this repository. However, if you encounter any difficulties, please report an #link("https://github.com/mareikep/typst-crc/issues")[issue on github.]
  - the Microsoft font `Arial` has to be installed on your system (required as the proposal font by the DFG)
    - on Ubuntu, run #excerpt.inline(`$ sudo apt install ttf-mscorefonts-installer`, lang: "bash") and #excerpt.inline(`$ sudo fc-cache -f`, lang: "bash") to install Windows fonts
  - the document can be built either using the provided `Makefile` or the `justfile`, i.e. the system needs to be able to execute either the `make` or `just` command
    - on Ubuntu, run #excerpt.inline(`$ sudo apt install build-essential`, lang: "bash") or #excerpt.inline(`$ sudo apt install build-essential`, lang: "bash") to use the `Makefile` build
    - on Ubuntu run #excerpt.inline(`$ sudo snap install just --classic`, lang: "bash") to use the `justfile` build
  - additional packages may be required for the `prepare` command, i.e. the extraction of information from the .xlsx file
    - run #excerpt.inline(`$ pip install --upgrade pip openpyxl`, lang: "bash")
  - `typst version >= 14.0` is required to build the document. The build executive will automaticaly use the binaries for Ubuntu, MacOS and Windows that are shipped with this repository if an installed version cannot be found.

//=============================================================================

== Release notes

  - Release 1.0.0 (August 2025)

    - *Initial Release*

//=============================================================================

== Contents
 
- #link("index.html")[typst-crc \[this document\]]
- #link("users.html")[For Contributors]
- #link("devs.html")[For Document Admins]

//=============================================================================

== Credits

=== Lead Developer

Mareike Picklum (#link("mailto:mareikep@cs.uni-bremen.de")[mareikep\@cs.uni-bremen.de])

//=============================================================================

=== Acknowledgments

This document has been generated using `Typst v0.14.0 (dd1e6e94)`.\
Illustrations and figures by ChatGPT.\
Copyediting by Mareike Picklum #orcid("0000-0003-2588-5119").

This template is inspired by the \LaTeX-template for a CRC proposal by Lukas C.~Bossert #orcid("0000-0003-3076-3968"), which is published under the MIT-licence: #smallcaps([DOI:])  #link("https://doi.org/10.18154/RWTH-2022-10554").
  
The Typst code for this document by Mareike Picklum #orcid("0000-0003-2588-5119") is published under the MIT-license: #link("https://github.com/mareikep/typst-crc").

//=============================================================================
