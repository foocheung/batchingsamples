#' dataInput UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dataInput_ui <- function(id){
  ns <- NS(id)

  # shinydashboard::dashboardSidebar(
  #   shinydashboard::sidebarMenu(id = "menu1",
  #                               shinydashboard::menuItem('mod1',
  #                                                        tabName = 'mod1',
  #                                                        icon = shiny::icon('file')),
  #
  #                               shinydashboard::menuItem('mod2',
  #                                                        tabName = 'mod2',
  #                                                        icon = shiny::icon('file'))
  #   )),

  tagList(
   # tabsetPanel(
    #  tabPanel(
    shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(id = "Options",
      fileInput(ns("id"), label="Upload",
              multiple = FALSE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv",
                         ".tsv"
            )
    )
    )),
  #   Input: Select separator ----
  sliderInput(ns("integer"), "# of Batches:",
              min=2, max=100, value=2),
  sliderInput(ns("sim"), "nSim",
              min=1000, max=5000, value=1000),

 radioButtons(ns("sep"), "Separator",
                 choices = c(Comma = ",",
                             Tab = "\t"),
                 selected = "\t"),
 actionButton(ns("goButton"), "Go!")
  )
}

#' dataInput Server Functions
#'
#' @noRd
mod_dataInput_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    userFile <- reactive({
      validate(need(input$id !="", "Hello Please import a data file"))
      input$id
    })

    datafile <- reactive({
     # read.csv(userFile()$datapath, header=T, fill=TRUE, sep="\t")
      utils::read.table(userFile()$datapath,
                        header = FALSE,
                        sep = input$sep,
                        row.names = NULL,
                        skip = 1,
                        stringsAsFactors = FALSE)

    })


    return(list(integer = reactive({input$integer}),
                sim   = reactive({input$sim}),
                df =datafile
                )
           )

    #bat <- reactive({
    #  input$integer
    #})
    #return(
    #list(
    #    c(
    #    "dat"=datafile
        #,
        #"batches" = reactive({ input$integer }),
        #"sim" = reactive({ input$sim })
    #  ))
    #)



   # return(list(c("datafile" = datafile, "userFile" = userFile)))
  })

}

## To be copied in the UI
# mod_dataInput_ui("dataInput_1")

## To be copied in the server
# mod_dataInput_server("dataInput_1")
