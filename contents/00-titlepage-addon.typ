#import "../crc-imports.typ": *

#page(
  numbering: none,
  align(
    center,
    [
      Proposal for the 3#super([rd]) Funding Period of\ Collaborative Research Centre #data.crc.number
  
      *"#data.crc.name-full"*
  
      #grid(
        columns: (1fr, 2fr),
        gutter: 15pt,
        align: (left, center, center),
        [funded since], [#data.crc.funded-since],
        [for], [#data.crc.funding-years.map(it => str(it)).join([-])],
        [Coordinating university], [#data.aux.universities.at(data.aux.universities.keys().at(0))]
      )
  
      #line(stroke: (thickness: 3pt, paint: defs.col_darkblue), length: 100%)
      
      #v(1em)
      
      #grid(
        columns: (1fr, 1fr),
        align: left,
        [
          *Spokesperson of\ the Collaborative Research Centre:*
          #personInfo(data.person.amehta)
        ],
        [
          *Management or office of\ the Collaborative Research Centre:*
          #personInfo(data.person.cdubois)
        ],
      )
        
      #v(1fr)

      #let sperson = data.person.pairs().filter(it => it.at(1).vip).find(it => it.at(1).specialRole == "spokesperson").first()
      #let rector = data.person.pairs().filter(it => it.at(1).vip).find(it => it.at(1).specialRole == "rector").first()
    
      #signatureMult(
        (
          data.person.at(sperson), 
          data.person.at(rector)
        ),
        datetime.today().display("[year]-[month]-[day]"),
        [Bremen]
      )
  
  
    ]
  )  
)
