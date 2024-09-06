### IMPORT DATA ####
train <- read.csv("Passengers Satisfaction/train.csv")
View(head(train))
test <- read.csv("Passengers Satisfaction/test.csv")
View(head(test))

train <- train[,-c(1, 2)]
test <- test[,-c(1, 2)]

### TRASFORMAZIONE DEI DATI ####
install.packages("caret")
library(caret)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(rstatix)
library(gplots)
library(UpSetR)
library(naniar)

# Customer.Type
train$Customer.Type <- as.factor(train$Customer.Type)

test$Customer.Type <- as.factor(test$Customer.Type)

# Class
train$Class <- as.factor(train$Class)

test$Class <- as.factor(test$Class)

# Gender
train$Gender <- as.factor(train$Gender)

test$Gender <- as.factor(test$Gender)

# Type.of.Travel
train$Type.of.Travel <- as.factor(train$Type.of.Travel)

test$Type.of.Travel <- as.factor(test$Type.of.Travel)

# Satisfaction
train$satisfaction<-as.factor(train$satisfaction)

test$satisfaction<-as.factor(test$satisfaction)

#ordered variables
train$Inflight.wifi.service <- ordered(train$Inflight.wifi.service, levels = c(0, 1, 2, 3, 4, 5))
train$Departure.Arrival.time.convenient <- ordered(train$Departure.Arrival.time.convenient, levels = c(0, 1, 2, 3, 4, 5))
train$Ease.of.Online.booking <- ordered(train$Ease.of.Online.booking, levels = c(0, 1, 2, 3, 4, 5))
train$Gate.location <- ordered(train$Gate.location, levels = c(0, 1, 2, 3, 4, 5))
train$Food.and.drink <- ordered(train$Food.and.drink, levels = c(0, 1, 2, 3, 4, 5))
train$Online.boarding <- ordered(train$Online.boarding, levels = c(0, 1, 2, 3, 4, 5))
train$Seat.comfort <- ordered(train$Seat.comfort, levels = c(0, 1, 2, 3, 4, 5))
train$Inflight.entertainment <- ordered(train$Inflight.entertainment, levels = c(0, 1, 2, 3, 4, 5))
train$On.board.service <- ordered(train$On.board.service, levels = c(0, 1, 2, 3, 4, 5))
train$Leg.room.service <- ordered(train$Leg.room.service, levels = c(0, 1, 2, 3, 4, 5))
train$Baggage.handling <- ordered(train$Baggage.handling, levels = c(0, 1, 2, 3, 4, 5))
train$Checkin.service <- ordered(train$Checkin.service, levels = c(0, 1, 2, 3, 4, 5))
train$Inflight.service <- ordered(train$Inflight.service, levels = c(0, 1, 2, 3, 4, 5))
train$Cleanliness <- ordered(train$Cleanliness, levels = c(0, 1, 2, 3, 4, 5))

test$Inflight.wifi.service <- ordered(test$Inflight.wifi.service, levels = c(0, 1, 2, 3, 4, 5))
test$Departure.Arrival.time.convenient <- ordered(test$Departure.Arrival.time.convenient, levels = c(0, 1, 2, 3, 4, 5))
test$Ease.of.Online.booking <- ordered(test$Ease.of.Online.booking, levels = c(0, 1, 2, 3, 4, 5))
test$Gate.location <- ordered(test$Gate.location, levels = c(0, 1, 2, 3, 4, 5))
test$Food.and.drink <- ordered(test$Food.and.drink, levels = c(0, 1, 2, 3, 4, 5))
test$Online.boarding <- ordered(test$Online.boarding, levels = c(0, 1, 2, 3, 4, 5))
test$Seat.comfort <- ordered(test$Seat.comfort, levels = c(0, 1, 2, 3, 4, 5))
test$Inflight.entertainment <- ordered(test$Inflight.entertainment, levels = c(0, 1, 2, 3, 4, 5))
test$On.board.service <- ordered(test$On.board.service, levels = c(0, 1, 2, 3, 4, 5))
test$Leg.room.service <- ordered(test$Leg.room.service, levels = c(0, 1, 2, 3, 4, 5))
test$Baggage.handling <- ordered(test$Baggage.handling, levels = c(0, 1, 2, 3, 4, 5))
test$Checkin.service <- ordered(test$Checkin.service, levels = c(0, 1, 2, 3, 4, 5))
test$Inflight.service <- ordered(test$Inflight.service, levels = c(0, 1, 2, 3, 4, 5))
test$Cleanliness <- ordered(test$Cleanliness, levels = c(0, 1, 2, 3, 4, 5))

