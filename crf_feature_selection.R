# STAT 527 Final Project

library(tidyverse)
library(moreparty)

# Load date
setwd("~/Desktop/UIUC/STAT527/final")
filt_set <- read_csv("filtered_training_set.csv")
# norm_set <- read_csv("normalized_training_set.csv")

filt_set$project_id <- factor(filt_set$project_id)  # convert labels to factors

# Perform CRF and feature selection
filt_set.cf <- cforest(project_id ~ ., data = filt_set[, -1], controls = cforest_unbiased(mtry = 14644, ntree = 300))
filt_set.vi <- fastvarImp(object = filt_set.cf, measure='ACC', parallel=FALSE)

imp <- data.frame(value = sort(filt_set.vi, decreasing = TRUE))  # arrange in desc order
imp$gene <- rownames(imp)

imp_genes <- head(imp, n = 50)$gene  # Choose top 50 features
imp_data <- filt_set %>% select(project_id, all_of(imp_genes))

# Output to csv file
write_csv(imp_data, "crf_top_50.csv")

# Tree visual
pt <- prettytree(filt_set.cf@ensemble[[300]], names(filt_set.cf@data@get("input")))
nt <- new("BinaryTree")
nt@tree <- pt
nt@data <- filt_set.cf@data
nt@responses <- filt_set.cf@responses
plot(nt, type="simple")

# Variable importance visual
p <- ggplot(data=head(imp, n=10), aes(x=reorder(gene, value), y=value)) +
  geom_bar(stat="identity") +
  xlab("Gene") +
  ylab("Importance measure") +
  labs(title = "Top 10 Important Genes using CRF") +
  coord_flip()
p

model_xgb <- readRDS("crf_top_50_xgbTree_cv_5foldCV.RData")
model_multinom <- readRDS("crf_top_50_multinom_cv_5foldCV.RData")
