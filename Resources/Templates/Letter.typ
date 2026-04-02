// Letter Template - Foundry Press
// Professional business letter format

#set page(
  paper: "us-letter",
  margin: (x: 1in, y: 1in)
)

#set text(
  font: "Times New Roman",
  size: 12pt
)

// Sender's address
#align(right)[
  Your Name\
  Street Address\
  City, State ZIP Code\
  email@example.com\
  (555) 123-4567
]

#v(1em)

// Date
#align(right)[
  #datetime.today().display("[month repr:long] [day], [year]")
]

#v(1em)

// Recipient's address
[
  Recipient Name\
  Title/Organization\
  Street Address\
  City, State ZIP Code
]

#v(1em)

// Salutation
Dear Recipient Name,

// Body
#set par(first-line-indent: 0.5in)

This is the opening paragraph of your letter. State the purpose clearly 
and concisely. Make your main point early to engage the reader.

This is the body of the letter where you provide supporting details, 
context, and information relevant to your purpose. Keep paragraphs 
focused and well-organized.

This is the closing paragraph where you restate your purpose, 
indicate next steps, or request specific action. End with a clear 
call to action or expression of gratitude.

// Closing
#set par(first-line-indent: 0pt)

#v(1em)

Sincerely,

#v(2em)

Your Name
