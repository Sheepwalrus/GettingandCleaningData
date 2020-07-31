## Data
# The Project uses six sets of data: 'x_train.txt','y_train.txt','x_test.txt','y_test.txt'.'subject_train.txt','subject_test.txt'
# These are all found within the folder of the main data zip file.
# Additionally, we use the 'features.txt' to identify the correct variable name which corresponds to each column in 'x_train.txt' and 'x_test.txt'.
# The `activity_labels.txt` contains the descriptive names for each activity label, which corresponds to each number in the `y_train.txt` and `y_test.txt`.
# The `README.txt` is the overall desciption about the overall process of how publishers of this dataset did the experiment and got the data result. 

## Project

# 1. The data is read in and put into tables. These tables are given an internal variable name like subjectID or activityID. 

# 2. The train datasets and test datasets are then merged creating one large dataset called mergedActivityData

# 3. Mean and standard deviation are extracted for each activity. 

# 4. The activity column names are updated from simply numbers to actual words like Walking or sitting. Likewise, the variableIDs are also updated to be more coherent. 

# 5. A summary table is exported called tidy_data.txt which contains the mean and standard deviation for each variable for each subject and activity. 