
# Entity-Relationship Diagram (ERD) for WUS University of Technology

- Author: Mubanga Nsofu
- Course: BAN6420, Assignment One
- Email: mnsofu@learner.nexford.org
- Learner ID: 149050
- Institution: Nexford University
- Lecturer: Prof. Rajan Thapaliya 
- Date: 5th September 2024
- Task: Entity-Relationship Diagram (ERD) for WUS University of Technology

Overview

This R script generates an Entity-Relationship Diagram (ERD) to visualize relationships between postgraduate students, supervisors, administrators, examiners, and their respective departments within the WUS University of Technology. The ERD serves as a key tool for modeling the assignment process of supervisors to students, managing thesis submissions, and capturing marks.


The diagram includes entities such as:

- Students
- Supervisors
- Administrators
- Departments
- Theses
- Examiners
- Supervisions

The relationships between these entities (such as a student writing a thesis, or a supervisor being assigned to a student) are also mapped out, including their cardinality, primary keys, and foreign keys.


## Installation

To run the script, you need to install the following R packages:

- pacman: To simplify the loading and installation of packages.
- DiagrammeR: To create, visualize, and export diagrams.
- DiagrammeRsvg: To export DiagrammeR visualizations in SVG format.
- rsvg: To render the SVG files to formats like PDF.
The code will automatically check if the required packages are installed and install them if necessary.

``` r
if (!require(pacman)) {
  install.packages("pacman") # Check if package manager is installed 
}

# Manage the installation and loading of DiagrammeR, DiagrammeRSvg, and rsvg
pacman::p_load(DiagrammeR, # Creates, visualizes, and exports diagrams & flowcharts
               DiagrammeRsvg, # Export  DiagrammeR plots as SVG
               rsvg # Render SVG files into other formats, such as PDF, PNG etc
)
```
How the code works?

## Highlevel view of what the code does?

1. Defines Constants
NODE_STYLE and EDGE_STYLE constants are defined to standardize the appearance of the nodes and edges within the ERD.

2. Creates helper functions
create_entity_node(): This function creates individual entity nodes for each of the ERD entities, specifying their attributes and methods.

3. Creates a Class Diagram
create_class_diagram(): This function generates the complete class diagram, linking the entity nodes together with specified relationships. The relationships between entities, such as Student -> Department [label='belongs to'], are defined here.

4. Saves the Diagram
save_diagram_as_pdf(): This function exports the generated diagram into a PDF file named WUS_University_ClassDiagram.pdf for ease of viewing.

5. Uses the Main function for EDGE_STYLExecution
The main function coordinates the generation of the ERD and saving it as a PDF file.

## Output

The main output of this script is:

ERD Visualization: The script will generate and display the ERD, mapping the relationships between the key entities.
PDF File: The diagram will be saved as WUS_University_ClassDiagram.pdf in the working directory.

## How to use the R script?

1. Run the Script: Simply execute the script using R. The main function main() will run automatically, generating the ERD and saving it as a PDF.

2. Access the PDF: After running the script, the file WUS_University_ClassDiagram.pdf will be saved to your current working directory, where you can view or share it as needed.

## Troubleshooting

For any queries with regards to troubleshooting, please contact the author via email at mnsofu@learner.nexford.org.

## Contact Author

- [@RProDigest](https://www.github.com/RProDigest)
- [@RProDigest](https://www.twitter.com/RProDigest)

