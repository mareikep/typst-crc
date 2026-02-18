#import "../crc-imports.typ": *


#heading(outlined: false)[Declaration on working space for the Collaborative Research Centre]

Is the existing office and/or lab space sufficient to accommodate the \CRC at the time of submitting the proposal? #h(1fr)#ifYesNo(true)

#v(2em)

Will there be sufficient office and/or lab space to accommodate the \CRC including any planned extensions in the financial years  \

#context [
  // load metadata
  #let metadata = query(metadata).find(it => "kind" in it.value and it.value.kind == "crc-data")
  #let fdy = if metadata != none { metadata.value.crc.funding-years } else { (:) }

  #fdy.at(0)#h(1fr)#ifYesNo(true)\ 
  #fdy.at(1)#h(1fr)#ifYesNo(true)\ 
  #fdy.at(2)#h(1fr)#ifYesNo(true)\ 
  #fdy.at(3)#h(1fr)#ifYesNo(true)\ 
]

#v(1fr)

#signature(
  "dean",
  datetime.today().display("[year]-[month]-[day]"),
  [Bremen]
)

// ==========================================================================