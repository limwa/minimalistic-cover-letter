#import "@preview/datify:1.0.1": custom-date-format

#let margin = 1in

#let day-suffix(day: int) = {
  if day == 1 or day == 21 or day == 31 {
    "st"
  } else if day == 2 or day == 22 {
    "nd"
  } else if day == 3 or day == 23 {
    "rd"
  } else {
    "th"
  }
}

#let today() = {
  let date = datetime.today()
  let suffix = day-suffix(day: date.day())

  return custom-date-format(date, lang: "en", pattern: "MMMM d'" + suffix + "', yyyy")
}

#let email-link(email: str) = {
  link("mailto:" + email)[#email]
}

#let phone-link(phone: str) = {
  let sanitized-phone = phone.replace(regex("[ -]"), "")
  link("tel:" + sanitized-phone)[#phone]
}

#let make-candidate-details(
  candidate: (:),
  show-name: false,
  show-location: false,
) = {
  let details = ()

  if show-name {
    details.push([#candidate.name])
  }

  if show-location {
    details.push([#candidate.location])
  }

  details.push(email-link(email: candidate.email))
  details.push(phone-link(phone: candidate.phone))

  return details.join(" | ")
}

#let make-header-details(
  candidate: (:)
) = {
  set text(size: 10pt)
  make-candidate-details(candidate: candidate, show-location: true)
}

#let make-header(
  candidate: (:)
) = {
  [
    #set text(font: "Open Sans", weight: 300)

    = #candidate.name
    #make-header-details(
      candidate: candidate
    )
  ]
}

#let make-footer(
  candidate: (:),
  subject: str
) = {
  set text(size: 9pt, font: "Open Sans", weight: 300)

  line(
    end: (100%, 0%),
    stroke: 0.05em + black,
  )

  columns(2, gutter: 1em)[
    #make-candidate-details(candidate: candidate, show-name: true)

    #colbreak()

    #[
      #set align(right)
      #subject
    ]
  ]
}


#let make-letter(
  candidate: (name: str, email: str, phone: str, location: str),
  subject: str,
  reader: str,
  body
) = {
  set page(
    paper: "us-letter",
    margin: (
      top: margin,
      bottom: margin,
      left: margin,
      right: margin,
    ),
    footer: make-footer(candidate: candidate, subject: subject),
  )

  set text(font: "New Computer Modern")

  show heading.where(level: 1): set text(
    size: 28pt,
    weight: "light",
  )

  make-header(
    candidate: candidate
  )

  v(2em)

  [
    #set align(right)
    #today()
  ]

  v(0em)

  [
    Dear #reader,
  ]

  v(1em)

  body

  v(1em)

  [
    Best Regards, #linebreak()
    #candidate.name
  ]
}
