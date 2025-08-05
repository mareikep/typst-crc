#import "../crc-imports.typ": *


#heading(outlined: false)[Declaration on working space for the Collaborative Research Centre]

Is the existing office and/or lab space sufficient to accommodate the \CRC at the time of submitting the proposal? #h(1fr)#ifYesNo(true)

#v(2em)

Will there be sufficient office and/or lab space to accommodate the \CRC including any planned extensions in the financial years  \

#context [
  #s-crc-data.get().crc.funding-years.at(0)#h(1fr)#ifYesNo(true)\ 
  #s-crc-data.get().crc.funding-years.at(1)#h(1fr)#ifYesNo(true)\ 
  #s-crc-data.get().crc.funding-years.at(2)#h(1fr)#ifYesNo(true)\ 
  #s-crc-data.get().crc.funding-years.at(3)#h(1fr)#ifYesNo(true)\ 
]

#v(1fr)

#signature(
  "dean",
  datetime.today().display("[year]-[month]-[day]"),
  [Bremen]
)

// ==========================================================================