#import "../../crc-imports.typ": *

// define, which publications should appear in the sub-categories of the reference lists. keys: (other, quality, patents)
#context s-publicationlists.update((
  s-current-project.get(): (
    other: ("uhde2020robot",), 
    patents: ("cheng2020neuroengineering",),
    quality: ()
  ))
)

== Project history

@bib-h04-uhde2020robot
@bib-h04-cheng2020neuroengineering

=== Report



$ 
    frac(a^2, 2)\
    a^2/2
$

$ 
    bb(N)\
    NN
$


=== Published project results <project-results>

// DO NOT TOUCH! The reference list(s) will be automatically generated. All citations within this file that are prefixed with `bib-<projectnumber>-` will be listed here.

== Funding

Funding of this project within the Collaborative Research Centre started in `month` `YYYY`. // <If applicable:> Previously, it was funded under a different DFG programme from `month` `YYYY` to `month` `YYYY` under reference number <x> as of. 

The project ended in `month` `YYYY`. 
// <Or:> The project will be completed by the end of the current funding period.

=== Project staff in the ending funding period

#proj-requested-funding-staff()
