=======================================================================================================
Code published on 26-Apr-2015 by Jeff Booth

The purpose of this code is to import data from the Human Activity Recognition Using Smartphones Dataset,
bind it into a common data table, calculate the mean of each character vector for each subject and activity,
and then return a text file containing the resulting data

Running requirements
=======================================================================================================
run_analysis.R assumes that the original data sets are all in your working directory and that the R packages
"dplyr" and "data.table" are installed on your machine.

Code Strategy
=======================================================================================================
The code works in the following way:

1. import all data on subjects(subject_test.txt/subject_train.txt), activity being tested(Y_test.txt/Y_train.txt) 
   vectors in data set(X_test.txt/X_train.txt) and the meaning of the measurements and 
   activities(features.txt/activity_labels.txt)

2. Creates a vector converting the activity ID to the actual description of the activity for 'train' and
   'test' data sets separately

3. Binds subject ID, activity description and data for the 'train' and 'test' sets separately

4. Merges data sets for 'train' and 'test' separately

5. Import the names of the vectors in the data set and apply them to the total data table

6. Clean up data labels. All data labels are in Camel Case. Lists of descriptors are separated with a period

7. Filter out measurements that are not means or standard deviations by copying only good measurements into a
   new data frame

8. Group final data frame by Subject and Activity and summarise the means for each of those factors

9. Print out data table