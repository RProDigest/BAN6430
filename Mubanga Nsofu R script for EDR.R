################################################################################
# Name: Mubanga Nsofu                                                          #
# Institution: Nexford University (NXU)                                        #
# Date : 1st September 2024                                                    #
# Course: BAN 6430 (Data Modeling & Mining)                                    #                  
# Program: Master of Science Data Analytics (MSDA)                             #
# Lecturer: Professor Rajan Thapaliya                                          #
# Assignment : 1 (Developing ERD to Model Data)                                #
################################################################################



# 1.0 INSTALL THE NECESSARY PACKAGES----

if (!require(pacman)) {
  install.packages("pacman") # Check if package manager is installed 
}

# Manage the installation and loading of DiagrammeR, DiagrammeRSvg, and rsvg
pacman::p_load(DiagrammeR, # Creates, visualizes, and exports diagrams & flowcharts
               DiagrammeRsvg, # Export  DiagrammeR plots as SVG
               rsvg # Render SVG files into other formats, such as PDF, PNG etc
)

# 2.0 DEFINE CONSTANTS----------

NODE_STYLE <- "shape=record, style=filled, fillcolor=lightblue"
EDGE_STYLE <- "arrowhead=vee"

# 3.0 DEFINE HELPER FUNCTIONS TO CREATE ENTITY NODES----------

#' Create an entity node for the diagram
#'
#' @param name Name of the entity
#' @param attributes Vector of attributes
#' @param methods Optional vector of methods
#' @return A formatted string representing the entity node

create_entity_node <- function(name, attributes, methods = NULL) {
  if (!is.character(name) || !is.character(attributes)) {
    stop("Name and attributes must be character vectors")
  }
  
  if (!is.null(methods) && !is.character(methods)) {
    stop("Methods must be a character vector")
  }
  
  methods_str <- if (!is.null(methods)) {
    paste0("<TR><TD PORT='methods' ALIGN='LEFT'>", 
           paste(methods, collapse = "<BR/>"), 
           "</TD></TR>")
  } else ""
  
  sprintf("%s [label = <<TABLE BORDER='0' CELLBORDER='1' CELLSPACING='0'>
    <TR><TD PORT='class'><B>%s</B></TD></TR>
    <TR><TD PORT='attributes' ALIGN='LEFT'>%s</TD></TR>
    %s
  </TABLE>>]", name, name, paste(attributes, collapse = "<BR/>"), methods_str)
}

# 4.0 DEFINE A FUNCTION TO CREATE THE CLASS DIAGRAM----------

#' Create the class diagram
#'
#' @return A graph object representing the class diagram

create_class_diagram <- function() {
  entities <- c(
    create_entity_node("Student", 
                       c("- studentID : int", "- name : string", "- email : string", 
                         "- researchArea : string", "- departmentID : int"),
                       c("+ viewResults() : void")),
    create_entity_node("Supervisor", 
                       c("- supervisorID : int", "- name : string", "- email : string", 
                         "- expertise : string", "- departmentID : int"),
                       c("+ assignStudent(Student) : void")),
    create_entity_node("Department", 
                       c("- departmentID : int", "- name : string")),
    create_entity_node("Administrator", 
                       c("- adminID : int", "- name : string", "- email : string", "- departmentID : int"),
                       c("+ sendThesisToExaminer(Thesis) : void", 
                         "+ recordMark(Thesis, float) : void", 
                         "+ recordCompletionDate(Thesis, date) : void")),
    create_entity_node("Thesis", 
                       c("- thesisID : int", "- title : string", "- studentID : int", 
                         "- mark : float", "- completionDate : date", "- status : string")),
    create_entity_node("Examiner", 
                       c("- examinerID : int", "- name : string", "- email : string", "- expertise : string"),
                       c("+ evaluateThesis(Thesis) : void")),
    create_entity_node("Supervision", 
                       c("- supervisionID : int", "- studentID : int", "- supervisorID : int", "- role : string"))
  )
  
  # A vector to define the relationships
  
  relationships <- c(
    "Student -> Department [label='belongs to']",
    "Supervisor -> Department [label='belongs to']",
    "Administrator -> Department [label='belongs to']",
    "Student -> Thesis [label='writes']",
    "Supervision -> Student [label='has']",
    "Supervision -> Supervisor [label='has']",
    "Administrator -> Thesis [label='manages']",
    "Examiner -> Thesis [label='evaluates']",
    "Administrator -> Supervision [label='manages']",
    "Administrator -> Examiner [label='assigns']",
    "Supervision -> Thesis [label='involves']"
  )
  
  diagram <- sprintf("
    digraph class_diagram {
      node [%s]
      edge [%s]
      %s
      %s
    }
  ", NODE_STYLE, EDGE_STYLE, paste(entities, collapse = "\n"), paste(relationships, collapse = "\n"))
  
  grViz(diagram)
}

# 5.0 DEFINE A FUNCTION TO SAVE THE DIAGRAM AS A PDF------

#' Save the diagram as a PDF file
#'
#' @param diagram The diagram object to be saved
#' @param filename The name of the output PDF file
save_diagram_as_pdf <- function(diagram, filename) {
  if (!grepl("\\.pdf$", filename)) {
    stop("Filename must end with .pdf")
  }
  
  tryCatch({
    diagram_svg <- DiagrammeRsvg::export_svg(diagram)
    rsvg::rsvg_pdf(charToRaw(diagram_svg), filename)
    cat(sprintf("Diagram saved as %s\n", filename))
  }, error = function(e) {
    cat(sprintf("Error saving diagram: %s\n", e$message))
    # Optionally add a recovery mechanism here
  })
}


# 6.0 DEFINE A FUNCTION FOR MAIN EXECUTION-----------

#' Main function to execute the script
main <- function() {
  diagram <- create_class_diagram()
  save_diagram_as_pdf(diagram, "WUS_University_ClassDiagram.pdf")
  print(diagram)
  }

# Execute the main function
main()
