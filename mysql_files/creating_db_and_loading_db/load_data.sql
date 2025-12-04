-- SHOW VARIABLES LIKE 'secure_file_priv';

USE cms_db; -- this is the name of the database use previous
SET GLOBAL local_infile = 1; 
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\geography.csv' -- this is the path for the file
INTO TABLE geography -- make sure correct csv file data is loaded to the correct table
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS; -- ignores first row which is the column names


-- use this to load in ruca_combined.csv file because it is in a different format 
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ruca_combined.csv'
INTO TABLE ruca_test
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- SELECT * FROM hcpcs;

-- SELECT COUNT(*) FROM hcpcs;