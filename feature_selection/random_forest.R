
#install.packages("randomForest")
#install.packages("dplyr")
library(randomForest)
library(dplyr)

data <- read.csv("/Users/gokulp2/Desktop/geneSelection-main/TCGAdata/filtered_training_set.csv")

print(unique(data$project_id))

data$project_id <- factor(data$project_id)

print(unique(data$project_id))
print(nlevels(data$project_id))

if (nlevels(data$project_id) >= 2) {
  features <- data[,2:(ncol(data)-1)]
  project_id <- data$project_id
    rf_model <- randomForest(features, project_id, ntree=100, importance=TRUE)
  importance_scores <- importance(rf_model)[,"MeanDecreaseGini"]
    feature_names <- colnames(features)
  
  if (length(feature_names) == length(importance_scores)) {
    feature_importance <- data.frame(Feature = feature_names, Importance = importance_scores)
    
    ordered_features <- feature_importance %>% arrange(desc(Importance))
    
    top_features <- head(ordered_features, 50)
    
    print(top_features)
  } 
  else {
    stop("Mismatch in number of features and importance scores.")
  }
} 
else {
  stop("Not enough classes in the target variable for classification.")
}


