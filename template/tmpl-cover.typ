// measures by https://www.sedruck.de/softcover-klebebindung.html (250 pages)
#let cover-double(
  front,
  back: [],
  saddle: none,
  showguides: false,
  textcolor: black,
  bgimgfull: none,              // background image spanning entire double cover
  bgimgfront: none,             // background image only front page
  bgimgback: none,              // background image only back page
  width: none,                  // width of the cover (depends on #pages)
  height: none,                 // height of the cover
  spine: none,                  // width of the book spine (depends on #pages)
  margin: 2em,                  // inset of the text field (inner margin)
  bleed: none,                  // bleed (will be wrapped around/may be not visible)
  fill: none
) = {

  let cover-width = width
  let cover-height = height
  let spine-width = spine
  let cover-margin = margin
  let bleed-margin = bleed

  // set page measures and layout for background images 
  set page(
    width: cover-width, 
    height: cover-height, 
    margin: bleed-margin, 
    fill: fill,
    background: if bgimgfull != none { bgimgfull } else { 
      grid(
        columns: (1fr, spine-width, 1fr),
        align: (center+horizon, center+horizon, center+horizon),
        rect(
          stroke: none, 
          width: 100%, 
          height: 100%,
          inset: 0pt,
          if bgimgback == none {} else { bgimgback } // this is the background of the back cover page
        ),
        rect(
          stroke: none, 
          width: spine-width, 
          height: cover-height  
        ),
        rect(
          stroke: none, 
          width: 100%, 
          height: 100%, 
          inset: 0pt,
          if bgimgfront == none {} else { bgimgfront } // this is the background of the front cover page
        )
      )
    }
  )

  set text(fill: textcolor)
  let lines = if showguides { gray } else { none }

  // layout for contents
  grid(
    columns: (1fr, spine-width, 1fr),
    rect(
      stroke: lines, 
      width: 100%, 
      height: 100%,
      inset: cover-margin,
      back // this is the content of the back cover page
    ),
    rect(
      stroke: lines, 
      width: spine-width, 
      height: cover-height
    ),
    rect(
      stroke: lines, 
      width: 100%, 
      height: 100%,
      inset: cover-margin,
      front // this is the content of the front cover page
    )
  )
  place(center+horizon, rotate(-90deg, saddle))
}

#let cover-dissertation(
  front,
  back: [],
  title: none,
  subtitle: none,
  author: none,
  showguides: false,
  textcolor: black,
  bgimg: none
) = {

  show: cover-double.with(
    back: [
        #set par(justify: true)
        #v(1fr)
        #back
        #v(1fr)
        #align(center, author)
    ],// back
    saddle: [#text(weight: "bold",[#title#h(11em)])#text(weight: "regular",[#author])],
    showguides: showguides,
    textcolor: textcolor,
    bgimgfull: bgimg,
    width: 480.5mm,
    height: 340mm,
    spine: 15.5mm,
    margin: 10mm,
    bleed: 20mm
  )
  [
        #align(
          right, 
          [
            #v(1fr)
            #text(2em, weight: "bold", title)\
            #v(1em)
            #block(width: 12cm, text(1em, subtitle))
            #v(1em)
            _Dissertation_
            #v(1fr)
          ]
        )
        #align(center, author)
    ]
}

#let cover-a4(
  front,
  title: none,
  subtitle: none,
  author: none,
  showguides: false,
  textcolor: black,
  bgimg: none
) = {
  set page(
    width: 210mm, 
    height: 297mm, 
    margin: 10mm, 
    background: bgimg
  )

  set text(fill: textcolor, weight: "regular", 20pt)
  let lines = if showguides { textcolor } else { none }

  rect(
    stroke: lines, 
    width: 100%, 
    height: 100%,
    inset: 2em,
    [
      #align(
        right, 
        [
          #v(1fr)
          #text(2em, weight: "bold", title)\
          #v(1em)
          #block(width: 12cm, text(1em, subtitle))
          #v(1em)
          _Dissertation_
          #v(1fr)
        ]
      )
      #align(center, author)
    ]
  )
}