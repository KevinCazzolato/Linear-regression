#libreria
k_fold <- function(set, k, modelli, norm) {
  errori_complessivi = vector("list", length(modelli)) #lista di liste
  fold_size= nrow(set) %/% k #parte inf del modulo
  
  for (i in 1:k) {
    # Seleziona i dati di test e di addestramento
    test_indices = ((i - 1) * fold_size + 1):(i * fold_size)
    test_data = set[test_indices, ]
    training_data = set[-test_indices, ]
    
    if(norm=="min_max"){
      training_data = normalizzazione_min_max(training_data)
      test_data = normalizzazione_min_max_test(training_data,test_data)
    }
    if(norm=="Z_score"){
      training_data=normalizzazione_Z(training_data)
      test_data=normalizzazione_Z_test(training_data,test_data)
    }
    if(norm=="log"){
      training_data=normalizzazione_log(training_data)
      test_data=normalizzazione_log(test_data)
    }
    
    for (j in seq_along(modelli)) {
      mod = training(modelli[[j]], training_data)
      prediction = predict(mod, newdata = test_data)
      errore_parziale = abs(test_data$tip - prediction)
      errori_complessivi[[j]] = c(errori_complessivi[[j]], errore_parziale)
    }
  }
  
  # Calcola le medie degli errori per ogni modello
  medie = sapply(errori_complessivi, mean)
  
  return(medie)
}


training <- function(f,dataset){
  return(lm(f,data=dataset))
}




normalizzazione_log<- function(dat){
  data_normalized=dat
  
  data_normalized$total_bill=log(dat$total_bill)
  data_normalized$tip=log(dat$tip)
  data_normalized$size=log(dat$size)
  
  return (data_normalized)
}


normalizzazione_Z<-function(dat){
  data_normalized=dat
  
  data_normalized$total_bill=(dat$total_bill - mean(dat$total_bill)) / (sqrt(var(dat$total_bill)))
  data_normalized$tip=(dat$tip-mean(dat$tip))/(sqrt(var(dat$tip)))
  data_normalized$size=(dat$size-mean(dat$size))/(sqrt(var(dat$size)))
  
  return (data_normalized)
}

normalizzazione_Z_test <- function(training, test) {
  data_normalized = test
  
  mean_total_bill = mean(c(training$total_bill, test$total_bill))
  sd_total_bill = sd(c(training$total_bill, test$total_bill))
  
  mean_tip = mean(c(training$tip, test$tip))
  sd_tip = sd(c(training$tip, test$tip))
  
  mean_size = mean(c(training$size, test$size))
  sd_size = sd(c(training$size, test$size))
  
  data_normalized$total_bill = (test$total_bill - mean_total_bill) / sd_total_bill
  data_normalized$tip = (test$tip - mean_tip) / sd_tip
  data_normalized$size = (test$size - mean_size) / sd_size
  
  return(data_normalized)
}


normalizzazione_min_max<-function(dat){
  data_normalized=dat
  
  data_normalized$total_bill= (dat$total_bill-min(dat$total_bill))/(max(dat$total_bill)-min(dat$total_bill))
  data_normalized$tip=(dat$tip-min(dat$tip))/(max(dat$tip)-min(dat$tip))
  data_normalized$size=(dat$size-min(dat$size))/(max(dat$size)-min(dat$size))
  
  return (data_normalized)
}

normalizzazione_min_max_test <- function(training, test) {
  data_normalized = test
  
  min_total_bill = min(min(training$total_bill), min(test$total_bill))
  max_total_bill = max(max(training$total_bill), max(test$total_bill))
  min_tip = min(min(training$tip), min(test$tip))
  max_tip = max(max(training$tip), max(test$tip))
  min_size = min(min(training$size), min(test$size))
  max_size = max(max(training$size), max(test$size))
  
  data_normalized$total_bill = (test$total_bill - min_total_bill) / (max_total_bill - min_total_bill)
  data_normalized$tip = (test$tip - min_tip) / (max_tip - min_tip)
  data_normalized$size = (test$size - min_size) / (max_size - min_size)
  
  return(data_normalized)
}










