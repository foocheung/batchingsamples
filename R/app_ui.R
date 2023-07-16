#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#'
## usethis::use_pipe()
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
   # golem_add_external_resources(),
    # List the first level UI elements here
   # navbarPage(
   #   "Batch Your Samples Here",
  shinyUI(pageWithSidebar(
    "",
    tabPanel(
        "Test Load Data",
        sidebarPanel(
          mod_dataInput_ui(
            "dataInput_ui_meta"
          ))),
        mainPanel(
        #  tabsetPanel(
            mod_table_ui("table_ui_1", "Meta Data")

         # )
         )
        )
      )
}


golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = ''
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
