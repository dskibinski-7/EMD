library(shiny)
shinyUI(fluidPage(
        titlePanel("Szanse przeżycia na Titanicu"),
        sidebarLayout(
            sidebarPanel(
              img(src="/titanic.jpg", height=200, width=250)),
            mainPanel(
                h3('Uzupełnij dane:'),
                textInput("name", "Imię:"),
                textInput("surname", "Nazwisko:"),
                selectInput("sex", "Płeć", c("Mężczyzna", "Kobieta")),
                numericInput("age", "Wiek", value = 20, min = 0, max = 100),
                numericInput("class", "Klasa", value = 1, min = 1, max = 3),
                h3("Przeżyłbyś?"),
                textOutput("Prediction"),
                plotOutput("Prediction_plot")
            )
        )
))
