library(shiny)
library(shinydashboard)
library(ggplot2)

dashboardPage(
  dashboardHeader(title = "Word Prediction"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Application", tabName = "app", icon = icon("circle-o")),
      menuItem("About", icon = icon("info-circle"), tabName = "about")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "app",
              h2("Word Prediction with N-grams: A Data Science Capstone Project"),
              p(paste("Type a phrase into the text field below to use this application. For app details and further ",
                "instructions, please select the 'About' option from the tab menu on the left side of this page.")),
              textInput("sentence", "Input Sentence", "Example phrase for this"),
              h4("Top Suggestion for Next Word:"),
              textOutput("suggested"),
              h2("Detail View"),
              h4("Top Five Suggestions for Next Word:"),
              textOutput("suggested2"),
              checkboxInput("details", "Increase number of entries in detail view (Note: this will slow response time)", FALSE),
              plotOutput("plot"),
              h3("Top 5 results (top 10 if increased entries selected)"),
              tableOutput("table")
      ),
      
      tabItem(tabName = "about",
              h2("Project Details"),
              p("Created by: Eric Henderson"),
              p("Created on: August 25th 2017"),
              p("Project Source at: https://Eric-Henderson-127.github.io/DataScienceCapstone"),
              p("Project Design Document at: https://github.com/Eric-Henderson-127/ShinyAppAndPitch"),
              p("Project Presentation at: http://rpubs.com/erichenderson127/303960"),
              h4("App Purpose"),
              p(paste("This app was developed as a final project for the Data Science Specialization Cap Stone. ",
                      "The app uses word prediction, via n-grams, to make suggestions for the next word to use while ",
                      "typing a phrase. A large amount of text data, compiled from blogs, news, and twitter, was used ",
                      "to construct n-grams or various length. N-grams, as used in this project, are sequences of ",
                      "words found in the source text along with the frequency of that sequence occurring in the source ",
                      "text. Prediction tables were created out of these n-grams, where the user's phrase is compared ",
                      "against sequences of words in the prediction table. When a trailing portion of the user's phrase ",
                      "matches a sequence then the next word for that sequence is suggested to the user. The order of ",
                      "suggested words is first ordered by the length of the matched sequence and then by the frequency ",
                      " of that sequence. The top match, and the top five matches, are then suggested to the user. For demonstration ",
                      "purposes, the app also shows some more detailed information about the matches that occur. The ",
                      "number of matches for each size n-gram and the top rows of the prediction table are shown to ",
                      "convey this extra information about the prediction process.")),
              h4("How to use"),
              p(paste("A user phrase may be typed into the 'Input Text' text field. Example phrase 'Example phrase for this' appears ",
                      " in the text field by default. The top suggestions, as well as the top five suggestions, will appear below ",
                      "the text input field. Additionally, data about the number of matched n-grams and top rows of the prediction ",
                      "table are presented. To increase the number of n-grams matched and the number of rows shown, simply check the ",
                      "check box marked 'Increase number of entries in detail view'. To navigate back to the app panel from this panel ",
                      "click on the 'Application' option in the tab bar on the left side of the page. If the tab bar has been hidden ",
                      "you may reveal it by clicking the 3-bar icon to the right of the 'Word Prediction' title at the top of the page."))
      )
    )
  )
)
