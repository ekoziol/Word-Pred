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
    tags$textarea(id="userText", rows=10, cols=2000, ""),
    tags$textarea(id="topSelection", rows=10, cols=2000, "")
  )
))