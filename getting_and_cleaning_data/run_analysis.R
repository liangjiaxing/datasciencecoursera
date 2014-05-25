run_analysis <- function () {
  features.all <- read.table('UCI HAR Dataset/features.txt')
  features <- subset(features.all, grepl('-(mean|std)[(]', features.all$V2))
  
  label <- read.table('UCI HAR Dataset/activity_labels.txt')
  
  data <- read.table('UCI HAR Dataset/train/X_train.txt')[, features$V1]
  names(data) <- features$V2
  y <- read.table('UCI HAR Dataset/train/y_train.txt')[,1]
  data$label <- factor(y, levels=label$V1, labels=label$V2)
  data$subject <- factor(read.table('UCI HAR Dataset/train/subject_train.txt')[,1])
  
  train <- data
  
  data <- read.table('UCI HAR Dataset/test/X_test.txt')[, features$V1]
  names(data) <- features$V2
  y <- read.table('UCI HAR Dataset/test/y_test.txt')[,1]
  data$label <- factor(y, levels=label$V1, labels=label$V2)
  data$subject <- factor(read.table('UCI HAR Dataset/test/subject_test.txt')[,1])
  
  data <- rbind(train, data)
  
  library(data.table)
  
  data <- data.table(data)
  tidy.dataset <- data[, lapply(.SD, mean), by=list(label, subject)]
  
  write.table(data, 'rawdata.txt', row.names = FALSE)
  write.table(tidy.dataset, 'tidydata.txt', row.names = FALSE, quote=FALSE)
}

