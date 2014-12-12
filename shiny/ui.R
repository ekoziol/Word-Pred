library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Next Word Text Prediction"),
  
  sidebarPanel(
    p('The purpose of this app is to predict the next word after a given amount of text.  
      A predicted word will be provided after typing along with other possible words and their
      respective probabilities')

    
    
  ),
  mainPanel(
    h3('Begin Typing in the Box Below'),
    textInput("userText", "",""),
    textOutput("firstWord"),
    textOutput("secondWord"),
    textOutput("thirdWord"),
    textOutput("otherWords")
  )
))