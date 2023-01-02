app_server <- function(input, output, session) {
  # List the first level callModules here

  metafile <- mod_dataInput_server("dataInput_ui_meta")

  callModule(mod_table_server, "table_ui_1", metafile)

  #genefile <- mod_dataInput_server("dataInput_ui_gene")

  #callModule(mod_table_server, "table_ui_2", genefile,10, 2)

}
