/* _src/pages/index.typ */
#let this = "_src/pages/index.typ"
#let highlight = "_src/common/highlight.typ"

// #set document(title: "BayRoB Docs")

#import "/_src/mod.typ": css, struct, excerpt, js, orcid
#import struct: text, box, table, align

#include "/_src/common/common.typ"

= typst-crc

== About

This repository provides a template for the continuation of a Collaborative Research Centre (CRC) written in the modern typesetting language Typst.

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
