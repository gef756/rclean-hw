# -------------------------------------------------
#
# Getting and Cleaning Data - Course Project
# 
# GEF 2014-08-23
#
# Clean up of wearable computing data
# 
# -------------------------------------------------

raw.data.folder = "./raw_data"

combine.data.set <- function(folder) {
  full_folder <- paste(raw.data.folder, folder, sep="/")
  
  # Import lookups
  activ.descs <- read.table(paste(raw.data.folder, "activity_labels.txt", sep="/"), sep=" ", header=F)
  names(activ.descs) <- c("Act.ID", "Act.Descr")
  feature.descs <- read.table(paste(raw.data.folder, "features.txt", sep="/"), sep=" ", header=F)
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
  #TODO: Fill in / Fix
  # write.table("blah", row.name=F)
  print(names(df))
  print(summary(df))
  print(dim(df))
}

combine.sets <- function(df1, df2) {
  res <- rbind(df1, df2)
  res
}

create.summary <- function(df) {
  #TODO: Fill in / fix
  df
}

prune <- function(df) {
  #TODO: Fill in / fix
  cols <- names(df)
  col.conds <- (grepl(cols, "-mean()") | grepl(cols, "-std()") | 
                  grepl(cols, "Act.Descr") | grepl(cols, "Subject.ID"))
  df
}


main <- function() {
  train.set <- combine.data.set("train")
  test.set <- combine.data.set("test")
  master.set <- combine.sets(train.set, test.set)
  pruned.set <- prune(master.set)
  summary.set <- create.summary(master.set)
  output.clean.data(summary.set, "")
}

main()