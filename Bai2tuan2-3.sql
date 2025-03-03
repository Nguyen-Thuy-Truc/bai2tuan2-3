USE NTT
CREATE DATABASE Movies
ON PRIMARY
(NAME =  Movies_data, FILENAME = 'D:\CSDL\Movies\Movies_data.mdf',
SIZE = 25MB, MAXSIZE = 40MB, FILEGROWTH = 1MB)
LOG ON
(NAME = Movies_log, FILENAME = 'D:\CSDL\Movies\Movies_log.ldf',
SIZE = 6MB, MAXSIZE = 8MB, FILEGROWTH = 1MB)

USE NTT
ALTER DATABASE Movies ADD FILE
(NAME = Movies_data2, FILENAME = 'D:\CSDL\Movies\Movies_data2.ndf', SIZE = 10MB)

ALTER DATABASE Movies SET SINGLE_USER
ALTER DATABASE Movies SET RESTRICTED_USER
ALTER DATABASE Movies SET MULTI_USER
SELECT user_access_desc FROM sys.databases WHERE name = 'Movies'

ALTER DATABASE Movies MODIFY FILE
(NAME = Movies_data2, SIZE = 15MB)

ALTER DATABASE Movies SET AUTO_SHRINK ON

USE NTT
CREATE TYPE Movie_num FROM INT NOT NULL
CREATE TYPE Category_num FROM INT NOT NULL
CREATE TYPE Cust_num FROM INT NOT NULL
CREATE TYPE Invoice_num FROM INT NOT NULL
SELECT * FROM SYS.TYPES WHERE is_user_defined = 1;

CREATE TABLE Customer
(Cust_num Cust_num IDENTITY(300,1) NOT NULL,
Lname VARCHAR(20) NOT NULL,
Fname VARCHAR(20) NOT NULL,
Address1 VARCHAR(30) NULL,
Address2 VARCHAR(20) NULL,
City VARCHAR(20) NULL,
State CHAR(2) NULL,
Zip CHAR(10) NULL,
Phone VARCHAR(10) NOT NULL,
Join_date SMALLDATETIME NOT NULL)

CREATE TABLE Category
(Category_num Category_num IDENTITY(1,1) NOT NULL,
Description VARCHAR(20) NOT NULL)

CREATE TABLE Movie
(Movie_num Movie_num NOT NULL,
Title Cust_num NOT NULL,
Category_num Category_num NOT NULL,
Date_purch SMALLDATETIME NULL,
Rental_price INT NULL,
Rating CHAR(5) NULL)

CREATE TABLE Rental
(Invoice_num Invoice_num NOT NULL,
Cust_num Cust_num NOT NULL,
Rental_date SMALLDATETIME NOT NULL,
Due_date SMALLDATETIME NOT NULL)

CREATE TABLE Rental_Detail
(Invoice_num Invoice_num NOT NULL,
Line_num INT NOT NULL,
Movie_num Movie_num NOT NULL,
Rental_price SMALLMONEY NOT NULL)

ALTER TABLE Movie ADD CONSTRAINT PK_movie PRIMARY KEY (Movie_num)
EXEC sp_helpconstraint Movie
ALTER TABLE Customer ADD CONSTRAINT PK_customer PRIMARY KEY (Cust_num)
EXEC sp_helpconstraint Customer
ALTER TABLE Category ADD CONSTRAINT PK_category PRIMARY KEY (Category_num)
EXEC sp_helpconstraint Category
ALTER TABLE Rental ADD CONSTRAINT PK_rental PRIMARY KEY (Invoice_num)
EXEC sp_helpconstraint Rental

ALTER TABLE Movie WITH CHECK ADD FOREIGN KEY ([Category_num]) REFERENCES Category ([Category_num])
EXEC sp_helpconstraint Movie
ALTER TABLE Rental WITH CHECK ADD FOREIGN KEY ([Cust_num]) REFERENCES Customer ([Cust_num])
EXEC sp_helpconstraint Rental
ALTER TABLE Rental_detail WITH CHECK ADD FOREIGN KEY ([Invoice_num]) REFERENCES Rental ([Invoice_num])
ON DELETE CASCADE
ALTER TABLE Rental_detail WITH CHECK ADD FOREIGN KEY ([Movie_num]) REFERENCES Movie ([Movie_num])
EXEC sp_helpconstraint Rental_detail

ALTER TABLE Movie ADD CONSTRAINT DK_movie_date_purch DEFAULT GETDATE() FOR Date_purch
EXEC sp_helpconstraint Movie
ALTER TABLE Customer ADD CONSTRAINT DK_customer_join_date DEFAULT GETDATE() FOR join_date
EXEC sp_helpconstraint Customer
ALTER TABLE Rental ADD CONSTRAINT DK_rental_rental_date DEFAULT GETDATE() FOR Rental_date
ALTER TABLE Rental ADD CONSTRAINT DK_rental_due_date DEFAULT DATEADD(DAY, 2, GETDATE()) FOR Due_date
EXEC sp_helpconstraint Rental

ALTER TABLE Movie ADD CONSTRAINT CK_movie CHECK (Rating IN ('G','PG','R','NC17','NR'))
EXEC sp_helpconstraint Movie
ALTER TABLE Rental ADD CONSTRAINT CK_Due_date CHECK (Due_date >= Rental_date)
EXEC sp_helpconstraint Rental

