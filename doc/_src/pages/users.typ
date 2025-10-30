/* _src/pages/users.typ */
#include "/_src/common/common.typ"
#import "/_src/mod.typ": *
#import struct: box, align

#let gray-box = box(
  inline: false, 
  class: "cell",
  fill: "var(--bg-box)", 
  // height: 2cm, 
  outset: 3pt, 
  inset: 12pt,
)
#let my-aligned-box(alignment, inner) = {
  table(
    columns: 2,
    [#sym.arrow.r.filled],
    gray-box({
      align(alignment)[#inner]
    })
  )
}

//=============================================================================

#html.h1([For Contributors])

//=============================================================================

#html.h2([Introduction])

This proposal template is written in the novel typesetting language Typst, an alternative to LaTeX. If you don't have Typst installed, you can still compile the document since a `typst` executable binary is provided with this package.

Writing content is very similar to `markup`. All markup you write and most functions you call produce `content` values. You can create a content value by enclosing markup in square brackets. This is also how you pass content to functions.
Generally, functions are called by prepending a hashtag (`#myfunction()`).

For writing a new (sub-) section, add a new heading by typing 

#excerpt.code("= My new heading

Some text

== My new subheading

Some more text
")

where the number of prepended `=` determines the heading level. 

The most frequently used functions when writing documents are 

- highlighting (boldfaced, italic, ...) and other text modifications
- inserting images
- citing 
- referencing images, tables, sections and other content
- drawing tables
- footnotes
- math functions
- raw content (code examples)

all of which are described in the remainder of this document for convenience. Some of the functions introduced here are macros specifically written for this proposal and are marked as such. Other functions are built-in Typst functions which are listed here for your convenience.

For more advanced writing, refer to the official #link("https://typst.app/docs/")[Typst documentation].

#html.h3([Text modifications])

#html.h4([Highlighting])

For setting single words or parts of a text boldfaced, simply surround it with single asterisks `*`:

#excerpt.full("_assets/code/highlight-bold.md", sourceline: false, lang: "markdown")

will render to 

#my-aligned-box(left)[
  Lorem ipsum dolor sit amet, *consetetur sadipscing elitr,* sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 
]

while using a single underscore `_`

#excerpt.full("_assets/code/highlight-emph.md", sourceline: false, lang: "markdown")

will render to 

#my-aligned-box(left)[
  Lorem ipsum dolor sit amet, _consetetur sadipscing elitr,_ sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 
]

#html.h4([Sub-/superscripting])

Sub-/superscripting works with functions

#excerpt.code("N#super[x]\
N#sub[x]
")

renders to 

#my-aligned-box(left)[
  N#super[x]\  
  N#sub[x]
]

#html.h4([Line breaks])

