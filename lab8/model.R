library(tidyr)
library(caret)
library(fastDummies)
library(dplyr)
#drzewo do predykcji przezycia
#cena moze byc po prosut mediana cen

df <- read.csv("/home/dawcio/EMD_laby/aplkacje_dla_uzytkownikkow/titanic.csv")
df$Survived = as.factor(df$Survived)
#nrow(data)
#is.na(data)
#print(head(data))
df <- drop_na(df)
#nrow(data)
#head(data)

#convert categorical data
df <- dummy_cols(df, 
                 select_columns = c("Sex"),
                 remove_selected_columns = TRUE
                 )

#remove probably redundant data
df <- select(df, -c(PassengerId,Name,Ticket, Cabin))
#remove data that are not in form:
df <- select(df, -c(Embarked, SibSp, Parch))

#podzial danych
set.seed(100)
inTraining <- createDataPartition(
  y = df$Survived,
  p = .75,
  list = FALSE)

training <- df[inTraining,]
testing <- df[-inTraining,]

#Random Forest:
ctrl <- trainControl(
  method = "repeatedcv",
  number = 2,
  repeats = 5
)
# 
# fit <- train(x=training[,2:12], y = training$Survived,
#              method = "rf",
#              trControl = ctrl,
#              ntree = 10)
# 
# rfClasses <- predict(fit, newdata = testing)
# confusionMatrix(data=rfClasses, testing$Survived)

#lr
fit <- train(x=training[,2:6], y = training$Survived,
             method = "LogitBoost",
             trControl = ctrl,
             nIter = 20)

rfClasses <- predict(fit, newdata = testing)
confusionMatrix(data=rfClasses, testing$Survived)

#saveRDS(fit, "./model.rds")
save(fit, file="model.Rdata")

ticket_price <- df %>%
  group_by(Pclass) %>%
  summarise(median(Fare)) 

write.csv(ticket_price[,2], file="ticket_price.csv")
