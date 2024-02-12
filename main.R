library(GGally)
library(corrplot)
library(MASS)
library(ggplot2)
source("/Users/39324/Desktop/progetto_Regressione_lineare_semplice/lib.R")
data = read.csv("tips.csv")
#------------------------ANALISI ESPLORATIVA--------------------------
#cosa c'è all'interno del dataset:
head(data)
str(data)
#analisi esplorativa:
data$sex = factor(data$sex, levels = c("Male", "Female"))
data$smoker = factor(data$smoker, levels = c("Yes", "No"))
data$day = factor(data$day, levels = c("Thur", "Fri", "Sat", "Sun"))
data$time = factor(data$time, levels = c("Lunch", "Dinner"))
ggpairs(data)

any(is.na(data))
k=(data$tip-mean(data$tip))/(sqrt(var(data$tip)))

shapiro.test(k)

plot(density(k))
lines(dnorm(0,1))
x <- seq(min(k), max(k), length.out = 1000)# Generazione di valori x per la densità normale
lines(x, dnorm(x, mean = 0, sd = 1), col = "blue", lwd = 2)

# Sovrapposizione della densità normale
# Istogramma della variabile "tip"
par(mfrow=c(2,3))
plot(density(data$tip), main = "Distribuzione della variabile 'tip'", xlab = "Tip",ylab="frequenza relativa", col = "blue", border = "black")
# Scatterplot tra "total_bill" e "tip"
plot(data$total_bill, data$tip, main = "Scatterplot tra 'total_bill' e 'tip'", xlab = "Total Bill", ylab = "Tip", col = "blue", pch=1)
# Boxplot per "sex" rispetto a "tip"
boxplot(tip ~ sex, data = data, main = "Boxplot di 'tip' per 'sex'", xlab = "Sex", ylab = "Tip", col = "blue")
# Boxplot per "day" rispetto a "tip"
boxplot(tip ~ day, data = data, main = "Boxplot di 'tip' per 'day'", xlab = "Day", ylab = "Tip", col = "lightgreen")
# Boxplot per "time" rispetto a "tip"
boxplot(tip ~ time, data = data, main = "Boxplot di 'tip' per 'time'", xlab = "Time", ylab = "Tip", col = "lightyellow")
#boxplot per "size" rispetto a "tip"
boxplot(tip ~ size, data = data, main = "Boxplot di 'tip' per 'size'", xlab = "size", ylab = "Tip", col = "lightyellow")
#boxplot per "size" rispetto a "smoker"
par(mfrow=c(1,1))
boxplot(tip ~ smoker, data = data, main = "Boxplot di 'tip' per 'smoker'", xlab = "smoker", ylab = "Tip", col = "lightyellow")

# matrice delle correlazioni:
cor_matrix_tip <- cor(data[, c("total_bill", "tip", "size")])
cor_matrix_tip
cor.test(data$tip,data$total_bill)

corrplot(cor_matrix_tip)
table(data$sex)
table(data$day)
table(data$smoker)
table(data$size)


#-------------------------ANALISI BIVARIATA-------

chisq.test(table(data$smoker,data$tip))# molto probabilmente indip
chisq.test(table(data$sex, data$tip))# molto probabilmente indip
chisq.test(table(data$size, data$tip)) #dipendendi
chisq.test(table(data$day, data$tip)) #indipendenti
chisq.test(table(data$total_bill,data$tip)) #dipendenti
chisq.test(table(data$time,data$tip)) #indipendenti

#uniche variabili sensate sono total_bill e size come mostrato anche di seguito

#analisi modello bivariato con total-bill

modello_naive=lm(tip~total_bill+smoker+sex+day+time+size,data=data)
modello_steppato=stepAIC(modello_naive)
modello2=lm(tip~total_bill*size,data=data)

AIC(modello_steppato)
AIC(modello2)
BIC(modello_steppato)
BIC(modello2)

formule=c(formula(tip~total_bill+size), formula(tip~total_bill*size))

errori  <- k_fold(data, 244, formule,norm=F)
errori

summary(modello2)
summary(modello_steppato)

par(mfrow=c(2,2))
plot(modello2)
plot(modello_steppato)



mod1=formula(tip~total_bill)
mod2=formula(tip~smoker)
mod3=formula(tip~total_bill*size)
formule=c(mod1,mod2,mod3)





a1=lm(tip~total_bill, data=data)
Y=a1[[1]][1]+a1[[1]][2]*data$total_bill
shapiro.test(Y)
plot(density(Y))
lines(dnorm(mean(Y),var(Y)))
x <- seq(min(k), max(k), length.out = 1000)# Generazione di valori x per la densità normale
lines(x, dnorm(x, mean = mean(Y), sd = var(Y)), col = "blue", lwd = 2)

#---------------------------ANALISI RESIDUI e CONFRONtO MODELLI



#-------------------------------------plott-----------------------------
#-----------------plot1
ggplot(data, aes(x = total_bill, y = tip, col=size)) +
  geom_point(alpha = 0.8, size=4) +  # Imposta la trasparenza dei pallini
  geom_smooth(method = "lm", se = TRUE, col = "red", level = 0.80) +
  labs(title = "Scatterplot con Retta di Regressione", 
       x = "Total Bill", 
       y = "Tip")
#---------------------,

data$size_category <- cut(data$size, breaks = c(0, 2, 3, 4, Inf), labels = c("1/2", "3", "4", "5+"))
#------------------plot2
ggplot(data, aes(x = total_bill, y = tip, size = size_category)) +
  geom_point(alpha = 0.5) +
  geom_smooth(aes(color = size_category), method = "lm", se = FALSE, size = 0.7) +  # Aggiunge la retta di regressione con intervallo di confidenza
  scale_color_manual(values = c("1/2" = "blue", "3" = "green", "4" = "orange", "5+" = "purple")) +  # Imposta i colori delle rette
  labs(title = "Scatterplot con Retta di Regressione", 
       x = "Total Bill", 
       y = "Tip") #si nota che la variabile size ha importanza nel modello
#--------------------.

#-----------------------------ANALISI IPOTESI DI LINEARITA-----
errore=k_fold(data,244)
errore

data_normalizzato_min_max=normalizzazione_min_max(data)
data_normalizzato_Z_score=normalizzazione_Z(data)
data_normalizzato_log=normalizzazione_log(data)

modnorm1=lm(tip~total_bill+size, data=data_normalizzato_min_max)
modnorm2=lm(tip~total_bill+size,data=data_normalizzato_Z_score)
modnorm3=lm(tip~total_bill+size,data=data_normalizzato_log)


AIC(modnorm1,modnorm2,modnorm3)
BIC(modnorm1,modnorm2,modnorm3)

summary(modnorm1)
summary(modnorm2)
summary(modnorm3)

plot(modnorm1)
plot(modnorm2)
plot(modnorm3)

formule=list()
testing=formula(tip~total_bill+size)
formule=c(formule,testing)

errore1=k_fold(data,244,formule,"min_max")
errore2=k_fold(data,244,formule,"Z_score")
errore3=k_fold(data,244,formule,"log")

errore1
errore2
errore3

