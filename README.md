Summary Data for Smartphone Dataset
========================================

Introduction
----------------------------------------
This repository provides the code and original source data to create a tidy, summarized version
of the Smartphone Data Set, whose original source is
[here]("http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones").
The data were collected from accelerometers and gyroscopes in Samsung Galaxy S II phones
for subjects who were either walking, walking upstairs, walking downstairs, sitting, standing,
or laying. For the mean and standard deviations calculated for each of the signals in the
original dataset, gives the mean for each subject-activity pair, (e.g. the mean of the means and
the mean of the standard deviations for subject 1 walking, the mean of the means and the mean of
the standard deviations for subject 1 walking upstairs, etc.)


Requirements
----------------------------------------
* The script requires R (and was tested under version 3.1.1)
* The script also uses the reshape2 library. Please ensure that it is downloaded and installed
  prior to running the script.

Procedure
----------------------------------------
Input: ./raw_data/ - folder containing the original data
Output: summarized.txt - a tidy dataset containing the average data for select variables,
  with their corresponding subject and activity identifiers.

The script performs the following steps:
 
1. Compile the training dataset (contained in the train folder).
  * Import the "X" data, which contains the raw measurements.
  * Add the corresponding column names to it (pulled in from the features.txt file)
  * Import the "y" data, which contains the activity labels.
  * Import the "Subject ID" data, which identifies each subject.
  * Add the "y" data and the "Subject" data as new columns to the "X" data to create the full set. 
    (At this point, the original ordering of the observations is still maintained.)
  * Join the data against the Activity descriptions (activity_labels.txt), so that the activities
    are clear from the data set.
2. Repeat step 1 with the test dataset (contained in the test folder).
3. Combine the train and test datasets.
4. Select only the columns desired.
  * We only want the mean measurements and standard deviation measurements, so
    the script looks for "-mean()" and "-std()". Including the parenthesis
    is important since other variables may use mean or std in the name, but
    do not necessarily indicate the mean or std.
  * We also include the Activity Description and the Subject ID.
5. Create the summary dataset from the "pruned" dataset.
  * Melts the data and then recasts it, calculating the mean for each variable per each
    Subject-Activity pair.
  * Each subject-activity pair constitutes an observation (and therefore, a row), while each
    average is the variable measured (and therefore, a column).
  * The original column names are kept so that running operations against the original data is easy.
  * For details on each column name, please see the code book.
6. Output the summary dataset as a text file.



File Descriptions
----------------------------------------
* ./run_analysis.R - the main script that combines, summarizes, and tidies the data in ./raw_data/
* ./summarized.txt - output from run_analysis.R; the tidy dataset
* ./summarized_codebook.md - codebook for the tidy summarized dataset
* ./raw_data/ - contains the original dataset
* ./raw_data/README.txt - original readme for the dataset (look at this for full details)
* ./raw_data/features_info.txt - original codebook for the dataset