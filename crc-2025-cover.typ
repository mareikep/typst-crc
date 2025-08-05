#import "crc-imports.typ": *
#import "template/tmpl-cover.typ": cover-double as softcover
#import "styles/cd-defs.typ" as defs

// set default font
#set text(font: defs.font_default)

// style headings
#show heading: it => [
  // default font size for headings (here: only level 1)
  #let ts = 15pt

  #if it.level == 2 {
    // style level-2 headings to be highlighted with a blue background
		ts = 12pt
    box(
      fill: defs.col_darkblue, 
      height: 1cm, 
      width: 100%,
      align(
        left + horizon, 
        text(
          ts, 
          white,
          weight: "regular",
          hyphenate: false,
          [#h(1em)#it.body]
        )
      )
    )
	} else {
    it.body
  }
]

#let projects_res = data.project.values().filter(proj => proj.type in ("research", "transfer"))
#let projects_nonres = data.project.values().filter(proj => proj.type not in ("research", "transfer"))
#let areas = projects_res.map(it => it.number.first()).dedup()

// show rule to style project names to be colored and bold
#show regex("proj-(?<number>F|Z|MGK|INF|WIKO|[" + areas.join() + "]\d\d)(?<addendum>-num|-full|-name)*(?<status>-nostatus)*"): match => {

  let number = match.text.ends-with("-num")
  let name = match.text.ends-with("-name")
  let full = match.text.ends-with("-full")
  let nostatus = match.text.ends-with("-nostatus")
  let id = match.text.split("-num").first().split("-name").first().split("-full").first().split("-nostatus").first().split("proj-").last()
  let col = projectcolors.default
  
  if projectcolors.keys().contains(lower(id)) {
    col = projectcolors.at(lower(id)).at(lower(id))
  } else if projectcolors.research.keys().contains(lower(id).first()) {
    col = projectcolors.research.at(lower(id).first())
  } else if projectcolors.transfer.keys().contains(lower(id).first()) {
    col = projectcolors.transfer.at(lower(id).first())
  } else if projectcolors.admin.keys().contains(lower(id).first()) {
    col = projectcolors.admin.at(lower(id).first())
  } 

  let cnt = none
  if number {
    cnt = [#text(col, [*#data.project.at(lower(id)).number*])#if data.project.at(lower(id)).status != "C" and not nostatus { [-#data.project.at(lower(id)).status]}]
  } else if name {
    cnt = [#data.project.at(lower(id)).name]
  } else if full {
    cnt = [#text(col, [*#data.project.at(lower(id)).number*])#if data.project.at(lower(id)).status != "C" and not nostatus { [-#data.project.at(lower(id)).status]} - #data.project.at(lower(id)).name]
  } else {
    cnt = [#text(col, [*#data.project.at(lower(id)).number*])#if data.project.at(lower(id)).status != "C" and not nostatus { [-#data.project.at(lower(id)).status]}]
  }

  // if the link does not exist, create only the styled content
   if query(label("kd-project-" + lower(id))) != () {
    [#link(label("kd-project-" + lower(id)))[#cnt]]
  } else {
    cnt
  }
}

#let projects_res = areas.fold((:), (prev, next) => prev + ((next): (projects_res.filter(it => it.number.starts-with(next)).map(p => ([proj-#p.number\-nostatus], [#if p.status != "C" {p.status}], [#p.name])))))

#let projects_nonres = projects_nonres.map(p => ([proj-#p.number\-nostatus], [#if p.status != "C" {p.status}], [#p.name]))

// style grid 
#set grid(
  columns: (.12fr, .05fr,   1fr),
  align: (center, left, left),
  column-gutter: .2em,
  row-gutter: 1.5em,
  inset: (x, y) => if x == 0 {(
    x: 20pt,
  )} else { (:) }
)

// define text elements
#let text1 = text(font: defs.font_default, 16pt, defs.col_mediumblue, weight: "bold", [#data.crc.name -- #data.crc.name-full])
#let text2 = text(font: defs.font_default, 16pt, style: "italic", [ Funding Proposal for CRC #data.crc.number (#data.crc.funding-years.first() -- #data.crc.funding-years.last())])
#let back = [
    // content of back cover page
    #v(4em)

    = Overview of Subprojects

    #for (k, v) in projects_res [
      == Research Area #k

      #grid(
        ..v.join()
      )
    ]

    == Non-Scientific Projects

    #grid(
      ..projects_nonres.join()
    )
  ]

// parameterize cover template with text/image elements
#show: softcover.with(
  back: back,
  saddle: [#box(baseline: 40%, width: 20mm, defs.logo)#h(2em)#text1#h(.7em)#text2#h(.7em)], // text and logo for book saddle
  showguides: false,
  textcolor: black,
  bgimgfront: image("img/frontpage.svg", width: 80%), // using svg image for front cover page
  width: 444.8mm, // width of cover depends on number of pages
  height: 301.0mm,
  spine: 20.8mm, // width of spine depends on number of pages
  margin: 0pt, // only for textutal content, background images ignore margin!
  bleed: 2mm, // area that goes beyond the edge or "trim line" of the finished printed page
  fill: defs.col_lightback.lighten(70%)
)

#v(3em)
#align(right, box(fill: defs.col_lightback, inset: 10pt, [#text(defs.col_darkblue, weight: "regular", 25pt, [Proposal for the Collaborative Research Centre #data.crc.number])

#text(defs.col_darkblue, weight: "bold", 35pt, [#data.crc.name -- #data.crc.name-full])]))

#v(1fr)
#align(right, box(inset: 10pt, image("img/logo-uni.png", width: 3cm)))