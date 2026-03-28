// Thesis Template - Foundry Press
// Comprehensive academic thesis format

#set page(
  paper: "us-letter",
  margin: (x: 1.5in, y: 1in),
  numbering: "1"
)

#set text(
  font: "Times New Roman",
  size: 12pt
)

#set par(justify: true, leading: 2em)

// Title Page
#align(center)[
  #v(2in)
  
  #text(size: 18pt, weight: "bold")[
    Your Thesis Title Here:\
    A Subtitle if Needed
  ]
  
  #v(1in)
  
  #text(size: 14pt)[
    by
    
    Your Full Name
  ]
  
  #v(1in)
  
  #text(size: 12pt)[
    A thesis submitted in partial fulfillment\
    of the requirements for the degree of
    
    Degree Name
    
    Department Name\
    University Name
    
    Month Year
  ]
]

#pagebreak()

// Abstract
#heading(level: 1)[Abstract]

The abstract should provide a comprehensive summary of your thesis, 
typically 300-500 words. It should cover the research problem, methodology, 
key findings, and conclusions.

#text(size: 10pt)[
  Keywords: keyword1, keyword2, keyword3, keyword4, keyword5
]

// Acknowledgments
#heading(level: 1)[Acknowledgments]

Thank those who supported your research journey, including advisors, 
committee members, colleagues, family, and funding sources.

#pagebreak()

// Table of Contents placeholder
#heading(level: 1)[Table of Contents]

*Note: In the final version, this will be auto-generated*

// Chapters
#heading(level: 1)[Chapter 1: Introduction]

#heading(level: 2)[1.1 Background]

Provide the background context for your research problem.

#heading(level: 2)[1.2 Problem Statement]

Clearly articulate the research problem you are addressing.

#heading(level: 2)[1.3 Research Objectives]

State your specific research objectives or questions.

#heading(level: 2)[1.4 Significance of Study]

Explain why this research matters and who benefits.

#heading(level: 1)[Chapter 2: Literature Review]

Review the theoretical framework and relevant literature.

#heading(level: 1)[Chapter 3: Methodology]

Detail your research design, methods, and procedures.

#heading(level: 1)[Chapter 4: Results]

Present your findings with appropriate analysis.

#heading(level: 1)[Chapter 5: Discussion]

Interpret findings and discuss implications.

#heading(level: 1)[Chapter 6: Conclusion]

Summarize and provide recommendations.

// References
#heading(level: 1)[References]

#heading(level: 1)[Appendices]

Include supplementary materials here.
