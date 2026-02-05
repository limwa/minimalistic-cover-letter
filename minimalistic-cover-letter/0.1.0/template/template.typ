// Import from Universe (not yet available) or if using Nix
// #import "@preview/minimalistic-cover-letter:0.1.0": make-letter

// Or import from a local package repository
#import "@local/minimalistic-cover-letter:0.1.0": make-letter

// Or, if you are developing the template, use a relative import
// #import "../lib.typ": make-letter

#show: make-letter.with(
  candidate: (
    name: "John Doe",
    email: "johndoe@example.com",
    phone: "+351 999 999 999",
    location: "Somewhere, Earth"
  ),
  reader: "Hiring Manager",
  subject: "ACME Internship 2026"
)

#lorem(50)

#lorem(20)

#lorem(70)

#lorem(15)
