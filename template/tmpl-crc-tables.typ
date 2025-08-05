#import "tmpl-crc-misc.typ": *

#let use-asserts = false 

///////////////////////////////////////////////////////////////////////////////

// Used to list the items for the requested funds (e.g. direct costs, 
// instrumentation, ...).
// The parameter `data` expects a list of 
//    (
//      `description`: content, 
//      `value`: int|float, 
//      `funded-by`: content
//    ) 
// dictionaries for the single rows. 
// The `funded-by` entry is optional.
#let justification-table(
  header: none,
  data: ()
) = {

  let hash = hashval(header) + hashval(data)   
  let rep-counter = repcounter(hash)
  let numrows = data.len()
  
  table(
    stroke: (col, row) => if row == 0 { 
      (
        bottom: (
          thickness: 2pt, 
          paint: defs.table-style-defaults.table-stroke-paint
        ), 
      ) 
    } else if row == numrows {
      (
        bottom: (
          thickness: 2pt, 
          paint: defs.table-style-defaults.table-stroke-paint
        ), 
      )
    },
    fill: (col, row) => {
      if row != 0 and not calc.odd(row) {
        defs.table-style-defaults.table-row-fill 
      }
    }, 
    columns: (1fr, .1fr, .15fr),
    align: (left+horizon, center+top, right+top),
    repheader(
      [*#header*], 
      [#text(9pt, [...continued from the previous page.])],
      rep-counter
    ),
    ..data.map(it => (
      [#it.description#if it.keys().contains("funded-by") and it.funded-by != none [ _(#it.funded-by)_]], // description [, _(funded-by)_]
      [EUR], 
      [#num-or-zero(it.value)] // value
    )).flatten(),
    continuation-footer(
      box(inset: 5pt)[#text(9pt, [Continued on the following page...])],
      rep-counter,
      numcols: 3
    )
  )
}

///////////////////////////////////////////////////////////////////////////////
//										PART I - General information                           //
///////////////////////////////////////////////////////////////////////////////

#let general-overview-project-leaders() = context {
  // 1.1.2 Project Leaders

  if use-asserts {
    assert(s-crc-data.get().keys().contains("person"), message: "There is no person data available for the table 1.1.2 Project Leaders")
  }

  if not s-crc-data.get().keys().contains("person") {
    return table-missing-msg
  }

  let pis = s-crc-data.get().person.keys().filter(pid => s-crc-data.get().person.at(pid).pi)
  let person = s-crc-data.get().person

  // generate table data
  let tablebody = pis.map(pid => ([*#person.at(pid).name*#label("pi-" + pid), #person.at(pid).name-first\ #if person.at(pid).title != none { person.at(pid).title }#if person.at(pid).titlesuffix != none { person.at(pid).titlesuffix }], person.at(pid).gender.at(0), [#person.at(pid).yearDoctorate], [#person.at(pid).institute,\ #person.at(pid).university], person.at(pid).projects.map(proj => project(proj)).join([, ]))).flatten()

  let vals = pis.fold("", (prev, next) => prev + next)
  let rep-counter = repcounter(vals)

  // generate actual table
  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 1,
      leftcols: (0, 3)
    ),
    columns: (.9fr, .3fr, .4fr, 1fr, .4fr),
    table.header(
      repeat: true,
      [*Project leader*], [*Gender*], [*Doctorate obtained in*], [*Home institution,\ location*], [*Project(s)*],
      table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    // repheader(
    //   table.header(
    //   repeat: true,
    //   [*Project leader*], [*Gender*], [*Doctorate obtained in*], [*Home institution,\ location*], [*Project(s)*],
    //   table.hline(start: 0, end: 5, stroke: table-style-defaults.table-stroke-thin),
    // ), 
    //   table.cell(colspan: 5, align: left, [#text(9pt, [...continued from the previous page.])]),
    //   rep-counter
    // ),
    ..tablebody

  )
}

///////////////////////////////////////////////////////////////////////////////

#let general-participating-institutions() = context {
  // 1.1.3 Participating institutions

  if use-asserts {
    assert(s-crc-data.get().keys().contains("person"), message: "There is no data available for the table 1.1.3 Participating institutions")
  }

  if not s-crc-data.get().keys().contains("person") {
    return table-missing-msg
  }

  let person-db = s-crc-data.get().person
  let aux-db-unis = s-crc-data.get().aux.universities

  // get all the universities from the persons database, but only from the PIs
  let universities = person-db.keys().fold((), (a, b) => a + if person-db.at(b).pi and person-db.at(b).keys().contains("university") { (person-db.at(b).university, ) }).dedup().sorted()

  // create mapping from university to list of institutions
  let uni-inst = (:)
  for u in universities {
    let institutions = person-db.keys().fold((), (a, b) => a + if person-db.at(b).pi and person-db.at(b).university == u and person-db.at(b).keys().contains("institute") { (person-db.at(b).institute, ) }).dedup()
      uni-inst.insert(u + " (" + aux-db-unis.keys().at(aux-db-unis.values().position(it => it == u)) + ")", institutions)        
  }  

  // print universities with their institutions
  for (uni_, institutions_) in uni-inst {
    heading(level: 4, numbering: none, outlined: false, uni_)
    for i in institutions_ {
      [#i\ ]
    }
  }
  v(1em)
}

///////////////////////////////////////////////////////////////////////////////

#let general-overview-projects-groups() = context {
  // 1.1.4 Project groups and projects

  if use-asserts {
    assert(s-crc-data.get().keys().contains("project"), message: "There is no project data available for the table 1.1.4 Project groups and projects")
  }

  if not s-crc-data.get().keys().contains("project") {
    return table-missing-msg
  }

  let project-db = s-crc-data.get().project
  let person-db = s-crc-data.get().person
  let research = project-db.keys().filter(proj => project-db.at(proj).type in ("research", "transfer"))
  let project-areas = research.map(rp => rp.at(0)).dedup()
  let others = project-db.keys().filter(proj => project-db.at(proj).type not in ("research", "transfer"))
  let research-areas = project-db.keys().fold((), (a, b) => a + if project-db.at(b).keys().contains("area") { project-db.at(b).area }).dedup()

  // draw tables for research projects
  for proj in project-areas {
      align(center, [*Project area #upper(proj.at(0))*])

      // group projects
      let projects = project-db.keys().filter(p => project-db.at(p).type in ("research", "transfer") and lower(project-db.at(p).number.at(0)) == proj)

      // generate table data
      let tablebody = projects.map(p => (project(lower(project-db.at(p).number), nostatus: true), if project-db.at(p).status != "C" { project-db.at(p).status }, project-db.at(p).name, project-db.at(p).area.join([, ]), [#project-db.at(p).pi.map(pid => [#pi(pid, first: true), #person-db.at(pid).institute,\ #person-db.at(pid).university]).join([\ ])])).flatten()

      // generate actual table
      let numrows = calc.ceil(tablebody.len() / 5)
      table(
        ..table-settings-default(
          numrows, 
          bodystart: 1, 
          leftcols: (2, 4)
        ),
        columns: (.5fr, .22fr, 1fr, .5fr, 1fr),
        table.header(
          repeat: true,
          [*Project*], [*Status*], [*Title*], [*Research area*], [*Projet leader(s),\ institute(s),\ location(s)*],
          table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
        ),
        ..tablebody,
      )
      v(2em)
  }

  // draw table for non-research projects
  align(center, [*Non-research projects*])

  // generate table data
  let tablebody = others.map(p => (project(lower(project-db.at(p).number)), if project-db.at(p).status != "C" { project-db.at(p).status }, project-db.at(p).name, [], [#project-db.at(p).pi.map(pid => [#pi(pid, first: true), #person-db.at(pid).institute,\ #person-db.at(pid).university]).join([\ ])])).flatten()

  // generate actual table
  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 1,
      leftcols: (2, 4)
    ),
    columns: (.5fr, .2fr, 1fr, .5fr, 1fr),
    table.header(
      repeat: true,
      [*Project*], [*Status*], [*Title*], [*Research area*], [*Projet leader(s),\ institute(s),\ location(s)*],
      table.hline(start: 0, end: 5, stroke: defs.table-style-defaults.table-stroke-thin),
    ),
    ..tablebody
  )
  text(
    9pt, 
    [*N*: New projects started in the second funding period; *E*: Ending projects not continued in
    the second funding period;\ Research project-areas according to the German Research Foundation
    (2024–2028) #footnote(link("https://www.dfg.de/resource/blob/331950/85717c3edb9ea8bd453d5110849865d3/
    fachsystematik-2024-2028-en-data.pdf")):\ #research-areas.sorted().map(ra => [*#ra*: #dfg-research-areas.at(ra)]).join([, ]) ]
  )
  
}

///////////////////////////////////////////////////////////////////////////////

#let general-early-career-phases() = context {
  // 1.4.1 Researchers in early career phases

  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().at("funding", default: (:)).at("earlyCareerSupport", default: none) != none, message: "There is no data available for the table 1.4.1 Researchers in early career phases")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().at("funding", default: (:)).at("earlyCareerSupport", default: none) == none {
    return table-missing-msg
  }

  let funds-earlycareer = s-crc-data.get().funding.earlyCareerSupport
  let tablebody = funds-earlycareer.map(it => (project(it.project), [#it.name, #it.nameFirst], it.fundingSource, it.topic, [#it.periodStart - #it.periodEnd])).flatten()

  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 1,
      leftcols: (1, 2, 3)
    ),
    columns: (.4fr, 1fr, .5fr, 1fr, .5fr),
    table.header(
      repeat: true,
      [*Project*], [*Surname, first name*], [*Type of\ funding*], [*Topic*], [*Duration*],
      table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
  )

  let funds-equality = s-crc-data.get().funding.earlyCareerGenderEquality
  let tablebody = funds-equality.map(it => (
    [Up to #it.duration months], 
    [#it.PhD-male], 
    [#it.PhD-female], 
    [#it.PostDoc-male], 
    [#it.PostDoc-female], 
    [#it.total-number]
  )).flatten()

  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(
      numrows, 
      leftcols: ()
    ),
    columns: (1.1fr, .9fr, .8fr, 1fr, 1fr, 1fr),
    table.header(
      repeat: true,
      table.cell(
        rowspan: 2,
        [*Duration of\ contract*],
      ), 
      table.cell(
        colspan: 2,
        [*Number of contracts\ for doctoral researchers*],
      ), table.cell(
        colspan: 2,
        [*Number of contracts\ for postdoctoral researchers*],
      ),
      table.cell(
        rowspan: 2,
        [*Number of\ researchers in total*],
      ),
      [male], [female], [male], [female],
      table.hline(start: 0, end: 6, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
  )
}

///////////////////////////////////////////////////////////////////////////////

#let general-objectives-female-researchers() = context {
  // 1.4.2 Objectives for the participation of female researchers
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().at("funding", default: (:)).at("genderEqualityStaff", default: none) != none, message: "There is no data available for the table 1.4.2 Objectives for the participation of female researchers")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().at("funding", default: (:)).at("genderEqualityStaff", default: none) == none {
    return table-missing-msg
  }

  let funds = s-crc-data.get().funding.genderEqualityStaff
  let tablebody = funds.map(it => (
    [#it.position], 
    [#it.at("current-targeted-female-percentage")], 
    [#it.at("current-female")], 
    [#percentage-or-zero(it.at("current-female"), it.at("current-female") + it.at("current-male"))], 
    [#it.at("next-targeted-female-percentage")]
  )).flatten()

  let numrows = 4
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 3, 
      leftcols: (0,)
    ),
    columns: (1fr, .5fr, .5fr, .5fr, .7fr),
    table.header(
      repeat: true,
      table.cell(
        rowspan: 3,
        [],
      ), 
      table.cell(
        colspan: 3,
        [*2#super[nd] funding period*],
      ),
      [*3#super[rd] funding period*],
      [*Objective\ [%]*], 
      table.cell(
        colspan: 2,
        [*Status Quo#super([a])*],
      ), [*Objective\ [%]*], [], [*Number*], [*[%]*], [],
      table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
    table.footer(
      table.cell(
        colspan: 5,
        align: left,
        fill: none,
        text(9pt, [#super([a]) Reference date: proposal for 3#super([rd]) funding period]))
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let general-objectives-female-leaders() = context {
  // 1.4.2 Objectives for the participation of female project leaders
  if use-asserts {
    assert(s-crc-data.get().keys().contains("person"), message: "There is no data available for the table1.4.2 Objectives for the participation of female project leaders")
  }

  if not s-crc-data.get().keys().contains("person") {
    return table-missing-msg
  }

  let crcdata = s-crc-data.get().crc // this is where the objectives for female researchers for the current (=ending) period can be found
  let pis = s-crc-data.get().person.keys().filter(pid => s-crc-data.get().person.at(pid).pi).map(it => s-crc-data.get().person.at(it))

  // current absolute
  let femalePostDocCurrent = pis.filter(pi => pi.gender == "female" and 2 in pi.periods and pi.position == "postDoc").len()
  
  let diversePostDocCurrent = pis.filter(pi => pi.gender == "diverse" and 2 in pi.periods and pi.position == "postDoc").len()
  
  let malePostDocCurrent = pis.filter(pi => pi.gender == "male" and 2 in pi.periods and pi.position == "postDoc").len()

  
  let femaleJuniorCurrent = pis.filter(pi => pi.gender == "female" and 2 in pi.periods and pi.position in ("researchGroupLeader", "juniorResearchGroupLeader", "juniorProfessor")).len()

  let diverseJuniorCurrent = pis.filter(pi => pi.gender == "diverse" and 2 in pi.periods and pi.position in ("researchGroupLeader", "juniorResearchGroupLeader", "juniorProfessor")).len()

  let maleJuniorCurrent = pis.filter(pi => pi.gender == "male" and 2 in pi.periods and pi.position in ("researchGroupLeader", "juniorResearchGroupLeader", "juniorProfessor")).len()

  
  let femaleProfW2Current = pis.filter(pi => pi.gender == "female" and 2 in pi.periods and pi.position == "prof-W2").len()
  
  let diverseProfW2Current = pis.filter(pi => pi.gender == "diverse" and 2 in pi.periods and pi.position == "prof-W2").len()
  
  let maleProfW2Current = pis.filter(pi => pi.gender == "male" and 2 in pi.periods and pi.position == "prof-W2").len()

  
  let femaleProfW3Current = pis.filter(pi => pi.gender == "female" and 2 in pi.periods and pi.position == "prof-W3").len()
  
  let diverseProfW3Current = pis.filter(pi => pi.gender == "diverse" and 2 in pi.periods and pi.position == "prof-W3").len()
  
  let maleProfW3Current = pis.filter(pi => pi.gender == "male" and 2 in pi.periods and pi.position == "prof-W3").len()
  
  // current percentage 
  let femalePostDocPercentageCurrent = percentage-or-zero(femalePostDocCurrent, femalePostDocCurrent + malePostDocCurrent + diversePostDocCurrent)

  let diversePostDocPercentageCurrent = percentage-or-zero(diversePostDocCurrent, femalePostDocCurrent + malePostDocCurrent + diversePostDocCurrent)

  let malePostDocPercentageCurrent = percentage-or-zero(malePostDocCurrent, femalePostDocCurrent + malePostDocCurrent + diversePostDocCurrent)


  let femaleJuniorPercentageCurrent = percentage-or-zero(femaleJuniorCurrent, femaleJuniorCurrent + maleJuniorCurrent + diverseJuniorCurrent)

  let diverseJuniorPercentageCurrent = percentage-or-zero(diverseJuniorCurrent, femaleJuniorCurrent + maleJuniorCurrent + diverseJuniorCurrent)

  let maleJuniorPercentageCurrent = percentage-or-zero(maleJuniorCurrent, femaleJuniorCurrent + maleJuniorCurrent + diverseJuniorCurrent)


  let femaleProfW2PercentageCurrent = percentage-or-zero(femaleProfW2Current, femaleProfW2Current + maleProfW2Current + diverseProfW2Current)

  let diverseProfW2PercentageCurrent = percentage-or-zero(diverseProfW2Current, femaleProfW2Current + maleProfW2Current + diverseProfW2Current)

  let maleProfW2PercentageCurrent = percentage-or-zero(maleProfW2Current, femaleProfW2Current + maleProfW2Current + diverseProfW2Current)


  let femaleProfW3PercentageCurrent = percentage-or-zero(femaleProfW3Current, femaleProfW3Current + maleProfW3Current + diverseProfW3Current)

  let diverseProfW3PercentageCurrent = percentage-or-zero(diverseProfW3Current, femaleProfW3Current + maleProfW3Current + diverseProfW3Current)

  let maleProfW3PercentageCurrent = percentage-or-zero(maleProfW3Current, femaleProfW3Current + maleProfW3Current + diverseProfW3Current)

  
  // next precentage
  let femalePostDocPercentageNext = pis.filter(pi => pi.gender == "female" and 3 in pi.periods and pi.position == "postDoc").len()
  
  let femaleJuniorPercentageNext = pis.filter(pi => pi.gender == "female" and 3 in pi.periods and pi.position in ("researchGroupLeader", "juniorResearchGroupLeader", "juniorProfessor")).len()
 
  let femaleProfW2PercentageNext = pis.filter(pi => pi.gender == "female" and 3 in pi.periods and pi.position == "prof-W2").len()
  
  let femaleProfW3PercentageNext = pis.filter(pi => pi.gender == "female" and 3 in pi.periods and pi.position == "prof-W3").len()

  // totals
  let femaleCurrentTotal = femalePostDocCurrent+femaleJuniorCurrent+femaleProfW2Current+femaleProfW3Current

  let maleCurrentTotal = malePostDocCurrent+maleJuniorCurrent+maleProfW2Current+maleProfW3Current

  let diverseCurrentTotal = diversePostDocCurrent+diverseJuniorCurrent+diverseProfW2Current+diverseProfW3Current

  let sumall = femaleCurrentTotal + maleCurrentTotal + diverseCurrentTotal
  
  let tablebody = (
    [Postdoctoral researchers], [#crcdata.current-targeted-female-PIpostDoc-percentage], [#femalePostDocCurrent],[#malePostDocCurrent],[#diversePostDocCurrent],[#femalePostDocPercentageCurrent],[#malePostDocPercentageCurrent],[#diversePostDocPercentageCurrent],[#femalePostDocPercentageNext],
    
    [Research group leaders,\ junior research group leaders,\ junior professors 
    ], [#crcdata.current-targeted-female-PIresearchGroupLeader-percentage],[#femaleJuniorCurrent],[#maleJuniorCurrent],[#diverseJuniorCurrent],[#femaleJuniorPercentageCurrent],[#maleJuniorPercentageCurrent],[#diverseJuniorPercentageCurrent],[#femaleJuniorPercentageNext],
    
    [Professors W2/C3], [#crcdata.current-targeted-female-PIprof-W2-percentage],[#femaleProfW2Current],[#maleProfW2Current],[#diverseProfW2Current],[#femaleProfW2PercentageCurrent],[#maleProfW2PercentageCurrent],[#diverseProfW2PercentageCurrent],[#femaleProfW2PercentageNext],
    
    [Professors W3/C4], [#crcdata.current-targeted-female-PIprof-W3-percentage], [#femaleProfW3Current],[#maleProfW3Current],[#diverseProfW3Current],[#femaleProfW3PercentageCurrent],[#maleProfW3PercentageCurrent],[#diverseProfW3PercentageCurrent],[#femaleProfW3PercentageNext],
    
    [*Total*], none, [#femaleCurrentTotal], [#maleCurrentTotal],[#diverseCurrentTotal],[#percentage-or-zero(femaleCurrentTotal, sumall, precision: 2)],[#percentage-or-zero(maleCurrentTotal, sumall, precision: 2)],[#percentage-or-zero(diverseCurrentTotal, sumall, precision: 2)], none
  )

  let numrows = calc.ceil((tablebody.len() / 5)-1)
  table(
    ..table-settings-default(
      numrows,
      bodystart: 4,
      leftcols: (0,)
    ),
    columns: (1fr, .4fr, .2fr, .2fr, .2fr, .2fr, .2fr, .2fr, .5fr),
    table.header(
      repeat: true,
      table.cell(
        rowspan: 4,
        [*Position*],
      ),
      table.cell(
        colspan: 7,
        [*2#super[nd] funding period*],
      ),
      [*3#super[rd] funding period*],
     table.cell(
        rowspan: 2,     
        [*Objective\ [%]*],
      ),
      table.cell(
        colspan: 6,
        align: center+horizon,
        [*Status Quo#super([a])*],
      ),
      table.cell(
        rowspan: 2,     
        [*Objective\ [%]*],
      ),
      table.cell(
        colspan: 3,
        align: center+horizon,
        [*Number*],
      ),
      table.cell(
        colspan: 3,
        align: center+horizon,
        [*[%]*],
      ),
      [],
      [*f*], [*m*], [*d*],
      [*f*], [*m*], [*d*],
      [*f*],
      table.hline(start: 0, end: 9, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
    table.footer(
      table.cell(
        colspan: 9,
        align: left,
        fill: none,
        text(9pt, [#super([a]) Reference date: proposal for 3#super([rd]) funding period]))
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let general-other-sources-funding-leaders() = context {
  // 1.6 Other sources of third-party funding for project leaders
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("otherFundingSource", default: none) != none, message: "There is no data available for the table 1.6 Other sources of third-party funding for project leaders")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("otherFundingSource", default: none) == none {
    return table-missing-msg
  }

  let funds = s-crc-data.get().funding.otherFundingSource
  let person = s-crc-data.get().person
  let tablebody = funds.map(it => ([#pi(it.nameID), #person.at(it.nameID).name-first], [#projects(person.at(it.nameID).projects.map(lower), last: [, ])], [#it.projectTitle], [#it.periodStart - #it.periodEnd], [#it.fundingAgency])).flatten()

  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(numrows, bodystart: 1, leftcols: (0, 2, 4)),
    columns: (.5fr, .4fr, .9fr, .4fr, .3fr),
    table.header(
      repeat: true,
      [*PI*], [*Project*], [*Project title*], [*Funding\ period*], [*Funding agency*],
      table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody
  )
}

///////////////////////////////////////////////////////////////////////////////
//										PART II - Existing funds and requested funds           //
///////////////////////////////////////////////////////////////////////////////

#let funds-overview-existing-direct-costs() = context {
  // 2.1.1 Overview of existing funds for direct costs
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("directCostsOverviewExisting", default: none) != none, message: "There is no data available for the table 2.1.1 Overview of existing funds for direct costs")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("directCostsOverviewExisting", default: none) == none {
    return table-missing-msg
  }

  let crcdata = s-crc-data.get().crc
  let funds = s-crc-data.get().funding.directCostsOverviewExisting

  let sums-ending = (funds.previous.fold(0, (a,b) => a + b.applicantInstitution), funds.previous.fold(0, (a,b) => a + b.otherInstitution), funds.previous.fold(0, (a,b) => a + b.otherFunds))
  let total-ending = sums-ending.fold(0, (a,b) => a + b)
  
  let sums-next = (funds.next.fold(0, (a,b) => a + b.applicantInstitution), funds.next.fold(0, (a,b) => a + b.otherInstitution), funds.next.fold(0, (a,b) => a + b.otherFunds))
  let total-next = sums-next.fold(0, (a,b) => a + b)
  
  let tablebody = (
    funds.previous.map(it => (
      [#crcdata.funding-years-previous.at((it.year - 1))], 
      [#num(it.applicantInstitution)], 
      [#num(it.otherInstitution)], 
      [#num(it.otherFunds)], 
      [#num(it.applicantInstitution + it.otherInstitution + it.otherFunds)])) + 
      (
        table.cell(fill: defs.table-style-defaults.table-subheader-fill, 
        [*Ending funding\ period*]), 
        sums-ending.map(it => table.cell(fill: defs.table-style-defaults.table-subheader-fill,[#num(it)])).flatten(), 
        table.cell(fill: defs.table-style-defaults.table-subheader-fill,[#num(total-ending)])
      ),
      funds.next.map(it => (
        [#crcdata.funding-years.at((it.year - 1))],
        [#num(it.applicantInstitution)], 
        [#num(it.otherInstitution)], 
        [#num(it.otherFunds)], 
        [#num(it.applicantInstitution + it.otherInstitution + it.otherFunds)])) + 
      (
        table.cell(fill: defs.table-style-defaults.table-subheader-fill, [*New funding period*]), 
        sums-next.map(it => table.cell(fill: defs.table-style-defaults.table-subheader-fill,[#num(it)])).flatten(), 
        table.cell(fill: defs.table-style-defaults.table-subheader-fill,[#num(total-next)])
      ),
  ).flatten()

  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 1, 
      leftcols: (0,), 
      rightcols: (1, 2, 3, 4), 
      thinline: (5, 10), 
      strongline: (6, )
    ),
    columns: (.3fr, .25fr, .25fr, .1fr, .15fr),
    table.header(
      repeat: true,
      [*Funding period*], [*Core support provided by applicant university*], [*Core support\ provided by\ other participating institutions*], [*Other\ funds*], [*Total*],
      table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
    table.footer(
      table.cell(
        colspan: 5,
        fill: none,
        align: left,
        text(9pt, [(All figures in thousands of Euros)]))   
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let funds-overview-existing-staff() = context {
  // 2.1.2 Overview of existing staff
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("staffOverviewExisting", default: none) != none, message: "There is no data available for the table 2.1.2 Overview of existing staff")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("staffOverviewExisting", default: none) == none {
    return table-missing-msg
  }

  let staff-existing = s-crc-data.get().funding.staffOverviewExisting
  let aux-staff = s-crc-data.get().aux.positions
  let aux-unis = s-crc-data.get().aux.universities
  
  let person-db = s-crc-data.get().person

  let tablebody = aux-staff.keys().map(it => 
  (
    aux-staff.at(it).info, aux-unis.keys().map(uni => 
      if staff-existing.filter(se => se.category == it) != () { 
      [#staff-existing.filter(se => se.category == it).first().at(uni)]
      } else { [0] }
    )
  )).flatten()

  let numrows = aux-staff.len() + 2
  table(
    ..table-settings-default(numrows, bodystart: 3, leftcols: (0,)),
    columns: (.5fr, .5fr) + (.15fr,)*(aux-unis.len()-1),
    table.header(
      repeat: true,
       table.cell(
        rowspan: 3,
        align: center+top,
        [*Category*],
      ),
      table.cell(
        colspan: aux-unis.len(),
        [*Number of persons*],
      ),
      [*at the applicant\ university*], 
      table.cell(
        colspan: (aux-unis.len() - 1),
        [*at other participating\ institutions#super([a])*],
      ),
      [*#aux-unis.at(aux-unis.keys().at(0))*], ..aux-unis.keys().filter(it => it != aux-unis.keys().at(0)).map(it => [*#it*]),
      table.hline(start: 0, end: aux-unis.len() + 1, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
    table.footer(
      repeat: false,
      table.cell(
        colspan: (aux-unis.len()+1),
        fill: none,
        align: left,
        text(9pt, [#super([a]) #aux-unis.keys().filter(it => it != aux-unis.keys().at(0)).map(it => [*#it:* #aux-unis.at(it)]).join([, ]).]))  
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let funds-overview-existing-instrumentation() = context {
  // 2.1.3 List of existing instrumentation
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("listExistingInstrumentation", default: none) != none, message: "There is no data available for the table 2.1.3 List of existing instrumentation")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("listExistingInstrumentation", default: none) == none {
    return table-missing-msg
  }

  let funds = s-crc-data.get().funding.listExistingInstrumentation
  let tablebody = funds.map(it => (
    [#project(it.project)], 
    [#it.instrument #if it.company != none [_(#it.company)_]], 
    [#it.year], 
    [#if it.cost != none { num(it.cost) }], 
    [#it.source]
  )).flatten()

  let numrows = calc.ceil(tablebody.len() / 5)
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 1, 
      leftcols: (1, 4), 
      rightcols: (3,)
    ),
    columns: (.3fr, 1fr, .3fr, .3fr, .4fr),
    table.header(
      repeat: true,
      [*Project*], [*Description of instrumentation*], [*Year of\ purchase*], [*Cost of\ purchase*], [*Source of\ funding*],
      table.hline(start: 0, end: 5, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    ..tablebody,
    table.footer(
      repeat: false,
      table.cell(
        colspan: 5,
        fill: none,
        align: left,
        text(9pt, [(All figures in thousands of Euros)]))
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let funds-overview-previous-requested() = context {
  // 2.2.1 Overview
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("overviewOfAll", default: none) != none, message: "There is no data available for the table 2.2.1 Overview")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("overviewOfAll", default: none) == none {
    return table-missing-msg
  }

  let crcdata = s-crc-data.get().crc
  let funds = s-crc-data.get().funding.overviewOfAll
  let tb-previous = funds.previous.keys().filter(it => it != "Total").map(it => (
    [#crcdata.funding-years-previous.at(int(it) - 1)],
    [#num-or-zero(funds.previous.at(it).staff)],
    [#num-or-zero(funds.previous.at(it).directCosts)],
    [#num-or-zero(funds.previous.at(it).instrumentation)],
    [#num-or-zero(funds.previous.at(it).fellowships)],
    [#num-or-zero(funds.previous.at(it).globalFunds)],
    [#num-or-zero(funds.previous.at(it).staff + funds.previous.at(it).directCosts + funds.previous.at(it).instrumentation + funds.previous.at(it).fellowships + funds.previous.at(it).globalFunds)]
  ))
  let tb-previous-total = funds.previous.keys().filter(it => it == "Total").map(it => (
    [#table.cell(fill: defs.table-style-defaults.table-subheader-fill, [*Previous funding period*])],
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.previous.at(it).staff)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.previous.at(it).directCosts)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.previous.at(it).instrumentation)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.previous.at(it).fellowships)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.previous.at(it).globalFunds)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.previous.at(it).staff + funds.previous.at(it).directCosts + funds.previous.at(it).instrumentation + funds.previous.at(it).fellowships + funds.previous.at(it).globalFunds)])
  ))
  let tb-applying = funds.next.keys().filter(it => it != "Total").map(it => (
    [#crcdata.funding-years.at(int(it) - 1)],
    [#num-or-zero(funds.next.at(it).staff)],
    [#num-or-zero(funds.next.at(it).directCosts)],
    [#num-or-zero(funds.next.at(it).instrumentation)],
    [#num-or-zero(funds.next.at(it).fellowships)],
    [#num-or-zero(funds.next.at(it).globalFunds)],
    [#num-or-zero(funds.next.at(it).staff + funds.next.at(it).directCosts + funds.next.at(it).instrumentation + funds.next.at(it).fellowships + funds.next.at(it).globalFunds)]
  ))
  let tb-applying-total = funds.next.keys().filter(it => it == "Total").map(it => (
    [#table.cell(fill: defs.table-style-defaults.table-subheader-fill, [*New funding period*])],
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.next.at(it).staff)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.next.at(it).directCosts)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.next.at(it).instrumentation)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.next.at(it).fellowships)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.next.at(it).globalFunds)]),
    table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(funds.next.at(it).staff + funds.next.at(it).directCosts + funds.next.at(it).instrumentation + funds.next.at(it).fellowships + funds.next.at(it).globalFunds)])
  ))
  let tablebody = (tb-previous + tb-applying).flatten()

  let headercell = table.cell.with(align: center+horizon, fill: defs.table-style-defaults.table-row-fill)
  let numrows = 2 + funds.previous.len() + funds.next.len() - 1
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 2,
      leftcols: (0,), 
      rightcols: (1,2,3,4,5,6)
    ),
    columns: (1.1fr, .8fr, .8fr, .8fr, .8fr, .8fr, .7fr),
    table.header(
      repeat: true,
      table.cell(
        rowspan: 2,
        [*Financial year/ \ funding period*], 
      ),
      table.cell(
        colspan: 5,
        align: center+top,
        [*Funding for*], 
      ),
      table.cell(
        align: center+top,
        fill: defs.table-style-defaults.table-header-fill, 
        []
      ),
      headercell([*Staff*]), headercell([*Direct costs*]), headercell([*Instrumentation*]), headercell([*Fellowships*]), headercell([*Global\ funds*]), 
       table.cell(
        align: center+top,
        fill: defs.table-style-defaults.table-header-fill, 
        [*Total*]
      ),
      table.hline(start: 0, end: 7, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
    ),
    // ..tablebody,
    
    ..tb-previous.flatten(),
    table.hline(start: 0, end: 7, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
    ..tb-previous-total.flatten(),
    table.hline(start: 0, end: 7, stroke: (thickness: defs.table-style-defaults.table-stroke-thick, paint: defs.table-style-defaults.table-stroke-paint)),
    
    ..tb-applying.flatten(),
    table.hline(start: 0, end: 7, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
    ..tb-applying-total.flatten(),
    table.footer(
      table.cell(
        colspan: 7,
        fill: none,
        align: left,
        text(9pt, [(All figures in EUR, sums rounded to hundreds.)]))
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let funds-overview-requested-staff() = context {
  // 2.2.2 Overview of funds requested for staff
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("staffOverviewRequested", default: none) != none, message: "There is no data available for the table 2.2.2 Overview of funds requested for staff")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("staffOverviewRequested", default: none) == none {
    return table-missing-msg
  }

  let positions = ([Postdocs], [Doctoral researchers], [Other research staff], [Non-research-staff], [Student assistants])
  set text(9pt)

  let crc-db = s-crc-data.get().crc
  let funds = s-crc-data.get().funding.staffOverviewRequested

  let tablebody = funds.filter(proj => proj.project != "Total").map(proj => (
    proj.keys().map(year => (
      [#num-or-cross(proj.at(year))],
    )).flatten()
  )).flatten()

  let tablebody-totals = funds.filter(proj => proj.project == "Total").map(proj => (
    proj.keys().map(year => (
      table.cell(fill: defs.table-style-defaults.table-subheader-fill, [*#num-or-cross(proj.at(year))*]),
    )).flatten()
  )).flatten()
  
  let cols-left-line = range(crc-db.funding-years.len()-1).map(it => (it*5) + 5 + 1) // determine position of new year block to draw vertical line

        
  let numrows = funds.len()
  let bodystart = 2
  let lastrow = numrows + 1
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 2, 
      leftcols: (2, 4)
    ),
    stroke: (col, row) => {
      let st = (:)
      
      if col in (1,) + cols-left-line { 
        st = (left: (thickness: 1pt, paint: defs.table-style-defaults.table-stroke-paint)) } 
      if bodystart != none and row == bodystart { 
        st = st + (
          top: (
            thickness: 1pt, 
            paint: defs.table-style-defaults.table-stroke-paint
          )
        ) 
      } else if row == lastrow { 
        st = st + (
          bottom: (
            thickness: 2pt, 
            paint: defs.table-style-defaults.table-stroke-paint
          )
        ) 
      } 
      st
    },
    columns: (.5fr,) + (.25fr, )*s-crc-data.get().crc.funding-years.len()*5,
    table.header(
      repeat: true,
      table.cell(
        rowspan: 2,
        rotate(-90deg, text(hyphenate: false, [*Project*])), 
      ),
      ..s-crc-data.get().crc.funding-years.map(yr => table.cell(
        colspan: 5,
        [*#yr*] 
      )),
      ..s-crc-data.get().crc.funding-years.map(yr => 
        positions.map(pos => 
          table.cell(
          fill: defs.table-style-defaults.table-header-fill,
          align: left,
            box(
              height: 4cm, 
              rotate(
                -90deg, 
                box(width: 4cm, text(hyphenate: false, [#h(-5em)*#pos*]))
              )
            )
        ))).flatten(),     
    ),
    ..tablebody,
    table.hline(start: 0, end: 1+(s-crc-data.get().crc.funding-years.len()*5), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
    ..tablebody-totals
  )
}

///////////////////////////////////////////////////////////////////////////////

#let funds-overview-requested-instrumentation() = context {
  // 2.2.3 Overview of funds requested for instrumentation

  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("instrumentation", default: none) != none, message: "There is no data available for the table 2.2.3 Overview of funds requested for instrumentation.")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("instrumentation", default: none) == none {
    return table-missing-msg
  }

  let numyears = s-crc-data.get().crc.funding-years.len()
    
  let funds = s-crc-data.get().funding.instrumentation
  let yrs = s-crc-data.get().crc.funding-years
  let sums = yrs.enumerate().map(it => funds.fold(0, (a,b) => a + b.years.at(it.at(0))))
  let funds_ = funds.map(it => it.project).dedup().map(proj => funds.map(it => it.category).dedup().map(category => funds.filter(f => f.category == category and f.project == proj).fold((years: (0,)*numyears), (prev, next) => (project: next.project, category: next.category, years: transpose((prev.years,) + (next.years,)).map(it => it.sum()))))).flatten()
  
  let tablebody = (funds_.map(it => (
    [#it.project],
    [#it.category],
    yrs.enumerate().map(pos => ([#num-or-zero(it.years.at(pos.at(0)))]))
  ))).flatten()
  let tablebody-totals = (
    table.cell(
      align: left+top,
      colspan: 2,
      fill: defs.table-style-defaults.table-subheader-fill,
      [#h(2em)*Total*]
    ), sums.map(it => table.cell(fill: defs.table-style-defaults.table-subheader-fill, [#num-or-zero(it)]))).flatten()

  let numcols = 2 + yrs.len()
  let numrows = funds_.len() + 2
  table(
    ..table-settings-default(
      numrows, 
      bodystart: 2, 
      leftcols: (1,), 
      rightcols: range(2, numcols)
    ),
    columns: (.3fr, .7fr) + (.2fr,)*s-crc-data.get().crc.funding-years.len(),
    table.header(
      repeat: true,
      table.cell(
        rowspan: 2,
        [*Project*]
      ),
      table.cell(
        rowspan: 2,
        [*Description of instrumentation*]
      ),
      table.cell(
        colspan: s-crc-data.get().crc.funding-years.len(),
        [*Funds requested for*]
      ),
      ..s-crc-data.get().crc.funding-years.map(yr => table.cell(
        align: center,
        fill: defs.table-style-defaults.table-header-fill,
        stroke: (bottom: (paint: defs.table-style-defaults.table-stroke-paint)),
        [*#yr*])),
      table.hline(start: 0, end: 2 + (s-crc-data.get().crc.funding-years.len()), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
    ),
    ..tablebody,
    table.hline(start: 0, end: 2 + (s-crc-data.get().crc.funding-years.len()), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
    ..tablebody-totals,
    table.footer(
      table.cell(
        colspan: numcols,
        fill: none,
        align: left,
        text(9pt, [(All figures in EUR, including VAT, transportation, etc.)]))
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////

#let funds-upkeep-laboratory-animals() = context {
  // 2.3 Upkeep of laboratory animals

  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("upkeepLabAnimals", default: none) != none, message: "There is no data available for the table 2.3 Upkeep of laboratory animals.")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("upkeepLabAnimals", default: none) == none {
    return [-- not applicable --]
  }

  let funds = s-crc-data.get().funding.upkeepLabAnimals
  let tablebody = ()

  let numrows = calc.ceil(tablebody.len() / 5)
  set text(10pt)
  table(
    ..table-settings-default(numrows, leftcols: (2, 4)),
    columns: (.6fr, .5fr, .6fr, 1fr, 1fr, 1fr, .8fr, .6fr),
    table.header(
      repeat: true,
      [*Project*], [*Species*], [*Quantity*], [*Average\ number of\ weeks kept*], [*Upkeep costs\ per animal\ per week*], [*Purchasing costs\ per animal*], [*Requested funds*], [*Existing funds*],
      table.hline(start: 0, end: 8, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
    ),
    ..tablebody,
    table.footer(
      table.cell(
        colspan: 8,
        fill: none,
        align: left+horizon,
        text(9pt, [(All figures in EUR)]))
    ),
  )
}

///////////////////////////////////////////////////////////////////////////////
//										PART III - Project details                             //
///////////////////////////////////////////////////////////////////////////////

#let proj-requested-funding() = context {
  // 3.8.2 Requested funding
  
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("staffRequestedAmount", default: none) != none and s-crc-data.get().funding.at("directCostsRequested", default: none) != none and s-crc-data.get().funding.at("instrumentation", default: none) != none, message: "There is no data available for the table 3.8.2 Requested funding")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("staffRequestedAmount", default: none) == none or s-crc-data.get().funding.at("directCostsRequested", default: none) == none or s-crc-data.get().funding.at("instrumentation", default: none) == none {
    return table-missing-msg
  }
  
  let num-years = s-crc-data.get().crc.funding-years.len()
  let aux = s-crc-data.get().aux.positions
  
  context {
    let current-project = s-current-project.get()

    //////////////////////////////////////////////////////////////////////////STAFF
    
    // calculate staff (allowed are requests for postDoc, phD, medDoc, research and nonresearch staff)
    let funds-staff = s-crc-data.get().funding.staffRequestedAmount.filter(it => it.project == upper(current-project))
    
    let funds-staff-totals = transpose(funds-staff.map(fse => 
    range(num-years).map(yr => 
        fse.years.at(yr).sum
      )
    )).map(it => it.sum())
    
    let cat-staff = funds-staff.map(it => (
      [#aux.at(it.category).print (#it.percentage%)], 
      range(num-years).map(yr => (
        [#it.years.at(yr).quantity],
        [#num-or-zero(it.years.at(yr).sum)]
      ))
    ))

    if cat-staff != () {
      cat-staff = cat-staff + (
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        [*Total*], 
        funds-staff-totals.map(it => (
          ([], [#num-or-zero(it)])
        ))
      ).flatten()
    }
    
    //////////////////////////////////////////////////////////////////////////COSTS
    
    // calculate direct costs (allowed are requests for equipment up to €10,000, software, and consumables, laboratory animals and other -- NO visits and travel costs!)
    let funds-costs = s-crc-data.get().funding.directCostsRequested.filter(it => lower(it.project) == current-project)

    // group categories together to not let them occur multiple times in the table
    let funds-costs = funds-costs.map(it => it.category).dedup().map(category => funds-costs.filter(f => f.category == category).fold((years: (0,)*num-years), (prev, next) => (project: next.project, category: next.category, years: transpose((prev.years,) + (next.years,)).map(it => it.sum())))).flatten()

    let funds-costs-totals = transpose(funds-costs.map(fsc => 
    range(num-years).map(yr => 
        fsc.years.at(yr)
      )
    )).map(it => it.sum())
    
    let cat-costs = funds-costs.map(it => (
      [#it.category],
      range(num-years).map(yr => (
        [],[#num-or-zero(it.years.at(yr))]
      ))
    )) 
    
    if cat-costs != () {
      cat-costs = (cat-costs + (
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        [*Total*], 
        funds-costs-totals.map(it => (
          ([], [#num-or-zero(it)])
        ))
      )).flatten()
    }

    /////////////////////////////////////////////////////////////////////FELLOWSHIPS
    
    // calculate fellowships (MGK)
    let funds-fellow = s-crc-data.get().funding.fellowships.filter(it => lower(it.project) == current-project)

    // group categories together to not let them occur multiple times in the table
    let funds-fellow = funds-fellow.map(it => it.category).dedup().map(category => funds-fellow.filter(f => f.category == category).fold((years: (0,)*num-years), (prev, next) => (project: next.project, category: next.category, years: transpose((prev.years,) + (next.years,)).map(it => it.sum())))).flatten()

    let funds-fellow-totals = transpose(funds-fellow.map(fsc => 
    range(num-years).map(yr => 
        fsc.years.at(yr)
      )
    )).map(it => it.sum())
    
    let cat-fellow = funds-fellow.map(it => (
      [#it.category],
      range(num-years).map(yr => (
        [],[#num-or-zero(it.years.at(yr))]
      ))
    )) 
    
    if cat-fellow != () {
      cat-fellow = (cat-fellow + (
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        [*Total*], 
        funds-fellow-totals.map(it => (
          ([], [#num-or-zero(it)])
        ))
      )).flatten()
    }

    /////////////////////////////////////////////////////////////////////////INVEST
    
    // calculate capital investments (allowed are requests for equipment costing between €10,000 and €50,000 and equipment costing over €50,000; decisive factor is purchase price (gross))
    let funds-instrumentation = s-crc-data.get().funding.instrumentation.filter(it => it.project == upper(current-project))

    // group categories together to not let them occur multiple times in the table
    let funds-instrumentation = funds-instrumentation.map(it => it.category).dedup().map(category => funds-instrumentation.filter(f => f.category == category).fold((years: (0,)*num-years), (prev, next) => (project: next.project, category: next.category, years: transpose((prev.years,) + (next.years,)).map(it => it.sum())))).flatten()
    
    let funds-instrumentation-totals = transpose(funds-instrumentation.map(fsi => 
    range(num-years).map(yr => 
        fsi.years.at(yr)
      )
    )).map(it => it.sum())
    
    let cat-instrumentation = funds-instrumentation.map(it => (
      [#it.category],
      range(num-years).map(yr => (
        ([],[#num-or-zero(it.years.at(yr))])
      ))
    )) 
    
    if cat-instrumentation != () {
      cat-instrumentation = (cat-instrumentation + (
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        [*Total*], 
        funds-instrumentation-totals.map(it => (
          ([], [#num-or-zero(it)])
        ))
      )).flatten()
    }
   
    ///////////////////////////////////////////////////////////////////////////////
    
    // generate table content
    if cat-staff != () {
      cat-staff = (
        (
          [*Staff*], 
          (([Qty.], table.cell(align: left+horizon, [Sum]))*num-years)
        ) + cat-staff
      ).flatten()
    }

    if cat-costs != () {
      cat-costs = ((
        (
          [*Direct costs*], 
        ) + (
          table.cell(colspan: 2, [Sum]),
        )*num-years
      ) + cat-costs).flatten()
    }

    
    if cat-fellow != () {
      cat-fellow = ((
        (
          [*Fellowships*], 
        ) + (
          table.cell(colspan: 2, [Sum]),
        )*num-years
      ) + cat-fellow).flatten()
    }

    if cat-instrumentation != () {
      cat-instrumentation = (
        (
          [*Instrumentation*], 
        ) + (
          table.cell(colspan: 2, [Sum]),
        )*num-years
      ).flatten() + cat-instrumentation
    }

    // calculate the grand totals
    let grand-totals = transpose((funds-staff-totals, funds-costs-totals, funds-fellow-totals + funds-instrumentation-totals).filter(it => it != ())).map(it => it.sum())
    let totals = (
      [*Grand Total*], 
      grand-totals.map(it => (
        ([], [#num-or-zero(it)]),
      ))
    ).flatten()

    ///////////////////////////////////////////////////////////////////////////////

    if grand-totals != () {

      // determine rows to fill (for separate categories)
      let numcols = 1 + num-years * 2
      let numrows = 0
      let fills = ()
      let nofills = ()
      let staffpos = 0 
      let costspos = 0 
      let fellowspos = 0
      let instpos = 0 
      
      if funds-staff.len() != 0 {
        fills.push(1)
        staffpos = funds-staff.len() + 2
        nofills.push(staffpos)
        numrows = numrows + funds-staff.len() + 2
      }
      if funds-costs.len() != 0 {
        fills.push(1 + staffpos)
        costspos = funds-costs.len() + 2
        nofills.push(staffpos + costspos)
        numrows = numrows + funds-costs.len() + 2
      }

      if funds-fellow.len() != 0 {
        fills.push(1 + staffpos + costspos)
        fellowspos = funds-fellow.len() + 2
        nofills.push(staffpos + costspos + fellowspos)
        numrows = numrows + funds-fellow.len() + 2
      }
      
      if funds-instrumentation.len() != 0 {
        fills.push(1 + staffpos + costspos + fellowspos)
        instpos = funds-instrumentation.len() + 2
        nofills.push(staffpos + costspos + instpos)
        numrows = numrows + funds-instrumentation.len() + 2
      }
      fills.push(1 + staffpos + costspos + fellowspos + instpos)
      
      // draw table
      table(
        ..table-settings-default(
          numrows + 1, 
          bodystart: 1,
          leftcols: (0, ),
          rightcols: range(1,num-years+1).map(it => 2*it)
        ),
        fill:  (col, row) => 
          if row == 0 { 
            // first line of header is always filled
            defs.table-style-defaults.table-header-fill 
          } else if row in fills {
            defs.table-style-defaults.table-subheader-fill
          } else if row in nofills {
            none
          }          
          else { // let first row of body always be white, then alternate
            // determine which category is closest, then alternate (white, blue) starting from category index
            let closest = 0
            for (a, b) in fills.zip(fills.slice(1) + (numrows + 2,)) {
              if row >= a and row < b {
                closest = a
              }
            }
            if not calc.odd(row - closest) {
              defs.table-style-defaults.table-row-fill  
            }          
          },
        columns: (1fr,) + ((.5fr, .3fr))*num-years,
        table.header(
          repeat: true,
          [*Funding for*], ..s-crc-data.get().crc.funding-years.map(year => table.cell(
            colspan: 2,
            [*#year*],
          )),
          table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))
        ), // header
        ..cat-staff,
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        ..cat-costs,
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        ..cat-fellow,
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        ..cat-instrumentation,
        table.hline(start: 0, end: 2 + (num-years*2), stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
        ..totals,
        table.footer(
          table.cell(
            colspan: 1 + (num-years*2),
            align: left,
            fill: none,
            text(9pt, [(All figures in euros)]))
        ),
      )
    } else {
      [-- not applicable --]
    }
  }
}

///////////////////////////////////////////////////////////////////////////////

#let proj-requested-funding-staff() = context {
  // 3.8.3 Requested funding for staff for the new funding period
    
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("staffExistingRequestedDetails", default: none) != none, message: "There is no data available for the table 3.8.3 Requested funding for staff for the new funding period")
  }

  let k = s-crc-data.get().funding.keys()
  let positions = s-crc-data.get().aux.positions
  let positionspi = s-crc-data.get().aux.position-pi
  let persons = s-crc-data.get().person
  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("staffExistingRequestedDetails", default: none) == none {
    return table-missing-msg
  }

  context {
    let current-project = s-current-project.get()    
    let status = s-crc-data.get().project.at(current-project).status

    // get existing staff for current project from data
    let staff-existing = s-crc-data.get().funding.staffExistingRequestedDetails.filter(it => it.project == upper(current-project) and it.type in ("ExistingResearchStaff", "ExistingNonResearchStaff")).sorted(key: it => (it.type, it.name))

    let staff-existing-research = staff-existing.filter(it => it.type == "ExistingResearchStaff").enumerate(start: 1)
    
    let staff-existing-nonresearch = staff-existing.filter(it => it.type == "ExistingNonResearchStaff").enumerate(start: staff-existing-research.len() + 1)

    let stafftype = if status == "E" { "Approved" } else { "Requested" }
    // get requested staff for current project from data
    let staff-requested = s-crc-data.get().funding.staffExistingRequestedDetails.filter(it => it.project == upper(current-project) and it.type in (stafftype + "ResearchStaff", stafftype + "NonResearchStaff")).sorted(key: it => (it.type, it.name))

    let staff-requested-research = staff-requested.filter(it => it.type == stafftype + "ResearchStaff").enumerate(start: staff-existing-research.len() + staff-existing-nonresearch.len() + 1)
    
    let staff-requested-nonresearch = staff-requested.filter(it => it.type == stafftype + "NonResearchStaff").enumerate(start: staff-existing-research.len() + staff-existing-nonresearch.len() + staff-requested-research.len() + 1)

    ////////////////////////////////////////////////////////////////////EXISTING

    let body-existing = ()
    // only add sub-header if there is existing staff
    if staff-existing-research + staff-existing-nonresearch != () {
      body-existing = body-existing + (
        (
          table.cell(colspan: 8, align: left+horizon, fill: defs.table-style-defaults.table-subheader-fill, [*Existing Staff*]),
        )
      )
    }

    // add research staff content
    if staff-existing-research != () {
      body-existing = body-existing + (
          table.cell(rowspan: staff-existing-research.len(), align: left, fill: defs.table-style-defaults.table-subheader-fill, [Research staff]),) + staff-existing-research.map(it => (
          [#it.at(0).],
          [#if it.at(1).name in persons.keys() [
            #persons.at(it.at(1).name).name#if persons.at(it.at(1).name).title != none [, #persons.at(it.at(1).name).title]#if persons.at(it.at(1).name).position != none [ (#positionspi.at(persons.at(it.at(1).name).position))]
          ] else [
            #it.at(1).name#if it.at(1).title != none [, #it.at(1).title]#if it.at(1).position != none [ (#it.at(1).position)]
          ]],
          [#it.at(1).field-of-research],
          [#it.at(1).department],
          [#it.at(1).commitment],
          [#positions.at(it.at(1).category).print],
          [#it.at(1).funding-source]
        )
      )
    }

    // add non-research staff content
    if staff-existing-nonresearch != () {
      body-existing = body-existing + (
          table.cell(rowspan: staff-existing-nonresearch.len(), align: left, fill: defs.table-style-defaults.table-subheader-fill, [Non-research staff]),) + staff-existing-nonresearch.map(it => (
          [#it.at(0).],
          [#if it.at(1).name in persons.keys() [
            #persons.at(it.at(1).name).name#if persons.at(it.at(1).name).title != none [, #persons.at(it.at(1).name).title]#if persons.at(it.at(1).name).position != none [ (#positionspi.at(persons.at(it.at(1).name).position))]
          ] else [
            #it.at(1).name#if it.at(1).title != none [, #it.at(1).title]#if it.at(1).position != none [ (#it.at(1).position)]
          ]],
          [#it.at(1).field-of-research],
          [#it.at(1).department],
          [#it.at(1).commitment],
          [#positions.at(it.at(1).category).print],
          [#it.at(1).funding-source]
        )
      )
    }

    body-existing = body-existing.flatten()

    ////////////////////////////////////////////////////////////////////REQUESTED
    
    let body-requested = ()
    // only add sub-header if there is requested staff
    if staff-requested-research + staff-requested-nonresearch != () {
      body-requested = (
          table.cell(colspan: 8, align: left, fill: defs.table-style-defaults.table-subheader-fill, if status == "E" [*Staff funded with approved grant money*] else [*Requested Staff*]),
      )
    }

    // add research staff content
    if staff-requested-research != () {
      body-requested = body-requested + (
        table.cell(rowspan: staff-requested-research.len(), align: left, fill: defs.table-style-defaults.table-subheader-fill, [Research staff]),) + staff-requested-research.map(it => (
          [#it.at(0).], // numbering
          [#if it.at(1).name in persons.keys() [
            #persons.at(it.at(1).name).name#if persons.at(it.at(1).name).title != none [, #persons.at(it.at(1).name).title]#if persons.at(it.at(1).name).position != none [ (#positionspi.at(persons.at(it.at(1).name).position))]
          ] else [
            #it.at(1).name#if it.at(1).title != none [, #it.at(1).title]#if it.at(1).position != none [ (#it.at(1).position)]
          ]], // name/title/position
          [#it.at(1).field-of-research], // field of research
          [#it.at(1).department], // department
          [#it.at(1).commitment], // empty
          [#positions.at(it.at(1).category).print], // category
          [#it.at(1).funding-source] // funding source
        )
      )
    }

    // add non-research staff content
    if staff-requested-nonresearch != () {
      body-requested = body-requested + (
          table.cell(rowspan: staff-requested-nonresearch.len(), align: left, fill: defs.table-style-defaults.table-subheader-fill, [Non-research staff]),) + staff-requested-nonresearch.map(it => (
          [#it.at(0).],
          [#if it.at(1).name in persons.keys() [
            #persons.at(it.at(1).name).name#if persons.at(it.at(1).name).title != none [, #persons.at(it.at(1).name).title]#if persons.at(it.at(1).name).position != none [ (#positionspi.at(persons.at(it.at(1).name).position))]
          ] else [
            #it.at(1).name#if it.at(1).title != none [, #it.at(1).title]#if it.at(1).position != none [ (#it.at(1).position)]
          ]],
          [#it.at(1).field-of-research],
          [#it.at(1).department],
          [#it.at(1).commitment],
          [#positions.at(it.at(1).category).print],
          [#it.at(1).funding-source]
        )
      )
    }

    body-requested = body-requested.flatten()

    ////////////////////////////////////////////////////////////////////BODY
    
    let tablebody = (body-existing + body-requested).flatten()
    let numcols = 8
    let fills = ()
    let existingpos = 0 
    let requestedpos = 0 
    let numrows = 0
    
    if staff-existing-research != () or staff-existing-nonresearch != () {
      numrows = numrows + staff-existing-research.len() + staff-existing-nonresearch.len() + 1
      fills.push(1)
      existingpos = 2
    }
    if staff-requested-research != () or staff-requested-nonresearch != (){
      numrows = numrows + staff-requested-research.len() + staff-requested-nonresearch.len() + 1
      fills.push(existingpos + staff-existing.len())
      requestedpos = existingpos + staff-existing.len() + 2
    }
    
    table(
      ..table-settings-default(
        numrows, 
        bodystart: 1, 
        leftcols: (2, 3, 4, 6, 7)
      ),
      fill:  (col, row) => if row == 0 { 
        // first line of header is always filled
        defs.table-style-defaults.table-header-fill 
      } else if col == 0 or row in fills {
        defs.table-style-defaults.table-subheader-fill
      }        
      else { 
        // let first row of (sub-)body always be white, then alternate
        // determine which category is closest, then alternate (white, rowfill) starting from category index
        let catindex = 0
        for (cat, catnext) in fills.zip(fills.slice(1) + (numrows + 2,)) {
          if row >= cat and row < catnext {
            catindex = cat
          }
        }
        if not calc.odd(row - catindex) {
          defs.table-style-defaults.table-row-fill  
        }          
      },
      columns: (.9fr, .2fr) + (1fr,) * 6,
      table.header(
        [], 
        rotate(-90deg, [*No.*]), 
        [*Name,\ academic degree,\ position*], 
        [*Field of\ research*], 
        [*Departm. of\ (non-)univers.\ institution*], 
        [*Project commitm.\ (h/wk)*], 
        [*Category*], 
        [*Funding source*], 
        table.hline(start: 0, end: 8, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint))        
      ),
      ..body-existing,
      table.hline(start: 0, end: 8, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
      ..body-requested,
      table.hline(start: 0, end: 8, stroke: (thickness: defs.table-style-defaults.table-stroke-thick, paint: defs.table-style-defaults.table-stroke-paint))
    )

    // add job descriptions for existing staff
    if (staff-existing-research + staff-existing-nonresearch) != () [
      Job descriptions of staff for the proposed funding period (supported through existing funds):

      #enum(
        numbering: "1.",
        ..(staff-existing-research + staff-existing-nonresearch).map(it => [#if it.at(1).name in persons.keys() [*#persons.at(it.at(1).name).name, #persons.at(it.at(1).name).name-first#if persons.at(it.at(1).name).title != none [, #persons.at(it.at(1).name).title]* -- #it.at(1).description] else [*#it.at(1).name#if it.at(1).name-first != none [, #it.at(1).name-first]#if it.at(1).title != none [, #it.at(1).title]* -- #it.at(1).description]])
      )
    ]

    // add job descriptions for requested staff
    if (staff-requested-research + staff-requested-nonresearch) != () [
      Job descriptions of staff for the proposed funding period (requested funds):

      #enum(
        numbering: "1.",
        start: staff-existing-research.len() + staff-existing-nonresearch.len() + 1,
        ..(staff-requested-research + staff-requested-nonresearch).map(it => [#if it.at(1).name in persons.keys() [*#persons.at(it.at(1).name).name, #persons.at(it.at(1).name).name-first#if persons.at(it.at(1).name).title != none [, #persons.at(it.at(1).name)).title]* -- #persons.at(it.at(1).name)).description] else [*#it.at(1).name#if it.at(1).name-first != none [, #it.at(1).name-first]#if it.at(1).title != none [, #it.at(1).title]* -- #it.at(1).description]])
      )
    ]
  }
}

///////////////////////////////////////////////////////////////////////////////

#let proj-requested-funding-direct-costs(
  
) = context {
  // 3.8.4 Requested funding for direct costs for the new funding period
    
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("directCostsByInstitutions", default: none) != none, message: "There is no data available for the table 3.8.3 Requested funding for direct costs for the new funding period")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("directCostsByInstitutions", default: none) == none {
    return table-missing-msg
  }

  let num-years = s-crc-data.get().crc.funding-years.len()
  let unis = s-crc-data.get().aux.universities
  
  context {
    let current-project = s-current-project.get()
    
    let funds-existing = s-crc-data.get().funding.directCostsByInstitutions.filter(it => lower(it.project) == current-project)
    let funds-requested = s-crc-data.get().funding.directCostsRequested.filter(it => lower(it.project) == current-project)
    
    if funds-existing + funds-requested == () {
      return table-empty-msg
    }

    let funds-existing-main = funds-existing.filter(it => it.category == unis.keys().at(0))
    let funds-existing-other = funds-existing.filter(it => it.category != unis.keys().at(0))
    let funds-requested-transposed = transpose(funds-requested.map(it => it.years)).map(it => it.sum())
  
    let tablebody-existing-main = funds-existing-main.map(it => (
      [#unis.at(it.category)#if it.keys().contains("source") and it.source != none [, existing funds from _ #it.source _]], range(num-years).map(yr => ([#num-or-zero(it.years.at(yr))],))
    )).flatten()
    let tablebody-existing-other = funds-existing-other.map(it => (
      [#unis.at(it.category)#if it.keys().contains("source") and it.source != none [, existing funds from _ #it.source _]], range(num-years).map(yr => ([#num-or-zero(it.years.at(yr))],))
    )).flatten()

    let totals = transpose((
      (funds-existing-main + funds-existing-other).map(it => range(num-years).map(yr => it.years.at(yr)))
    )).map(it => it.sum())

    let tablebody = ((
      table.cell(fill: defs.table-style-defaults.table-subheader-fill, [Sum of existing funds]), (if totals == () { (0,)*num-years } else { totals }).map(t => (table.cell(fill: none, [#num-or-zero(t)]),)) 
    ) + (
      table.cell(fill: defs.table-style-defaults.table-subheader-fill, [Sum of requested funds]), (if funds-requested-transposed == () { (0,)*num-years } else { funds-requested-transposed }).map(t => (table.cell(fill: none, [#num-or-zero(t)]),)) 
    )).flatten()

    let numrows = funds-existing-main.len() + funds-existing-other.len() + 2
    table(
      ..table-settings-default(
        numrows, 
        bodystart: 1,
        leftcols: (0, ), 
        rightcols: range(num-years).map(it => 1+it), 
      ),
      columns: (1fr,) + ((.5fr,))*num-years,
      table.header(
        [], 
        ..s-crc-data.get().crc.funding-years.map(year => [*#year*]),
        table.hline(start: 0, end: 1 + num-years, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
      ),
      ..tablebody-existing-main,
      table.hline(start: 0, end: 1 + num-years, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
      ..tablebody-existing-other,
      table.hline(start: 0, end: 1 + num-years, stroke: (thickness: defs.table-style-defaults.table-stroke-thin, paint: defs.table-style-defaults.table-stroke-paint)),
      ..tablebody,
      table.footer(
          table.cell(
            colspan: 5,
            align: left,
            fill: none,
            text(9pt, [(All figures in euros)]))
        ),
    )

    let yrs = s-crc-data.get().crc.funding-years
  
    for (idx, yr) in yrs.enumerate() {
      for category in funds-requested.map(it => it.category).dedup() {
        if not funds-requested.filter(it => it.category == category).all(it => it.years.at(idx) == 0) {
            justification-table(
              header: [#category for financial year #yr],
              data: funds-requested.filter(it => it.years.at(idx) != 0 and it.category == category).map(fs => (
                description: fs.description,
                value: fs.years.at(idx),
                funded-by: none
              ))
            )
        }        
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////////

#let proj-requested-funding-global-funds() = context {
  // 3.5.5/3.6.7/3.8.7 (Requested) Global funds (MGK, WIKO, Z)
    
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("directCostsByInstitutions", default: none) != none, message: "There is no data available for the table 3.8.3 Requested funding for direct costs for the new funding period")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("directCostsByInstitutions", default: none) == none {
    return table-missing-msg
  }

  context {
    let current-project = s-current-project.get()

    let globalfunds = s-crc-data.get().funding.globalfunds.filter(it => lower(it.project) == current-project)

    if globalfunds == () {
      return table-empty-msg
    }
    
    let yrs = s-crc-data.get().crc.funding-years
  
    for (idx, yr) in yrs.enumerate() {
      for category in globalfunds.map(it => it.category).dedup() {
        if not globalfunds.filter(it => it.category == category).all(it => it.years.at(idx) == 0) {
          justification-table(
            header: [#category for financial year #yr],
            data: globalfunds.filter(it => it.years.at(idx) != 0 and it.category == category).map(fs => (
              description: fs.description,
              value: fs.years.at(idx),
              funded-by: none
            ))
          )
        }        
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////

#let proj-requested-funding-fellowships() = context {
  // 3.8.6 Requested funding for fellowships (MGK)
    
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("fellowships", default: none) != none, message: "There is no data available for the table 3.8.6 Requested funding for fellowships")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("fellowships", default: none) == none {
    return table-missing-msg
  }

  
  context {
    let current-project = s-current-project.get()
    
    let fellowships = s-crc-data.get().funding.fellowships.filter(it => lower(it.project) == current-project)

    if fellowships == () {
      return table-empty-msg
    }
    
    let yrs = s-crc-data.get().crc.funding-years
    let unis = s-crc-data.get().aux.universities
  
    for (idx, yr) in yrs.enumerate() {
      if not fellowships.all(it => it.years.at(idx) == 0) {
        justification-table(
          header: [Short-term fellowships for financial year #yr],
          data: fellowships.filter(it => it.years.at(idx) != 0).map(fs => (
            description: [#fs.category -- #fs.description],
            value: fs.years.at(idx),
            funded-by: none
          ))
        )
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////

#let proj-requested-funding-instrumentation() = context {
  // 3.8.5 Requested funding for instrumentation
    
  if use-asserts {
    assert(s-crc-data.get().keys().contains("funding") and s-crc-data.get().funding.at("instrumentation", default: none) != none, message: "There is no data available for the table 3.8.5 Requested funding for instrumentation")
  }

  if not s-crc-data.get().keys().contains("funding") or s-crc-data.get().funding.at("instrumentation", default: none) == none {
    return table-missing-msg
  }

  context {
    let current-project = s-current-project.get()

    let instrumentation = s-crc-data.get().funding.instrumentation.filter(it => lower(it.project) == current-project)

    if instrumentation == () {
      return table-empty-msg
    }
  
    let yrs = s-crc-data.get().crc.funding-years
  
    for (idx, yr) in yrs.enumerate() {
      for category in instrumentation.map(it => it.category).dedup() {
        if not instrumentation.filter(it => it.category == category).all(it => it.years.at(idx) == 0) {
          justification-table(
            header: [#category for financial year #yr],
            data: instrumentation.filter(it => it.years.at(idx) != 0 and it.category == category).map(fs => (
              description: fs.description,
              value: fs.years.at(idx),
              funded-by: none
            ))
          )
        }        
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
