#import "../crc-imports.typ": *

= Project details

#let proj = crc-project.with(colors: projectcolors)

#context {
  for pid in data.aux.project.map(it => lower(it)) {
    // check whether current project has a bibliography and prepare the contents
    let hasbib = data.project.keys().filter(it => data.project.at(it).type in ("research", "inf", "transfer"))
    let prefix =  "bib-" + pid + "-"
    let bibfile = "../bib/" + upper(pid) + ".bib"
    let bibcontent = if pid in hasbib { read(bibfile, encoding: none) } else { none }

    // set state for current project, which is used in project-related tables 
    // to determine which data to show
    s-current-project.update(pid)

    // show template for crc subproject 
    show: proj.with(
      number: pid, 
      bib: bibcontent,
    )
   
    // load contents of respective subproject
    include "subprojects/03-" + upper(pid) + ".typ"
  }
}

// ==========================================================================
