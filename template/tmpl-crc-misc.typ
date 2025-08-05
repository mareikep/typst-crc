#import "@preview/alexandria:0.2.0": *
#import "@preview/zero:0.2.0": num, set-group, set-num, set-round
#import "@preview/jumble:0.0.1"

#import "../styles/cd-defs.typ" as defs
#import "../dfg-research-areas.typ": dfg-research-areas

// state information to be filled with metadata from YAML files
#let s-crc-data = state("crc-data", (:))
#let s-crc-persons = state("crc-persons", (:))
#let s-crc-projects = state("crc-projects", (:))
#let s-crc-funding = state("crc-funding", (:))
#let s-crc-aux = state("crc-aux", (:))
#let s-current-project = state("current-project", none)
#let s-publicationlists = state("publicationlists", (:))
#let s-defs = state("defs", defs)

#let table-empty-msg = [-- None --]
#let table-missing-msg = text(red, [`Attention: Failed to generate table due to missing metadata.`])

///////////////////////////////////////////////////////////////////////////////

// an attempt to somewhat hash the given data `val`. Used to create a unique 
// counter (e.g. for repeated headers/continuation footers)
#let hashval(
  val
) = {
  if type(val) == str {
    return val
  } else if type(val) in (int, float) {
    return str(val)
  } else if type(val) == array {
    val.fold("", (prev, next) => prev + hashval(next))
  } else if type(val) == content {
    if val.fields().keys().contains("text") { 
      return val.text 
    } else if val.fields().keys().contains("children") { 
      return (val.children.enumerate().map(c => if c.at(1).has("text") { 
        c.at(1).text 
      } else { 
        hashval(c.at(1)) 
      }),).flatten().join("-")
    } 
  } else if type(val) == dictionary {
    return val.keys().fold("", (prev, next) => prev + str(next) + hashval(val.at(next)))
  } else {
    return "iamtrulyoutofideas"
  }
}

///////////////////////////////////////////////////////////////////////////////

#let repcounter(
  values,
  prefix: "justification-table-counter-"
) = {
  counter(prefix + jumble.bytes-to-hex(jumble.sha1(values)))
}

///////////////////////////////////////////////////////////////////////////////

// this is a template for a repeated table header, that shows different content
// depending on wheter it's the first (`first`) or continued (`contd`) pages 
// (for long tables). Requires a new counter `cntr` that needs to be created 
// beforehand 
// #let repheader(
//   first, 
//   cont, 
//   cntr
// ) = {
//   table.header({
//     cntr.step()
//     context {
//       if cntr.get().first() == 1 {
//         if type(first) == array {
//           first.map(it => table.cell(it))
//         } else {
//           first
//         }
//       } else {
//         cont
//       }
//     }
//   })
// }
#let repheader(
  first, 
  cont, 
  cntr
) = {
  table.header({
    cntr.step()
    context {
      if cntr.get().first() == 1 {
        if type(first) == array {
          first
        } else { 
          first
        }
      } else {
        cont
      }
    }
  })
}

///////////////////////////////////////////////////////////////////////////////

// similarly to repheader, this is a template for a continuation table footer, 
// that shows different content depending on wheter it's the first (`first`) 
// or continued (`contd`) pages (for long tables). Requires a new counter 
// `cntr` that needs to be created beforehand. By default, the continuation 
// footer is right-aligned in the first column. The optional parameter `numcols`
// lets the footer cell span `numcols` columns
#let continuation-footer(
  cont, 
  cntr, 
  first: none,
  numcols: 1
) = {
  table.footer({
    // Need to make the cell "invisible" / take no space when not used
    table.cell(inset: 0pt, colspan: numcols, context {
      // show continuation footer if we have header continuations
      // and we're not on the last one.
      let s = cntr.get()
      let t = cntr.final()
      if s.first() < t.first() {
        table.cell({
          set align(right)
          cont
        })
      } else {
        first
      }
    })
  })
}

///////////////////////////////////////////////////////////////////////////////

