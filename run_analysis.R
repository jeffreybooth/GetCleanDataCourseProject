run_analysis <- function() {
  
  ##Import packages and data 
  
  library(dplyr)
  library(data.table)

  carryover <- as.integer()
  
  feat <- read.table("features.txt")
  labels <- read.table("activity_labels.txt")
  
  SubjTest <- read.table("test/subject_test.txt")
  X.Test <- read.table("test/X_test.txt")
  Y.Test <- read.table("test/Y_test.txt")
  Y.Test2 <-as.character()
  
  #Create vector with Activity Labels
  for (m in 1:dim(Y.Test)[1]) {
    
    if (Y.Test[m,1] == 1) {
      
      Y.Test2 <- rbind(Y.Test2, "WALKING")
      
    }
    else if (Y.Test[m,1] == 2) {
      
      Y.Test2 <- rbind(Y.Test2, "WALKING_UPSTAIRS")
      
    }
    else if (Y.Test[m,1] == 3) {
      
      Y.Test2 <- rbind(Y.Test2, "WALKING_DOWNSTAIRS")
      
    }
    else if (Y.Test[m,1] == 4) {
      
      Y.Test2 <- rbind(Y.Test2, "SITTING")
      
    }
    else if (Y.Test[m,1] == 5) {
    
    Y.Test2 <- rbind(Y.Test2, "STANDING")
    
    }
    else if (Y.Test[m,1] == 6) {
      
      Y.Test2 <- rbind(Y.Test2, "LAYING")
      
    }
  }
  
  ##Change the names of Subj Test and Y.Test
  SubjTest <- rename(SubjTest, Subj = V1)
  
  ##Bind SubjTest, X.Test and Y.Test together
  Test <- cbind(SubjTest, Y.Test2, X.Test)
  
  ##Repeat previous steps for Train data
  SubjTrain <- read.table("train/subject_train.txt")
  X.Train <- read.table("train/X_train.txt")
  Y.Train <- read.table("train/Y_train.txt")
  Y.Train2 <- as.character()

  for (m in 1:dim(Y.Train)[1]) {
    
    if (Y.Train[m,1] == 1) {
      
      Y.Train2 <- rbind(Y.Train2, "WALKING")
      
    }
    else if (Y.Train[m,1] == 2) {
      
      Y.Train2 <- rbind(Y.Train2, "WALKING_UPSTAIRS")
      
    }
    else if (Y.Train[m,1] == 3) {
      
      Y.Train2 <- rbind(Y.Train2, "WALKING_DOWNSTAIRS")
      
    }
    else if (Y.Train[m,1] == 4) {
      
      Y.Train2 <- rbind(Y.Train2, "SITTING")
      
    }
    else if (Y.Train[m,1] == 5) {
      
      Y.Train2 <- rbind(Y.Train2, "STANDING")
      
    }
    else if (Y.Train[m,1] == 6) {
      
      Y.Train2 <- rbind(Y.Train2, "LAYING")
      
    }
  }
  
  SubjTrain <- rename(SubjTrain, Subj = V1)
  
  Train <- cbind(SubjTrain, Y.Train2, X.Train)
  
  ##merge train and test data sets and update the names of the 'X' columns with descriptions in "feat"
  oldn <- c(names(Train))
  newn <- c(names(Train)[1], "Y.Test2", names(Train)[3:dim(Train)[2]])
  setnames(Train, old = oldn, new = newn)
  
  alldat <- merge(Test, Train, all = TRUE)
  
  ##Cleaning up variable names
  badnames <- as.character(feat[,2])
  goodnames <- gsub("-", "", badnames)
  goodnames <- gsub("\\()", "", goodnames)
  goodnames <- gsub("\\(", ".", goodnames)
  goodnames <- gsub("\\)", "", goodnames)
  goodnames <- gsub(",", ".", goodnames)
  goodnames <- gsub("mean", "Mean", goodnames)
  goodnames <- gsub("std", "Std", goodnames)
  goodnames <- gsub("grav", "Grav", goodnames)
  
  oldnames <- c(names(SubjTest), "Y.Test2", names(X.Test))
  newnames <- c(names(SubjTest), "ActLab", goodnames)
  
  setnames(alldat, old = oldnames, new = newnames)
  
  ##Determine which columns are means or stds
  
  for (i in 3:(dim(X.Train)[2]+2)) {
    
    if (grepl("mean", names(alldat[i])) == TRUE) {
      
      carryover <- rbind(carryover, i)
      
    }
    
    else if (grepl("Mean", names(alldat[i])) == TRUE) {
      
      carryover <- rbind(carryover, i)
      
    }
    
    else if (grepl("std", names(alldat[i])) == TRUE) {
      
      carryover <- rbind(carryover, i)
      
    }
  
  }
  
  ##Isolate means or standards in new data frame
  
  carryover <- rbind(1, 2, carryover)  
  alldat2 <- data.table(row.names = 1:(dim(alldat)[1]))
  
  for (i in 1:(ncol(alldat))) {
  
    if (i %in% carryover) {
      
      alldat2 <- cbind(alldat2, alldat[,i])
      
    }
  
  }
  
  ##work around to get column names to paste into new data frame
  
  colnames(alldat2) <- as.character(1:ncol(alldat2))  
  keepname <- as.character()
  
  for (k in 1:(ncol(alldat))) {
    
    if (k %in% carryover) {
      
      keepname <- rbind(keepname, (names(alldat)[k]))
      
    }
    
  }
  
  oldnames3 <- c(1:ncol(alldat2))
  newnames3 <- c("row.names", keepname)
  setnames(alldat2, old = oldnames3, new = newnames3)
  alldat2 <- select(alldat2, 2:ncol(alldat2))

  ##Group data by Subject and Activity and compute means. Compile into single data frame
  
  alldat2[,1] <- as.factor(alldat[,1])
  alldat2[,2] <- as.factor(alldat[,2])
  result <- group_by(alldat2, Subj, ActLab) %>% summarise_each(funs(mean))
  write.table(result, file = "run_analysis.txt", row.names = FALSE) 

}