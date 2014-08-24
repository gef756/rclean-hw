# -------------------------------------------------
#
# Getting and Cleaning Data - Course Project
# 
# GEF 2014-08-23
#
# Clean up of wearable computing data
# 
# -------------------------------------------------

# Location of the raw data
RAW.DATA.LOC = "./raw_data"


# Supporting Functions
combine.data.set <- function(folder) {
  full_folder <- paste(RAW.DATA.LOC, folder, sep="/")
  
  # Import lookups
  activ.descs <- read.table(paste(RAW.DATA.LOC, "activity_labels.txt", sep="/"), sep=" ", header=F)
  names(activ.descs) <- c("Act.ID", "Act.Descr")
  feature.descs <- read.table(paste(RAW.DATA.LOC, "features.txt", sep="/"), sep=" ", header=F)
  names(feature.descs) <- c("Feature.ID", "Feature.Descr")
  
  # Import data
  x.data <- read.table(paste(full_folder, "/X_", folder, ".txt", sep=""), header=F)
  names(x.data) <- feature.descs$Feature.Descr
  
  # Process activity data
  y.data <- read.table(paste(full_folder, "/y_", folder, ".txt", sep=""), header=F)
  names(y.data) <- "Act.ID"
  y.data <- merge(y.data, activ.descs, by="Act.ID", all.x=T, sort=F)
  
  # Process subject data
  subj.data <- read.table(paste(full_folder, "/subject_", folder, ".txt", sep=""), sep=" ", header=F)
  
  # Combine sets
  res <- x.data
  res$Act.Descr <- y.data$Act.Descr
  res$Subject.ID <- subj.data[, 1]
  
  # Return resulting dataframe
  res
}

output.clean.data <- function(df, tgt) {
  print(names(df))
  # print(summary(df))
  print(dim(df))
  write.table(df, tgt, row.names=F)
}

combine.sets <- function(df1, df2) {
  res <- rbind(df1, df2)
  res
}

create.summary <- function(df) {
  library(reshape2)
  melted <- melt(df, id.vars=c("Subject.ID", "Act.Descr"))
  res <- dcast(melted, Subject.ID + Act.Descr ~ ..., mean)
  res
}

prune <- function(df) {  
  cols <- names(df)
  col.conds <- (grepl("-mean()", cols, fixed=T) | grepl("-std()", cols, fixed=T) | 
                  grepl("Act.Descr", cols, fixed=T) | grepl("Subject.ID", cols, fixed=T))
  df[, col.conds]
}

# Main control
main <- function() {
  train.set <- combine.data.set("train")
  test.set <- combine.data.set("test")
  master.set <- combine.sets(train.set, test.set)
  pruned.set <- prune(master.set)
  summary.set <- create.summary(pruned.set)
  output.clean.data(summary.set, "summarized.txt")
}

# Run the script
main()