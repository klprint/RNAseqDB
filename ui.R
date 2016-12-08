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
       passwordInput('passwd', label= 'Enter DB password:'),
       submitButton('Login')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
     dataTableOutput('testContent')
    )
  )
))
