
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
    top_feature_names <- top_features$Feature
    selected_data <- data[, c(top_feature_names, "project_id")]
    
    # Save the selected data to a new CSV file
    write.csv(selected_data, "top_features_data.csv", row.names = FALSE)
    
    print(top_features)
  } 
  else {
    stop("Mismatch in number of features and importance scores.")
  }
} 
else {
  stop("Not enough classes in the target variable for classification.")
}


