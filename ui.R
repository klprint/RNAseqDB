#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RMySQL)
library(DBI)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("RNAseqDB"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput('serverIP', label='Server IP Address:'),
       passwordInput('passwd', label= 'Enter DB password:'),
       submitButton('Login')
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        
        tabPanel('Test',
          dataTableOutput('dbtest')
        ),
        
        
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
                 
                 tableOutput('inputFilePreview')
                 )
                
        #End tabsetPanel
        )
    #End Main Panel
    )
  )
))
