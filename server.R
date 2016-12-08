#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
########################################################################################
# ----------------------------- FUNCTIONS -----------------------------------
########################################################################################

quickmerge <- function(x, y){
  df            <- merge(x, y, by= "row.names", all.x= F, all.y= F)
  rownames(df)  <- df$Row.names
  df$Row.names  <- NULL
  return(df)
}

quickmerge.multi <- function(...){
  dfs <- list(...)
  merged.df <- Reduce(quickmerge, dfs)
  return(merged.df)
}

quick.read = function(path){
  con <- file(path, "rb")
  rawContent <- readLines(con, warn = F) # empty
  close(con)  # close the connection to the file, to keep things tidy
  
  
  expectedColumns <- length(gregexpr('\t', rawContent[1])[[1]])
  delim <- "\t"
  
  indxToOffenders <-
    sapply(rawContent, function(x)   # for each line in rawContent
      length(gregexpr(delim, x)[[1]]) != expectedColumns   # count the number of delims and compare that number to expectedColumns
    ) 
  
  df = read.table(text = rawContent[!indxToOffenders], sep = delim, header=T)
  
  df = df[!duplicated(df[,1]), ]
  
  print(paste('Removed lines: ',length(rawContent)-(nrow(df)+1)))
  
  df = data.frame(row.names = df[,1],
                  df[,2:ncol(df)]
  )
  
  #print(head(df))
  #print(nrow(df))
  return(df)
}



########################################################################################
# ------------------------------------ Server -----------------------------------
########################################################################################
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  print('Hello')
  new.uploaded <- F
  # db.con <- reactive({con =  dbConnect(MySQL(), host = input$serverIP, user = 'root', password = input$passwd, dbname = 'RIPseq')})

  #### Login Button ####
  is.logged.in <- eventReactive(input$login, {
    if(input$serverIP == ''){
      return('')
    }else{
      return('logged.in')
    }
  })
  
  #### Show U.List ####
  output$dbtest <- renderDataTable({
    if(is.logged.in() == 'logged.in'){
      con =  dbConnect(MySQL(), 
                       host = input$serverIP,
                       port = 3306,
                       user = 'RNAseqDBUser', 
                       password = input$passwd, 
                       dbname = 'RIPseq')
      
      out.df <- dbGetQuery(con, 'SELECT * FROM UList;')
      dbDisconnect(con)
      mes <- paste('Number of fetched rows: ', nrow(out.df), sep='')
      print(mes)
      return(out.df)
    }
  })
  
  
  data <- reactive({
    inFile <- input$inputFile
    if(is.null(inFile)){return(NULL)
      }else{
        data <- quick.read(inFile$datapath)
        
        return(data)
      }
  })
  
  output$inputFilePreview <- renderTable({
    df <- data()
    print(head(df))
    return(head(df))
  })
  

  #### Upload new file ####
  observeEvent(input$inputFileUpload, {
    

    con =  dbConnect(MySQL(),  # Connect to the database
                      host = input$serverIP,
                      port = 3306,
                      user = 'RNAseqDBUser',
                      password = input$passwd,
                      dbname = 'RIPseq')

    df <- data()
    
    table.name <- input$inputFileTitle
    
    for(not.allowed.char in c('\\.', ' ', '-')){  # Removes characters and replaces them with a '_'
      table.name <- gsub(not.allowed.char, '_', table.name)
    }

    dbWriteTable(conn = con, name = table.name, value = df)
    
    db.querryList <- paste('(','\'',table.name,'\'',',','\'',input$inputFileDesc,'\'',',','\'',input$inputFileExperimentType,'\'',')', sep = '' )
    dbSendQuery(con, paste('INSERT INTO ExpDescr (Experiment, Description, ExpKind) VALUES',
                           db.querryList, sep = ' '))
    
    dbDisconnect(con)
    new.uploaded <- T

  })
  
  output$inputFileUploadSucc <- renderText({
    if(new.uploaded){
      return('Data Uploaded')
    }else{
      return('')
    }
  })
  
# End server.R
})
