#let orcid(
  id,
  icon: true
) = {
  if icon { 
    link("https://orcid.org/"+id)[#box(baseline: 10%, height: .8em, html.img(src: "_assets/img/orcid-logo.svg", height: 15)) #id] 
  } else { 
    link("https://orcid.org/"+id)[#id]
  }
}