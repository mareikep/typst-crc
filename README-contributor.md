Introduction
===

This proposal template is written in the novel typesetting language Typst, an alternative to LaTeX. If you don't have Typst installed, you can still compile the document since a `typst` executable binary is provided with this package.

Writing content is very similar to `markup`. All markup you write and most functions you call produce `content` values. You can create a content value by enclosing markup in square brackets. This is also how you pass content to functions.
Generally, functions are called by prepending a hashtag (`#myfunction()`).

For writing a new (sub-) section, add a new heading by typing 

```typ
= My new heading

Some text

== My new subheading

Some more text
```

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

For more advanced writing, refer to the official [Typst documentation](https://typst.app/docs/).

Text modifications
===

Highlighting
---

For setting single words or parts of a text boldfaced, simply surround it with single asterisks `*`:

```rust
Lorem ipsum dolor sit amet, *consetetur sadipscing elitr*, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 
```

will render to 

Lorem ipsum dolor sit amet, **consetetur sadipscing elitr**, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 

while using a single underscore `_`

```rust
Lorem ipsum dolor sit amet, _consetetur sadipscing elitr_, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 
```

will render to 

Lorem ipsum dolor sit amet, *consetetur sadipscing elitr*, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 

Sub-/superscripting
---

Sub-/superscripting works with functions

```rust
N#super[x]\
N#sub[x]
```

renders to 

N<sup>x</sup>\
N<sub>x</sub>

Line breaks
---

A simple line break can be achieved with `\`, while an empty line starts a new paragraph:

```rust
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est \ Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 

At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
```

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est   
Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. 

At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

Underlining
---

Underlined text can be achieved with:

```rust
#underline[I am underlined]
```

<ins>I am underlined</ins>

Bulleted lists
---

For single items lists, use 

```rust
- first item
- second item
- third item
- ...
```

- first item
- second item
- third item
- ...

Enumerated lists
---

Similarly, for numbered lists, use 

```rust
+ first item
+ second item
+ third item
+ ...
```

or 

```rust
#enum[first item][second item][third item][...]
```

1. first item
1. second item
1. third item
1. ...

By default, this will create a numbered lists with roman numbers starting at 1. 
If you want to start at a certain number, use

```rust
#enum(start: 3)[first item][second item][third item][...]
```

3. first item
3. second item
3. third item
3. ...

For a different numbering style, use 

```rust
#set enum(numbering: "a.")

+ Starting off ...
+ Don't forget step two
```

<ol type="a">
  <li>Starting off ...</li>
  <li>Don't forget step two</li>
</ol>

More complex numberings are possible. See the documentation on [enums](https://typst.app/docs/reference/model/enum/).

Inserting images
===

If you only want to insert an image without any caption etc., simply use

```rust
#image("<path/to/file.png>", width: 80%)  
```

This image will be scaled take 80% of the available horizontal space.

However, if you want to add a caption and be able to reference the image, create a figure around it, similar to LaTeX:

```rust
#figure(
  image("<path/to/file.png>", width: 80%),
  caption: [My fancy caption],
)<img:my-fancy-image>
```

Tables
===

```rust
#table(
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
  image("tetrahedron.svg"),
  $ sqrt(2) / 12 a^3 $,
  [$a$: edge length]
)
```

see the [table documentation](https://typst.app/docs/reference/model/table/) for more advanced tables.

Footnotes
===

Inserting footnotes in Typst is very easy: 

```rust
Check the docs#footnote[https://typst.app/docs] for more details.
```

Check the docs<sup>1</sup> for more details
<hr style="border:.5px solid white">
<sup>1</sup>https://typst.app/docs


Referencing
===

In typst, you can reference different kinds of content such as images, tables and sections using `ref` or its short form `@`. 
You can reference the above figure by simply calling `#ref(<img:my-fancy-image>)` or short: `@img:my-fancy-image` which outputs *Figure 1* by default. If the image is replaced by a table, the reference will automatically output *Table 1*. This behaviour can be overridden by explicitly specifying the figure's `kind`. All figures of the same kind share a common counter.

There are some additional functions specifically for this proposal to reference PIs and projects:

projects (proposal-specific!)
---