my_data <- union(train, test)

### ANALISI ESPLORATIVA #########
install.packages("GGally")

library(dplyr)
library(ggplot2)
library(ggpubr)
library(rstatix)
library(gplots)
library(UpSetR)
library(naniar)
library(GGally)

summary(my_data)

#Conteggio valori satisfaction
options(repr.plot.width = 14, repr.plot.height = 8)
ggplot(my_data, aes(x=`satisfaction`))+
    geom_bar(fill="cadetblue", alpha=0.6)+
    geom_text(aes(label=scales::percent((..count..)/sum(..count..))), stat="count", vjust = -0.8, size=3)+
    stat_count(aes(y=..count..,label=paste0("n=",..count..)),geom="text",vjust=1.2,size=5.8,color="gray35")+
    labs(x="Satisfaction", title = "Distribution of Customer Satisfaction")+
    theme(text = element_text(size=10))

# Ricerca dei valori N/A nel dataset e rimozione dei valori
gg_miss_var(my_data, show_pct = TRUE)
miss_var_summary(my_data)

train <- na.exclude(train)
test <- na.exclude(test)

my_data <- union(train, test)
levels(my_data$satisfaction) <- c("neutral.or.dissatisfied","satisfied")


# Matrice di correlazione sulle variabili numeriche
library(corrplot)

my_data_corr_df <- my_data[, c(3, 6, 21, 22)]
my_data_cor1 <- cor(subset(my_data_corr_df))
my_data_cor1
options(repr.plot.width = 20, repr.plot.height = 20)
corrplot(my_data_cor1, method="color", type = "lower", 
         cl.ratio = 0.1 , tl.srt = 45,
         tl.col = "black", tl.cex = 0.5)

ggpairs(my_data_corr_df)

#Gender
tmp <- count(my_data, my_data$Gender, my_data$satisfaction)
names(tmp) <- c("Gender", "satisfaction", "freq")

