#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

`%>%` <- dplyr::`%>%`

mod_table_ui <- function(id, name){
    ns <- NS(id)


tabsetPanel(
     tabPanel(
       "Summary",
       plotOutput(ns("qc"))
     ),
     tabPanel(
       "Stats",
       tableOutput(ns("text2"))
     ),
    tabPanel("Sample Batches",
             DT::dataTableOutput(ns('tab'))
    ),
    tabPanel("Info",
              HTML('<iframe width="560" height="315" src="https://github.com/foocheung/batchingsamples/assets/25374694/45780282-9a05-4414-a96b-e7c238ceb073" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'),
              HTML('<br>
                    <p>A simple Shiny app to help allocate batches.
                      File format must be tab delimited and have column names, example can be seen below:

                      <PRE>
                      ID	SampleType	Race	AgeGrp
                      1	Case	Hispanic	(60,100]
                      2	Case	Hispanic	(60,100]
                      3	Case	European	(60,100]
                      4	Control	European	(50,60]
                      5	Control	European	(50,60]
                      </PRE>
                      <br>
                      <h4>How To</h4>
                      <p>Step1) Upload your tab delimited file
                      <p>Step2) Select the number of batches you are using from the slider "# of Batches:"
                      <p>Step3) press GO
                      <p>
                      A recommendation for practice is to put the variable of primary interest as the first of the list.
                      <p>
                      Output:
                      "Sample distribution by plates can also be visualized (Figure 1). It shows that samples with different
                      characteristics were distributed across batches with only small variations. The small variation is largely due
                      to the trade off in block randomizing multiple variables. The last plot is the index of optimization steps
                      versus value of the objective function. The blue diamond indicate the starting point, and the red diamond
                      mark the final optimal setup. It is clear that final setup is more optimal than the starting setup."
                      <br>
                      This app uses functions from the R package
                      <a href="http://bioconductor.org/packages/2.11/bioc/html/OSAT.html">OSAT</a>

                      </p>')
    )



)

#)

}




# Module Server

#' @rdname mod_table
#' @export
#' @keywords internal

mod_table_server <- function(input, output, session, file){  #,batches,sim){
  ns <- session$ns
 # output$metacontents <- renderTable({

 # output$text2 <- renderTable({
  sliderValues <- reactive({
req(file$goButton())
      dff<-file$df()
  
    sbj_per_batch<-ceiling(nrow(dff)/file$integer())

    myChip <- new("BeadChip", nRows=sbj_per_batch, nColumns=1, byrow=FALSE, comment="mock chip")
    myPlate<-new("BeadPlate", chip=myChip,nRows=1L, nColumns=1L)
    cn<-colnames(dff)
    cnum <- ncol(dff)
    gss <- OSAT::setup.sample(dff, optimal=c(optimal=cn[-1]) )

    gcc <- OSAT::setup.container(myPlate, file$integer(), batch="plates")
    gsetup <- OSAT::create.optimized.setup(sample=gss, container=gcc, nSim=file$sim())
    results<-as.matrix(capture.output(OSAT::QC(gsetup)))
    tab<-OSAT::get.experiment.setup(gsetup) %>% dplyr::select(0:cnum+1)
    tab<-dplyr::rename(tab,  Batch = plates)
    return(list("gsetup"=gsetup,"tab"=tab, "results"=results))
    #results
  })



output$text2 <- renderTable({
  res<-sliderValues()$results
  res
})


output$qc<-renderPlot({
    req(file$goButton())
  #req(input$go)
  #  outfile <- tempfile(fileext='.png')

    # Generate a png
  #  png(outfile, width=800, height=800)

    OSAT::QC(sliderValues()$gsetup)
    #dev.off()
  #  dev.list()
    # Return a list
  #  list(src = outfile)

})
    #,
#deleteFile = FALSE)




output$tab <- DT::renderDataTable(
  DT::datatable(
    sliderValues()$tab,
    extensions = 'Buttons', options = list(
      dom = 'Bfrtip', pageLength = 500,
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')

    )
  )
)



}
## To be copied in the UI
# mod_table_ui("table_1")

## To be copied in the server
# mod_table_server("table_1")
