// Academic Paper Template - Foundry Press
// Standard academic paper format with sections

#set page(
  paper: "us-letter",
  margin: (x: 1in, y: 1in),
  numbering: "1"
)

#set text(
  font: "Times New Roman",
  size: 12pt
)

#set par(justify: true, leading: 1.5em)

// Title
#align(center)[
  #text(size: 16pt, weight: "bold")[
    Your Paper Title Here
  ]
]

#align(center)[
  #text(size: 12pt)[
    Author Name\
    Institution Name\
    email@institution.edu
  ]
]

#v(1em)

// Abstract
#heading[Abstract]

This is where your abstract goes. The abstract should be a concise summary 
of your paper, typically 150-250 words. It should include the main objectives, 
methodology, key findings, and conclusions.

// Introduction
#heading[Introduction]

The introduction sets the context for your research and explains why it matters. 
Start broad and narrow down to your specific research question.

Your research question or thesis statement should be clearly articulated 
early in the introduction.

// Literature Review
#heading[Literature Review]

Review relevant literature and prior work in the field. Discuss how your 
research builds upon or differs from existing scholarship.

// Methodology
#heading[Methodology]

Explain your research methods in detail. This section should be clear enough 
for others to replicate your study.

// Results
#heading[Results]

Present your findings objectively. Use tables and figures where appropriate 
to illustrate key results.

// Discussion
#heading[Discussion]

Interpret your results and explain their significance. Address limitations 
and suggest directions for future research.

// Conclusion
#heading[Conclusion]

Summarize the key findings and their implications. Restate the importance 
of your contribution to the field.

// References
#heading[References]

Author, A. (Year). *Title of Work*. Publisher.\
Author, B., & Author, C. (Year). Title of article. *Journal Name*, Volume(Issue), Pages.
