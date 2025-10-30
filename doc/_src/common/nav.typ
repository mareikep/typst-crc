/* _src/common/nav.typ */
#import "/_src/mod.typ": css, struct

#import struct: *

// Define and style of the navigation bar.
#html.nav(class: "navbar")[
  #html.a(class: "navbar-brand", href: "./index.html", [typst-crc])
  #html.div(class: "nav-links")[
    #html.ul[
      #html.li(class: "dropdown", [
        #html.a(class: "dropdown-toggle", href: "./index.html", [Readme ▾])
        #html.ul(class: "dropdown-menu")[
          #html.li(link("./users.html")[For Contributors])
          #html.li(link("./devs.html")[For Document Admins])
        ]
      ])
    ]
  ]
]