library(shiny)
library(RMySQL)
library(DBI)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("RNAseqDB"),
  
  #### Sidebar ####
  sidebarLayout(
    sidebarPanel(
       textInput('serverIP', label='Server IP Address:'),
       passwordInput('passwd', label= 'Enter DB password:'),
       submitButton('Login')
       
    ),
    
    #### MAIN panel ####
    mainPanel(
      tabsetPanel(
        
        tabPanel('Test',
          dataTableOutput('dbtest')
        ),
        
        #### Input table ####
        tabPanel('New Data',
                 #tags$textarea(id="foo", rows=3, cols=40, "Default value"),
                 textInput('inputFileTitle', 'Title (no spaces, one word)'),
                 
                 radioButtons('inputFileExperimentType', 'Type of experiment:',
                              choices = c(RNAseq = 'rnaseq',
                                          RIPseq = 'ripseq')),
                 
                 p('Description:'),
                 tags$textarea(id = 'inputFileDesc', rows=10, cols=40),
                 
                 br(''),
                 
                 fileInput('inputFile', 'Choose Read-Count File',
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),
                 br(''),
                 actionButton(inputId = 'inputFileUpload', label = 'Upload'),
                 
                 tableOutput('inputFilePreview')
                 )
                
        #End tabsetPanel
        )
    #End Main Panel
    )
  )
))