A simple line break can be achieved with `\`, while an empty line starts a new paragraph:

#excerpt.full("_assets/code/highlight-lb.md", sourceline: false, lang: "markdown")

#my-aligned-box(left)[
  Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est \ Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 

  At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
]

#html.h4([Underlining])

Underlined text can be achieved with:

#excerpt.code("#underline[I am underlined]", lang: "rust")

#my-aligned-box(left)[
  #underline[I am underlined]
]

#html.h4([Bulleted lists])

For single items lists, use 

#excerpt.code("- first item
- second item
- third item
- ...
")

#my-aligned-box(left)[
  - first item
  - second item
  - third item
  - ...
]

#html.h4([Enumerated lists])

Similarly, for numbered lists, use 

#excerpt.code("+ first item
+ second item
+ third item
+ ...
")

or 

#excerpt.code("#enum[first item][second item][third item][...]")

#my-aligned-box(left)[
  + first item
  + second item
  + third item
  + ...
]

By default, this will create a numbered lists with roman numbers starting at 1. 
If you want to start at a certain number, use

#excerpt.code("#enum(start: 3)[first item][second item][third item][...]")

#my-aligned-box(left)[
  #enum(start: 3)[first item][second item][third item][...]
]

For a different numbering style, use 

#excerpt.code("#set enum(numbering: \"a.\")

+ Starting off ...
+ Don't forget step two
")

#my-aligned-box(left)[
  #set enum(numbering: "a)")

  + Starting off ...
  + Don't forget step two
]

More complex numberings are possible. See the documentation on #link("https://typst.app/docs/reference/model/enum/")[enums].

#html.h3([Inserting images])

If you only want to insert an image without any caption etc., simply use

#excerpt.code("#image(\"<path/to/file.png>\", width: 70%)  ")

#my-aligned-box(left)[
  #image("../../_assets/img/tigernofig.svg")
]

This image will be scaled take 70% of the available horizontal space.

However, if you want to add a caption and be able to reference the image, create a figure around it, similar to LaTeX:

#excerpt.code("#figure(
  image(\"<path/to/file.png>\", width: 70%),
  caption: [My fancy caption],
)<img:my-fancy-image>
")

#my-aligned-box(left)[
  #image("../../_assets/img/image.svg")
]

#html.h3([Tables])

#excerpt.code("#table(
  columns: 3,
  align: horizon,
  table.header(
    [], [*Volume*], [*Parameters*],
  ),
  [Test],
  $ pi h (D^2 - d^2) / 4 $,
  [
    $h$: height \
    $D$: outer radius \
    $d$: inner radius
  ],
  [Test],
  $ sqrt(2) / 12 a^3 $,
  [$a$: edge length]
)
")

#my-aligned-box(left)[
  #image("../../_assets/img/table.svg")
]

see the #link("https://typst.app/docs/reference/model/table/")[table documentation] for more advanced tables.

#html.h3([Footnotes])

Inserting footnotes in Typst is very easy: 

#excerpt.code("Check the docs#footnote[#link(\"https://typst.app/docs\")] for more details.")

#my-aligned-box(left)[
  Check the docs#footnote[#link("https://typst.app/docs")] for more details
]


#html.h3([Referencing])

In typst, you can reference different kinds of content such as images, tables and sections using `ref` or its short form `@`. 
You can reference the above figure by simply calling `#ref(<img:my-fancy-image>)` or short: `@img:my-fancy-image` which outputs *Figure 1* by default. If the image is replaced by a table, the reference will automatically output *Table 1*. This behaviour can be overridden by explicitly specifying the figure's `kind`. All figures of the same kind share a common counter.

There are some additional functions specifically for this proposal to reference PIs and projects:

#html.h4([projects (proposal-specific!)])

You can reference a project using the command `#project("<project-id>")`, e.g. `#project("h01")` which then renders to *H01*. Multiple projects are referenced like this: `#projects(("h01", "h03", "h04"))` which renders to: *H01, H03-N and H04*. By default, only the project number is rendered. Using the mutually exclusive flags `name` or `full`, the function either renders only the project's name (`#project("h01", name: true)`): Adaptive Multi-Robot Collaboration for Dynamic Environments or its number _and_ name (`#project("P01", full: true)`): *H01* - Adaptive Multi-Robot Collaboration for Dynamic Environments. (Note that the project number is printed bold in the respective color of the subproject, which cannot be displayed here.)

#html.h4([PIs (proposal-specific!)])

Similarly, one can use the functions `#pi("<name>")` and `#pis(("<name1>", "<name2"))` to print (and highlight) the respective PIs last name (`#pi("carter")` => *Carter*), first and last name (`#pi("carter", first: true)` => *Emily Carter*) or full title, first name and last name: `#pi("carter", full: true)` => Prof. Dr.-Ing. *Emily Carter*, Ph.D.

#html.h3([Citing])

In general, bib entries in Typst are referenced using either `@<key>` or `#cite(<key>)`. However, in this proposal we're using a specific package to generate multiple bibliographies, so we have to prepend the project id to the bib key to identify the correct citations for this project's reference list. The prefix is `bib-<projectnumber>-`. As an example, the bib key `uhde2020robot` becomes `bib-h01-uhde2020robot` for the project H01, so the citation either looks like this `@bib-h01-uhde2020robot` or this `#cite(<bib-h01-uhde2020robot>, form: "normal")`. Both render to: (Uhde et al., 2020). 

