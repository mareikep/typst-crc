#import "tmpl-crc-misc.typ": *
#import "tmpl-crc-tables.typ": *

#import "@preview/alexandria:0.2.0": *
  
  ///////////////////////////////////////////////////////////////////////////////
  //										TEMPLATE TITLEPAGE                                     //
  ///////////////////////////////////////////////////////////////////////////////
  
  #let crc-titlepage(
    // the number of the crc
    number: "",
    
    // the name of the crc
    name: "",
    
    // the logo of the crc.
    logo-crc: none,
    
    // the funding years of the crc.
    // should be a dictionary: e.g. (1: 2026, 2: 2027, 3: 2028, 4: 2029)
    funding-years: (),
    
    // the funding period of the crc, e.g. 3
    funding-period: none,
    
    // the logo of the university/institution
    logo-institution: (),
    body
  ) = {
  
    ///////////// TITLE PAGE ///////////////////////////////////////
    
    // set the body font
    set text(
      font: (
         "Arial",
         "STIX Two Text"
      ), 
      size: 11pt,
      weight: "regular",
      fallback: false,
      lang: "en"
    )
    
    // set page layout properties for remaining document
    set page(
      paper: "a4",
      margin: defs.margins.at("a4"),
      numbering: none
    )
    
    v(.7fr)
    
    align(center, text(1.5em, [Collaborative Research Centre #number]))
    
    v(.2fr)
    
    // title and subtitle of the thesis
    align(center, box(width: 20em, logo-crc))
    
    v(.2fr)
    
    align(
      center, 
      text(
        1.2em, 
        [
          Proposal for the #if funding-period == 1 { [1#super[st]] } else { if funding-period == 2 { [2#super[nd]] } else { [3#super[rd]] } } Funding Period\
          #funding-years.values().map(it => [#it]).join([ -- ])
        ]
      )
    )
    
    v(2fr)
    
    align(right, box(width: 5em, logo-institution))
    body
  }
  
  ///////////////////////////////////////////////////////////////////////////////
  //										TEMPLATE PROPOSAL                                      //
  ///////////////////////////////////////////////////////////////////////////////
  
  #let crc-proposal(
    author: none,
    data: none,
    logo-crc: none,
    logo-institution: none,
    persons: none,
    projects: none,
    projectcolors: none,
    funding: none,
    aux: none,
    body
  ) = context {
    //////////////// update state(s) ////////////////////////////////////
    
    s-crc-data.update(data + persons + projects + funding + aux + (colors: projectcolors))
    ///////////// document settings ////////////////////////////////////
  
  	// set the pdf document's metadata
    set document(
  		author: author.name, 
  		title: [Collaborative Research Centre #data.crc.number - #data.crc.name]
  	)
  
    // set the body font
    set text(
  		font: (
         "Arial",
         "STIX Two Text"
      ), 
  		size: 11pt,
  		weight: "regular",
  		fallback: false,
  		lang: "en"
  	)
  
  	// set page layout properties for remaining document
    set page(
  		paper: "a4",
  		margin: (
  			bottom: 4cm, 
  			top: 2.25cm, 
  			inside: 2cm, 
  			outside: 3cm
  		),
  		numbering: none
  	)
  
    set-group(
      separator: sym.space.thin,// ",", 
      size: 3, 
      threshold: 4
    )
    set-num(
      product: math.dot, 
      tight: true
    )
    set-round(
      mode:       none,
      precision:  2,
      pad:        true,
      direction:  "nearest",
    )
  	
  	set math.equation(numbering: "(1)")
  	
  	// set raw(syntaxes: "misc/CRAM.sublime-syntax")
  
  	set outline.entry(fill: repeat[$ dot.c quad$])
  
     set par(justify: true)
  
    ///////////// show rules ///////////////////////////////////////////
  	
  	// configure text styling
  	show "sr-crc": [Collaborative Research Centre]
  	show "sr-this-crc": smallcaps([#data.crc.name])
  	show "sr-thisfull": smallcaps([#data.crc.name-full])
  	show "sr-uni": [My University]
  	show "sr-inst": [My Institution]
  
    if projectcolors != none {
      for (num, col) in projectcolors.research.pairs() {
        show regex(num+"\d+"): text(col, num)
      }
    }
  
  	show heading.where(level: 1): it => {	
  		pagebreak(to: "odd", weak: true)
      text(defs.col_darkblue, 2em, weight: "bold", it)
      v(1em)
    }
  
    show heading.where(level: 2): it => {	
      text(defs.col_darkblue, 1.3em, weight: "bold", it)
      v(.5em)
    }
  
  	show heading.where(level: 3): it => {
  		text(defs.col_darkblue, weight: "bold", it)
  		v(.5em)
  	}
  
     show grid.cell: set text(10pt)
     show grid.cell: set par(justify: false)
     show table.cell: set text(10pt)
     show table.cell: set par(justify: false)
     show table.header: set text(defs.col_mediumblue)
     // show link: set text(defs.col_mediumblue)
     
  
  	///////////// table of contents ////////////////////////////////////
  
  	show outline.entry.where(
  		level: 1
  	): it => {
  		set block(above: 1.2em)
      let pbreak = false
  		link(
  			it.element.location(),
  			if it.element.numbering == none {
  				// If heading has no numbering, leave it as is.
  				it.indented(none, text(defs.col_darkblue, smallcaps([*#it.inner()*])))
  			} else {
  				let txt = it.inner()
  				let prefix = it.prefix()
  				if it.element.has("supplement") {
  						if it.element.supplement != [Section] {
  						prefix = strong(smallcaps(text(defs.col_darkblue, it.prefix())))	  
  						txt = it.inner()
  						} else {
  							if prefix == [3] and it.body() != [Project details] {
  								// subproject entries
  								prefix = project(it.body().text)
  								txt = text(black, projects.project.at(lower(it.body().text)).name)
                } else if prefix == [3] and it.body() == [Project details] {
                  // default case
  								txt = smallcaps(text(1.2em, hyphenate: false, defs.col_darkblue, [*#it.inner()*]))
  								prefix = strong(smallcaps(text(defs.col_darkblue, it.prefix())))
                  pbreak = true
  							} else {
  								// default case
  								txt = smallcaps(text(1.2em, hyphenate: false, defs.col_darkblue, [*#it.inner()*]))
  								prefix = strong(smallcaps(text(defs.col_darkblue, it.prefix())))
  							}
  						}
  				}
          if pbreak {
            pagebreak()
          }
  				it.indented(prefix, txt)
  			}
  		)
  	}
  
  	show outline.entry.where(
  		level: 2
  	): it => {
  			let txt = it.inner()
  			let prefix = it.prefix()
  			
  			if float(prefix.text) >= 3 and float(prefix.text) < 4 {
  				return 
  			} else {
  				prefix = [*#it.prefix()*]
  				txt = [*#it.inner()*]
  			}
  			link(
  				it.element.location(),
  				it.indented(prefix, text(black, txt))
  			)
  	}
  
  	show outline.entry.where(
  		level: 3
  	): it => {
  			let txt = it.inner()
  			let prefix = it.prefix()
  			let b = it.body()
  			
  			if prefix.text.starts-with("3") {
  				return 
  			}
  			prefix = [#it.prefix()]
  			txt = [#it.inner()]
  		
  			link(
  				it.element.location(),
  				it.indented(prefix, text(black, txt))
  			)
  	}
  
  	show outline.entry.where(
    	level: 2
  	): set block(above: 1.2em)
  
    counter(page).update(1)
   
    set page(
  		numbering: "i",
  
  		// The footer always contains the page number on the left on even pages and 
  		// on the right on odd pages, unless the page is one that starts a chapter, then 
  		// it has no page number
  		footer: context {
  				grid(
  					columns: (1fr, 1fr),
  					align: (left+horizon, right+horizon),
  					..if calc.odd(here().page()) { 
  						(
  							box(width: 2cm, logo-crc), 
  							[#numbering(if here().page-numbering() != none { here().page-numbering() } else { "1." }, counter(page).get().first())]
  						) 
  					} else { 
  						(
  							[#numbering(if here().page-numbering() != none { here().page-numbering() } else { "1." }, counter(page).get().first())], 
  							box(width: 2cm, logo-crc)
  						)
  					}
  				)
  		}
  	)
  
     outline()
  
  	///////////// formatting main document /////////////////////////////
  
   	set heading(numbering: "I.i")
  
  	let margin = (
  			bottom: 4cm, 
  			top: 3cm, 
  			inside: 2cm, 
  			outside: 3cm
  	)
  
  	set page(
  		paper: "a4",
  		numbering: "1", // page number is set manually, because 
  		// left/right switch for odd/even pages is currently not 
  		// supported
  	
  		// The margins depend on the paper size.
  		margin: margin
  	)
  
  	counter(page).update(1)
  	set heading(numbering: "1.1")
  	counter(heading).update(0)
  
   	body
  }
  
  ///////////////////////////////////////////////////////////////////////////////
  //										TEMPLATE SUBPROJECT                                    //
  ///////////////////////////////////////////////////////////////////////////////
  
  // the wrapper for a subproject part
  #let crc-project(
  	number: none,
  	colors: none,
  	bib: none,
  	body
  ) = {
  
    pagebreak(to: "odd")
    counter(heading).update(2)
    let prefix = "bib-" + number + "-"

     show grid.cell: set text(10pt)
     show table.cell: set text(10pt)
      
      // draw thumb
      set page(
       background: context {
          let c = if colors.research.keys().contains(lower(s-crc-data.get().project.at(lower(number)).number.at(0))) { 
              colors.research.at(lower(s-crc-data.get().project.at(lower(number)).number.at(0)))
          } else if colors.mgk.keys().contains(lower(s-crc-data.get().project.at(lower(number)).number)) { 
              colors.mgk.at(lower(s-crc-data.get().project.at(lower(number)).number))
          } else if colors.inf.keys().contains(lower(s-crc-data.get().project.at(lower(number)).number)) { 
              colors.inf.at(lower(s-crc-data.get().project.at(lower(number)).number)) 
          } else if colors.wiko.keys().contains(lower(s-crc-data.get().project.at(lower(number)).number)) { 
              colors.wiko.at(lower(s-crc-data.get().project.at(lower(number)).number)) 
          } else if colors.transfer.keys().contains(lower(s-crc-data.get().project.at(lower(number)).number.at(0))) { 
              colors.transfer.at(lower(s-crc-data.get().project.at(lower(number)).number.at(0))) 
          } else if colors.admin.keys().contains(lower(s-crc-data.get().project.at(lower(number)).number)) { 
              colors.admin.at(lower(s-crc-data.get().project.at(lower(number)).number)) 
          } else { colors.default }
          
          let algn = left
          let radius = (
                top-right: 20pt,
                bottom-right: 5pt,
              )
          if calc.odd(here().page()) {
            algn = right
            radius = (
                top-left: 20pt,
                bottom-left: 5pt,
              )
          }
          let thumb-other = rect.with(
            width: 2cm, 
            height: 2cm, 
            fill: gray.lighten(80%), 
            radius: radius
          )
          let thumb-current = rect.with(
            width: 2cm, 
            height: 2cm, 
            fill: c, 
            radius: radius
          )
          
          align(
            algn, 
            grid(
              rows: (1fr)*s-crc-data.get().project.keys().len(),
            ..s-crc-data.get().aux.project.map(it => { 
                if it == s-crc-data.get().project.at(lower(number)).number { 
                  [#show: thumb-current[#align(center, text(white, 2em, weight: "bold", upper(number)))] ]
                } else {
                  // [#show: thumb-other[#text(white, 2em, weight: "bold", it)] ]
                } }
              )
            )
          )
      },
      header: context { align(center, [#s-crc-data.get().project.at(lower(number)).pi.map(it => s-crc-data.get().person.at(it).name).join([ #sym.dot.c ]) | #s-crc-data.get().project.at(lower(number)).name]) }
      )
      
      // generate content of the subproject's general information
      {
      show heading: none
      let h = heading(level: 1, [#upper(number)])
      let t = label("project-" + number)
      [#h#t]
      }
      counter(heading).update((3, 0))
      context [
      
      == General information about Project #project(number) 
      #label("kd-project-" + number)
      
      === Project title: #s-crc-data.get().project.at(lower(number)).name
      
      #if s-crc-data.get().project.at(lower(number)).type in ("research", "transfer") and s-crc-data.get().project.at(lower(number)).status in ("C", "N") [
        === Research areas: #s-crc-data.get().project.at(lower(number)).area.join([, ])
      ]
      
      === Project leaders
      
      // the boxes containing personal information about the subproject's PIs
      #let pi = s-crc-data.get().project.at(lower(number)).pi.map(it => personInfo(it))
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 10pt,
        row-gutter: 15pt,
        align: left,
        ..pi
      )
      #v(1em)
      
      // the questions about the PIs' employment/funding
      #let questions = ()
      #if s-crc-data.get().project.at(lower(number)).pi.len() > 1 {
        questions = s-crc-data.get().aux.questions.person.multiple
      } else {
        questions = s-crc-data.get().aux.questions.person.single
      } 
      
      - #questions.Q1 #s-crc-data.get().project.at(lower(number)).pi.map(p => [*#ifYesNo(s-crc-data.get().person.at(p).Q1)* (#s-crc-data.get().person.at(p).name)]).join([, ])
      - #questions.Q2 #s-crc-data.get().project.at(lower(number)).pi.map(p => [*#ifYesNo(s-crc-data.get().person.at(p).Q2)* (#s-crc-data.get().person.at(p).name)]).join([, ])
      #if s-crc-data.get().project.at(lower(number)).pi.map(p => s-crc-data.get().person.at(p).Q2).any(it => it) { 
        [ - #questions.Q3: #s-crc-data.get().project.at(lower(number)).pi.filter(p => s-crc-data.get().person.at(p).Q2).map(p => if s-crc-data.get().person.at(p).Q2 { 
          [*#s-crc-data.get().person.at(p).Q3* (#s-crc-data.get().person.at(p).name)]
        }).join([, ])]}
      #if s-crc-data.get().project.at(lower(number)).pi.map(p => s-crc-data.get().person.at(p).Q2).any(it => it) { 
        [ - #questions.Q4: #s-crc-data.get().project.at(lower(number)).pi.filter(p => s-crc-data.get().person.at(p).Q2).map(p => if s-crc-data.get().person.at(p).Q2 { 
          [*#s-crc-data.get().person.at(p).Q4* (#s-crc-data.get().person.at(p).name)]
        }).join([, ])]}   
      #if s-crc-data.get().project.at(lower(number)).pi.map(p => s-crc-data.get().person.at(p).Q5).any(it => it) { 
        [ - #questions.Q5 #s-crc-data.get().project.at(lower(number)).pi.map(p => [*#ifYesNo(s-crc-data.get().person.at(p).Q5)* (#s-crc-data.get().person.at(p).name)]).join([, ])]
      }
      - #questions.Q6: #s-crc-data.get().project.at(lower(number)).pi.map(p => [*#ifYesNo(s-crc-data.get().person.at(p).Q6)* (#s-crc-data.get().person.at(p).name)]).join([, ])
      
      
      #if s-crc-data.get().project.at(lower(number)).type == "transfer" [
        === Application partner
      
        // <Full name of company or institution>
        // <Contact partner stating surname, full first name, academic degree, position, address>
        // <phone number>
        // <e-mail address>
      ]
      
          #if s-crc-data.get().project.at(lower(number)).type in ("research", "infrastructure", "wiko", "transfer") and s-crc-data.get().project.at(lower(number)).status in ("C", "N") [
        		#block(
        			breakable: false,
        			[
        				=== Legal issues
        
        				This project includes
        
        				// the questions about the subproject's legal issues
        				#line(stroke: (paint: defs.col_darkblue, thickness: 2pt), length: 100%)
        
        				#grid(
        					columns: (.02fr, 1fr, .1fr),
        					align: (right+bottom, left+bottom, left+bottom),
        					gutter: 7pt,
        					[1.], s-crc-data.get().aux.questions.legal.Q1, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q1)],
        					..if s-crc-data.get().project.at(lower(number)).Q1 { 
        						([], s-crc-data.get().aux.questions.legal.Q1a, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q1a)])
        					},
        					[2.], s-crc-data.get().aux.questions.legal.Q2, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q2)],
        					..if s-crc-data.get().project.at(lower(number)).Q2 { 
        						([], s-crc-data.get().aux.questions.legal.Q2a, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q2a)])
        					},
        					[3.], s-crc-data.get().aux.questions.legal.Q3, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q3)],
        					[4.], s-crc-data.get().aux.questions.legal.Q4, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q4)],
        					[5.], s-crc-data.get().aux.questions.legal.Q5, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q5)],
        					..if s-crc-data.get().project.at(lower(number)).Q5 { 
        						([], s-crc-data.get().aux.questions.legal.Q5a, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q5a)])
        					},
        					[6.], s-crc-data.get().aux.questions.legal.Q6, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q6)],
        					[7.], s-crc-data.get().aux.questions.legal.Q7, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q7)],
        					..if s-crc-data.get().project.at(lower(number)).Q7 { 
        						([], s-crc-s-crc-data.get().project.at(lower(number)).get().aux.questions.legal.Q7a, [#ifYesNoIcon(s-crc-data.get().project.at(lower(number)).Q7a)])
        					}
        				)
        					
        				#line(stroke: (paint: defs.col_darkblue, thickness: 2pt), length: 100%)
        			]
        		)
          ]
    	]
   
      if bib != none {
    
        // this show rule is necessary to tell the alexandria package, 
        // which citation prefix to consider in the remaining content of this 
        // project
        show: alexandria(prefix: prefix)
        
        // the remaining content comes from the included subproject files
        context if body.has("children") {
          // extract children from body
          let (children, ..fields) = body.fields()
          
          // get position of publication section
          let pos_default = children.position(it => (it.func() == heading and it.body in (
            [Project- and subject-related list of publications], 
            [Project- and subject-related publications], 
            [Project-related publications by participating researchers],
            [Published project results]
          )))
            
      		// init bib content
      		let bib_ = [
      			// this show rule searches for the names of the respective 
      			// project's PIs and highlights them in the bibliography
      			// The pattern it searches for is e.g. "Beetz, M." (APA)
    			  #show regex(s-crc-data.get().project.at(lower(number)).pi.map(pi => s-crc-data.get().person.at(pi).name + ", " + s-crc-data.get().person.at(pi).name-first.at(0) + ".").join("|")): set text(weight: "bold")
    		  ]
      
      		// check which type of bibliography is needed, 
          if s-crc-data.get().project.at(lower(number)).type == "inf" or s-crc-data.get().project.at(lower(number)).type in ("research", "transfer") and s-crc-data.get().project.at(lower(number)).status == "E" {
            bib_ = bib_ + [
      
              #load-bibliography(bib, prefix: prefix, style: read("styles/chicago-author-date-highlight.csl", encoding: none))
        			
              #context {
        				// get the bibliography items and groups
                let projectrefs = s-publicationlists.get().at(number, default: (:))
        				let res = get-bibliography(prefix)
            
        				if res != none {
                  let (references, ..rest) = res
        
                  ///////////////////////////////////////////////////////////////////////////////////////// DEFAULT
                  // render the bibliography
          				render-bibliography(
          					title: none,
          					(
            					references: references.filter(x => projectrefs.keys() == () or not projectrefs.keys().map(cat => projectrefs.at(cat).contains(x.key)).any(it => it)),
            					..rest,
          					),
          				)
              ///////////////////////////////////////////////////////////////////////////////////////// QUALITY
                  heading(level: 3, outlined: false, numbering: none, [Publications with scientific quality assurance])
                  
                  // render the bibliography
          				render-bibliography(
          					title: none,
          					(
            					references: references.filter(x => projectrefs.keys().contains("quality") and projectrefs.quality.contains(x.key)),
            					..rest,
          					),
          				)
          				
                  ///////////////////////////////////////////////////////////////////////////////////////// OTHER
          				heading(level: 3, outlined: false, numbering: none, [Other publications and published results])
          				
                  // render the rest of the bibliography
          				// (this could also be somewhere else in the document)
          				render-bibliography(
          					title: none,
          					(
            					references: references.filter(x => projectrefs.keys().contains("other") and projectrefs.other.contains(x.key)),
            					..rest,
          					),
          				)
          
                  ///////////////////////////////////////////////////////////////////////////////////////// PATENTS
          				heading(level: 3, outlined: false, numbering: none, [Patents])
        
                  // render the rest of the bibliography
          				// (this could also be somewhere else in the document)
          				render-bibliography(
          					title: none,
          					(
            					references: references.filter(x => projectrefs.keys().contains("patents") and projectrefs.patents.contains(x.key)),
            					// references: references.filter(x => not(x.details.keys().contains("note") and x.details.note != "FAV")),
            					..rest,
          					),
          				)
        				}
              }    
        		]
          } else {
        		bib_ = bib_ + [  			
        			#bibliographyx(
        				bib,
        				prefix: prefix,
        				title: none,
        				style: "apa"
        			)
      		  ]
          }
          // generate bibliography and extract its child element(s)
          let children-bib = bib_.children
          
          let body-before = []
          let body-after = []
          if pos_default != none {
            body-before = body.children.slice(0, (pos_default + 1))
            body-after = body.children.slice((pos_default + 1))
            
            children = body-before + children-bib + body-after
            return body.func()(children, ..fields)
          } 
          return body
        }
      } else {
        body
      }
  }
  
  ///////////////////////////////////////////////////////////////////////////////
  //										SETUP                                                  //
  ///////////////////////////////////////////////////////////////////////////////
  
  #let crc-proposal-setup(
    author: none,
    logo-crc: none,
    logo-institution: none,
    data: none,
    persons: none,
    projects: none,
    projectcolors: none,
    funding: none,
    aux: none,
    style-defaults: none
  ) = {
  	
    let proposal = crc-proposal.with(
      author: author,
      logo-crc: logo-crc,
      logo-institution: logo-institution,
      data: data,
      persons: persons,
      projects: projects,
      projectcolors: projectcolors,
      funding: funding,
      aux: aux
    )
  
    // Return the values and functions generated based on
    // the given parameters to make them available outside the template
    (
      proposal: proposal,
      data: data + aux + projects + persons,
      projectcolors: projectcolors
    )
  }
  
