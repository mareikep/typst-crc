///////////// COLOR definitions ////////////////////////////////

// ---------- colorgroup primary -------------------------------

#let col_darkblue = rgb(0,48,82) // rgb("#003052")
#let col_mediumblue = rgb(0,100,163) // rgb("#0064A3")
#let col_lightblue = rgb(28,155,216) // rgb("#1C9BD8")
#let col_oldblue = rgb(25,80,117) // rgb("#195075")

// ---------- colorgroup backgrounds ---------------------------

#let col_darkback = rgb(84,208,255) // rgb("#54D0FF")
#let col_mediumback = rgb(180,230,250) // rgb("#B4E6FA")
#let col_lightback = rgb(220,245,255) // rgb("#DCF5FF")
#let col_mediumgrey = rgb(156,158,159) // rgb("#DCF5FF")

// ---------- colorgroup accent --------------------------------

#let col_accentred = rgb(231,76,60) // rgb("#E74C3C")
#let col_accentorange = rgb(253,143,0) // rgb("#FD8F00")
#let col_accentturquoise = rgb(40,125,120) // rgb("#287D78")
#let col_accentgreen = rgb(112,184,93) // rgb("#70B85D")
#let col_accentlime = rgb(198,224,112) // rgb("#C6E070")
#let col_accentyellow = rgb(241,230,100) // rgb("#F1E664")


///////////// FONT definitions /////////////////////////////////

#let font_default = "Arial"
#let font_backup = "STIX Two Text"

///////////// PAGE LAYOUT definitions //////////////////////////

#let margins = (
	a0: (bottom: 4.35cm, top: 4.35cm, left: 4.34cm, right: 4.34cm),
	a1: (bottom: 3.07cm, top: 3.07cm, left: 3.07cm, right: 3.07cm),
	a2: (bottom: 2.17cm, top: 2.17cm, left: 2.17cm, right: 2.17cm),
	a3: (bottom: 1.53cm, top: 1.53cm, left: 1.53cm, right: 1.53cm),
	a4: (bottom: 2.00cm, top: 3.00cm, left: 2.50cm, right: 2.50cm),
	a5: (bottom: 0.76cm, top: 0.76cm, left: 0.77cm, right: 0.77cm),
	a6: (bottom: 0.54cm, top: 0.54cm, left: 0.54cm, right: 0.54cm),
	a7: (bottom: 0.38cm, top: 0.38cm, left: 0.38cm, right: 0.38cm),
	a8: (bottom: 0.27cm, top: 0.27cm, left: 0.27cm, right: 0.27cm)
)

#let page_sizes = (
	a0: (width: 841mm, height: 1189mm),
	a1: (width: 594mm, height: 841mm),
	a2: (width: 420mm, height: 594mm),
	a3: (width: 297mm, height: 420mm),
	a4: (width: 210mm, height: 297mm),
	a5: (width: 148mm, height: 210mm),
	a6: (width: 105mm, height: 148mm),
	a7: (width: 74mm, height: 105mm),
	a8: (width: 52mm, height: 74mm)
)

///////////// LOGOS ////////////////////////////////////////////

// horizontally filled to 100%
#let logo = image("../img/logo-crc.png", width: 100%)
#let logo_writing = image("../img/logo-crc.png", width: 100%)
#let uni_logo_en = image("../img/logo-crc.png", width: 100%)
#let uni_logo_de = image("../img/logo-crc.png", width: 100%)

// vertically filled to 100%
#let logo_h = image("../img/logo-crc.png", height: 100%)
#let logo_writing_h = image("../img/logo-crc.png", height: 100%)
#let uni_logo_en_h = image("../img/logo-crc.png", height: 100%)
#let uni_logo_de_h = image("../img/logo-crc.png", height: 100%)

///////////// CRC STYLE DEFAULTS ///////////////////////////////

// style defaults for the entire document
#let crc-style-defaults = (
  table-header-fill: col_mediumback,
  table-subheader-fill: col_mediumback.lighten(20%),
  table-row-fill: col_lightback,
  table-stroke-paint: col_darkblue,
  table-stroke-thin: 1pt,
  table-stroke-thick: 2pt,
)