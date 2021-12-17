#image doesn't work
library(shiny)
shinyServer(
  function(input,output){
    vals <- reactiveValues(counter = c(1))
    preds <- reactiveValues(pred = c(0))
    my_model <- readRDS("model.rds")
    column.names <- c("Pclass", "Age", "Fare", "Sex_female", "Sex_male")
    row.names <- 1
    
    output$Prediction <- renderText({
      ticket_price_data <- read.csv("ticket_price.csv")
      class = input$class
      paste("Mediana ceny dla podanej klasy: ",round(ticket_price_data[class,2],2))
    })
    
    # output$Prediction <- renderText({
    #   #predict(fit, array(c(3,22,7.25,0,1)))
    #   sex <- input$sex
    #   if (sex == "Mężczyzna"){
    #     female = 0
    #     male = 1
    #   }
    #   else {
    #     female = 1
    #     male = 0
    #   }
    #   user_data <-array(c(input$class, input$age, 7.25, female, male),dim=c(1,5), dimnames = list(row.names, column.names))
    #   model_prediction = predict(my_model, user_data, type="prob")
    #   # if (model_prediction == 1){
    #   #   answer = 'Tak'
    #   # }
    #   # else {
    #   #   answer = 'Nie'
    #   # }
    #   #vals$counter <- append(isolate(vals$counter), tail(isolate(vals$counter),n=1)+1)
    #   #preds$pred <- append(isolate(preds$pred), model_prediction[2]*100)
    #   
    #   paste("Predykcja modelu: ",round(model_prediction[2],2)*100, "%")
    #   #paste(preds$pred)
    #   
    # })
    output$Prediction_plot <- renderPlot({
      ticket_price_data <- read.csv("ticket_price.csv")
      sex <- input$sex
      if (sex == "Mężczyzna"){
        female = 0
        male = 1
      }
      else {
        female = 1
        male = 0
      }
      user_data <-array(c(input$class, input$age, ticket_price_data[input$class,2], female, male),dim=c(1,5), dimnames = list(row.names, column.names))
      model_prediction = predict(my_model, user_data, type="prob")
      
      #vals$counter <- isolate(vals$counter) + 1
      #przerobiony na liste
      vals$counter <- append(isolate(vals$counter), tail(isolate(vals$counter),n=1)+1)
      preds$pred <- append(isolate(preds$pred), model_prediction[2]*100)
      plot(vals$counter, preds$pred, type='l', ylab = "Szanse przeżycia [%]", xlab = "")
    })
    
    
  })