#let table-settings-default(
  lastrow,
  headerfill: true,
  bodystart: none,
  thinline: (),
  strongline: (),
  leftcols: (),
  rightcols: (),
) = {
  (
    align: (col, row) => if col in leftcols and row != 0 { left } else if col in rightcols and row != 0 { right } else { center } + horizon,
    inset: 5pt,
    stroke: (col, row) => if row == 0 { 
    (
      top: (
        thickness: defs.crc-style-defaults.table-stroke-thick, 
        paint: defs.crc-style-defaults.table-stroke-paint
      ), 
    ) } else if row == lastrow { 
    (
      bottom: (
        thickness: defs.crc-style-defaults.table-stroke-thick, 
        paint: defs.crc-style-defaults.table-stroke-paint
      )
    ) } else if row in thinline {
      (
        bottom: (
          thickness: defs.crc-style-defaults.table-stroke-thin, 
          paint: defs.crc-style-defaults.table-stroke-paint
        )
      )
    } else if row in strongline {
      (
        bottom: (
          thickness: defs.crc-style-defaults.table-stroke-thick, 
          paint: defs.crc-style-defaults.table-stroke-paint
        )        
      )
    } else { none },
    fill: (col, row) => 
    if row == 0 { defs.crc-style-defaults.table-header-fill } // first line of header is always filled
    else if calc.odd(row) { // let first row of body always be white, then alternate
      if bodystart != none and calc.odd(bodystart) {
        none 
      } else { 
        defs.crc-style-defaults.table-row-fill 
      }
    } 
    else { 
      if bodystart != none and calc.odd(bodystart) {
        defs.crc-style-defaults.table-row-fill 
      } else { 
        none
      }
    }
  )
}

///////////////////////////////////////////////////////////////////////////////

#let project-references(
  project, 
  refs
) = context {
  s-crc-data.update(orig-d => orig-d + (project + "-refs": refs))
  [updated refs to #s-crc-data.get().keys()]
}

///////////////////////////////////////////////////////////////////////////////

// define enums in bylaws to be paragraph-numbered
#let bylaws(
  body
) = {
  set enum(numbering: "§1.1", full: true)
  body
}

///////////////////////////////////////////////////////////////////////////////

// translates true to "yes" and false to "no" (for legal questions)
#let ifYesNo(
  answer
) = {
  if answer {
    [yes]
  } else {
    [no]
  }
}

///////////////////////////////////////////////////////////////////////////////

