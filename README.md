# Coursera Data Science Specialization Course 3 Week 4 Assignment README

## Acknowledgement and Disclaimer

Acknowledgement for portions of this readme and project goes to the original
authors and institutions:
>Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
>Smartlab - Non Linear Complex Systems Laboratory
>DITEN - Università degli Studi di Genova.
>Via Opera Pia 11A, I-16145, Genoa, Italy.
>activityrecognition@smartlab.ws
>www.smartlab.ws
>
>Use of the original dataset in publications must be acknowledged by referencing
>the following publication [1] 
>
>[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
>Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass
>Hardware-Friendly Support Vector Machine. International Workshop of Ambient
>Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
>
>This dataset is distributed AS-IS and no responsibility implied or explicit can
>be addressed to the authors or their institutions for its use or misuse. Any
>commercial use is prohibited.
>
>Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November
>2012.

## Summary
The purpose of this project is to satisfy the requirements of the week 4
peer-graded assignment that is part of the Getting and Cleaning Data course
within the Data Science Specialization on Coursera. The assignment makes use of
the Human Activity Recognition Using Smartphones data set available from the
UC Irvine Machine Learning Repository available at the URL below.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The assignment takes this data set as input. An R script called `run_analysis.R`
was written which processes the data and returns the required output. The output
of the assignment is a subset of the original data summarized in a tidy format.
A summary of the original data set is provided by the original authors in their
readme:

>The experiments have been carried out with a group of 30 volunteers within an
age bracket of 19-48 years. Each person performed six activities (WALKING,
WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a
smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer
and gyroscope, we captured 3-axial linear acceleration and 3-axial angular
velocity at a constant rate of 50Hz. The experiments have been video-recorded to
label the data manually. The obtained dataset has been randomly partitioned into
two sets, where 70% of the volunteers was selected for generating the training
data and 30% the test data.

The script was prepared with the recommendations of Google's R Style guide in
mind. The `dplyr` and `tidyr` packages are required to run the script. As per
the assignment instructions the script must:
- Merge the training and test data sets to create one data set
- Extract only the measurements on the mean and standard deviation for each
- Use descriptive activity names to name the activities in the data set
- Appropriately label the data set with descriptive variable names
- Create a tidy data set with the average of each variable for each activity

The output of the script is the tidy data set called `data.sub1.means`. This
output is left as an object after running the script, and it is also saved as a
file called `TidyData.txt`.

The assignment submission consists of four files:
- This `README.md` file which explains the submission and script
- A `CodeBook.md` file which describes the variables, data, and processing
- The `run_analysis.R` script used to compelte the assignment
- The `TidyData.txt` file which is the tidy data output (not uploaded to GitHub)

## Details about the input data
From the original authors' readme file:
>For each record it is provided:
>- Triaxial acceleration from the accelerometer (total acceleration) and the
>estimated body acceleration.
>- Triaxial Angular velocity from the gyroscope. 
>- A 561-feature vector with time and frequency domain variables. 
>- Its activity label. 
>- An identifier of the subject who carried out the experiment.
>
>The dataset includes the following files:
>- 'README.txt'
>- 'features_info.txt': Shows information about the variables used on the
>feature vector.
>- 'features.txt': List of all features.
>- 'activity_labels.txt': Links the class labels with their activity name.
>- 'train/X_train.txt': Training set.
>- 'train/y_train.txt': Training labels.
>- 'test/X_test.txt': Test set.
>- 'test/y_test.txt': Test labels.

>The following files are available for the train and test data. Their
>descriptions are equivalent:
>- 'train/subject_train.txt': Each row identifies the subject who performed the
>activity for each window sample. Its range is from 1 to 30. 
>- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from
>the smartphone accelerometer X axis in standard gravity units 'g'. Every row
>shows a 128 element vector. The same description applies for the
>'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
>- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal
>obtained by subtracting the gravity from the total acceleration. 
>- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector
>measured by the gyroscope for each window sample. The units are radians/second. 

>Notes:
>- Features are normalized and bounded within [-1,1].
>- Each feature vector is a row on the text file.

Additional details about the variables can be found in the codebook.

## Details about the script
The script was prepared with the recommendations of Google's R Style guide in
mind, and it progresses through 6 parts where the script:
1) Accesses the original data set
2) Reads the data into R
3) Assembles the data into a single table.
4) Subsets the data, selecting only the columns required for the assignment
5) Rearranges and summarizes the table so it is in a tidy format
6) Returns the data as a data frame object and saves it to a file

Part 1 checks if the file and folder already exist in the current directory and
downloads the file or unzips it as needed.

Part 2 reads in all of the data from the 8 files that are required to complete
this assignment. The files are each read into their own data frame object in
this step. Classes and names are explicitly defined for the data frames at the
time of read-in. It is important to note that when reading in the `X_test.txt`
and `X_train.txt` files `read.table()` replaces special characters such as
parenthesis in the feature names with periods. For example `tBodyAcc-mean()-X`
becomes `tBodyAcc-mean...X`. This is not a problem, it is just important to note
when working with the objects.

Part 3 assembles six of the data frames into a single data frame. This data
frame is converted to a `tbl_df` object and a column is added which contains the
descriptive activity labels. Later in the script this column will be selected
instead of the activity codes which are less descriptive.

Part 4 subsets the data selecting only the columns needed for the assignment.
The script looks for the explicit character sequences "mean." or "std." in the
feature names. The period is a literal period instead of a parenthesis due to
how the feature names were read in originally. The periods were included to
select only features where the function was `mean()` instead of selecting
features that contain the character sequence "mean" elsewhere such as
"meanFreq()". The instructions for the assignment did not clarify if these other
occurrances of mean should be included in the output data set, so they were
excluded. When subsetting the data the `activity.code` column was dropped and
instead the more descriptive `activity` column was selected. As the names for
the feature columns were already descriptive they were not renamed again.

Part 5 rearranges and summarizes the table so it is in a tidy format. The table
is first melted, gathering all the features into a single column. The table is
then grouped on the `subject`, `activity`, and `feature` variables. The `mean()`
function is applied to each group and the table is collapsed down to summarize
the mean for each group.

Part 6 returns the data as a data frame object and saves it to a file. The
`tbl_df` object from part 5 is converted back to a data frame and then saved to
a file called `TidyData.txt`. Example code is shown for how the data frame
object could be recreated by reading in the .txt file.

## Details about the output data
The output data set is a single data frame with 11880 observations of 4
variables. It gives the mean value for each activity, subject, and feature that
measures a mean or standard deviation.
- `subject`: A column of integer values that identifies the subject who
performed the activity. Its range is from 1 to 30, and it is the same as the
subject IDs provided in the original data such as the file `subject_train.txt`
- `activity`: A column of character values that describe the activity performed
which yielded the feature measurements. These labels were taken directly from
the file `activity_labels.txt`
- `feature`: A column of character values which identify the feature variable
values that were used to calculate the mean. The values in this column are a
subset of the complete list provided in `features.txt`. The subset includes
only the features that are measurements on the mean or standard deviation (a
function like meanFreq was assumed to not meet these criteria). The values
resemble but do not exatly match the values in the original `features.txt` file
because special characters have been replaced with periods. These slightly
modified names are still sufficiently descriptive, so they were not modified
again.
- `mean`: A column of double values which is the mean of all values within the
set of the other three variables in that observation
 
The data is output in two forms. It is left behind as a data frame object
called `data.sub1.means` after running the script. The data are also saved to a
file called `TidyData.txt`. 
