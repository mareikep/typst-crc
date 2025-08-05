#import "template/tmpl-crc-proposal.typ": *
#import "template/tmpl-crc-misc.typ": *
#import "template/tmpl-crc-tables.typ": *
#import "styles/cd-defs.typ" as defs

#let (
  proposal: proposal,
  data: data,
  projectcolors: projectcolors
) = crc-proposal-setup(
  author: (name: "AICOR"),
  logo-crc: image("img/logo-crc.png", width: 100%),
  logo-institution: image("img/logo-uni.png", width: 100%),
  data: yaml("metadata/crc-data.yaml"),
  persons: yaml("metadata/crc-persons.yaml"),
  projects: yaml("metadata/crc-projects.yaml"),
  funding: yaml("metadata/crc-funding.yaml"),
  aux: yaml("metadata/crc-aux.yaml"),
  projectcolors: (
    research: (
      "h": defs.col_mediumblue,
      "p": defs.col_accentred,
      "r": defs.col_accentgreen,
      "f": defs.col_mediumgrey
    ),
    mgk: (
      "mgk": defs.col_accentlime,
    ),
    inf: (
      "inf": defs.col_mediumgrey      
    ), 
    wiko: (
      "wiko": defs.col_accentorange
    ),
    transfer: (
      "t": defs.col_accentturquoise
    ),
    admin: (
      "z": defs.col_mediumgrey,      
    ),
    default: defs.col_mediumgrey
  )
)
