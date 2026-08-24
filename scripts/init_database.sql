/*
================================================================================
SCRIPT: Data Warehouse Initialization
================================================================================

PURPOSE:
--------
This script creates a fresh Data Warehouse database named "DataWarehouse"
and initializes the Bronze, Silver, and Gold schemas.

SCHEMA PURPOSE:
---------------
Bronze -> Stores raw/source data with minimal transformation.
Silver -> Stores cleaned, validated, and transformed data.
Gold   -> Stores business-ready data for reporting and analytics.

WARNING:
--------
This script will DROP the existing "DataWarehouse" database if it exists.

!! ALL DATA, TABLES, VIEWS, PROCEDURES, AND OTHER OBJECTS INSIDE THE
   "DataWarehouse" DATABASE WILL BE PERMANENTLY DELETED !!

Do NOT run this script in a production environment unless you are
absolutely sure that the existing database and its data can be deleted.

================================================================================
*//*
================================================================================
SCRIPT: Data Warehouse Initialization
================================================================================

PURPOSE:
--------
This script creates a fresh Data Warehouse database named "DataWarehouse"
and initializes the Bronze, Silver, and Gold schemas.

SCHEMA PURPOSE:
---------------
Bronze -> Stores raw/source data with minimal transformation.
Silver -> Stores cleaned, validated, and transformed data.
Gold   -> Stores business-ready data for reporting and analytics.

WARNING:
--------
This script will DROP the existing "DataWarehouse" database if it exists.

!! ALL DATA, TABLES, VIEWS, PROCEDURES, AND OTHER OBJECTS INSIDE THE
   "DataWarehouse" DATABASE WILL BE PERMANENTLY DELETED !!

Do NOT run this script in a production environment unless you are
absolutely sure that the existing database and its data can be deleted.

================================================================================
*/

-- Create database "Data Warehouse
DROP DATABASE IF EXISTS DataWarehouse;
CREATE DATABASE DataWarehouse;

-- Use database
USE DataWarehouse;

-- Create Schema 
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