#html.h4([Publication categories])

Some projects allow to split the references into different categories. Put 

#excerpt.code("#context s-publicationlists.update((
    s-current-project.get(): (
        other: (\"key1\", \"key2\"), 
        patents: (\"key5\",),
        quality: ()
    ))
)")

at the top of the respective project file to define, which bib keys should appear in the respective sub categories. All cited keys that are not mentioned here, are listed in the default reference list above the categories.

#html.h4([Highlighting significant publications])

It is possible to highlight certain publications in the projects' reference lists. To achieve this, mark the respective bib entries of the project's bib file with `annote={true}`. _Make sure to not exceed the limit of *10* highlighted publications as requested by the DFG._

#html.h4([Math functions#footnote[rendering math functions is not supported in HTML output yet, so they will not be shown in this readme, but they will of course work in-document]])

The math environment is defined by enclosing dollar signs: 

#excerpt.code("$ x^2 $")

compiles to 

#my-aligned-box(left)[
  #image("../../_assets/img/math.svg")
]

Math formulas can be displayed inline with text or as separate blocks. They will be typeset into their own block if they start and end with at least one space (as in the example above).

There are lots of predefined symbols such as greek letters, symbols for sums and integrals, brackets, operators etc. You can find a list of these symbols here in the [symbols list](https://typst.app/docs/reference/symbols/sym/). Tip: similarly to the service Detexify for LaTeX, there exist [Detypify](https://detypify.quarticcat.com/) for Typst, which will suggest a number of symbols that match your drawing in a canvas. This is quite helpful, when you need a certain symbol but cannot remember its name. 

Writing mathematical formulas in Typst is quite intuitive. While you can explicitly use predefined functions for fractions or blackboard bold, you can often just use the natural notation:

#excerpt.code("$ 
  frac(a^2, 2)\
  a^2/2
$")

and

#excerpt.code("$ 
  bb(N)\
  NN
$")

are two ways of generating the same output, respectively:

#my-aligned-box(left)[
  #image("../../_assets/img/eq.svg")
]

and

#my-aligned-box(left)[
  #image("../../_assets/img/eq_.svg")
]

Similarly to LaTeX, each line can contain one or multiple alignment points (&) which are then aligned. 

#excerpt.code("$ 
  sum_(k=0)^n k &= 1 + ... + n \
                &= (n(n+1)) / 2 
$")

#my-aligned-box(left)[
  #image("../../_assets/img/eq1.svg")
]

When equations include multiple alignment points (&), this creates blocks of alternatingly right- and left-aligned columns

#excerpt.code("$ 
  (3x + y) / 7 &= 9         &&  \"multiply by 7\" \
        3x + y &= 63        &&  \"subtract y\"\
            3x &= 63 - y    &&  \"divide by 3\"  \
             x &= 21 - y/3  
$")

#my-aligned-box(left)[
  #image("../../_assets/img/eq2.svg")
]

If you want to use a different math font than the default one, you can set it with a show-set rule:

#excerpt.code("#show math.equation: set text(font: \"Fira Math\")
$ 
  sum_(k=0)^n k &= 1 + ... + n \
                &= (n(n+1)) / 2 
$")

#my-aligned-box(left)[
  #image("../../_assets/img/fiera.svg")
]

For more complex mathematical functions and formulas, refer to the documentation on #link("https://typst.app/docs/reference/math/")[math in Typst].

#html.h4([Raw content])

For displaying code examples, use the raw environment of Typst, which displays the text verbatim and in a monospace font. Similar to many other languages, raw code is enclosed in single or triple backticks:

#excerpt.code("`def main()`", lang: none)

#my-aligned-box(left)[
#excerpt.code("def main()", lang: "python")
]
Adding the programming language information gives you proper syntax highlighting:


#excerpt.code("```py
def main() {
    print('Hello World!')
}
```", lang: none)

#my-aligned-box(left)[
#excerpt.code("def main() {
    print('Hello World!')
}", lang: "python")
]