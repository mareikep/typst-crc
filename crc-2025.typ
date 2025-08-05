#import "crc-imports.typ": *

#let titlepage = crc-titlepage.with(
  number: data.at("crc").at("number"),
  name: data.at("crc").at("name"),
  funding-years: data.at("crc").at("funding-years").enumerate(start: 1).map(it => (str(it.at(0)), it.at(1))).to-dict(),
  funding-period: data.at("crc").at("funding-years"),
  logo-crc: image("img/logo-crc.png", width: 100%),
  logo-institution: image("img/logo-uni.png", width: 100%)
)

#show: titlepage
#include "contents/colophon.typ"
#pagebreak()
#include "contents/00-titlepage-addon.typ"
#show: proposal

// CONTENT STARTS HERE -------------------------------------------------

#include "contents/01-0-general-info.typ"
#include "contents/02-funding.typ"
#include "contents/03-project-details.typ"
#include "contents/04-bylaws.typ"
#include "contents/05-declaration-working-space.typ"
#include "contents/06-declaration-pubs.typ"

// CONTENT ENDS HERE ---------------------------------------------------
