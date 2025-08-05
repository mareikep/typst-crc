#import "../crc-imports.typ": *

= General information

#{
  // consider citations prefixed with `bib-main-` for the bibliography of the main part of the document
  show: alexandria(prefix: "bib-main-")

  include "01-1-key-data.typ"
  include "01-2-research-profile-crc.typ"
  
  // print the bibliography for the main part. Move position of the bibliography up/down the 
  // documnt as required. Make sure to keep it within the curly braces and below the show 
  // rule for the `alexandria` package.
  heading(outlined: false, numbering: none, level: 2, [References])
  bibliographyx(
    read("../bib/main.bib", encoding: none),
    prefix: "bib-main-",
    title: none,
  )

  include "01-3-research-profile-applicant.typ"
  include "01-4-support-structures.typ"
  include "01-5-risks.typ"
  include "01-6-third-party-funding.typ"
}