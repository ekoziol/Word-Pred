library(shiny)
source("KoziolPredict.R")

shinyServer(
  function(input,output){
#     userText <- reactive({input$userText})
#     writtenText <- as.character(substitute(userText))
#    output$topSelection <- userText
#     if(substr(userText,length(userText)-1, length(userText)) == " "){
#     
      predictedWords <- reactive({predictThis(input$userText)})
    
      output$firstWord <- renderText({
          predictedWords()[1]
      })
      output$secondWord <- renderText({
        predictedWords()[2]
      })
      output$thirdWord <- renderText({
        predictedWords()[3]
      })
      output$otherWords <- renderText({
        predictedWords()[4:10]
      })
#     }
  }
)