// same as ifYesNo, but adds tick and cross icons
#let ifYesNoIcon(
  answer,
  style: 1
) = {
  if answer {
    [#box(image(if style != 1 { "img/yes_style2.svg" } else { "img/yes.svg" }), height: 1em) yes]
  } else {
    [#box(image(if style != 1 { "img/no_style2.svg" } else { "img/no.svg" }), height: 1em) no]
  }
}

///////////////////////////////////////////////////////////////////////////////

// this function draws a signature line including 
// date/city/name/role for the given role. The relevant
// data is taken from the metadata
// Note: `role` can either be a string (id of person) or a dict (person data), 
// since this function might be called before s-crc-data is set up
#let signature(
  role,
  date,
  city
) = context {
  let pdata = role
  if type(role) == str {
    assert(s-crc-data.get().person.pairs().filter(it => it.at(1).vip).find(it => it.at(1).specialRole == role) != none, message: "Role " + role + " for signature does not exist.")
    let pid = s-crc-data.get().person.pairs().filter(it => it.at(1).vip).find(it => it.at(1).specialRole == role).first()
    pdata = s-crc-data.get().person.at(pid)
  }
  
  grid(
    columns: (.5fr, 1fr),
    stroke: (col, row) => if col == 1 and row == 1 { (top: .5pt) },
    row-gutter: 0pt,
    align: left+horizon,
    [#city, #date],
    [#v(-15pt)#text(font: "Noto Color Emoji", emoji.hand.write)], [],
    text(9pt, [#v(10pt)#pdata.title #pdata.name-first #pdata.name #if pdata.titlesuffix != none { [, #pdata.titlesuffix] } (#pdata.specialRoleText)])
  )
}

///////////////////////////////////////////////////////////////////////////////

// this function uses `signature` to draw multiple signature lines 
// for the given roles 
#let signatureMult(
  roles,
  date,
  city
) = context {
  for r in roles {
    signature(r, date, city)
    v(10em)
  }
}

///////////////////////////////////////////////////////////////////////////////

#let orcid(
  id,
  icon: true
) = {
  if icon { 
    link("https://orcid.org/"+id)[#box(baseline: 10%, height: .8em, image("img/orcid-logo.svg", height: 100%)) #id] 
  } else { 
    link("https://orcid.org/"+id)[#id]
  }
}

///////////////////////////////////////////////////////////////////////////////

// this function generates the content for a person's info, 
// as for example printed at the beginning of each subproject
// Note: `pi` can either be a string (id of person) or a dict (person data), 
// since this function might be called before s-crc-data is set up
#let personInfo(
  pi,
  icons: true
) = context {
  let pi = pi
  if type(pi) == str {
    assert(s-crc-data.get().person.keys().contains(pi), message: "PI " + pi + " does not exist in the database.")
    pi = s-crc-data.get().person.at(pi)
  }
  
  set par(justify: false)
  grid(
    columns: if icons { (.3cm, auto) } else { (0cm, auto) },
    row-gutter: 5pt,
    column-gutter: 3pt,
    align: (left+top, left+top),
    grid.cell(
      colspan: 2,
      [*#pi.name-first #pi.name*#if pi.title != none [, #pi.title]#if pi.titlesuffix != none [, #pi.titlesuffix]],
    ),
    grid.cell(
      colspan: 2,
      orcid(pi.orcid, icon: icons)
    ),
    if icons { box(height: .8em, image("img/avatar.svg", height: 100%)) }, [\*#pi.dateBirth, #pi.nationality],
    if icons { box(height: .8em, image("img/location.svg", height: 100%)) }, [#pi.institute],
    if icons { none }, pi.university,
    if icons { none }, [#pi.addressZIP #pi.addressCity],
    if icons { box(height: .8em, image("img/phone.svg", height: 100%)) }, [#pi.phone],
    if icons { box(height: .8em, image("img/mail.svg", height: 100%)) }, [#link("mailto:"+pi.email)[#pi.email]]
  )
}

///////////////////////////////////////////////////////////////////////////////
//							HELPER FUNCTIONS                                             //
///////////////////////////////////////////////////////////////////////////////

// creates a link to the respective project key data sheet and styles the
// link to be highlighted in the document (project color)
#let project(
	id,
	number: false,
	name: false,
	full: false,
   nostatus: false
) = context {
  assert(s-crc-data.get().project.keys().contains(lower(id)), message: "Project " + id + " does not exist in the database.")
  
  let colors = s-crc-data.get().colors
  let c = if colors.research.keys().contains(lower(id.at(0))) { 
    colors.research.at(lower(id.at(0))) 
    } else if colors.mgk.keys().contains(lower(id)) { 
      colors.mgk.at(lower(id)) 
    } else if colors.inf.keys().contains(lower(id)) { 
      colors.inf.at(lower(id)) 
    } else if colors.wiko.keys().contains(lower(id)) { 
      colors.wiko.at(lower(id)) 
    } else if colors.transfer.keys().contains(lower(id.at(0))) { 
      colors.transfer.at(lower(id.at(0))) 
    } else if colors.admin.keys().contains(lower(id)) { 
      colors.admin.at(lower(id)) 
    } else { colors.default }

  // generate styled content
  let cnt = none
  if number {
    cnt = [#text(c, [*#s-crc-data.get().project.at(lower(id)).number*])#if s-crc-data.get().project.at(lower(id)).status != "C" and not nostatus { [-#s-crc-data.get().project.at(lower(id)).status]}]
  } else if name {
    cnt = [#s-crc-data.get().project.at(lower(id)).name]
  } else if full {
    cnt = [#text(c, [*#s-crc-data.get().project.at(lower(id)).number*])#if s-crc-data.get().project.at(lower(id)).status != "C" and not nostatus { [-#s-crc-data.get().project.at(lower(id)).status]} - #s-crc-data.get().project.at(lower(id)).name]
  } else {
    cnt = [#text(c, [*#s-crc-data.get().project.at(lower(id)).number*])#if s-crc-data.get().project.at(lower(id)).status != "C" and not nostatus { [-#s-crc-data.get().project.at(lower(id)).status]}]
  }

  // if the link does not exist, create only the styled content
   if query(label("kd-project-" + lower(id))) != () {
    [#link(label("kd-project-" + lower(id)))[#cnt]]
  } else {
    cnt
  }
}

///////////////////////////////////////////////////////////////////////////////

// styles multiple project links
#let projects(
	id,
	number: false,
	name: false,
	full: false,
   nostatus: false,
   last: [ and ]
) = context {

	if type(id) != array {
		let id = (id,)
	}

	id.map(id_ => project(
			id_,
			number: number,
			name: name,
			full: full,
       nostatus: nostatus
		)).join([, ], last: last)
}

///////////////////////////////////////////////////////////////////////////////

// creates a link to the respective entry in the project leaders table and styles the
// link to be highlighted in the document (bold-faced)
#let pi(
	id,
	first: false,
	last: false,
	full: false
) = context {
  assert(s-crc-data.get().person.keys().contains(id), message: "PI " + id + " does not exist in the database.")

  // generate styled content
  let cnt = none
	if first {
    cnt = [*#s-crc-data.get().person.at(lower(id)).name-first #s-crc-data.get().person.at(lower(id)).name*]
	} else if last {
    cnt = [*#s-crc-data.get().person.at(lower(id)).name*]
	} else if full {
		cnt = [#if s-crc-data.get().person.at(lower(id)).title != none { [#s-crc-data.get().person.at(lower(id)).title] } *#s-crc-data.get().person.at(lower(id)).name-first #s-crc-data.get().person.at(lower(id)).name*#if s-crc-data.get().person.at(lower(id)).titlesuffix != none { [, #s-crc-data.get().person.at(lower(id)).titlesuffix] }]
	} else {
		cnt = [*#s-crc-data.get().person.at(lower(id)).name*]
	}

  // if the link does not exist, create only the styled content
  if query(label("pi-" + lower(id))) != () {
    [#link(label("pi-" + lower(id)))[#cnt]]
  } else {
    cnt
  }
}

///////////////////////////////////////////////////////////////////////////////

// styles multiple PI links
#let pis(
	id,
	first: false,
	last: false,
	full: false
) = context {

	if type(id) != array {
		let id = (id,)
	}

	id.map(id_ => pi(
			id_,
			first: first,
			last: last,
			full: full
		)).join([, ], last: [ and ])
}

///////////////////////////////////////////////////////////////////////////////

#let percentage-or-zero(
  a,
  b,
  precision: 0
) = {
  if b != 0 { num(calc.round((a/b) * 100, digits: precision)) } else { 0 }  
}

///////////////////////////////////////////////////////////////////////////////

#let num-or-zero(
  n
) = {
  if n != none { num(n) } else { num(0) }
}

///////////////////////////////////////////////////////////////////////////////

#let num-or-cross(
  n
) = {
  if type(n) == str { if n != "Total" { project(n) } else { n } } else if n != 0 { num(n) } else { text(gray, sym.times) }
}

///////////////////////////////////////////////////////////////////////////////

// helper function to transpose a matrix
#let transpose(
  mat
) = {
  if mat == () {
    return mat
  }
  return range(mat.at(0).len()).map(i => mat.map(row => row.at(i)))
}

///////////////////////////////////////////////////////////////////////////////

// redefine cite function to automatically use project-specific label
// Note: this does not affect citations triggered with the `@` symbol
#let cite_ = cite
#let cite(
  lbl,
  supplement: none,
  form: "normal",
  style: auto,
) = context [
  #let prefix = "bib-" + s-current-project.get() + "-"
  #let lbl_ = str(lbl)
  #if not lbl_.starts-with(prefix) {
    lbl_ = prefix + lbl_
  }
  #cite_(
    label(lbl_), 
    supplement: supplement, 
    form: form, 
    style: style
  )
]
