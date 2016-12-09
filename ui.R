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
       actionButton('login', 'Login'),
       textOutput('loginSuc')
       
    ),
    
    #### MAIN panel ####
    mainPanel(
      tabsetPanel(
        
        #### Unique Genes List ####
        tabPanel('Unique Genes',
          dataTableOutput('dbtest')
        ),
        
        #### Input table ####
        tabPanel('New Data',
                 textInput('inputFileTitle', 'Title (no spaces, one word)'),
                 
                 radioButtons('inputFileExperimentType', 'Type of experiment:',
                              choices = c(RNAseq = 'rnaseq',
                                          RIPseq = 'ripseq')),
                 
                 h3('Description:'),
                 tags$textarea(id = 'inputFileDesc', rows=20, cols=70, 'Description:\n\n\nExperimentalist:\n\n\nNotes:\n'),
                 
                 br(''),
                 
                 textInput('inputFilecolIDs', 'Column data sets', placeholder = 'RIPseq: elu,elu,ft,ft / RNAseq: a,a,b,b,...'),
                 
                 fileInput('inputFile', 'Choose Read-Count File',
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),
                 
                 tableOutput('inputFilePreview'),
                 
                 br(''),
                 actionButton(inputId = 'inputFileUpload', label = 'Upload'),
                 br(''),
                 textOutput('inputFileUploadSucc')
                 )
                
        #End tabsetPanel
        )
    #End Main Panel
    )
  )
))
