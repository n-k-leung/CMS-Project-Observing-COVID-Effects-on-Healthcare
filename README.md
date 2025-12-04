# CMS Project: Observing COVID Effects on Healthcare
## Introduction
This project explores how COVID has affected healthcare providers and services in the US. We explored data from years 2019 and 2023 to mark the years of pre-COVID and post-COVID times. To see the effects, we came up with the following questions:
1. What impact has COVID-19 had on the range and availability of services offered by providers, and how has it influenced the number of providers in operation?
2. How has COVID-19 affected patient demographics and population reach, particularly in terms of age, sex, and race?
3. In what ways has COVID-19 affected the Medicare coverage of the numbers of beneficiaries diagnosed with chronic disease and disorders?
4. What effects has COVID-19 had on both the provider services cost and the financial burden on the patients?

Link to data from the CMS.gov:
https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-practitioners/medicare-physician-other-practitioners-by-geography-and-service 

https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-practitioners/medicare-physician-other-practitioners-by-provider

https://data.cms.gov/provider-summary-by-type-of-service/medicare-physician-other-practitioners/medicare-physician-other-practitioners-by-provider-and-service 
## Folders/Files
* csv_files (in zip_data zip folder)
    * holds csv files of normalized tables that will be loaded into MySQL
* ER_diagrams
    * includes our logical and conceptual ER diagram pictures
    * the logical ER diagram was made using the reverse engineer option on MySQL
* mysql_files
    * creating_db_and_loading_db
        * create_tables: schema for creating the MySQL db that we are using
        * load_data: how we load in the data from our csv_files to MySQL as we did not use import wizard as files are quite large
    * queries 
        * all queries used for this project in .sql format
* original_downloaded_data_files (in zip_data zip folder)
    * datasets and data dictionaries retrieved from cms.org that we scrapped
* python_files_cleaning_dataset
    * scrapped datasets in csv files that are referenced in our cleaning files
    * ipynb files that were used to clean and normalize the scrapped data
* Importing Data from CSV File to MySQL pdf file 
    * explains settings to be made and goes over an example of how to load files
## Setup MySQL for Loading in Local Files
This project uses loading in data from local files to MySQL database as the csv files are quite large and will take a long time using import wizard.
1. follow steps in the Importing Data from CSV File to MySQL pdf file to setup MySQL to ensure that loading in data is correction

The pdf file goes over an example on how to load in the data after adjusting the settings to MySQL
## Running Steps
1. download the github zip file and extract it to a designated location
2. creating the csv files to use for the MySQL database
    * download and extract the zip folder called zip_data from: https://drive.google.com/file/d/1Kke-C4_JvI7RbU9G986I-fDJgxyOnY-N/view?usp=sharing 
    * open the zip folder and there are there are 6 csv files under original_downloaded_data_files
    * move files to the python_files_cleaning_dataset so they can be accessed by the ipynb files
    * open the create_schema_Geography_Service.ipynb file and run it
        * this will take care of using the original geography datasets (2019&2023) by combining them, cleaning the data, and normalizing it into tables
    * open the create_schema_Providers.ipynb file and run it
        * does the same as the before but using the original providers datasets (2019&2023)
    * open the create_schema_Pro&Services.ipynb file and run it
        * does the same as the before but using the original provider
        &service datasets (2019&2023)
    * run Combine_common_tables
        * after applying the same normalization to all three data sets, we were left with a couple tables with the same tables with the same columns
        * to ensure that there is one table of each combination of columns, we combined the two csv files with the same column grouping and made sure to drop any duplicate data
    * run delete_common_cols
        * we still have some common attributes between service_totals and provider_benefit_service_amounts table
        * to handle this issue, we drop the common attributes as these would result in the same values across our csv tables
            * specifically, we dropped Tot_Benes and Tot_Srvcs columns from the provider_benefit_service_amounts table and updated the csv file
    * run keep_us_state_data 
        * we wanted states only relevant to the US
        * it checks for valid states in US and updates the state csv
    * open the ruca_combined csv
        * remove the empty row
    * optional: delete the state_providers_benefit_service_amounts.csv as we will not use it as it is repeative to the provider_benefit_service_amounts.csv file
3. setting up and creating the tables for the MySQL Database
    * under the folder location \mysql_files\creating_db_and_loading_db, open and run the create_tables.sql file
    * this creates the tables needed and sets up the database
4. make sure you have read the above section titles "Setup MySQL for Loading in Local Files" to proceed with loading in the data
5. open the load_data.sql file to load in the dat
6. match the correct csv file to the correct MySQL tables
    * run the first part of the file and edit lines 5 and 6 to load in all csv files except for the ruca_combined.csv file
    * run the second part of the file to load in the ruca_combined.csv file because of the format of the data
7. check the row count and contents to see if the data was loaded in correctly
8. running the queries 
    * NOTE: some query runs may time out for users as our dataset is large, running querries depends on how updated the device running is 
    * queries are under the \mysql_files\queries and are in sql file format to run
9. creating logical ER diagram
    * use the reverse engineer function on MySQL to recreate the logical ER diagram
    * the file for this is found under \ER_diagrams

## Tableau Visualization
For this project, we created a storyboard that consists of 3 dashboards together. 

Link: https://public.tableau.com/app/profile/natalie.leung6809/viz/CMSProjectObservingCOVIDEffectsonHealthcare/Story1 
NOTE: the prefered web browser to open this is Google Chrome

### Recreating Visualization through linking MySQL to Tableau
NOTE: must use Tableau Desktop (paid or 14-day trial version)
1. Table connection used for Tableau Data Source Page
2. Recreate graphs based on dragging appropriate columns to their respective places
3. Visualizations were combined together to create our story board and can be found on the link mentioned above
