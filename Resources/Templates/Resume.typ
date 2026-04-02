// Resume Template - Foundry Press
// A professional resume template for job applications

#set page(
  paper: "us-letter",
  margin: (x: 0.75in, y: 0.5in)
)

#set text(
  font: "Helvetica",
  size: 11pt
)

#let name = [Your Name]
#let email = "email@example.com"
#let phone = "(555) 123-4567"
#let location = "City, State"
#let linkedin = "linkedin.com/in/yourprofile"

// Header with name and contact info
#align(center)[
  #text(size: 24pt, weight: "bold")[#name]
  
  #text(size: 10pt)[
    #email | #phone | #location | #linkedin
  ]
]

#line(length: 100%, stroke: 0.5pt + gray)

// Summary
#heading[Professional Summary]

Results-driven professional with X years of experience in your field. 
Proven track record of delivering high-impact projects and driving 
organizational growth.

// Experience
#heading[Professional Experience]

*Senior Position Title* — Company Name, City, State \
*Month Year – Present*

- Accomplished significant achievement with measurable outcome
- Led cross-functional team of X members to deliver project Y
- Improved process efficiency by Z% through implementation of new system

*Previous Position Title* — Previous Company, City, State \
*Month Year – Month Year*

- Key responsibility or achievement
- Another significant accomplishment
- Relevant metric or outcome

// Education
#heading[Education]

*Degree Name* \
University Name, City, State \
Graduation Year

// Skills
#heading[Skills]

**Technical:** Skill 1, Skill 2, Skill 3, Skill 4 \
**Languages:** Language 1, Language 2 \
**Certifications:** Certification 1, Certification 2