gender.plot <- ggplot(tmp, aes(y=freq, x=Gender, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Age
age.boxplot <- ggboxplot(my_data, x = "satisfaction", y = "Age",
          color = "satisfaction",
          palette = c("#00AFBB", "#E7B800", "#FC4E07"))

#Customer.Type
tmp <- count(my_data, my_data$Customer.Type, my_data$satisfaction)
names(tmp) <- c("Customer.Type", "satisfaction", "freq")

customerTyoe.plot <- ggplot(tmp, aes(y=freq, x=Customer.Type, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Type.of.Travel
tmp <- count(my_data, my_data$Type.of.Travel, my_data$satisfaction)
names(tmp) <- c("Type.of.Travel", "satisfaction", "freq")

typeOfTravel.plot <- ggplot(tmp, aes(y=freq, x=Type.of.Travel, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Class
tmp <- count(my_data, my_data$Class, my_data$satisfaction)
names(tmp) <- c("Class", "satisfaction", "freq")

class.plot <- ggplot(tmp, aes(y=freq, x=Class, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Flight.Distance
flightDistance.plot <- ggboxplot(my_data, x = "satisfaction", y = "Flight.Distance",
          color = "satisfaction",
          palette = c("#00AFBB", "#E7B800", "#FC4E07"))

#Inflight.wifi.service
tmp <- count(my_data, my_data$Inflight.wifi.service, my_data$satisfaction)
names(tmp) <- c("Inflight.wifi.service", "satisfaction", "freq")

inflightWifiService.plot <- ggplot(tmp, aes(y=freq, x=Inflight.wifi.service, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Departure.Arrival.time.convenient
tmp <- count(my_data, my_data$Departure.Arrival.time.convenient, my_data$satisfaction)
names(tmp) <- c("Departure.Arrival.time.convenient", "satisfaction", "freq")

departureArrivalTimeConveninet.plot <- ggplot(tmp, 
       aes(y=freq, x=Departure.Arrival.time.convenient, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Ease.of.Online.booking
tmp <- count(my_data, my_data$Ease.of.Online.booking, my_data$satisfaction)
names(tmp) <- c("Ease.of.Online.booking", "satisfaction", "freq")

easyOfOnlineBooking.plot <- ggplot(tmp, aes(y=freq, x=Ease.of.Online.booking, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Gate.location
tmp <- count(my_data, my_data$Gate.location, my_data$satisfaction)
names(tmp) <- c("Gate.location", "satisfaction", "freq")

gateLocation.plot <- ggplot(tmp, aes(y=freq, x=Gate.location, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Food.and.drink
tmp <- count(my_data, my_data$Food.and.drink, my_data$satisfaction)
names(tmp) <- c("Food.and.drink", "satisfaction", "freq")

foodAndDrink.plot <- ggplot(tmp, aes(y=freq, x=Food.and.drink, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Online.boarding
tmp <- count(my_data, my_data$Online.boarding, my_data$satisfaction)
names(tmp) <- c("Online.boarding", "satisfaction", "freq")

onlineBoarding.plot <- ggplot(tmp, aes(y=freq, x=Online.boarding, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Seat.comfort
tmp <- count(my_data, my_data$Seat.comfort, my_data$satisfaction)
names(tmp) <- c("Seat.comfort", "satisfaction", "freq")

seatComfort.plot <- ggplot(tmp, aes(y=freq, x=Seat.comfort, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Inflight.entertainment
tmp <- count(my_data, my_data$Inflight.entertainment, my_data$satisfaction)
names(tmp) <- c("Inflight.entertainment", "satisfaction", "freq")

inflightEntertainment.plot <- ggplot(tmp, aes(y=freq, x=Inflight.entertainment, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#On.board.service
tmp <- count(my_data, my_data$On.board.service, my_data$satisfaction)
names(tmp) <- c("On.board.service", "satisfaction", "freq")

onBoardService.plot <- ggplot(tmp, aes(y=freq, x=On.board.service, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Leg.room.service
tmp <- count(my_data, my_data$Leg.room.service, my_data$satisfaction)
names(tmp) <- c("Leg.room.service", "satisfaction", "freq")

legRoomService.plot <- ggplot(tmp, 
       aes(y=freq, x=Leg.room.service, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Baggage.handling
tmp <- count(my_data, my_data$Baggage.handling, my_data$satisfaction)
names(tmp) <- c("Baggage.handling", "satisfaction", "freq")

baggageHandling.plot <- ggplot(tmp, aes(y=freq, x=Baggage.handling, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Checkin.service
tmp <- count(my_data, my_data$Checkin.service, my_data$satisfaction)
names(tmp) <- c("Checkin.service", "satisfaction", "freq")

checkingService.plot <- ggplot(tmp, aes(y=freq, x=Checkin.service, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Inflight.service
tmp <- count(my_data, my_data$Inflight.service, my_data$satisfaction)
names(tmp) <- c("Inflight.service", "satisfaction", "freq")

inflightService.plot <- ggplot(tmp, aes(y=freq, x=Inflight.service, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#Cleanliness
tmp <- count(my_data, my_data$Cleanliness, my_data$satisfaction)
names(tmp) <- c("Cleanliness", "satisfaction", "freq")

clearness.plot <- ggplot(tmp, aes(y=freq, x=Cleanliness, fill = satisfaction)) +
    geom_bar(stat="identity", color="black", position = position_dodge()) +
    scale_fill_manual(values=c("#999999", "#E69F00")) +
    theme_minimal()

#analizzo la proporzioni di passeggeri soddisfatti e non rispetto al ritardo
departureDelayInMinutes.plot <- ggstripchart(my_data, x = "satisfaction", y = "Departure.Delay.in.Minutes",
             color = "satisfaction",
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             add = "mean_sd")

arrivalDelayInMinutes.plot <- ggstripchart(my_data, x = "satisfaction", y = "Arrival.Delay.in.Minutes",
             color = "satisfaction",
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             add = "mean_sd")

#raggruppamento grafici variabili ordinali
figure1.plot <- ggarrange(inflightWifiService.plot, departureArrivalTimeConveninet.plot,
                          easyOfOnlineBooking.plot,gateLocation.plot, foodAndDrink.plot, 
                          onlineBoarding.plot, seatComfort.plot, inflightEntertainment.plot, 
                     labels = c("Inflight Wifi Service","Departure Arrival Time Convenient", 
                                "Easy Online Booking", "Gate Location", "Food and Drink", "Online Boarding", 
                                "Seat Comfort", "Inflight Entertainment"),
                     ncol = 4, nrow = 2)
figure1.plot

figure2.plot <- ggarrange( onBoardService.plot,legRoomService.plot, baggageHandling.plot, 
                           checkingService.plot, inflightService.plot, clearness.plot,
                     labels = c("On Board Service", "Leg Room Service", "Baggage Handling",
                                "Checking Service", "Inflight Service", "Clearness"),
                     ncol = 4, nrow = 2)
figure2.plot

#raggruppamento grafici variabili numeriche
figure3 <- ggarrange(age.boxplot, flightDistance.plot, 
                     arrivalDelayInMinutes.plot, departureDelayInMinutes.plot,
                     labels = c("Age", "Flight Distance", "Arrival Delay in Minutes", 
                                "Departure Delay in Minutes"),
                     ncol = 2, nrow = 2)
figure3

#raggruppamento grafici variabili categoriche
figure4 <- ggarrange(gender.plot, customerTyoe.plot, typeOfTravel.plot, class.plot, 
                     labels = c("Gender", "Customer Type", "Type of Travel", 
                                "Class"),
                     ncol = 2, nrow = 2)
figure4

### PCA ####

#eseguo la PCA sulle mie variabili numeriche per avere un analisi approfondita
#non é possibile applicarla sulle varibaili categoriche
install.packages(c("FactoMineR", "factoextra"))
library(factoextra)
library(FactoMineR)

my_data.pca <- my_data[,c(3,6,21,22)]
pca <- PCA(my_data.pca, scale.unit = TRUE)

pca_result <- get_pca_var(pca)

eig.val<-get_eigenvalue(pca)
eig.val

fviz_eig(pca, addlabels = TRUE)

#cos2
corrplot(pca_result$cos2, is.corr=FALSE)

fviz_pca_var(pca,
             col.var = "cos2", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

#contrib
corrplot(pca_result$contrib, is.corr=FALSE)

fviz_pca_var(pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

### ALGORITMI ###################

#usefull functions
macro_average <- function(fun1, fun2, number_of_class) {
    result <- (fun1 + fun2)/number_of_class
}

#normalizzazione variabili continue
my_data.normalize <- my_data[, -c(1, 3, 22)]
numeric_vars <- my_data.normalize[, sapply(my_data.normalize, is.integer)]
normalized_data <- scale(numeric_vars)
my_data.normalize <- cbind(normalized_data, my_data.normalize[, !sapply(my_data.normalize, is.numeric)])

#division in training and test set
ind = sample(2, nrow(my_data.normalize), replace = TRUE, prob = c(0.7,0.30))
train <- my_data.normalize[ind == 1, ]
test <- my_data.normalize[ind == 2, ]

### NAIVE BAYES ####
library(e1071)

nb.model = naiveBayes(satisfaction ~., data=train) 

#testing model
nb.pred = predict(nb.model, test[,! names(test) %in% c("satisfaction")], type = "class")

#confusion matrix satisfied
nb.result = confusionMatrix(nb.pred, test[,c("satisfaction")], positive = "satisfied", mode = "prec_recall")
nb.result
#confusion matrix dissatisfied
nb.result2 = confusionMatrix(nb.pred, test[,c("satisfaction")], positive = "neutral.or.dissatisfied", mode = "prec_recall")
nb.result2

#global evaluetion measure for classification
nb.global.accuracy <- nb.result$overall[1]
nb.global.precision <- macro_average(nb.result$byClass[5], nb.result2$byClass[5], 2)
nb.global.recall <- macro_average(nb.result$byClass[6], nb.result2$byClass[6], 2)
nb.global.fmeasure <- macro_average(nb.result$byClass[7], nb.result2$byClass[7], 2)

library(cvms)
plot_confusion_matrix(as.data.frame(nb.result$table), 
                      target_col = "Reference", 
                      prediction_col = "Prediction",
                      counts_col = "Freq")

nb.pred = predict(nb.model, test[,! names(test) %in% c("satisfaction")], type = "raw")

library(pROC)

nb.roc <- roc(test$satisfaction, nb.pred[, "satisfied"])
nb.roc$auc

plot(nb.roc, col = "red", main = "ROC Curve Naive Bayes")


### DECISION TREE ####
library(rpart)

rpart.model = rpart(satisfaction ~ ., data=train, method="class", cp = 0.00001)

rpart.pred = predict(rpart.model, test, type = "class")

#confusion matrix satisfied
rpart.result = confusionMatrix(rpart.pred, test[,c("satisfaction")], positive = "satisfied", mode = "prec_recall")
rpart.result
#confusion matrix dissatisfied
rpart.result2 = confusionMatrix(rpart.pred, test[,c("satisfaction")], positive = "neutral.or.dissatisfied", mode = "prec_recall")
rpart.result2

#parametro di complessitá
printcp(rpart.model)

plotcp(rpart.model)

rpart.model = prune(rpart.model, cp = 0.00016)

printcp(rpart.model)

rpart.pred = predict(rpart.model, test, type = "class")

#confusion matrix satisfied
rpart.result = confusionMatrix(rpart.pred, test[,c("satisfaction")], positive = "satisfied", mode = "prec_recall")
rpart.result
#confusion matrix dissatisfied
rpart.result2 = confusionMatrix(rpart.pred, test[,c("satisfaction")], positive = "neutral.or.dissatisfied", mode = "prec_recall")
rpart.result2

rpart.global.accuracy <- rpart.result$overall[1]
rpart.global.precision <- macro_average(rpart.result$byClass[5], rpart.result2$byClass[5], 2)
rpart.global.recall <- macro_average(rpart.result$byClass[6], rpart.result2$byClass[6], 2)
rpart.global.fmeasure <- macro_average(rpart.result$byClass[7], rpart.result2$byClass[7], 2)

plot_confusion_matrix(as.data.frame(rpart.result$table), 
                      target_col = "Reference", 
                      prediction_col = "Prediction",
                      counts_col = "Freq")

rpart.pred = predict(rpart.model, test, type = "prob")

rpart.roc <- roc(test$satisfaction, rpart.pred[, 1])
rpart.roc$auc

plot(rpart.roc, col = "blue", main = "ROC Curve Decision Tree")



plot(nb.roc, col = "red", main = "ROC Curves")
lines(rpart.roc, col = "blue")
legend("bottomright", legend = c("Decision Tree", "Naive Bayes"), col = c("blue", "red"), lty = 1)
