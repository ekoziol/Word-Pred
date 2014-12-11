library(shiny)
source("KoziolPredict.R")

shinyServer(
  function(input,output){
    userText <- as.char(reactive(input$userText))
    output$topSelection <- predictThis(userText)
  }
)