You can reference a project using the command `#project("<project-id>")`, e.g. `#project("h01")` which then renders to **H01**. Multiple projects are referenced like this: `#projects(("h01", "h03", "h04"))` which renders to: **H01, H03-N and H04**. By default, only the project number is rendered. Using the mutually exclusive flags `name` or `full`, the function either renders only the project's name (`#project("h01", name: true)`): Adaptive Multi-Robot Collaboration for Dynamic Environments or its number _and_ name (`#project("P01", full: true)`): **H01** - Adaptive Multi-Robot Collaboration for Dynamic Environments. (Note that the project number is printed bold in the respective color of the subproject, which cannot be displayed here.)

PIs (proposal-specific!)
---

Similarly, one can use the functions `#pi("<name>")` and `#pis(("<name1>", "<name2"))` to print (and highlight) the respective PIs last name (`#pi("carter")` => **Carter**), first and last name (`#pi("carter", first: true)` => **Emily Carter**) or full title, first name and last name: `#pi("carter", full: true)` => Prof. Dr.-Ing. **Emily Carter**, Ph.D.

Citing
===

In general, bib entries in Typst are referenced using either `@<key>` or `#cite(<key>)`. However, in this proposal we're using a specific package to generate multiple bibliographies, so we have to prepend the project id to the bib key to identify the correct citations for this project's reference list. The prefix is `bib-<projectnumber>-`. As an example, the bib key `uhde2020robot` becomes `bib-h01-uhde2020robot` for the project H01, so the citation either looks like this `@bib-h01-uhde2020robot` or this `#cite(<bib-h01-uhde2020robot>, form: "normal")`. Both render to: (Uhde et al., 2020). 

Publication categories
---

Some projects allow to split the references into different categories. Put 

```
#context s-publicationlists.update((
    s-current-project.get(): (
        other: ("key1", "key2"), 
        patents: ("key5",),
        quality: ()
    ))
)
```

at the top of the respective project file to define, which bib keys should appear in the respective sub categories. All cited keys that are not mentioned here, are listed in the default reference list above the categories.

Highlighting significant publications
---

It is possible to highlight certain publications in the projects' reference lists. To achieve this, mark the respective bib entries of the project's bib file with `annote={true}`. _Make sure to not exceed the limit of **10** highlighted publications as requested by the DFG._

Math functions
---


The math environment is defined by enclosing dollar signs: 

```
$ x^2 $
```
compiles to 

$x^2$

Math formulas can be displayed inline with text or as separate blocks. They will be typeset into their own block if they start and end with at least one space (as in the example above).

There are lots of predefined symbols such as greek letters, symbols for sums and integrals, brackets, operators etc. You can find a list of these symbols here in the [symbols list](https://typst.app/docs/reference/symbols/sym/). Tip: similarly to the service Detexify for LaTeX, there exist [Detypify](https://detypify.quarticcat.com/) for Typst, which will suggest a number of symbols that match your drawing in a canvas. This is quite helpful, when you need a certain symbol but cannot remember its name. 

Writing mathematical formulas in Typst is quite intuitive. While you can explicitly use predefined functions for fractions or blackboard bold, you can often just use the natural notation:

```
$ 
    frac(a^2, 2)\
    a^2/2
$

and

$ 
    bb(N)\
    NN
$
```
are two ways of generating the same output, respectively ($\frac{a^2}{2}$ and $\mathbb{N}$). 

Similarly to LaTeX, each line can contain one or multiple alignment points (&) which are then aligned. 

```
$ sum_(k=0)^n k
    &= 1 + ... + n \
    &= (n(n+1)) / 2 $
```

When equations include multiple alignment points (&), this creates blocks of alternatingly right- and left-aligned columns

```
$ (3x + y) / 7 &= 9 && "given" \
  3x + y &= 63 & "multiply by 7" \
  3x &= 63 - y && "subtract y" \
  x &= 21 - y/3 & "divide by 3" $
```

If you want to use a different math font than the default one, you can set it with a show-set rule:

```
#show math.equation: set text(font: "Fira Math")
```

For more complex mathematical functions and formulas, refer to the documentation on [math in Typst](https://typst.app/docs/reference/math/).

Raw content
---

For displaying code examples, use the raw environment of Typst, which displays the text verbatim and in a monospace font. Similar to many other languages, raw code is enclosed in single or triple backticks:

```
`fn main()`
```

Adding the programming language information gives you proper syntax highlighting:


```rust
fn main() {
    println!("Hello World!");
}
```