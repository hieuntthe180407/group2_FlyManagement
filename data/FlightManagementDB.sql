USE [master]
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'FlightManagementDB')
BEGIN
	ALTER DATABASE FlightManagementDB SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE FlightManagementDB SET ONLINE;
	DROP DATABASE FlightManagementDB;
END

GO

CREATE DATABASE FlightManagementDB
GO

USE FlightManagementDB
GO

/*******************************************************************************
	Drop tables if exists
*******************************************************************************/
DECLARE @sql nvarchar(MAX) 
SET @sql = N'' 

SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(KCU1.TABLE_SCHEMA) 
    + N'.' + QUOTENAME(KCU1.TABLE_NAME) 
    + N' DROP CONSTRAINT ' -- + QUOTENAME(rc.CONSTRAINT_SCHEMA)  + N'.'  -- not in MS-SQL
    + QUOTENAME(rc.CONSTRAINT_NAME) + N'; ' + CHAR(13) + CHAR(10) 
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
    ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
    AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
    AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

EXECUTE(@sql) 

GO
DECLARE @sql2 NVARCHAR(max)=''

SELECT @sql2 += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql2 
GO 

---------------------------- Create table ----------------------------------
create table airport(
id int primary key,
code varchar(10) unique,
name nvarchar(100),
country nvarchar(50),
state nvarchar(50),
city nvarchar(50)
)

create table airline(
id int primary key,
code varchar(10) unique,
name nvarchar(100) unique,
country nvarchar(50)
)

create table flight(
id int primary key,
airline_id int references airline(id),
departing_airport int references airport(id),
arriving_airport int references airport(id),
departing_gate varchar(10),
arriving_gate varchar(10),
departure_time datetime,
arrival_time datetime
)

create table passenger(
id int primary key,
first_name nvarchar(50),
last_name nvarchar(50),
date_of_birth date,
country nvarchar(50),
email nvarchar(50),
gender nvarchar(20)
)

create table bookingPlatform(
id int primary key,
name nvarchar(100),
url nvarchar(200)
)

create table booking(
id int primary key,
passenger_id int references passenger(id),
flight_id int references flight(id),
booking_platform_id int references bookingPlatform(id),
booking_time datetime 
)

create table baggage(
id int primary key,
booking_id int references booking(id),
weight_in_kg decimal(4,2)
)
GO
CREATE TABLE [dbo].[AccountMember](
	[MemberID] [nvarchar](20) NOT NULL,
	[MemberPassword] [nvarchar](80) NOT NULL,
	[FullName] [nvarchar](80) NOT NULL,
	[EmailAddress] [nvarchar](100) NULL,
	[MemberRole] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---------------------------- insert data ------------------------------------
GO
INSERT [dbo].[AccountMember] ([MemberID], [MemberPassword], [FullName], [EmailAddress], [MemberRole]) VALUES (N'Admin', N'@1', N'Administrator', N'admin@CompanyName.com', 1)
GO
INSERT [dbo].[AccountMember] ([MemberID], [MemberPassword], [FullName], [EmailAddress], [MemberRole]) VALUES (N'PS0002', N'@2', N'Staff', N'staff@CompanyName.com', 2)
GO
INSERT [dbo].[AccountMember] ([MemberID], [MemberPassword], [FullName], [EmailAddress], [MemberRole]) VALUES (N'PS0003', N'@3', N'Member 1', N'member1@CompanyName.com', 3)
GO
INSERT [dbo].[AccountMember] ([MemberID], [MemberPassword], [FullName], [EmailAddress], [MemberRole]) VALUES (N'PS0004', N'@3', N'Member 2', N'member2@CompanyName.com', 3)



insert into airport (id, code, name, country, state, city) values (1,'DEN', 'Denver International Airport', 'United States', 'Colorado', 'Denver');
insert into airport (id, code, name, country, state, city) values (2,'ATL', 'Atlanta Hartsfield-Jackson Airport', 'United States', 'Georgia', 'Atlanta');
insert into airport (id, code, name, country, state, city) values (3,'IST', 'Istanbul International Airport', 'Turkey', null, 'Istanbul');
insert into airport (id, code, name, country, state, city) values (4,'DFW', 'Dallas / Fort Worth International Airport', 'United States', 'Texas', 'Dallas');
insert into airport (id, code, name, country, state, city) values (5,'MCO', 'Orlando International Airport', 'United States', 'Florida', 'Orlando');
insert into airport (id, code, name, country, state, city) values (6,'IAD', 'Washington Dulles International Airport', 'United States', 'Virginia', 'Washington');
insert into airport (id,code, name, country, state, city) values (7,'PKX', 'Beijing Daxing International Airport', 'China', null, 'Beijing');
insert into airport (id,code, name, country, state, city) values (8,'IAH', 'George Bush Intercontinental Airport', 'United States', 'Texas', 'Houston');
insert into airport (id,code, name, country, state, city) values (9,'PVG', 'Shanghai Pudong International Airport', 'China', null, 'Shanghai');
insert into airport (id,code, name, country, state, city) values (10,'CAI', 'Cairo International Airport', 'Egypt', null, 'Cairo');
insert into airport (id,code, name, country, state, city) values (11,'BKK', 'Suvarnabhumi Airport', 'Thailand', null, 'Bangkok');
insert into airport (id,code, name, country, state, city) values (12,'CDG', 'Charles-de-Gaulle Airport', 'France', 'Ile de France', 'Paris');
insert into airport (id,code, name, country, state, city) values (13,'BER', 'Berlin Brandenburg Airport', 'Germany', 'Brandenburg', 'Berlin');
insert into airport (id,code, name, country, state, city) values (14,'FRA', 'Frankfurt Airport', 'Germany', 'Hesse', 'Frankfurt');
insert into airport (id,code, name, country, state, city) values (15,'SEN', 'London Southend Airport', 'United Kingdom', 'Essex', 'Southend');
insert into airport (id,code, name, country, state, city) values (16,'LHR', 'Heathrow Airport', 'United Kingdom', 'Greater London', 'Hillingdon');
insert into airport (id,code, name, country, state, city) values (17,'HAN', 'Noibai International Airport', 'Vietnam', null, 'Hanoi');
insert into airport (id,code, name, country, state, city) values (18,'SGN', 'Tan Son Nhat International Airport', 'Vietnam', null, 'Ho Chi Minh city');
insert into airport (id,code, name, country, state, city) values (19,'SIN', 'Singapore Changi Airport', 'Singapore', null, 'Singapore');
insert into airport (id,code, name, country, state, city) values (20,'DXB', 'Dubai International Airport', 'United Arab Emirates', null, 'Dubai');


insert into airline(id,code,name,country) values(1,'VN','Vietnam Airlines', 'Vietnam')
insert into airline(id,code,name,country) values(2,'CZ','China Southern Airlines', 'China')
insert into airline(id,code,name,country) values(3,'CI','China Airlines', 'China')
insert into airline(id,code,name,country) values(4,'MU','China Eastern Airlines', 'China')
insert into airline(id,code,name,country) values(5,'MH','Malaysia Airlines', 'Malaysia')
insert into airline(id,code,name,country) values(6,'PG','Bangkok Airways', 'Thailand')
insert into airline(id,code,name,country) values(7,'BA','British Airways', 'United Kingdom')
insert into airline(id,code,name,country) values(8,'HX','Hong Kong Airlines', 'China')
insert into airline(id,code,name,country) values(9,'AF','Air France', 'France')
insert into airline(id,code,name,country) values(10,'SQ','Singapore Airlines', 'Singapore')
insert into airline(id,code,name,country) values(11,'AS','Alaska Airlines', 'United States')
insert into airline(id,code,name,country) values(12,'AA','American Airlines', 'United States')
insert into airline(id,code,name,country) values(13,'DL','Delta Air Lines', 'United States')
insert into airline(id,code,name,country) values(14,'WN','Southwest Airlines', 'United States')
insert into airline(id,code,name,country) values(15,'UA','United Airlines', 'United States')
insert into airline(id,code,name,country) values(16,'EK','Emirates Airlines', 'United Arab Emirates')
insert into airline(id,code,name,country) values(17,'LH','Lufthansa Airlines', 'Germany')
insert into airline(id,code,name,country) values(18,'EZY','easyJet', 'United Kingdom')
insert into airline(id,code,name,country) values(19,'RK','Ryanair UK', 'Vietnam')
insert into airline(id,code,name,country) values(20,'KE','Korean Air', 'South Korea')

INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (1, 17, 12, 9, N'2E', N'2A', CAST(N'2023-05-31T13:15:22.000' AS DateTime), CAST(N'2023-06-01T03:53:22.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (2, 8, 18, 17, N'1C', N'2E', CAST(N'2023-08-16T14:21:12.000' AS DateTime), CAST(N'2023-08-16T23:57:12.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (3, 10, 5, 9, N'2D', N'2C', CAST(N'2023-11-06T23:15:36.000' AS DateTime), CAST(N'2023-11-07T15:09:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (4, 20, 19, 14, N'1D', N'2E', CAST(N'2023-07-20T18:25:38.000' AS DateTime), CAST(N'2023-07-21T04:01:38.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (5, 5, 7, 12, N'2D', N'2D', CAST(N'2023-08-27T14:22:53.000' AS DateTime), CAST(N'2023-08-28T05:00:53.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (6, 10, 3, 17, N'2B', N'1B', CAST(N'2023-03-20T19:39:46.000' AS DateTime), CAST(N'2023-03-21T05:38:46.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (7, 1, 7, 4, N'1B', N'1A', CAST(N'2023-05-03T19:55:04.000' AS DateTime), CAST(N'2023-05-04T11:49:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (8, 10, 6, 2, N'2E', N'1C', CAST(N'2023-09-20T11:12:21.000' AS DateTime), CAST(N'2023-09-20T20:48:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (9, 7, 18, 17, N'2B', N'2B', CAST(N'2023-08-27T08:35:09.000' AS DateTime), CAST(N'2023-08-27T18:11:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (10, 7, 11, 16, N'1D', N'2B', CAST(N'2023-07-24T07:52:59.000' AS DateTime), CAST(N'2023-07-24T20:49:59.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (11, 5, 17, 3, N'1B', N'1D', CAST(N'2023-06-30T18:37:17.000' AS DateTime), CAST(N'2023-07-01T04:36:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (12, 16, 12, 16, N'2E', N'1D', CAST(N'2023-10-27T20:57:36.000' AS DateTime), CAST(N'2023-10-27T23:48:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (13, 3, 4, 1, N'1A', N'2F', CAST(N'2023-11-13T09:50:26.000' AS DateTime), CAST(N'2023-11-13T19:26:26.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (14, 19, 10, 14, N'2C', N'2D', CAST(N'2023-09-26T00:35:58.000' AS DateTime), CAST(N'2023-09-26T04:17:58.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (15, 5, 10, 9, N'2C', N'1D', CAST(N'2024-01-17T00:53:14.000' AS DateTime), CAST(N'2024-01-17T10:43:14.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (16, 1, 10, 14, N'2B', N'2C', CAST(N'2024-01-21T17:51:51.000' AS DateTime), CAST(N'2024-01-21T21:33:51.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (17, 9, 15, 17, N'2E', N'2A', CAST(N'2023-05-22T00:30:54.000' AS DateTime), CAST(N'2023-05-22T15:00:54.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (18, 1, 16, 17, N'2E', N'1D', CAST(N'2023-03-04T15:29:52.000' AS DateTime), CAST(N'2023-03-05T05:59:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (19, 6, 15, 2, N'2D', N'1B', CAST(N'2023-12-23T15:20:04.000' AS DateTime), CAST(N'2023-12-23T23:17:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (20, 8, 18, 19, N'1D', N'1D', CAST(N'2023-07-27T18:17:42.000' AS DateTime), CAST(N'2023-07-28T03:53:42.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (21, 10, 2, 3, N'2B', N'1B', CAST(N'2023-11-18T10:46:17.000' AS DateTime), CAST(N'2023-11-18T20:20:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (22, 9, 11, 10, N'1A', N'1A', CAST(N'2024-01-04T09:12:28.000' AS DateTime), CAST(N'2024-01-04T19:05:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (23, 11, 4, 8, N'1A', N'2D', CAST(N'2023-09-26T18:46:33.000' AS DateTime), CAST(N'2023-09-27T04:22:33.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (24, 15, 1, 2, N'1D', N'1A', CAST(N'2023-03-30T01:44:46.000' AS DateTime), CAST(N'2023-03-30T11:20:46.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (25, 8, 1, 15, N'1B', N'2E', CAST(N'2023-07-06T06:35:11.000' AS DateTime), CAST(N'2023-07-06T14:32:11.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (26, 8, 11, 8, N'2C', N'2F', CAST(N'2023-12-20T09:18:51.000' AS DateTime), CAST(N'2023-12-21T01:05:51.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (27, 16, 8, 19, N'2D', N'2C', CAST(N'2023-02-22T07:47:08.000' AS DateTime), CAST(N'2023-02-22T17:23:08.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (28, 16, 13, 19, N'2A', N'1D', CAST(N'2023-06-18T09:33:15.000' AS DateTime), CAST(N'2023-06-18T19:09:15.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (29, 20, 1, 13, N'2E', N'1D', CAST(N'2023-09-12T21:01:09.000' AS DateTime), CAST(N'2023-09-13T06:37:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (30, 12, 1, 15, N'1C', N'2F', CAST(N'2023-12-06T18:38:31.000' AS DateTime), CAST(N'2023-12-07T02:35:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (31, 2, 2, 8, N'1C', N'2B', CAST(N'2023-09-21T02:32:25.000' AS DateTime), CAST(N'2023-09-21T12:08:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (32, 9, 19, 7, N'1B', N'1D', CAST(N'2023-11-18T13:47:37.000' AS DateTime), CAST(N'2023-11-18T23:23:37.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (33, 17, 2, 13, N'2E', N'2E', CAST(N'2023-09-23T22:34:47.000' AS DateTime), CAST(N'2023-09-24T08:10:47.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (34, 7, 5, 9, N'1D', N'2D', CAST(N'2023-11-19T04:40:43.000' AS DateTime), CAST(N'2023-11-19T20:34:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (35, 11, 9, 1, N'2C', N'2E', CAST(N'2023-11-25T07:18:36.000' AS DateTime), CAST(N'2023-11-25T23:12:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (36, 17, 5, 14, N'2A', N'2D', CAST(N'2023-03-17T19:25:41.000' AS DateTime), CAST(N'2023-03-18T05:01:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (37, 14, 6, 13, N'2F', N'2F', CAST(N'2023-07-04T14:18:35.000' AS DateTime), CAST(N'2023-07-04T23:54:35.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (38, 8, 14, 16, N'1C', N'2A', CAST(N'2024-02-15T11:32:35.000' AS DateTime), CAST(N'2024-02-15T17:18:35.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (39, 14, 6, 15, N'2A', N'1C', CAST(N'2023-11-23T03:48:44.000' AS DateTime), CAST(N'2023-11-23T11:45:44.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (40, 9, 16, 1, N'1A', N'1A', CAST(N'2023-11-10T08:40:45.000' AS DateTime), CAST(N'2023-11-10T16:37:45.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (41, 10, 7, 16, N'1D', N'1A', CAST(N'2023-12-03T03:15:48.000' AS DateTime), CAST(N'2023-12-03T17:47:48.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (42, 17, 11, 7, N'1B', N'2C', CAST(N'2024-01-29T23:05:57.000' AS DateTime), CAST(N'2024-01-30T04:48:57.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (43, 15, 2, 9, N'2E', N'1B', CAST(N'2023-03-06T01:11:41.000' AS DateTime), CAST(N'2023-03-06T17:05:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (44, 4, 6, 7, N'2D', N'1D', CAST(N'2024-02-08T16:49:51.000' AS DateTime), CAST(N'2024-02-09T08:43:51.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (45, 8, 10, 17, N'2C', N'2D', CAST(N'2023-12-27T20:47:25.000' AS DateTime), CAST(N'2023-12-28T06:23:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (46, 15, 6, 9, N'2B', N'2D', CAST(N'2023-10-13T08:28:27.000' AS DateTime), CAST(N'2023-10-14T00:22:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (47, 11, 8, 3, N'1A', N'2A', CAST(N'2023-10-16T13:34:56.000' AS DateTime), CAST(N'2023-10-16T23:08:56.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (48, 16, 12, 19, N'2B', N'1C', CAST(N'2023-08-13T17:00:37.000' AS DateTime), CAST(N'2023-08-14T02:36:37.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (49, 12, 2, 9, N'2F', N'2D', CAST(N'2023-11-27T03:26:24.000' AS DateTime), CAST(N'2023-11-27T19:20:24.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (50, 15, 13, 1, N'2D', N'2F', CAST(N'2023-04-05T01:01:24.000' AS DateTime), CAST(N'2023-04-05T10:37:24.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (51, 20, 9, 4, N'2B', N'2C', CAST(N'2024-02-02T05:44:06.000' AS DateTime), CAST(N'2024-02-02T21:38:06.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (52, 3, 12, 20, N'2A', N'2D', CAST(N'2023-07-13T16:47:43.000' AS DateTime), CAST(N'2023-07-14T00:29:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (53, 5, 11, 9, N'1D', N'2B', CAST(N'2023-07-15T11:10:49.000' AS DateTime), CAST(N'2023-07-15T16:53:49.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (54, 16, 5, 18, N'2B', N'2D', CAST(N'2023-06-14T23:41:18.000' AS DateTime), CAST(N'2023-06-15T16:15:18.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (55, 20, 7, 3, N'2B', N'2D', CAST(N'2024-02-06T13:54:34.000' AS DateTime), CAST(N'2024-02-07T01:41:34.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (56, 13, 5, 20, N'1B', N'1B', CAST(N'2024-01-03T02:18:42.000' AS DateTime), CAST(N'2024-01-03T15:56:42.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (57, 19, 20, 16, N'2F', N'1A', CAST(N'2023-11-03T21:54:39.000' AS DateTime), CAST(N'2023-11-04T05:29:39.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (58, 2, 15, 11, N'1B', N'2C', CAST(N'2023-11-17T16:23:58.000' AS DateTime), CAST(N'2023-11-18T05:20:58.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (59, 12, 2, 7, N'2F', N'1D', CAST(N'2023-09-25T10:35:37.000' AS DateTime), CAST(N'2023-09-26T02:29:37.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (60, 9, 14, 17, N'2E', N'2D', CAST(N'2023-11-13T15:55:09.000' AS DateTime), CAST(N'2023-11-14T03:43:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (61, 18, 9, 5, N'2E', N'1B', CAST(N'2023-03-05T18:26:03.000' AS DateTime), CAST(N'2023-03-06T10:20:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (62, 7, 14, 4, N'1B', N'1B', CAST(N'2023-09-16T02:41:56.000' AS DateTime), CAST(N'2023-09-16T12:17:56.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (63, 17, 17, 16, N'2C', N'1D', CAST(N'2023-11-11T08:47:34.000' AS DateTime), CAST(N'2023-11-11T23:17:34.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (64, 3, 10, 2, N'2B', N'2D', CAST(N'2023-11-03T19:05:39.000' AS DateTime), CAST(N'2023-11-04T07:41:39.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (65, 13, 8, 17, N'1C', N'2A', CAST(N'2023-12-14T22:07:31.000' AS DateTime), CAST(N'2023-12-15T14:41:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (66, 1, 15, 13, N'1D', N'2A', CAST(N'2023-09-10T05:20:52.000' AS DateTime), CAST(N'2023-09-10T11:06:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (67, 4, 14, 11, N'1C', N'2A', CAST(N'2023-03-13T13:30:16.000' AS DateTime), CAST(N'2023-03-13T23:29:16.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (68, 18, 4, 13, N'1D', N'2A', CAST(N'2023-12-09T06:53:37.000' AS DateTime), CAST(N'2023-12-09T16:29:37.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (69, 18, 1, 11, N'2A', N'1C', CAST(N'2023-09-27T18:24:14.000' AS DateTime), CAST(N'2023-09-28T10:11:14.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (70, 12, 10, 17, N'2B', N'1C', CAST(N'2023-03-28T22:32:27.000' AS DateTime), CAST(N'2023-03-29T08:08:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (71, 16, 16, 6, N'1C', N'1C', CAST(N'2023-03-16T04:46:09.000' AS DateTime), CAST(N'2023-03-16T12:43:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (72, 6, 2, 5, N'1C', N'1C', CAST(N'2023-06-06T10:41:39.000' AS DateTime), CAST(N'2023-06-06T20:17:39.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (73, 10, 3, 6, N'1D', N'1A', CAST(N'2023-07-25T05:32:16.000' AS DateTime), CAST(N'2023-07-25T15:06:16.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (74, 2, 14, 12, N'1A', N'1D', CAST(N'2023-11-29T09:00:34.000' AS DateTime), CAST(N'2023-11-29T11:52:34.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (75, 16, 9, 5, N'2C', N'1B', CAST(N'2024-01-05T09:20:26.000' AS DateTime), CAST(N'2024-01-06T01:14:26.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (76, 4, 18, 10, N'2E', N'1D', CAST(N'2023-12-20T11:43:35.000' AS DateTime), CAST(N'2023-12-20T21:19:35.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (77, 4, 19, 3, N'2A', N'1D', CAST(N'2023-05-26T00:20:55.000' AS DateTime), CAST(N'2023-05-26T09:56:55.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (78, 5, 1, 3, N'2D', N'1A', CAST(N'2023-03-07T09:41:18.000' AS DateTime), CAST(N'2023-03-07T19:15:18.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (79, 11, 17, 6, N'2F', N'2E', CAST(N'2023-05-16T02:11:52.000' AS DateTime), CAST(N'2023-05-16T18:45:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (80, 8, 1, 13, N'1C', N'2A', CAST(N'2023-03-11T16:38:10.000' AS DateTime), CAST(N'2023-03-12T02:14:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (81, 6, 8, 11, N'1C', N'2F', CAST(N'2023-08-26T02:04:02.000' AS DateTime), CAST(N'2023-08-26T17:51:02.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (82, 10, 19, 9, N'2A', N'1C', CAST(N'2023-03-06T00:58:02.000' AS DateTime), CAST(N'2023-03-06T10:34:02.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (83, 12, 7, 19, N'2F', N'2E', CAST(N'2023-06-26T09:05:19.000' AS DateTime), CAST(N'2023-06-26T18:41:19.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (84, 12, 20, 4, N'2C', N'1A', CAST(N'2023-04-20T11:07:21.000' AS DateTime), CAST(N'2023-04-21T00:45:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (85, 13, 1, 10, N'2D', N'1C', CAST(N'2023-02-20T16:21:31.000' AS DateTime), CAST(N'2023-02-21T04:57:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (86, 5, 9, 3, N'2F', N'1D', CAST(N'2023-03-05T10:29:11.000' AS DateTime), CAST(N'2023-03-05T22:16:11.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (87, 9, 12, 19, N'1A', N'2E', CAST(N'2023-04-27T05:31:39.000' AS DateTime), CAST(N'2023-04-27T15:07:39.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (88, 7, 16, 12, N'1A', N'2B', CAST(N'2023-04-08T18:49:41.000' AS DateTime), CAST(N'2023-04-08T21:40:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (89, 7, 1, 5, N'2A', N'1B', CAST(N'2023-04-18T23:30:34.000' AS DateTime), CAST(N'2023-04-19T09:06:34.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (90, 14, 7, 4, N'2E', N'2A', CAST(N'2023-08-31T23:34:23.000' AS DateTime), CAST(N'2023-09-01T15:28:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (91, 18, 16, 12, N'2E', N'2C', CAST(N'2024-01-22T15:05:05.000' AS DateTime), CAST(N'2024-01-22T17:56:05.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (92, 2, 14, 17, N'2C', N'2F', CAST(N'2023-06-05T14:11:39.000' AS DateTime), CAST(N'2023-06-06T01:59:39.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (93, 8, 18, 4, N'1D', N'2F', CAST(N'2023-03-20T03:42:45.000' AS DateTime), CAST(N'2023-03-20T20:16:45.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (94, 13, 7, 12, N'1A', N'1D', CAST(N'2023-04-01T11:33:54.000' AS DateTime), CAST(N'2023-04-02T02:11:54.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (95, 20, 10, 11, N'2F', N'2A', CAST(N'2023-12-10T19:58:23.000' AS DateTime), CAST(N'2023-12-11T05:51:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (96, 9, 10, 17, N'2B', N'2E', CAST(N'2023-12-22T15:49:44.000' AS DateTime), CAST(N'2023-12-23T01:25:44.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (97, 18, 9, 15, N'1C', N'1A', CAST(N'2023-08-14T22:01:10.000' AS DateTime), CAST(N'2023-08-15T12:33:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (98, 4, 2, 7, N'1A', N'1A', CAST(N'2023-06-18T21:09:28.000' AS DateTime), CAST(N'2023-06-19T13:03:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (99, 12, 3, 20, N'2E', N'2F', CAST(N'2023-09-17T06:05:50.000' AS DateTime), CAST(N'2023-09-17T08:43:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (100, 11, 16, 1, N'1B', N'1D', CAST(N'2023-12-05T04:06:47.000' AS DateTime), CAST(N'2023-12-05T12:03:47.000' AS DateTime))
GO
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (101, 16, 10, 16, N'2D', N'1B', CAST(N'2023-08-12T23:19:10.000' AS DateTime), CAST(N'2023-08-13T05:07:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (102, 2, 13, 17, N'1A', N'2B', CAST(N'2023-04-27T00:55:52.000' AS DateTime), CAST(N'2023-04-27T12:43:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (103, 5, 7, 16, N'1C', N'2D', CAST(N'2024-01-30T08:13:25.000' AS DateTime), CAST(N'2024-01-30T22:45:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (104, 11, 2, 6, N'1C', N'2D', CAST(N'2023-06-20T03:33:21.000' AS DateTime), CAST(N'2023-06-20T13:09:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (105, 8, 11, 20, N'2F', N'2B', CAST(N'2023-05-08T07:01:43.000' AS DateTime), CAST(N'2023-05-08T12:37:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (106, 17, 2, 5, N'1C', N'1A', CAST(N'2023-11-17T13:24:31.000' AS DateTime), CAST(N'2023-11-17T23:00:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (107, 1, 10, 19, N'1D', N'2C', CAST(N'2023-05-07T11:48:01.000' AS DateTime), CAST(N'2023-05-07T21:24:01.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (108, 1, 10, 20, N'1C', N'2C', CAST(N'2023-04-10T07:20:24.000' AS DateTime), CAST(N'2023-04-10T18:57:24.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (109, 6, 10, 12, N'2E', N'2E', CAST(N'2023-07-02T00:50:11.000' AS DateTime), CAST(N'2023-07-02T05:23:11.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (110, 19, 14, 17, N'2D', N'2D', CAST(N'2023-07-31T13:42:03.000' AS DateTime), CAST(N'2023-08-01T01:30:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (111, 17, 18, 4, N'2D', N'2F', CAST(N'2023-12-16T20:01:04.000' AS DateTime), CAST(N'2023-12-17T12:35:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (112, 6, 17, 5, N'1D', N'2C', CAST(N'2023-07-24T06:57:43.000' AS DateTime), CAST(N'2023-07-24T23:31:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (113, 6, 7, 4, N'1A', N'2F', CAST(N'2024-01-05T10:02:46.000' AS DateTime), CAST(N'2024-01-06T01:56:46.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (114, 5, 1, 3, N'2A', N'2C', CAST(N'2023-12-14T04:06:46.000' AS DateTime), CAST(N'2023-12-14T13:40:46.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (115, 16, 17, 20, N'2A', N'2B', CAST(N'2023-10-05T21:11:48.000' AS DateTime), CAST(N'2023-10-06T05:10:48.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (116, 3, 7, 12, N'2B', N'1D', CAST(N'2024-01-20T20:08:50.000' AS DateTime), CAST(N'2024-01-21T10:46:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (117, 5, 20, 7, N'1C', N'2A', CAST(N'2023-09-05T22:45:40.000' AS DateTime), CAST(N'2023-09-06T08:22:40.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (118, 20, 16, 17, N'1C', N'1C', CAST(N'2024-01-15T17:28:50.000' AS DateTime), CAST(N'2024-01-16T07:58:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (119, 8, 9, 1, N'1D', N'1D', CAST(N'2023-04-27T20:41:52.000' AS DateTime), CAST(N'2023-04-28T12:35:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (120, 10, 19, 2, N'2D', N'2F', CAST(N'2023-09-03T21:19:03.000' AS DateTime), CAST(N'2023-09-04T06:55:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (121, 5, 19, 10, N'2E', N'1B', CAST(N'2023-12-14T19:33:25.000' AS DateTime), CAST(N'2023-12-15T05:09:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (122, 17, 11, 6, N'2F', N'2F', CAST(N'2023-05-03T14:41:15.000' AS DateTime), CAST(N'2023-05-04T06:28:15.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (123, 16, 3, 11, N'2C', N'2C', CAST(N'2023-06-03T05:53:40.000' AS DateTime), CAST(N'2023-06-03T15:40:40.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (124, 1, 18, 12, N'2D', N'2B', CAST(N'2023-02-16T19:27:57.000' AS DateTime), CAST(N'2023-02-17T08:20:57.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (125, 5, 4, 18, N'2F', N'2F', CAST(N'2023-06-18T08:10:30.000' AS DateTime), CAST(N'2023-06-19T00:44:30.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (126, 7, 5, 6, N'2A', N'1D', CAST(N'2023-09-30T13:13:18.000' AS DateTime), CAST(N'2023-09-30T22:49:18.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (127, 19, 7, 18, N'2F', N'2F', CAST(N'2023-06-18T08:18:11.000' AS DateTime), CAST(N'2023-06-18T13:00:11.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (128, 13, 10, 16, N'1C', N'2D', CAST(N'2023-12-09T02:39:27.000' AS DateTime), CAST(N'2023-12-09T08:27:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (129, 10, 2, 5, N'2D', N'2D', CAST(N'2023-07-22T11:07:44.000' AS DateTime), CAST(N'2023-07-22T20:43:44.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (130, 10, 4, 13, N'2A', N'1C', CAST(N'2023-07-20T01:14:16.000' AS DateTime), CAST(N'2023-07-20T10:50:16.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (131, 14, 11, 10, N'2C', N'2C', CAST(N'2023-08-26T23:18:13.000' AS DateTime), CAST(N'2023-08-27T09:11:13.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (132, 10, 13, 19, N'1D', N'2E', CAST(N'2023-02-26T23:02:10.000' AS DateTime), CAST(N'2023-02-27T08:38:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (133, 18, 3, 5, N'2E', N'2E', CAST(N'2023-12-16T01:23:41.000' AS DateTime), CAST(N'2023-12-16T10:57:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (134, 10, 11, 20, N'2A', N'2F', CAST(N'2023-06-10T14:13:31.000' AS DateTime), CAST(N'2023-06-10T19:49:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (135, 4, 1, 17, N'1B', N'1B', CAST(N'2023-10-23T00:11:31.000' AS DateTime), CAST(N'2023-10-23T16:45:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (136, 10, 13, 10, N'2B', N'1C', CAST(N'2023-09-20T07:21:44.000' AS DateTime), CAST(N'2023-09-20T11:03:44.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (137, 5, 12, 2, N'2C', N'2F', CAST(N'2023-02-23T21:34:09.000' AS DateTime), CAST(N'2023-02-24T05:11:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (138, 10, 14, 7, N'1D', N'1B', CAST(N'2023-12-21T03:38:53.000' AS DateTime), CAST(N'2023-12-21T16:09:53.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (139, 17, 11, 17, N'1A', N'2D', CAST(N'2023-03-21T01:53:40.000' AS DateTime), CAST(N'2023-03-21T04:38:40.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (140, 2, 14, 9, N'1B', N'2C', CAST(N'2023-09-10T22:46:52.000' AS DateTime), CAST(N'2023-09-11T11:17:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (141, 20, 5, 4, N'1D', N'1A', CAST(N'2023-05-13T08:08:53.000' AS DateTime), CAST(N'2023-05-13T17:44:53.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (142, 2, 3, 2, N'2F', N'2E', CAST(N'2023-11-16T08:06:57.000' AS DateTime), CAST(N'2023-11-16T17:40:57.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (143, 15, 18, 10, N'1B', N'2C', CAST(N'2023-08-02T21:55:57.000' AS DateTime), CAST(N'2023-08-03T07:31:57.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (144, 16, 7, 3, N'2F', N'2C', CAST(N'2023-05-05T09:51:59.000' AS DateTime), CAST(N'2023-05-05T21:38:59.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (145, 8, 13, 14, N'2A', N'2E', CAST(N'2024-02-09T14:21:36.000' AS DateTime), CAST(N'2024-02-09T23:57:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (146, 12, 19, 2, N'1B', N'2F', CAST(N'2023-05-01T23:08:07.000' AS DateTime), CAST(N'2023-05-02T08:44:07.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (147, 15, 5, 18, N'2B', N'2A', CAST(N'2023-10-09T12:13:36.000' AS DateTime), CAST(N'2023-10-10T04:47:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (148, 9, 4, 2, N'2D', N'1B', CAST(N'2023-11-16T14:29:23.000' AS DateTime), CAST(N'2023-11-17T00:05:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (149, 20, 1, 19, N'2A', N'2A', CAST(N'2023-03-25T16:44:24.000' AS DateTime), CAST(N'2023-03-26T02:20:24.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (150, 7, 16, 18, N'1D', N'2E', CAST(N'2023-08-05T00:29:08.000' AS DateTime), CAST(N'2023-08-05T14:59:08.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (151, 12, 19, 1, N'2D', N'2A', CAST(N'2023-06-29T07:49:02.000' AS DateTime), CAST(N'2023-06-29T17:25:02.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (152, 4, 19, 8, N'1B', N'1C', CAST(N'2023-06-13T05:03:13.000' AS DateTime), CAST(N'2023-06-13T14:39:13.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (153, 4, 9, 5, N'2A', N'2F', CAST(N'2023-03-17T07:14:40.000' AS DateTime), CAST(N'2023-03-17T23:08:40.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (154, 1, 17, 4, N'2D', N'1C', CAST(N'2024-01-22T02:00:31.000' AS DateTime), CAST(N'2024-01-22T18:34:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (155, 8, 6, 7, N'1A', N'2F', CAST(N'2023-11-26T14:30:31.000' AS DateTime), CAST(N'2023-11-27T06:24:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (156, 18, 1, 17, N'2E', N'1A', CAST(N'2023-07-03T21:31:37.000' AS DateTime), CAST(N'2023-07-04T14:05:37.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (157, 8, 8, 19, N'2F', N'1D', CAST(N'2023-06-02T04:55:21.000' AS DateTime), CAST(N'2023-06-02T14:31:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (158, 5, 4, 9, N'1C', N'2B', CAST(N'2023-05-29T17:16:42.000' AS DateTime), CAST(N'2023-05-30T09:10:42.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (159, 9, 3, 17, N'2B', N'2E', CAST(N'2023-11-17T09:00:03.000' AS DateTime), CAST(N'2023-11-17T18:59:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (160, 13, 3, 19, N'2B', N'2B', CAST(N'2023-11-08T08:00:04.000' AS DateTime), CAST(N'2023-11-08T17:36:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (161, 5, 6, 17, N'2B', N'2A', CAST(N'2023-06-23T05:08:08.000' AS DateTime), CAST(N'2023-06-23T21:42:08.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (162, 20, 1, 14, N'2F', N'1A', CAST(N'2024-02-01T01:30:08.000' AS DateTime), CAST(N'2024-02-01T11:06:08.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (163, 4, 16, 2, N'1A', N'2C', CAST(N'2023-10-24T05:09:58.000' AS DateTime), CAST(N'2023-10-24T13:06:58.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (164, 2, 13, 20, N'2D', N'2F', CAST(N'2023-10-25T19:56:09.000' AS DateTime), CAST(N'2023-10-26T02:51:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (165, 9, 1, 3, N'2C', N'1C', CAST(N'2023-11-16T10:23:42.000' AS DateTime), CAST(N'2023-11-16T19:57:42.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (166, 5, 10, 8, N'2E', N'1C', CAST(N'2024-02-02T17:56:27.000' AS DateTime), CAST(N'2024-02-03T06:32:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (167, 4, 4, 14, N'2C', N'1B', CAST(N'2023-07-18T22:45:22.000' AS DateTime), CAST(N'2023-07-19T08:21:22.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (168, 9, 10, 6, N'2F', N'2F', CAST(N'2023-03-18T05:55:17.000' AS DateTime), CAST(N'2023-03-18T18:31:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (169, 18, 8, 17, N'2E', N'1A', CAST(N'2023-07-18T10:52:47.000' AS DateTime), CAST(N'2023-07-19T03:26:47.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (170, 19, 11, 19, N'1C', N'1A', CAST(N'2023-05-25T06:19:05.000' AS DateTime), CAST(N'2023-05-25T15:55:05.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (171, 17, 13, 10, N'2C', N'2D', CAST(N'2023-08-31T04:37:58.000' AS DateTime), CAST(N'2023-08-31T08:19:58.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (172, 19, 12, 4, N'2D', N'1D', CAST(N'2023-07-21T09:52:43.000' AS DateTime), CAST(N'2023-07-21T17:29:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (173, 15, 3, 7, N'2D', N'1B', CAST(N'2023-05-27T18:13:21.000' AS DateTime), CAST(N'2023-05-28T06:00:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (174, 7, 11, 15, N'1A', N'2D', CAST(N'2023-08-22T06:04:21.000' AS DateTime), CAST(N'2023-08-22T19:01:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (175, 15, 19, 4, N'1B', N'2A', CAST(N'2023-05-17T08:35:15.000' AS DateTime), CAST(N'2023-05-17T18:11:15.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (176, 8, 16, 9, N'2E', N'2E', CAST(N'2024-01-03T21:19:43.000' AS DateTime), CAST(N'2024-01-04T11:51:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (177, 15, 18, 10, N'1C', N'1C', CAST(N'2023-09-25T09:58:29.000' AS DateTime), CAST(N'2023-09-25T19:34:29.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (178, 11, 8, 10, N'2C', N'2E', CAST(N'2023-07-18T18:58:30.000' AS DateTime), CAST(N'2023-07-19T07:34:30.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (179, 3, 14, 15, N'2E', N'1A', CAST(N'2023-03-01T01:05:49.000' AS DateTime), CAST(N'2023-03-01T06:51:49.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (180, 11, 1, 17, N'2B', N'2D', CAST(N'2023-10-03T13:12:43.000' AS DateTime), CAST(N'2023-10-04T05:46:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (181, 7, 17, 5, N'1C', N'2E', CAST(N'2024-01-30T21:02:41.000' AS DateTime), CAST(N'2024-01-31T13:36:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (182, 10, 16, 1, N'2D', N'1D', CAST(N'2023-12-25T06:39:10.000' AS DateTime), CAST(N'2023-12-25T14:36:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (183, 18, 19, 13, N'1B', N'2C', CAST(N'2023-03-29T07:03:07.000' AS DateTime), CAST(N'2023-03-29T16:39:07.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (184, 18, 4, 16, N'2D', N'1B', CAST(N'2023-02-23T09:05:18.000' AS DateTime), CAST(N'2023-02-23T17:02:18.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (185, 10, 4, 16, N'2D', N'2E', CAST(N'2023-04-22T13:01:38.000' AS DateTime), CAST(N'2023-04-22T20:58:38.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (186, 8, 19, 12, N'2D', N'2D', CAST(N'2023-06-04T23:35:22.000' AS DateTime), CAST(N'2023-06-05T09:11:22.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (187, 16, 9, 4, N'1D', N'2E', CAST(N'2023-11-15T09:42:52.000' AS DateTime), CAST(N'2023-11-16T01:36:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (188, 7, 9, 14, N'1A', N'2F', CAST(N'2023-09-01T17:23:12.000' AS DateTime), CAST(N'2023-09-02T05:54:12.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (189, 8, 2, 4, N'2F', N'2B', CAST(N'2024-01-05T17:07:06.000' AS DateTime), CAST(N'2024-01-06T02:43:06.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (190, 8, 16, 20, N'1C', N'2B', CAST(N'2023-07-17T03:23:04.000' AS DateTime), CAST(N'2023-07-17T10:58:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (191, 15, 15, 9, N'1D', N'2B', CAST(N'2023-07-13T16:51:08.000' AS DateTime), CAST(N'2023-07-14T07:23:08.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (192, 7, 11, 5, N'2A', N'1B', CAST(N'2023-06-19T06:19:53.000' AS DateTime), CAST(N'2023-06-19T22:06:53.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (193, 18, 16, 13, N'1D', N'1A', CAST(N'2023-08-01T08:12:33.000' AS DateTime), CAST(N'2023-08-01T13:58:33.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (194, 6, 1, 5, N'1A', N'2D', CAST(N'2023-10-03T14:26:03.000' AS DateTime), CAST(N'2023-10-04T00:02:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (195, 9, 6, 5, N'1B', N'2B', CAST(N'2023-12-24T21:24:59.000' AS DateTime), CAST(N'2023-12-25T07:00:59.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (196, 8, 17, 20, N'2C', N'1B', CAST(N'2023-05-23T17:29:04.000' AS DateTime), CAST(N'2023-05-24T01:28:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (197, 1, 13, 17, N'2D', N'2F', CAST(N'2023-04-01T21:54:04.000' AS DateTime), CAST(N'2023-04-02T09:42:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (198, 12, 2, 10, N'1A', N'1C', CAST(N'2023-03-03T21:54:23.000' AS DateTime), CAST(N'2023-03-04T10:30:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (199, 19, 7, 1, N'2E', N'2C', CAST(N'2024-01-31T22:16:04.000' AS DateTime), CAST(N'2024-02-01T14:10:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (200, 10, 3, 12, N'2D', N'2B', CAST(N'2023-06-25T06:11:53.000' AS DateTime), CAST(N'2023-06-25T14:02:53.000' AS DateTime))
GO
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (201, 4, 6, 10, N'2D', N'1D', CAST(N'2023-09-29T12:32:00.000' AS DateTime), CAST(N'2023-09-30T01:08:00.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (202, 20, 6, 2, N'2D', N'1B', CAST(N'2023-10-26T21:21:41.000' AS DateTime), CAST(N'2023-10-27T06:57:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (203, 9, 15, 2, N'1C', N'1C', CAST(N'2023-08-24T15:59:36.000' AS DateTime), CAST(N'2023-08-24T23:56:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (204, 12, 8, 2, N'2D', N'2F', CAST(N'2023-05-06T13:53:36.000' AS DateTime), CAST(N'2023-05-06T23:29:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (205, 16, 18, 9, N'2F', N'2E', CAST(N'2023-04-28T12:17:19.000' AS DateTime), CAST(N'2023-04-28T16:59:19.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (206, 8, 19, 5, N'2C', N'2D', CAST(N'2023-05-08T07:22:54.000' AS DateTime), CAST(N'2023-05-08T16:58:54.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (207, 10, 11, 14, N'1D', N'2C', CAST(N'2023-07-24T17:52:23.000' AS DateTime), CAST(N'2023-07-25T03:51:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (208, 4, 13, 10, N'1B', N'2C', CAST(N'2023-03-16T09:50:56.000' AS DateTime), CAST(N'2023-03-16T13:32:56.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (209, 2, 12, 11, N'1D', N'2F', CAST(N'2023-09-13T09:30:32.000' AS DateTime), CAST(N'2023-09-13T20:16:32.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (210, 3, 4, 9, N'2B', N'2B', CAST(N'2023-12-31T22:17:50.000' AS DateTime), CAST(N'2024-01-01T14:11:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (211, 20, 13, 18, N'2C', N'2D', CAST(N'2023-03-05T09:23:31.000' AS DateTime), CAST(N'2023-03-05T21:11:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (212, 4, 7, 15, N'2E', N'1A', CAST(N'2023-06-30T06:05:45.000' AS DateTime), CAST(N'2023-06-30T20:37:45.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (213, 10, 6, 7, N'2D', N'2A', CAST(N'2023-04-24T18:31:41.000' AS DateTime), CAST(N'2023-04-25T10:25:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (214, 20, 16, 1, N'1C', N'1A', CAST(N'2023-11-05T20:07:43.000' AS DateTime), CAST(N'2023-11-06T04:04:43.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (215, 17, 3, 19, N'2A', N'2E', CAST(N'2023-05-21T09:26:53.000' AS DateTime), CAST(N'2023-05-21T19:02:53.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (216, 8, 10, 15, N'2A', N'1B', CAST(N'2023-03-23T08:35:27.000' AS DateTime), CAST(N'2023-03-23T14:23:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (217, 3, 14, 2, N'2C', N'1D', CAST(N'2023-04-05T22:08:36.000' AS DateTime), CAST(N'2023-04-06T07:44:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (218, 10, 18, 17, N'1D', N'1D', CAST(N'2023-12-04T22:59:16.000' AS DateTime), CAST(N'2023-12-05T08:35:16.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (219, 8, 20, 7, N'1C', N'1D', CAST(N'2023-07-09T10:14:50.000' AS DateTime), CAST(N'2023-07-09T19:51:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (220, 3, 12, 3, N'2B', N'2E', CAST(N'2023-07-24T07:44:27.000' AS DateTime), CAST(N'2023-07-24T15:35:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (221, 9, 16, 20, N'1A', N'1D', CAST(N'2023-05-05T05:31:33.000' AS DateTime), CAST(N'2023-05-05T13:06:33.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (222, 15, 13, 2, N'1D', N'1C', CAST(N'2024-01-11T09:53:20.000' AS DateTime), CAST(N'2024-01-11T19:29:20.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (223, 12, 17, 3, N'1B', N'2F', CAST(N'2023-07-19T10:53:50.000' AS DateTime), CAST(N'2023-07-19T20:52:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (224, 19, 7, 4, N'1A', N'2E', CAST(N'2024-01-15T03:46:31.000' AS DateTime), CAST(N'2024-01-15T19:40:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (225, 13, 6, 11, N'2C', N'1C', CAST(N'2023-03-29T19:00:51.000' AS DateTime), CAST(N'2023-03-30T10:47:51.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (226, 15, 3, 5, N'2E', N'1D', CAST(N'2023-05-12T09:32:08.000' AS DateTime), CAST(N'2023-05-12T19:06:08.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (227, 10, 19, 4, N'1C', N'2E', CAST(N'2023-02-26T16:06:23.000' AS DateTime), CAST(N'2023-02-27T01:42:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (228, 4, 13, 8, N'1A', N'2E', CAST(N'2023-09-07T20:25:04.000' AS DateTime), CAST(N'2023-09-08T06:01:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (229, 18, 3, 8, N'1C', N'1D', CAST(N'2023-08-07T17:36:36.000' AS DateTime), CAST(N'2023-08-08T03:10:36.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (230, 12, 11, 12, N'2D', N'2B', CAST(N'2023-10-02T16:36:51.000' AS DateTime), CAST(N'2023-10-03T03:22:51.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (231, 14, 9, 11, N'2E', N'2A', CAST(N'2023-08-22T14:22:03.000' AS DateTime), CAST(N'2023-08-22T20:05:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (232, 4, 12, 1, N'2A', N'2C', CAST(N'2023-07-31T19:18:30.000' AS DateTime), CAST(N'2023-08-01T02:55:30.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (233, 14, 3, 17, N'1D', N'1A', CAST(N'2023-09-02T11:15:19.000' AS DateTime), CAST(N'2023-09-02T21:14:19.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (234, 15, 16, 5, N'2E', N'1C', CAST(N'2023-03-29T07:32:25.000' AS DateTime), CAST(N'2023-03-29T15:29:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (235, 18, 18, 16, N'1D', N'2B', CAST(N'2023-04-30T11:54:00.000' AS DateTime), CAST(N'2023-05-01T02:24:00.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (236, 4, 17, 12, N'2C', N'2B', CAST(N'2023-07-01T22:38:24.000' AS DateTime), CAST(N'2023-07-02T11:31:24.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (237, 12, 11, 6, N'2C', N'2C', CAST(N'2023-06-27T20:09:52.000' AS DateTime), CAST(N'2023-06-28T11:56:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (238, 7, 15, 20, N'1D', N'2F', CAST(N'2023-02-17T05:45:17.000' AS DateTime), CAST(N'2023-02-17T13:20:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (239, 6, 7, 1, N'2D', N'1A', CAST(N'2024-01-19T05:53:29.000' AS DateTime), CAST(N'2024-01-19T21:47:29.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (240, 16, 11, 7, N'2A', N'2A', CAST(N'2023-10-14T07:19:55.000' AS DateTime), CAST(N'2023-10-14T13:02:55.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (241, 14, 15, 19, N'2C', N'1B', CAST(N'2023-05-02T01:22:10.000' AS DateTime), CAST(N'2023-05-02T10:58:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (242, 7, 10, 14, N'2B', N'1D', CAST(N'2023-04-18T02:07:28.000' AS DateTime), CAST(N'2023-04-18T05:49:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (243, 19, 11, 10, N'1B', N'1A', CAST(N'2023-04-27T11:24:14.000' AS DateTime), CAST(N'2023-04-27T21:17:14.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (244, 10, 12, 17, N'2E', N'2B', CAST(N'2023-12-19T08:53:13.000' AS DateTime), CAST(N'2023-12-19T21:46:13.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (245, 14, 4, 15, N'2F', N'2B', CAST(N'2023-04-01T19:13:05.000' AS DateTime), CAST(N'2023-04-02T03:10:05.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (246, 19, 10, 17, N'1C', N'1B', CAST(N'2024-01-10T07:01:03.000' AS DateTime), CAST(N'2024-01-10T16:37:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (247, 13, 11, 19, N'2B', N'1C', CAST(N'2023-03-18T19:14:58.000' AS DateTime), CAST(N'2023-03-19T04:50:58.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (248, 15, 8, 19, N'1C', N'1B', CAST(N'2023-10-24T07:30:03.000' AS DateTime), CAST(N'2023-10-24T17:06:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (249, 19, 16, 8, N'1B', N'2D', CAST(N'2023-12-31T22:42:17.000' AS DateTime), CAST(N'2024-01-01T06:39:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (250, 5, 17, 12, N'2F', N'2B', CAST(N'2023-10-10T05:34:51.000' AS DateTime), CAST(N'2023-10-10T18:27:51.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (251, 8, 16, 13, N'1C', N'2C', CAST(N'2023-07-31T08:12:25.000' AS DateTime), CAST(N'2023-07-31T13:58:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (252, 8, 11, 7, N'2D', N'1D', CAST(N'2024-02-13T10:52:17.000' AS DateTime), CAST(N'2024-02-13T16:35:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (253, 5, 18, 4, N'2A', N'1C', CAST(N'2023-08-14T23:44:37.000' AS DateTime), CAST(N'2023-08-15T16:18:37.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (254, 14, 13, 11, N'2E', N'2A', CAST(N'2023-11-09T20:34:25.000' AS DateTime), CAST(N'2023-11-10T06:33:25.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (255, 10, 17, 16, N'2E', N'2A', CAST(N'2023-04-01T03:16:50.000' AS DateTime), CAST(N'2023-04-01T17:46:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (256, 15, 4, 5, N'2E', N'1A', CAST(N'2023-09-07T06:50:21.000' AS DateTime), CAST(N'2023-09-07T16:26:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (257, 15, 11, 8, N'2B', N'2E', CAST(N'2023-06-17T05:55:13.000' AS DateTime), CAST(N'2023-06-17T21:42:13.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (258, 4, 1, 11, N'1C', N'1D', CAST(N'2023-09-04T09:52:50.000' AS DateTime), CAST(N'2023-09-05T01:39:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (259, 2, 3, 13, N'1B', N'2F', CAST(N'2023-06-05T18:15:32.000' AS DateTime), CAST(N'2023-06-05T21:04:32.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (260, 7, 5, 16, N'2F', N'1A', CAST(N'2023-04-03T16:16:01.000' AS DateTime), CAST(N'2023-04-04T00:13:01.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (261, 9, 18, 10, N'1D', N'1D', CAST(N'2024-02-04T00:54:40.000' AS DateTime), CAST(N'2024-02-04T10:30:40.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (262, 9, 13, 3, N'1B', N'2E', CAST(N'2023-03-05T22:11:45.000' AS DateTime), CAST(N'2023-03-06T01:00:45.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (263, 7, 15, 13, N'2D', N'1A', CAST(N'2023-06-25T03:47:26.000' AS DateTime), CAST(N'2023-06-25T09:33:26.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (264, 7, 4, 9, N'2F', N'2C', CAST(N'2023-03-08T12:12:52.000' AS DateTime), CAST(N'2023-03-09T04:06:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (265, 15, 14, 16, N'2B', N'1A', CAST(N'2023-05-11T09:18:40.000' AS DateTime), CAST(N'2023-05-11T15:04:40.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (266, 3, 11, 17, N'2F', N'1B', CAST(N'2023-11-18T11:50:18.000' AS DateTime), CAST(N'2023-11-18T14:35:18.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (267, 7, 6, 2, N'2D', N'1D', CAST(N'2023-04-15T20:34:41.000' AS DateTime), CAST(N'2023-04-16T06:10:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (268, 19, 1, 10, N'2A', N'2E', CAST(N'2023-03-15T02:05:28.000' AS DateTime), CAST(N'2023-03-15T14:41:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (269, 9, 15, 1, N'2D', N'2A', CAST(N'2023-05-07T17:15:34.000' AS DateTime), CAST(N'2023-05-08T01:12:34.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (270, 13, 11, 4, N'1C', N'2A', CAST(N'2023-10-25T18:48:14.000' AS DateTime), CAST(N'2023-10-26T10:35:14.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (271, 12, 8, 19, N'1C', N'2D', CAST(N'2023-06-20T12:15:02.000' AS DateTime), CAST(N'2023-06-20T21:51:02.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (272, 14, 9, 8, N'1A', N'1D', CAST(N'2023-03-06T23:27:04.000' AS DateTime), CAST(N'2023-03-07T15:21:04.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (273, 7, 7, 8, N'1C', N'2B', CAST(N'2023-07-09T20:32:32.000' AS DateTime), CAST(N'2023-07-10T12:26:32.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (274, 12, 6, 3, N'1D', N'2A', CAST(N'2023-10-01T02:29:27.000' AS DateTime), CAST(N'2023-10-01T12:03:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (275, 12, 4, 11, N'2B', N'2D', CAST(N'2023-04-13T00:33:44.000' AS DateTime), CAST(N'2023-04-13T16:20:44.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (276, 19, 19, 1, N'2B', N'2F', CAST(N'2023-02-19T01:49:41.000' AS DateTime), CAST(N'2023-02-19T11:25:41.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (277, 14, 1, 5, N'1C', N'1C', CAST(N'2023-02-28T02:51:20.000' AS DateTime), CAST(N'2023-02-28T12:27:20.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (278, 10, 12, 17, N'2E', N'1B', CAST(N'2023-09-20T10:09:12.000' AS DateTime), CAST(N'2023-09-20T23:02:12.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (279, 19, 2, 8, N'2B', N'2B', CAST(N'2023-06-07T15:28:13.000' AS DateTime), CAST(N'2023-06-08T01:04:13.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (280, 16, 12, 4, N'1A', N'1B', CAST(N'2024-02-10T07:08:48.000' AS DateTime), CAST(N'2024-02-10T14:45:48.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (281, 13, 8, 4, N'2A', N'2F', CAST(N'2023-02-26T14:14:00.000' AS DateTime), CAST(N'2023-02-26T23:50:00.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (282, 5, 15, 18, N'2A', N'2F', CAST(N'2023-11-01T06:31:21.000' AS DateTime), CAST(N'2023-11-01T21:01:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (283, 16, 7, 17, N'1C', N'2B', CAST(N'2024-02-03T07:05:49.000' AS DateTime), CAST(N'2024-02-03T11:47:49.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (284, 6, 2, 16, N'1C', N'2C', CAST(N'2023-06-24T09:12:22.000' AS DateTime), CAST(N'2023-06-24T17:09:22.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (285, 19, 11, 17, N'2F', N'2E', CAST(N'2024-02-15T20:43:28.000' AS DateTime), CAST(N'2024-02-15T23:28:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (286, 7, 6, 9, N'1C', N'2D', CAST(N'2023-03-31T02:02:52.000' AS DateTime), CAST(N'2023-03-31T17:56:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (287, 2, 10, 1, N'2D', N'2D', CAST(N'2023-04-12T15:58:11.000' AS DateTime), CAST(N'2023-04-13T04:34:11.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (288, 10, 10, 13, N'1C', N'1A', CAST(N'2023-05-24T07:12:27.000' AS DateTime), CAST(N'2023-05-24T10:54:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (289, 11, 16, 14, N'2E', N'1A', CAST(N'2024-01-23T08:58:53.000' AS DateTime), CAST(N'2024-01-23T14:44:53.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (290, 2, 14, 16, N'2B', N'2D', CAST(N'2024-01-11T22:21:58.000' AS DateTime), CAST(N'2024-01-12T04:07:58.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (291, 16, 1, 17, N'2B', N'2E', CAST(N'2023-04-11T11:44:00.000' AS DateTime), CAST(N'2023-04-12T04:18:00.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (292, 2, 20, 1, N'2E', N'2D', CAST(N'2023-10-02T04:37:16.000' AS DateTime), CAST(N'2023-10-02T18:15:16.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (293, 11, 12, 19, N'2F', N'1A', CAST(N'2023-02-20T02:42:05.000' AS DateTime), CAST(N'2023-02-20T12:18:05.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (294, 3, 16, 10, N'1C', N'1B', CAST(N'2023-12-12T21:19:47.000' AS DateTime), CAST(N'2023-12-13T03:07:47.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (295, 9, 19, 1, N'1C', N'2E', CAST(N'2023-07-11T13:37:33.000' AS DateTime), CAST(N'2023-07-11T23:13:33.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (296, 19, 13, 17, N'1A', N'2B', CAST(N'2023-09-15T15:58:21.000' AS DateTime), CAST(N'2023-09-16T03:46:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (297, 17, 19, 5, N'1B', N'2F', CAST(N'2023-03-21T15:42:00.000' AS DateTime), CAST(N'2023-03-22T01:18:00.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (298, 10, 9, 13, N'2F', N'2F', CAST(N'2023-02-17T01:44:30.000' AS DateTime), CAST(N'2023-02-17T14:15:30.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (299, 8, 12, 8, N'2C', N'2E', CAST(N'2023-05-04T19:06:50.000' AS DateTime), CAST(N'2023-05-05T02:43:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (300, 16, 6, 4, N'2F', N'2B', CAST(N'2023-10-15T20:15:38.000' AS DateTime), CAST(N'2023-10-16T05:51:38.000' AS DateTime))
GO
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (301, 13, 15, 10, N'2A', N'1A', CAST(N'2023-12-25T13:00:46.000' AS DateTime), CAST(N'2023-12-25T18:48:46.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (302, 12, 2, 16, N'1D', N'2D', CAST(N'2023-03-03T04:22:31.000' AS DateTime), CAST(N'2023-03-03T12:19:31.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (303, 8, 7, 9, N'2C', N'2A', CAST(N'2023-09-07T01:18:48.000' AS DateTime), CAST(N'2023-09-07T10:54:48.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (304, 13, 1, 7, N'2A', N'2E', CAST(N'2023-03-12T15:44:52.000' AS DateTime), CAST(N'2023-03-13T07:38:52.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (305, 2, 6, 11, N'2E', N'1D', CAST(N'2023-04-03T13:09:35.000' AS DateTime), CAST(N'2023-04-04T04:56:35.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (306, 8, 16, 15, N'1C', N'1D', CAST(N'2023-04-10T09:27:44.000' AS DateTime), CAST(N'2023-04-10T19:03:44.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (307, 15, 19, 5, N'2B', N'2D', CAST(N'2023-05-18T06:54:33.000' AS DateTime), CAST(N'2023-05-18T16:30:33.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (308, 6, 7, 8, N'2A', N'2B', CAST(N'2023-09-29T12:46:42.000' AS DateTime), CAST(N'2023-09-30T04:40:42.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (309, 12, 10, 20, N'1A', N'2D', CAST(N'2023-04-27T17:44:23.000' AS DateTime), CAST(N'2023-04-28T05:21:23.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (310, 14, 15, 16, N'2D', N'2D', CAST(N'2023-07-06T18:59:22.000' AS DateTime), CAST(N'2023-07-07T04:35:22.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (311, 13, 15, 17, N'2B', N'1B', CAST(N'2023-04-19T11:27:28.000' AS DateTime), CAST(N'2023-04-20T01:57:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (312, 10, 11, 16, N'2A', N'2C', CAST(N'2023-11-12T20:31:49.000' AS DateTime), CAST(N'2023-11-13T09:28:49.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (313, 15, 15, 7, N'2E', N'1C', CAST(N'2023-08-12T14:17:30.000' AS DateTime), CAST(N'2023-08-13T04:49:30.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (314, 4, 8, 10, N'2F', N'2C', CAST(N'2023-09-24T06:34:48.000' AS DateTime), CAST(N'2023-09-24T19:10:48.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (315, 1, 15, 3, N'2F', N'2D', CAST(N'2023-10-30T00:18:50.000' AS DateTime), CAST(N'2023-10-30T04:15:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (316, 10, 5, 17, N'2F', N'1A', CAST(N'2023-04-27T00:59:11.000' AS DateTime), CAST(N'2023-04-27T17:33:11.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (317, 15, 12, 14, N'1D', N'1C', CAST(N'2023-07-03T19:03:54.000' AS DateTime), CAST(N'2023-07-03T21:55:54.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (318, 5, 3, 2, N'2C', N'1C', CAST(N'2023-05-02T12:54:49.000' AS DateTime), CAST(N'2023-05-02T22:28:49.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (319, 16, 17, 9, N'2D', N'1D', CAST(N'2023-12-17T12:39:05.000' AS DateTime), CAST(N'2023-12-17T17:21:05.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (320, 16, 12, 14, N'1D', N'2C', CAST(N'2023-02-20T19:09:06.000' AS DateTime), CAST(N'2023-02-20T22:01:06.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (321, 12, 1, 19, N'2E', N'2D', CAST(N'2023-07-30T20:26:27.000' AS DateTime), CAST(N'2023-07-31T06:02:27.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (322, 11, 6, 9, N'1B', N'2D', CAST(N'2023-11-23T05:11:09.000' AS DateTime), CAST(N'2023-11-23T21:05:09.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (323, 13, 15, 11, N'2D', N'2A', CAST(N'2024-01-22T05:50:34.000' AS DateTime), CAST(N'2024-01-22T18:47:34.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (324, 14, 13, 15, N'1C', N'2C', CAST(N'2023-03-06T16:29:28.000' AS DateTime), CAST(N'2023-03-06T22:15:28.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (325, 18, 11, 10, N'2B', N'2B', CAST(N'2023-09-16T15:20:07.000' AS DateTime), CAST(N'2023-09-17T01:13:07.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (326, 16, 13, 1, N'2A', N'2C', CAST(N'2023-11-06T10:13:47.000' AS DateTime), CAST(N'2023-11-06T19:49:47.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (327, 18, 17, 11, N'2E', N'2A', CAST(N'2023-04-22T01:40:21.000' AS DateTime), CAST(N'2023-04-22T04:25:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (328, 11, 16, 3, N'2B', N'2E', CAST(N'2023-02-18T05:16:14.000' AS DateTime), CAST(N'2023-02-18T09:13:14.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (329, 16, 2, 7, N'2F', N'1B', CAST(N'2024-02-02T22:20:45.000' AS DateTime), CAST(N'2024-02-03T14:14:45.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (330, 4, 7, 9, N'1A', N'2B', CAST(N'2023-02-25T03:04:50.000' AS DateTime), CAST(N'2023-02-25T12:40:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (331, 8, 9, 16, N'1B', N'2B', CAST(N'2023-05-20T00:59:50.000' AS DateTime), CAST(N'2023-05-20T15:31:50.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (332, 7, 12, 17, N'2B', N'1D', CAST(N'2023-03-23T05:47:38.000' AS DateTime), CAST(N'2023-03-23T18:40:38.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (333, 17, 15, 13, N'2C', N'2A', CAST(N'2023-09-14T15:54:47.000' AS DateTime), CAST(N'2023-09-14T21:40:47.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (334, 7, 15, 17, N'2F', N'2E', CAST(N'2024-01-08T20:48:21.000' AS DateTime), CAST(N'2024-01-09T11:18:21.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (335, 15, 5, 18, N'2C', N'2D', CAST(N'2023-11-08T13:51:00.000' AS DateTime), CAST(N'2023-11-09T06:25:00.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (336, 7, 2, 9, N'2F', N'1D', CAST(N'2023-08-30T16:07:12.000' AS DateTime), CAST(N'2023-08-31T08:01:12.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (337, 12, 12, 18, N'2C', N'2B', CAST(N'2023-05-19T07:41:14.000' AS DateTime), CAST(N'2023-05-19T20:34:14.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (338, 20, 14, 13, N'1A', N'2A', CAST(N'2023-12-12T07:17:17.000' AS DateTime), CAST(N'2023-12-12T16:53:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (339, 17, 19, 8, N'2C', N'2E', CAST(N'2023-07-02T13:12:35.000' AS DateTime), CAST(N'2023-07-02T22:48:35.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (340, 7, 1, 14, N'2F', N'1D', CAST(N'2024-01-17T21:34:55.000' AS DateTime), CAST(N'2024-01-18T07:10:55.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (341, 20, 2, 16, N'1B', N'2D', CAST(N'2023-04-29T16:51:10.000' AS DateTime), CAST(N'2023-04-30T00:48:10.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (342, 17, 6, 3, N'2F', N'2E', CAST(N'2023-12-18T05:28:02.000' AS DateTime), CAST(N'2023-12-18T15:02:02.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (343, 4, 2, 3, N'1B', N'2A', CAST(N'2024-01-05T15:37:03.000' AS DateTime), CAST(N'2024-01-06T01:11:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (344, 12, 2, 8, N'2D', N'1A', CAST(N'2023-03-16T19:38:55.000' AS DateTime), CAST(N'2023-03-17T05:14:55.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (345, 5, 18, 6, N'1D', N'2E', CAST(N'2023-04-10T03:16:17.000' AS DateTime), CAST(N'2023-04-10T19:50:17.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (346, 17, 8, 1, N'2C', N'2E', CAST(N'2023-06-08T20:56:33.000' AS DateTime), CAST(N'2023-06-09T06:32:33.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (347, 2, 18, 20, N'2F', N'1D', CAST(N'2023-06-21T11:13:03.000' AS DateTime), CAST(N'2023-06-21T19:12:03.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (348, 3, 6, 12, N'2E', N'2E', CAST(N'2024-01-30T16:52:19.000' AS DateTime), CAST(N'2024-01-31T00:29:19.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (349, 6, 13, 6, N'2A', N'1C', CAST(N'2023-07-16T11:43:49.000' AS DateTime), CAST(N'2023-07-16T21:19:49.000' AS DateTime))
INSERT [dbo].[flight] ([id], [airline_id], [departing_airport], [arriving_airport], [departing_gate], [arriving_gate], [departure_time], [arrival_time]) VALUES (350, 11, 5, 14, N'1D', N'1C', CAST(N'2023-08-18T09:24:40.000' AS DateTime), CAST(N'2023-08-18T19:00:40.000' AS DateTime))
GO
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (1, 'Taddeo', 'Rabjohns', 'trabjohns0@so-net.ne.jp', 'Male', '1974-06-29', 'Mongolia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (2, 'Rad', 'Baudins', 'rbaudins1@ihg.com', 'Male', '1975-05-31', 'Bulgaria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (3, 'Kylila', 'Millins', 'kmillins2@utexas.edu', 'Female', '1944-02-09', 'Israel');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (4, 'Amalie', 'Okeshott', 'aokeshott3@independent.co.uk', 'Female', '1941-02-09', 'Morocco');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (5, 'Denis', 'Buckhurst', 'dbuckhurst4@webnode.com', 'Male', '1982-11-04', 'Costa Rica');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (6, 'Laurens', 'Vaen', 'lvaen5@hao123.com', 'Male', '2002-03-16', 'Bangladesh');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (7, 'Gabrila', 'Pattingson', 'gpattingson6@yellowbook.com', 'Female', '1983-01-16', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (8, 'Dorian', 'Huntly', 'dhuntly7@nsw.gov.au', 'Male', '1974-02-01', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (9, 'Catlin', 'Cockill', 'ccockill8@npr.org', 'Female', '1959-11-24', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (10, 'Thorndike', 'Kenton', 'tkenton9@studiopress.com', 'Female', '1937-05-03', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (11, 'Cathryn', 'Noyce', 'cnoycea@hhs.gov', 'Female', '2014-05-30', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (12, 'Dun', 'Ellum', 'dellumb@apple.com', 'Male', '1950-04-20', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (13, 'Sterling', 'Brockie', 'sbrockiec@biblegateway.com', 'Male', '2002-10-11', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (14, 'Ronni', 'Scargill', 'rscargilld@sitemeter.com', 'Female', '1989-05-06', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (15, 'Ezechiel', 'Monkeman', 'emonkemane@mozilla.com', 'Male', '1994-01-31', 'Paraguay');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (16, 'Colette', 'Winchcombe', 'cwinchcombef@ameblo.jp', 'Female', '2007-09-27', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (17, 'Lanie', 'Fryd', 'lfrydg@1688.com', 'Male', '1959-04-22', 'Nigeria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (18, 'Birgitta', 'Stiddard', 'bstiddardh@liveinternet.ru', 'Female', '1973-07-07', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (19, 'Bendick', 'Scoates', 'bscoatesi@vk.com', 'Male', '1948-03-05', 'Cyprus');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (20, 'Zahara', 'Fesby', 'zfesbyj@bravesites.com', 'Female', '1975-08-20', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (21, 'Dorie', 'McClenan', 'dmcclenank@sciencedaily.com', 'Male', '1990-08-15', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (22, 'Augy', 'Walliker', 'awallikerl@go.com', 'Male', '1965-08-10', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (23, 'Greta', 'Cadman', 'gcadmanm@cnet.com', 'Female', '1956-09-19', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (24, 'Bernard', 'Bercevelo', 'bbercevelon@github.io', 'Male', '1982-06-01', 'Albania');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (25, 'Galvin', 'Furphy', 'gfurphyo@opensource.org', 'Male', '1978-12-09', 'Argentina');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (26, 'Jayson', 'Cowen', 'jcowenp@nhs.uk', 'Male', '1939-10-10', 'Georgia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (27, 'Borg', 'Creswell', 'bcreswellq@twitpic.com', 'Male', '1941-02-03', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (28, 'Shelly', 'Skilton', 'sskiltonr@photobucket.com', 'Female', '2007-02-20', 'Vietnam');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (29, 'Jake', 'Graffham', 'jgraffhams@topsy.com', 'Male', '2008-05-22', 'Finland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (30, 'Candie', 'Yearne', 'cyearnet@stanford.edu', 'Female', '1968-05-23', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (31, 'Marius', 'Havock', 'mhavocku@smh.com.au', 'Male', '1937-07-29', 'Saudi Arabia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (32, 'Cheston', 'Gowler', 'cgowlerv@mozilla.com', 'Male', '1960-03-30', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (33, 'Amargo', 'Ternouth', 'aternouthw@ovh.net', 'Male', '2005-07-17', 'Croatia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (34, 'Willabella', 'Cristofalo', 'wcristofalox@usda.gov', 'Female', '2003-10-02', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (35, 'Eachelle', 'Grealy', 'egrealyy@weather.com', 'Female', '2023-03-08', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (36, 'Corrine', 'Sackur', 'csackurz@wix.com', 'Female', '1967-01-21', 'Venezuela');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (37, 'Julita', 'Dalziell', 'jdalziell10@histats.com', 'Female', '2005-04-09', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (38, 'Bella', 'Aikman', 'baikman11@unblog.fr', 'Female', '1934-08-21', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (39, 'Mendy', 'Audibert', 'maudibert12@sakura.ne.jp', 'Male', '1951-12-24', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (40, 'Nadeen', 'Yeskin', 'nyeskin13@ebay.co.uk', 'Female', '2020-08-23', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (41, 'Amalle', 'Occleshaw', 'aoccleshaw14@creativecommons.org', 'Female', '2016-02-24', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (42, 'Bard', 'Dzeniskevich', 'bdzeniskevich15@sitemeter.com', 'Male', '2002-02-10', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (43, 'Wilden', 'Steketee', 'wsteketee16@sfgate.com', 'Male', '1970-11-03', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (44, 'Drusie', 'Brabin', 'dbrabin17@zimbio.com', 'Female', '1932-02-11', 'Nigeria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (45, 'Jayme', 'Beel', 'jbeel18@liveinternet.ru', 'Female', '1958-04-23', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (46, 'Rourke', 'Labern', 'rlabern19@who.int', 'Male', '1989-01-20', 'Uganda');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (47, 'Teddi', 'Renoden', 'trenoden1a@berkeley.edu', 'Female', '2023-05-14', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (48, 'Celle', 'Dessant', 'cdessant1b@gravatar.com', 'Female', '1943-06-24', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (49, 'Christean', 'Edds', 'cedds1c@myspace.com', 'Female', '1985-03-02', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (50, 'Andreas', 'Grundwater', 'agrundwater1d@pinterest.com', 'Male', '1993-11-19', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (51, 'Barny', 'Ivanyutin', 'bivanyutin1e@topsy.com', 'Male', '2017-11-11', 'Hungary');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (52, 'Marilyn', 'Chastang', 'mchastang1f@google.ca', 'Female', '2019-09-19', 'New Zealand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (53, 'Arther', 'Ainsbury', 'aainsbury1g@mapquest.com', 'Male', '1987-04-25', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (54, 'Diana', 'Seniour', 'dseniour1h@prnewswire.com', 'Female', '1998-02-06', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (55, 'Muire', 'Kilpin', 'mkilpin1i@scientificamerican.com', 'Female', '1949-09-18', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (56, 'Brenna', 'Verdie', 'bverdie1j@wikipedia.org', 'Female', '1955-05-14', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (57, 'Jerrilyn', 'Toth', 'jtoth1k@cargocollective.com', 'Female', '1956-07-13', 'Guatemala');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (58, 'Karoline', 'Orneblow', 'korneblow1l@google.de', 'Female', '2011-01-14', 'Jordan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (59, 'Angelle', 'Massimi', 'amassimi1m@studiopress.com', 'Female', '1998-07-05', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (60, 'Berri', 'Thurgood', 'bthurgood1n@theatlantic.com', 'Female', '2011-03-07', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (61, 'Lucias', 'Lipsett', 'llipsett1o@bandcamp.com', 'Male', '1963-10-06', 'Tanzania');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (62, 'Maryjane', 'Tyrer', 'mtyrer1p@china.com.cn', 'Female', '1944-09-22', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (63, 'Eugene', 'Durrans', 'edurrans1q@miitbeian.gov.cn', 'Male', '1978-01-22', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (64, 'Jackson', 'Nabbs', 'jnabbs1r@webs.com', 'Male', '1935-12-16', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (65, 'Dall', 'Fosher', 'dfosher1s@plala.or.jp', 'Male', '1994-10-05', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (66, 'Carolyn', 'Carleman', 'ccarleman1t@npr.org', 'Female', '1940-06-09', 'Uganda');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (67, 'Laurel', 'Buckner', 'lbuckner1u@bloglines.com', 'Female', '2004-03-08', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (68, 'George', 'Welman', 'gwelman1v@adobe.com', 'Male', '1999-11-11', 'Argentina');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (69, 'Thaddus', 'Pudsall', 'tpudsall1w@reuters.com', 'Male', '1941-01-02', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (70, 'Bernelle', 'Musla', 'bmusla1x@google.co.uk', 'Female', '1955-12-13', 'Venezuela');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (71, 'Kellby', 'Nansom', 'knansom1y@reverbnation.com', 'Male', '1973-08-16', 'Greece');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (72, 'Dugald', 'Seyler', 'dseyler1z@bloglines.com', 'Male', '1954-01-30', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (73, 'Legra', 'Pilcher', 'lpilcher20@hugedomains.com', 'Female', '1990-03-05', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (74, 'Stevana', 'Boughen', 'sboughen21@github.com', 'Female', '1959-11-07', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (75, 'Gill', 'Laboune', 'glaboune22@paypal.com', 'Male', '1942-02-27', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (76, 'Mindy', 'Busfield', 'mbusfield23@deliciousdays.com', 'Female', '1966-06-04', 'Chile');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (77, 'Perceval', 'Geffen', 'pgeffen24@nps.gov', 'Male', '2000-02-13', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (78, 'Henriette', 'Janus', 'hjanus25@amazonaws.com', 'Female', '2009-09-10', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (79, 'Ganny', 'O''Geaney', 'gogeaney26@google.pl', 'Male', '1937-09-06', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (80, 'Francesca', 'Murrhaupt', 'fmurrhaupt27@cisco.com', 'Female', '1942-04-21', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (81, 'Glenda', 'Busson', 'gbusson28@sciencedirect.com', 'Female', '2016-02-27', 'Kyrgyzstan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (82, 'Cecile', 'Klimschak', 'cklimschak29@cornell.edu', 'Female', '1936-01-01', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (83, 'Aurie', 'Rowaszkiewicz', 'arowaszkiewicz2a@rambler.ru', 'Female', '1953-09-14', 'Latvia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (84, 'Wyatt', 'Aland', 'waland2b@webs.com', 'Male', '1982-04-05', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (85, 'Krista', 'Anthes', 'kanthes2c@fastcompany.com', 'Female', '1953-07-08', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (86, 'Elena', 'Jerrim', 'ejerrim2d@constantcontact.com', 'Female', '1952-11-10', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (87, 'Percy', 'Stookes', 'pstookes2e@theglobeandmail.com', 'Male', '1956-12-09', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (88, 'Nicky', 'Casetti', 'ncasetti2f@washingtonpost.com', 'Male', '1947-02-11', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (89, 'Jasun', 'Amor', 'jamor2g@house.gov', 'Male', '2013-04-28', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (90, 'Immanuel', 'Flude', 'iflude2h@intel.com', 'Male', '1989-07-04', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (91, 'Janessa', 'Ottee', 'jottee2i@tinyurl.com', 'Female', '1961-08-12', 'Madagascar');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (92, 'Bobbye', 'Langworthy', 'blangworthy2j@npr.org', 'Female', '1931-02-24', 'Mali');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (93, 'Lee', 'O''Sherin', 'losherin2k@github.com', 'Female', '1975-07-24', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (94, 'Naomi', 'Innman', 'ninnman2l@netscape.com', 'Female', '2023-08-16', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (95, 'Shannan', 'Aubery', 'saubery2m@mtv.com', 'Female', '1941-10-16', 'South Korea');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (96, 'Karyl', 'Van de Vlies', 'kvandevlies2n@altervista.org', 'Female', '1972-08-11', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (97, 'Nefen', 'Beig', 'nbeig2o@economist.com', 'Male', '1993-03-18', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (98, 'Ashleigh', 'Raspin', 'araspin2p@kickstarter.com', 'Female', '2003-10-01', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (99, 'Camella', 'McCraine', 'cmccraine2q@wikispaces.com', 'Female', '1994-12-27', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (100, 'Alessandra', 'Burgum', 'aburgum2r@jugem.jp', 'Female', '1967-10-22', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (101, 'Eimile', 'Kerrich', 'ekerrich2s@earthlink.net', 'Female', '1990-02-21', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (102, 'Shelley', 'Devons', 'sdevons2t@squidoo.com', 'Male', '1969-06-29', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (103, 'Raviv', 'Debnam', 'rdebnam2u@yandex.ru', 'Male', '1938-02-09', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (104, 'Tome', 'Hinckesman', 'thinckesman2v@elpais.com', 'Male', '1954-07-24', 'North Korea');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (105, 'Allison', 'Alsop', 'aalsop2w@psu.edu', 'Female', '1996-10-03', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (106, 'Washington', 'Quennell', 'wquennell2x@mashable.com', 'Male', '1937-03-06', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (107, 'Stacia', 'Jarlmann', 'sjarlmann2y@amazon.de', 'Female', '1938-07-31', 'Ethiopia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (108, 'Phylys', 'Waple', 'pwaple2z@joomla.org', 'Female', '2016-01-21', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (109, 'Tiphany', 'Lokier', 'tlokier30@simplemachines.org', 'Female', '1952-05-07', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (110, 'Leighton', 'Braam', 'lbraam31@indiatimes.com', 'Male', '1957-04-07', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (111, 'Umeko', 'McGaugan', 'umcgaugan32@businesswire.com', 'Female', '2011-09-13', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (112, 'Merci', 'Dumpleton', 'mdumpleton33@stumbleupon.com', 'Male', '1935-03-06', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (113, 'Juana', 'Derdes', 'jderdes34@i2i.jp', 'Female', '1973-08-16', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (114, 'Bren', 'Nibley', 'bnibley35@answers.com', 'Female', '2010-12-21', 'Palestinian Territory');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (115, 'Anselma', 'Munkley', 'amunkley36@miitbeian.gov.cn', 'Female', '1955-11-15', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (116, 'Clim', 'Bosquet', 'cbosquet37@toplist.cz', 'Male', '2007-12-22', 'Colombia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (117, 'Corine', 'Jurczak', 'cjurczak38@jimdo.com', 'Female', '1981-06-15', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (118, 'Tibold', 'Lewnden', 'tlewnden39@yellowpages.com', 'Male', '1938-08-19', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (119, 'Cleve', 'Orring', 'corring3a@reference.com', 'Male', '1954-10-15', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (120, 'Mylo', 'Bassingden', 'mbassingden3b@cmu.edu', 'Male', '1952-04-18', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (121, 'Tallia', 'Gamell', 'tgamell3c@ebay.co.uk', 'Female', '1967-10-27', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (122, 'Read', 'Hicken', 'rhicken3d@chron.com', 'Male', '2021-08-01', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (123, 'Helaine', 'Towell', 'htowell3e@fastcompany.com', 'Female', '1955-02-17', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (124, 'Heath', 'Gask', 'hgask3f@prweb.com', 'Male', '2015-03-08', 'Serbia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (125, 'Claribel', 'Brendish', 'cbrendish3g@nymag.com', 'Female', '2000-09-01', 'Pakistan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (126, 'Katti', 'Hardwin', 'khardwin3h@alibaba.com', 'Female', '1969-04-12', 'Slovenia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (127, 'Gerri', 'Drinkhall', 'gdrinkhall3i@tumblr.com', 'Female', '1981-08-21', 'Yemen');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (128, 'Marybelle', 'Craske', 'mcraske3j@ning.com', 'Female', '2000-03-06', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (129, 'Verina', 'Vasilischev', 'vvasilischev3k@geocities.com', 'Female', '1939-02-26', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (130, 'Robb', 'Lille', 'rlille3l@dell.com', 'Male', '1958-12-01', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (131, 'Lindon', 'Delgado', 'ldelgado3m@prnewswire.com', 'Male', '1977-10-02', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (132, 'Marje', 'Biset', 'mbiset3n@mozilla.com', 'Female', '1984-05-03', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (133, 'Hillary', 'Bennitt', 'hbennitt3o@diigo.com', 'Female', '1948-03-19', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (134, 'Koral', 'Elijah', 'kelijah3p@last.fm', 'Female', '1962-04-14', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (135, 'Josias', 'Claremont', 'jclaremont3q@reverbnation.com', 'Male', '1951-11-24', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (136, 'Otha', 'Isacq', 'oisacq3r@bigcartel.com', 'Female', '1989-03-25', 'Belarus');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (137, 'Wernher', 'Macallam', 'wmacallam3s@symantec.com', 'Male', '2022-07-24', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (138, 'Borden', 'Barnett', 'bbarnett3t@smh.com.au', 'Male', '1965-07-07', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (139, 'Nanice', 'Gallichiccio', 'ngallichiccio3u@merriam-webster.com', 'Female', '2012-01-15', 'Yemen');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (140, 'Demeter', 'Larrie', 'dlarrie3v@thetimes.co.uk', 'Male', '2007-10-14', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (141, 'Ramsey', 'Chittleburgh', 'rchittleburgh3w@meetup.com', 'Male', '1958-09-11', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (142, 'Douglas', 'Kynge', 'dkynge3x@bbb.org', 'Male', '1944-09-05', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (143, 'Dario', 'Geraud', 'dgeraud3y@skype.com', 'Male', '1958-02-25', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (144, 'Lindie', 'Mullaly', 'lmullaly3z@jalbum.net', 'Female', '1992-12-29', 'Morocco');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (145, 'Madge', 'Ditchfield', 'mditchfield40@soup.io', 'Female', '1991-05-16', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (146, 'Roy', 'Beckhouse', 'rbeckhouse41@odnoklassniki.ru', 'Male', '1972-11-01', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (147, 'Babbette', 'Punter', 'bpunter42@washington.edu', 'Female', '1943-07-17', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (148, 'Malinda', 'Larby', 'mlarby43@dot.gov', 'Female', '2001-06-23', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (149, 'Lorrin', 'Ovendale', 'lovendale44@yale.edu', 'Female', '1956-09-08', 'Germany');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (150, 'Lazare', 'Rodge', 'lrodge45@chicagotribune.com', 'Male', '1992-10-20', 'Egypt');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (151, 'Mozelle', 'Rowbottom', 'mrowbottom46@mac.com', 'Female', '1930-09-25', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (152, 'Adelbert', 'Pech', 'apech47@sfgate.com', 'Male', '1992-10-16', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (153, 'Diena', 'Bazley', 'dbazley48@gov.uk', 'Female', '1994-01-05', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (154, 'Cal', 'Fortesquieu', 'cfortesquieu49@wikipedia.org', 'Male', '1944-10-17', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (155, 'Novelia', 'O''Docherty', 'nodocherty4a@artisteer.com', 'Female', '1966-01-30', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (156, 'Alley', 'Sarle', 'asarle4b@biglobe.ne.jp', 'Male', '2011-02-09', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (157, 'Crystal', 'Gounet', 'cgounet4c@ovh.net', 'Male', '1982-06-26', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (158, 'Gabi', 'Moye', 'gmoye4d@ihg.com', 'Male', '1987-10-19', 'Serbia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (159, 'Leonard', 'Sloyan', 'lsloyan4e@wikispaces.com', 'Male', '1981-11-01', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (160, 'Kaylil', 'Paula', 'kpaula4f@dell.com', 'Female', '1948-05-30', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (161, 'Kacie', 'Tiddy', 'ktiddy4g@shareasale.com', 'Female', '1985-08-07', 'Croatia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (162, 'Carol', 'Sparway', 'csparway4h@auda.org.au', 'Female', '1978-11-20', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (163, 'Frankie', 'Pohlke', 'fpohlke4i@mozilla.com', 'Male', '1988-04-18', 'Georgia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (164, 'Roby', 'Pietesch', 'rpietesch4j@marketwatch.com', 'Female', '1992-11-24', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (165, 'Annadiane', 'Heintze', 'aheintze4k@behance.net', 'Female', '1950-01-28', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (166, 'Gaylord', 'Gresley', 'ggresley4l@sitemeter.com', 'Male', '1986-10-15', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (167, 'Amery', 'Rudland', 'arudland4m@tripod.com', 'Male', '1957-12-22', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (168, 'Grannie', 'Castillon', 'gcastillon4n@ca.gov', 'Male', '1964-12-10', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (169, 'Nessy', 'Mawer', 'nmawer4o@furl.net', 'Female', '1990-06-26', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (170, 'Bennie', 'Netley', 'bnetley4p@github.io', 'Male', '1966-06-23', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (171, 'Hobey', 'Tibbotts', 'htibbotts4q@cbc.ca', 'Male', '1992-08-08', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (172, 'Adolf', 'Firmage', 'afirmage4r@psu.edu', 'Male', '1977-08-23', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (173, 'Tracey', 'Elham', 'telham4s@canalblog.com', 'Female', '1985-04-23', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (174, 'Faina', 'Dubarry', 'fdubarry4t@booking.com', 'Female', '1949-09-23', 'Argentina');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (175, 'Rodi', 'Saur', 'rsaur4u@amazon.de', 'Female', '1985-05-23', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (176, 'Sisely', 'Greave', 'sgreave4v@webmd.com', 'Female', '2008-01-16', 'South Korea');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (177, 'Karissa', 'Balasini', 'kbalasini4w@privacy.gov.au', 'Female', '2000-04-21', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (178, 'Natala', 'Wonter', 'nwonter4x@xinhuanet.com', 'Female', '1997-11-11', 'Iran');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (179, 'Isaac', 'Nesbeth', 'inesbeth4y@dmoz.org', 'Male', '1966-11-21', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (180, 'Robinetta', 'Graalman', 'rgraalman4z@ftc.gov', 'Female', '1940-10-05', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (181, 'Edgar', 'Jako', 'ejako50@phpbb.com', 'Male', '1977-03-07', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (182, 'Amabel', 'Giovannilli', 'agiovannilli51@dailymotion.com', 'Female', '1979-03-04', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (183, 'Tuesday', 'Beccles', 'tbeccles52@gmpg.org', 'Female', '2013-11-02', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (184, 'Guido', 'Calbert', 'gcalbert53@washingtonpost.com', 'Male', '1985-04-29', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (185, 'Giacobo', 'Ronayne', 'gronayne54@google.ca', 'Male', '1951-12-09', 'Canada');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (186, 'Zoe', 'Whitcombe', 'zwhitcombe55@uiuc.edu', 'Female', '1971-01-11', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (187, 'Odo', 'Crewe', 'ocrewe56@nymag.com', 'Male', '1971-01-19', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (188, 'Jenica', 'Eddolls', 'jeddolls57@is.gd', 'Female', '1938-03-08', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (189, 'Rodolphe', 'Rominov', 'rrominov58@php.net', 'Male', '1947-11-08', 'Panama');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (190, 'Beverie', 'Robard', 'brobard59@unc.edu', 'Female', '1975-11-04', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (191, 'Waldemar', 'Birmingham', 'wbirmingham5a@clickbank.net', 'Male', '1964-01-10', 'Serbia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (192, 'Candide', 'Briars', 'cbriars5b@businessinsider.com', 'Female', '2018-05-07', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (193, 'Stephine', 'Dummer', 'sdummer5c@ow.ly', 'Female', '1948-01-09', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (194, 'Abbe', 'Goley', 'agoley5d@edublogs.org', 'Female', '2014-12-22', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (195, 'Patrizius', 'Fishbourne', 'pfishbourne5e@studiopress.com', 'Male', '2017-01-12', 'Serbia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (196, 'Henry', 'Richemond', 'hrichemond5f@icq.com', 'Male', '1943-01-27', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (197, 'Melinda', 'Bartczak', 'mbartczak5g@github.io', 'Female', '1973-06-09', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (198, 'Lock', 'Starr', 'lstarr5h@taobao.com', 'Male', '1985-12-11', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (199, 'Zorah', 'Casoni', 'zcasoni5i@google.nl', 'Female', '2012-04-05', 'Syria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (200, 'Donall', 'Yitshak', 'dyitshak5j@kickstarter.com', 'Male', '2023-02-14', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (201, 'Teresita', 'Lampitt', 'tlampitt5k@paypal.com', 'Female', '1948-01-09', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (202, 'Terrie', 'Tatford', 'ttatford5l@flavors.me', 'Female', '1959-05-20', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (203, 'Niels', 'Corneljes', 'ncorneljes5m@geocities.com', 'Male', '1962-04-17', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (204, 'Tish', 'Early', 'tearly5n@linkedin.com', 'Female', '1972-12-01', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (205, 'Buckie', 'Jaram', 'bjaram5o@dot.gov', 'Male', '1956-11-24', 'Albania');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (206, 'Art', 'Austing', 'aausting5p@arizona.edu', 'Male', '1939-12-23', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (207, 'Humfried', 'Bassham', 'hbassham5q@comcast.net', 'Male', '1968-03-05', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (208, 'Meara', 'Phant', 'mphant5r@examiner.com', 'Female', '1964-11-29', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (209, 'Faustina', 'Ayllett', 'fayllett5s@sbwire.com', 'Female', '1969-09-22', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (210, 'Noami', 'Dosdill', 'ndosdill5t@slideshare.net', 'Female', '1939-12-13', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (211, 'Chickie', 'Gilliam', 'cgilliam5u@linkedin.com', 'Male', '1935-03-11', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (212, 'Elsa', 'Tupper', 'etupper5v@ftc.gov', 'Female', '2006-02-11', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (213, 'Barbra', 'Bruce', 'bbruce5w@mapquest.com', 'Female', '2019-09-30', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (214, 'Dionne', 'Sandham', 'dsandham5x@alexa.com', 'Female', '1990-04-10', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (215, 'Stevana', 'Mahomet', 'smahomet5y@apache.org', 'Female', '2016-12-23', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (216, 'Huberto', 'Rudram', 'hrudram5z@sciencedaily.com', 'Male', '1998-05-29', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (217, 'Jervis', 'Dorow', 'jdorow60@sourceforge.net', 'Male', '1969-08-24', 'Mexico');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (218, 'Noble', 'Gillon', 'ngillon61@earthlink.net', 'Male', '1962-05-22', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (219, 'Ogdon', 'Cowing', 'ocowing62@hc360.com', 'Male', '1973-03-12', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (220, 'Tessa', 'Bendix', 'tbendix63@yahoo.co.jp', 'Female', '1961-10-21', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (221, 'Eleen', 'Downgate', 'edowngate64@tripod.com', 'Female', '1947-08-08', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (222, 'Janelle', 'Roddam', 'jroddam65@utexas.edu', 'Female', '2005-09-25', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (223, 'Ardys', 'Jefford', 'ajefford66@redcross.org', 'Female', '1991-09-19', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (224, 'Jed', 'Mulholland', 'jmulholland67@squidoo.com', 'Male', '1957-11-09', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (225, 'Lilllie', 'Apark', 'lapark68@goo.gl', 'Female', '1977-02-24', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (226, 'Pablo', 'McGauhy', 'pmcgauhy69@nhs.uk', 'Male', '1969-02-22', 'Afghanistan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (227, 'Yoshiko', 'Clemmey', 'yclemmey6a@ustream.tv', 'Female', '1977-02-17', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (228, 'Beau', 'Willoughby', 'bwilloughby6b@cbc.ca', 'Male', '2015-12-11', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (229, 'Isadora', 'Hymans', 'ihymans6c@japanpost.jp', 'Female', '2019-10-03', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (230, 'Tadio', 'Bolduc', 'tbolduc6d@bing.com', 'Male', '1974-08-19', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (231, 'Beaufort', 'Slyman', 'bslyman6e@nih.gov', 'Male', '1937-03-06', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (232, 'Zacherie', 'Antognetti', 'zantognetti6f@latimes.com', 'Male', '2013-09-22', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (233, 'Shirley', 'Kimbrough', 'skimbrough6g@netvibes.com', 'Female', '1964-05-01', 'Honduras');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (234, 'Kim', 'Shrieve', 'kshrieve6h@youtube.com', 'Male', '1986-08-14', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (235, 'Peter', 'Dutteridge', 'pdutteridge6i@sitemeter.com', 'Male', '2019-03-21', 'Denmark');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (236, 'Eamon', 'Lorent', 'elorent6j@networksolutions.com', 'Male', '1956-03-08', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (237, 'Lionel', 'Taree', 'ltaree6k@elpais.com', 'Male', '1932-02-29', 'Morocco');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (238, 'Nolie', 'Waby', 'nwaby6l@ow.ly', 'Female', '1968-11-16', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (239, 'Benny', 'Panting', 'bpanting6m@oracle.com', 'Male', '1931-11-29', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (240, 'Tybalt', 'Mirfield', 'tmirfield6n@wordpress.org', 'Male', '1989-12-30', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (241, 'Olav', 'Kroger', 'okroger6o@google.co.jp', 'Male', '2020-12-03', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (242, 'Jeramey', 'Huegett', 'jhuegett6p@digg.com', 'Male', '2009-09-07', 'Laos');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (243, 'Verna', 'Mewburn', 'vmewburn6q@dell.com', 'Female', '1975-11-13', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (244, 'Levon', 'Archibald', 'larchibald6r@businessinsider.com', 'Male', '1990-09-13', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (245, 'Arel', 'Reams', 'areams6s@dmoz.org', 'Male', '1965-04-24', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (246, 'Matthew', 'Napoli', 'mnapoli6t@hp.com', 'Male', '1983-03-03', 'Bulgaria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (247, 'Dehlia', 'Hiddy', 'dhiddy6u@umich.edu', 'Female', '1972-11-16', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (248, 'Rikki', 'Kinnerley', 'rkinnerley6v@bloomberg.com', 'Male', '1966-11-10', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (249, 'Celestina', 'Maulkin', 'cmaulkin6w@hhs.gov', 'Female', '2017-02-21', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (250, 'Marisa', 'Sant', 'msant6x@yelp.com', 'Female', '1957-03-28', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (251, 'Gene', 'Skeermor', 'gskeermor6y@msn.com', 'Female', '1979-11-21', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (252, 'Zach', 'Abrashkin', 'zabrashkin6z@weebly.com', 'Male', '1971-05-18', 'Azerbaijan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (253, 'Korella', 'Bastistini', 'kbastistini70@reference.com', 'Female', '2001-12-08', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (254, 'Madelin', 'Yuryichev', 'myuryichev71@google.com.br', 'Female', '1959-02-06', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (255, 'Viki', 'Febry', 'vfebry72@ed.gov', 'Female', '1972-04-18', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (256, 'Konstantin', 'Sherrock', 'ksherrock73@globo.com', 'Male', '1960-04-23', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (257, 'Gwenni', 'O''Brogane', 'gobrogane74@sohu.com', 'Female', '1946-04-10', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (258, 'Annice', 'O''Dare', 'aodare75@scribd.com', 'Female', '2019-03-10', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (259, 'Hercule', 'Dumbreck', 'hdumbreck76@sfgate.com', 'Male', '1959-11-29', 'Mexico');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (260, 'Tabbi', 'Beevis', 'tbeevis77@themeforest.net', 'Female', '1968-08-22', 'Tunisia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (261, 'Harrie', 'Buckingham', 'hbuckingham78@usa.gov', 'Male', '1974-07-12', 'Chile');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (262, 'Joana', 'Pummell', 'jpummell79@msu.edu', 'Female', '1976-01-15', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (263, 'Ignazio', 'Hartnell', 'ihartnell7a@elegantthemes.com', 'Male', '1997-10-04', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (264, 'Veriee', 'Ausher', 'vausher7b@wunderground.com', 'Female', '1998-01-19', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (265, 'Mano', 'Kezar', 'mkezar7c@alibaba.com', 'Male', '1961-08-10', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (266, 'Verna', 'Mayers', 'vmayers7d@amazon.co.jp', 'Female', '1968-01-11', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (267, 'Valery', 'Mattschas', 'vmattschas7e@w3.org', 'Female', '1946-03-15', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (268, 'Simona', 'Cresar', 'scresar7f@arizona.edu', 'Female', '1992-12-19', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (269, 'Kipper', 'Sprionghall', 'ksprionghall7g@parallels.com', 'Male', '1991-12-26', 'Greece');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (270, 'Pall', 'Ablott', 'pablott7h@sphinn.com', 'Male', '2005-01-25', 'Canada');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (271, 'Boote', 'Stendell', 'bstendell7i@sina.com.cn', 'Male', '1950-02-05', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (272, 'Salomi', 'Kennerknecht', 'skennerknecht7j@dailymail.co.uk', 'Female', '1954-12-15', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (273, 'Tull', 'Strutz', 'tstrutz7k@oaic.gov.au', 'Male', '1968-07-01', 'Iran');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (274, 'Hollis', 'Boyack', 'hboyack7l@tripadvisor.com', 'Male', '1968-10-26', 'South Korea');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (275, 'Hilde', 'Sibbert', 'hsibbert7m@nature.com', 'Female', '2017-12-24', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (276, 'Carroll', 'Curnucke', 'ccurnucke7n@washington.edu', 'Male', '1980-01-05', 'Syria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (277, 'Neall', 'Villalta', 'nvillalta7o@webeden.co.uk', 'Male', '1956-11-02', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (278, 'Evan', 'Joice', 'ejoice7p@wisc.edu', 'Male', '1995-02-14', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (279, 'Sammie', 'Noir', 'snoir7q@mapquest.com', 'Male', '1955-07-21', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (280, 'Bald', 'Prothero', 'bprothero7r@ask.com', 'Male', '1954-08-13', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (281, 'Erin', 'Aggis', 'eaggis7s@arizona.edu', 'Female', '1958-07-02', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (282, 'Yanaton', 'Luten', 'yluten7t@ucoz.com', 'Male', '2020-12-27', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (283, 'Lucia', 'Luce', 'lluce7u@chron.com', 'Female', '1983-06-05', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (284, 'Derek', 'McKall', 'dmckall7v@ihg.com', 'Male', '2002-12-17', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (285, 'Nil', 'Petrozzi', 'npetrozzi7w@tuttocitta.it', 'Male', '2024-01-29', 'Zambia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (286, 'Pernell', 'Schult', 'pschult7x@addtoany.com', 'Male', '1981-10-23', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (287, 'Joanie', 'Milmith', 'jmilmith7y@omniture.com', 'Female', '1937-07-01', 'Norway');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (288, 'Ashien', 'Tolwood', 'atolwood7z@ibm.com', 'Female', '1944-02-28', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (289, 'Sonnie', 'Lippo', 'slippo80@quantcast.com', 'Male', '1981-01-03', 'Syria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (290, 'Ward', 'Viste', 'wviste81@taobao.com', 'Male', '1952-10-31', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (291, 'Aurel', 'Bloomer', 'abloomer82@eepurl.com', 'Female', '1961-04-17', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (292, 'Salomone', 'Sarver', 'ssarver83@vinaora.com', 'Male', '1950-05-24', 'Israel');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (293, 'Mersey', 'Pierce', 'mpierce84@ning.com', 'Female', '1961-06-21', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (294, 'Skipton', 'Hevey', 'shevey85@mail.ru', 'Male', '2008-03-05', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (295, 'Fanchon', 'Laight', 'flaight86@bbb.org', 'Female', '2001-05-13', 'Iran');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (296, 'Lynnett', 'Deeble', 'ldeeble87@dyndns.org', 'Female', '1931-12-13', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (297, 'Mandi', 'Haughey', 'mhaughey88@acquirethisname.com', 'Female', '2007-02-09', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (298, 'Rubia', 'Stobbs', 'rstobbs89@yale.edu', 'Female', '1938-04-03', 'Nigeria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (299, 'Stuart', 'Greenham', 'sgreenham8a@telegraph.co.uk', 'Male', '1998-12-25', 'Kazakhstan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (300, 'Nealon', 'Dakhov', 'ndakhov8b@sciencedaily.com', 'Male', '1962-10-20', 'Serbia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (301, 'Hetty', 'Evelyn', 'hevelyn8c@squidoo.com', 'Female', '1958-02-23', 'Palestinian Territory');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (302, 'Alphonso', 'Wooder', 'awooder8d@mapy.cz', 'Male', '1979-11-01', 'Argentina');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (303, 'Jim', 'Bremmell', 'jbremmell8e@bloomberg.com', 'Male', '2011-05-13', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (304, 'Rhona', 'Hastler', 'rhastler8f@walmart.com', 'Female', '2004-12-29', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (305, 'Annmarie', 'Skin', 'askin8g@imageshack.us', 'Female', '2021-08-26', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (306, 'Obidiah', 'Baughn', 'obaughn8h@cdbaby.com', 'Male', '1949-05-10', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (307, 'Denys', 'Casoni', 'dcasoni8i@example.com', 'Male', '1986-01-31', 'Canada');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (308, 'Susy', 'Graysmark', 'sgraysmark8j@virginia.edu', 'Female', '1988-04-15', 'Malaysia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (309, 'Kevon', 'Blazek', 'kblazek8k@mayoclinic.com', 'Male', '1940-05-28', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (310, 'Milena', 'Winfred', 'mwinfred8l@nationalgeographic.com', 'Female', '2006-07-14', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (311, 'Gordie', 'Boase', 'gboase8m@google.es', 'Male', '1980-06-07', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (312, 'Estell', 'De Zuani', 'edezuani8n@live.com', 'Female', '2008-06-20', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (313, 'Hazel', 'Tonge', 'htonge8o@ucsd.edu', 'Female', '1955-07-26', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (314, 'Lucia', 'Trahmel', 'ltrahmel8p@pcworld.com', 'Female', '2016-11-02', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (315, 'Lucine', 'Goodlatt', 'lgoodlatt8q@scribd.com', 'Female', '2011-12-08', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (316, 'Hanna', 'Flewan', 'hflewan8r@miibeian.gov.cn', 'Female', '1949-03-17', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (317, 'Taite', 'Walworche', 'twalworche8s@twitter.com', 'Female', '1943-01-25', 'Portugal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (318, 'Devy', 'Pritchett', 'dpritchett8t@baidu.com', 'Male', '2016-01-13', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (319, 'Andria', 'Ripsher', 'aripsher8u@sohu.com', 'Female', '1995-07-24', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (320, 'Zachariah', 'Dries', 'zdries8v@sun.com', 'Male', '1971-09-24', 'Canada');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (321, 'Frankie', 'Bourdon', 'fbourdon8w@bbb.org', 'Male', '2002-10-27', 'Colombia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (322, 'Lynde', 'O''Nion', 'lonion8x@java.com', 'Female', '1998-05-15', 'Costa Rica');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (323, 'Obadias', 'Itzkov', 'oitzkov8y@list-manage.com', 'Male', '2021-02-12', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (324, 'Nanci', 'Strother', 'nstrother8z@dell.com', 'Female', '1958-03-07', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (325, 'Tammara', 'Schoenfisch', 'tschoenfisch90@blogtalkradio.com', 'Female', '1987-05-17', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (326, 'Lindsay', 'Le Noury', 'llenoury91@pagesperso-orange.fr', 'Female', '1974-04-19', 'Samoa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (327, 'Roman', 'Fabbro', 'rfabbro92@wufoo.com', 'Male', '1970-06-04', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (328, 'Margit', 'Stag', 'mstag93@prlog.org', 'Female', '1937-12-13', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (329, 'Elisabet', 'Fitzroy', 'efitzroy94@xing.com', 'Female', '1959-12-23', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (330, 'Humfried', 'Threadgill', 'hthreadgill95@cnbc.com', 'Male', '1931-09-23', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (331, 'Merrili', 'Kain', 'mkain96@plala.or.jp', 'Female', '1970-10-30', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (332, 'Tiff', 'Hargroves', 'thargroves97@hatena.ne.jp', 'Female', '1985-02-03', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (333, 'Fallon', 'Need', 'fneed98@twitpic.com', 'Female', '2007-09-17', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (334, 'Filia', 'Conen', 'fconen99@stumbleupon.com', 'Female', '2007-01-03', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (335, 'Faustine', 'Batting', 'fbatting9a@so-net.ne.jp', 'Female', '2019-05-20', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (336, 'Layne', 'Minor', 'lminor9b@php.net', 'Female', '1942-02-25', 'Latvia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (337, 'Katleen', 'Klimashevich', 'kklimashevich9c@bluehost.com', 'Female', '2007-11-24', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (338, 'Donnamarie', 'Farmiloe', 'dfarmiloe9d@salon.com', 'Female', '1970-10-12', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (339, 'Moss', 'Veltman', 'mveltman9e@people.com.cn', 'Male', '1931-08-30', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (340, 'Cristian', 'Baggott', 'cbaggott9f@webs.com', 'Male', '1950-02-20', 'Zimbabwe');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (341, 'Ivor', 'Blancowe', 'iblancowe9g@army.mil', 'Male', '1962-12-29', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (342, 'Zola', 'Vila', 'zvila9h@friendfeed.com', 'Female', '2014-11-21', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (343, 'Rance', 'Robrow', 'rrobrow9i@sina.com.cn', 'Male', '1937-10-27', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (344, 'Bobbie', 'Aubry', 'baubry9j@ask.com', 'Male', '2022-08-30', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (345, 'Cletis', 'Welford', 'cwelford9k@elpais.com', 'Male', '1988-02-25', 'Georgia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (346, 'Edith', 'Able', 'eable9l@psu.edu', 'Female', '1973-05-15', 'Honduras');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (347, 'Garrard', 'Fitzmaurice', 'gfitzmaurice9m@sphinn.com', 'Male', '1945-07-09', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (348, 'Marleen', 'Bourgeois', 'mbourgeois9n@nyu.edu', 'Female', '1988-05-27', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (349, 'Adi', 'Tchaikovsky', 'atchaikovsky9o@narod.ru', 'Female', '2016-04-11', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (350, 'Irwin', 'McGarva', 'imcgarva9p@joomla.org', 'Male', '2003-01-15', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (351, 'Jackson', 'Mellem', 'jmellem9q@cbc.ca', 'Male', '2017-09-23', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (352, 'Bourke', 'Duggan', 'bduggan9r@cbsnews.com', 'Male', '1995-04-06', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (353, 'Modesta', 'Doerr', 'mdoerr9s@dion.ne.jp', 'Female', '2001-05-11', 'North Korea');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (354, 'Linc', 'Carloni', 'lcarloni9t@live.com', 'Male', '1979-03-23', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (355, 'Terrye', 'Holgan', 'tholgan9u@whitehouse.gov', 'Female', '2023-04-19', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (356, 'Elias', 'Lissandri', 'elissandri9v@ebay.co.uk', 'Male', '2002-05-15', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (357, 'Aura', 'Webb-Bowen', 'awebbbowen9w@mysql.com', 'Female', '1962-08-09', 'Colombia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (358, 'Mandel', 'Braz', 'mbraz9x@studiopress.com', 'Male', '1946-12-11', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (359, 'Christophe', 'Walkington', 'cwalkington9y@sciencedaily.com', 'Male', '1982-02-18', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (360, 'Emlynn', 'McLese', 'emclese9z@admin.ch', 'Female', '2021-09-21', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (361, 'Lee', 'Danielsson', 'ldanielssona0@aol.com', 'Male', '2017-06-21', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (362, 'Charles', 'Jouaneton', 'cjouanetona1@adobe.com', 'Male', '1944-02-17', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (363, 'Carola', 'Drynan', 'cdrynana2@lulu.com', 'Female', '2000-03-19', 'Cambodia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (364, 'Maurie', 'Seif', 'mseifa3@google.it', 'Male', '2002-09-02', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (365, 'Loralyn', 'Garrie', 'lgarriea4@photobucket.com', 'Female', '1995-01-29', 'Ethiopia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (366, 'Vitoria', 'Cheyenne', 'vcheyennea5@army.mil', 'Female', '2013-07-11', 'Colombia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (367, 'Chiquita', 'Oxley', 'coxleya6@csmonitor.com', 'Female', '1952-03-05', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (368, 'Jarrod', 'Tomaskunas', 'jtomaskunasa7@netvibes.com', 'Male', '1989-12-03', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (369, 'Tallia', 'Ballin', 'tballina8@weibo.com', 'Female', '1940-07-11', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (370, 'Roseanne', 'Tomasek', 'rtomaseka9@exblog.jp', 'Female', '1947-07-26', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (371, 'Annie', 'Taplow', 'ataplowaa@geocities.jp', 'Female', '1939-12-07', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (372, 'Sile', 'Sever', 'sseverab@gov.uk', 'Female', '1931-04-29', 'Czech Republic');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (373, 'Renard', 'Feldfisher', 'rfeldfisherac@flickr.com', 'Male', '2014-06-12', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (374, 'Hermina', 'Rosander', 'hrosanderad@nytimes.com', 'Female', '1995-12-13', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (375, 'Alana', 'Peyro', 'apeyroae@163.com', 'Female', '2005-07-21', 'Nigeria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (376, 'Loydie', 'Gosz', 'lgoszaf@barnesandnoble.com', 'Female', '2002-04-18', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (377, 'Gilbert', 'Salasar', 'gsalasarag@cisco.com', 'Male', '1966-01-18', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (378, 'Melloney', 'Offiler', 'moffilerah@google.ca', 'Female', '2017-10-02', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (379, 'Robbert', 'Howsden', 'rhowsdenai@theguardian.com', 'Male', '1975-10-30', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (380, 'Vivienne', 'Andresen', 'vandresenaj@sciencedirect.com', 'Female', '1952-09-20', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (381, 'Boony', 'Clows', 'bclowsak@sina.com.cn', 'Male', '1947-11-06', 'Canada');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (382, 'Maure', 'Candelin', 'mcandelinal@fotki.com', 'Female', '2007-11-18', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (383, 'Thorstein', 'Cleyburn', 'tcleyburnam@wikia.com', 'Male', '1964-09-20', 'Iraq');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (384, 'Romy', 'Mulcock', 'rmulcockan@wunderground.com', 'Female', '2016-10-15', 'Mexico');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (385, 'Florence', 'Peartree', 'fpeartreeao@prlog.org', 'Female', '1951-10-30', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (386, 'Whit', 'Antonopoulos', 'wantonopoulosap@discuz.net', 'Male', '1974-04-04', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (387, 'Arch', 'Bostick', 'abostickaq@blogs.com', 'Male', '1963-04-08', 'Pakistan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (388, 'Siegfried', 'Chaplin', 'schaplinar@livejournal.com', 'Male', '1932-05-20', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (389, 'Berton', 'Troyes', 'btroyesas@fotki.com', 'Male', '2014-09-30', 'Serbia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (390, 'Faythe', 'Crucitti', 'fcrucittiat@businesswire.com', 'Female', '1953-10-06', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (391, 'Jenn', 'Roome', 'jroomeau@hc360.com', 'Female', '1967-11-23', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (392, 'Myca', 'Seemmonds', 'mseemmondsav@php.net', 'Male', '2010-04-03', 'Thailand');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (393, 'Ricard', 'Cranney', 'rcranneyaw@facebook.com', 'Male', '1955-10-28', 'Myanmar');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (394, 'Garfield', 'Harris', 'gharrisax@whitehouse.gov', 'Male', '1952-07-30', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (395, 'Elisabeth', 'Burgise', 'eburgiseay@artisteer.com', 'Female', '2008-03-20', 'Israel');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (396, 'Nikki', 'Shilburne', 'nshilburneaz@nhs.uk', 'Male', '1980-07-08', 'Rwanda');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (397, 'Bran', 'Fearey', 'bfeareyb0@myspace.com', 'Male', '1976-11-19', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (398, 'Shara', 'Bernette', 'sbernetteb1@google.it', 'Female', '2001-08-16', 'South Africa');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (399, 'Bobbi', 'Prosser', 'bprosserb2@senate.gov', 'Female', '1934-07-30', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (400, 'Barnett', 'Rodear', 'brodearb3@va.gov', 'Male', '1944-02-24', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (401, 'Elli', 'Matterson', 'emattersonb4@cam.ac.uk', 'Female', '2011-02-26', 'Venezuela');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (402, 'Rick', 'Greenhaugh', 'rgreenhaughb5@time.com', 'Male', '1961-08-15', 'Vietnam');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (403, 'Verla', 'Jinda', 'vjindab6@ovh.net', 'Female', '1964-07-19', 'Peru');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (404, 'Shari', 'Choke', 'schokeb7@oracle.com', 'Female', '1960-12-18', 'Croatia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (405, 'Twyla', 'Parres', 'tparresb8@go.com', 'Female', '2007-01-25', 'Albania');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (406, 'Dulcea', 'Cholonin', 'dcholoninb9@cargocollective.com', 'Female', '1947-03-20', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (407, 'Zarah', 'Frichley', 'zfrichleyba@facebook.com', 'Female', '1969-11-12', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (408, 'Lucy', 'Booij', 'lbooijbb@arstechnica.com', 'Female', '1972-10-06', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (409, 'Coral', 'Wiffler', 'cwifflerbc@imgur.com', 'Female', '1976-07-02', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (410, 'Ceciley', 'Fridlington', 'cfridlingtonbd@shareasale.com', 'Female', '1961-02-26', 'Cape Verde');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (411, 'Jobye', 'Sign', 'jsignbe@pcworld.com', 'Female', '1971-08-12', 'Kazakhstan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (412, 'Krissy', 'Downer', 'kdownerbf@tripadvisor.com', 'Female', '1938-11-30', 'Iceland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (413, 'Valeda', 'Sired', 'vsiredbg@blogger.com', 'Female', '1961-08-24', 'Macedonia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (414, 'Adi', 'Komorowski', 'akomorowskibh@upenn.edu', 'Male', '1962-12-13', 'Italy');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (415, 'Emyle', 'Sybbe', 'esybbebi@a8.net', 'Female', '1985-06-07', 'Mauritania');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (416, 'Teodorico', 'Cantera', 'tcanterabj@123-reg.co.uk', 'Male', '2020-11-07', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (417, 'Leone', 'McCree', 'lmccreebk@bloglovin.com', 'Female', '1961-08-15', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (418, 'Barrie', 'Ratke', 'bratkebl@baidu.com', 'Female', '1948-09-04', 'Uganda');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (419, 'Rudolfo', 'Willgress', 'rwillgressbm@whitehouse.gov', 'Male', '1955-07-20', 'Cambodia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (420, 'Gaye', 'Lilleman', 'glillemanbn@yahoo.co.jp', 'Female', '1988-07-10', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (421, 'Auria', 'Pashler', 'apashlerbo@blogtalkradio.com', 'Female', '1934-08-15', 'Malaysia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (422, 'Alejandrina', 'Kynaston', 'akynastonbp@archive.org', 'Female', '1951-02-27', 'Syria');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (423, 'Chadd', 'Adamovitch', 'cadamovitchbq@cnet.com', 'Male', '1996-12-13', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (424, 'Hunt', 'Littefair', 'hlittefairbr@ycombinator.com', 'Male', '1998-01-19', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (425, 'Vonny', 'Rentelll', 'vrentelllbs@csmonitor.com', 'Female', '1980-11-24', 'Finland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (426, 'Hanna', 'Crawley', 'hcrawleybt@ft.com', 'Female', '1949-01-08', 'France');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (427, 'Dolorita', 'Mounch', 'dmounchbu@wordpress.org', 'Female', '1976-12-30', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (428, 'Corbin', 'McPhillips', 'cmcphillipsbv@dot.gov', 'Male', '2023-12-25', 'Haiti');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (429, 'Jarvis', 'Jecock', 'jjecockbw@1688.com', 'Male', '2001-04-21', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (430, 'Thomasin', 'Hunston', 'thunstonbx@google.com.hk', 'Female', '2004-01-31', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (431, 'Dex', 'Le Prevost', 'dleprevostby@webnode.com', 'Male', '2012-08-12', 'Colombia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (432, 'Mindy', 'Collingwood', 'mcollingwoodbz@nifty.com', 'Female', '1975-05-18', 'Brazil');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (433, 'Ronalda', 'Leckey', 'rleckeyc0@smugmug.com', 'Female', '2016-07-23', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (434, 'Luther', 'Pantling', 'lpantlingc1@ed.gov', 'Male', '1957-04-24', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (435, 'Jeramie', 'Rearie', 'jreariec2@state.gov', 'Male', '2020-04-13', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (436, 'Liuka', 'Cheverton', 'lchevertonc3@icq.com', 'Female', '1947-03-28', 'Iran');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (437, 'Jordan', 'Radbourn', 'jradbournc4@usatoday.com', 'Male', '1992-03-22', 'Croatia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (438, 'Daloris', 'Randall', 'drandallc5@taobao.com', 'Female', '2007-03-27', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (439, 'Levey', 'Murtagh', 'lmurtaghc6@de.vu', 'Male', '1932-04-10', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (440, 'Tessi', 'Gathwaite', 'tgathwaitec7@ezinearticles.com', 'Female', '1955-03-09', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (441, 'Aubert', 'Hail', 'ahailc8@dion.ne.jp', 'Male', '1982-04-05', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (442, 'Hilarius', 'Pitfield', 'hpitfieldc9@people.com.cn', 'Male', '1944-04-28', 'Bosnia and Herzegovina');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (443, 'Alexandro', 'Marl', 'amarlca@rediff.com', 'Male', '1947-12-07', 'Mongolia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (444, 'Celeste', 'Bamborough', 'cbamboroughcb@zdnet.com', 'Female', '1952-11-26', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (445, 'Laughton', 'Bolderoe', 'lbolderoecc@cbslocal.com', 'Male', '1999-11-04', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (446, 'Abbe', 'Pashba', 'apashbacd@photobucket.com', 'Male', '1971-06-21', 'Belarus');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (447, 'Pris', 'Cleal', 'pclealce@privacy.gov.au', 'Female', '2000-01-03', 'Greece');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (448, 'Evyn', 'Muro', 'emurocf@alexa.com', 'Male', '1959-05-14', 'Azerbaijan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (449, 'Ira', 'Lambarton', 'ilambartoncg@walmart.com', 'Male', '1950-12-27', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (450, 'Nicolais', 'Counsell', 'ncounsellch@netvibes.com', 'Male', '1946-12-01', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (451, 'Connie', 'Shenfisch', 'cshenfischci@taobao.com', 'Female', '1935-09-04', 'Tanzania');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (452, 'Jake', 'Dines', 'jdinescj@intel.com', 'Male', '2014-10-02', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (453, 'Ron', 'Schafer', 'rschaferck@biglobe.ne.jp', 'Male', '1955-04-13', 'Colombia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (454, 'Breena', 'Weatherill', 'bweatherillcl@eepurl.com', 'Female', '1988-08-02', 'Afghanistan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (455, 'Fredra', 'Basilio', 'fbasiliocm@blogspot.com', 'Female', '2002-04-10', 'Ukraine');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (456, 'Arlena', 'Cabrera', 'acabreracn@upenn.edu', 'Female', '1948-02-17', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (457, 'Jamie', 'Kinastan', 'jkinastanco@is.gd', 'Female', '1998-04-30', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (458, 'Kimberlee', 'Okenden', 'kokendencp@github.io', 'Female', '1940-07-14', 'Netherlands');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (459, 'Oralie', 'Houldey', 'ohouldeycq@youtu.be', 'Female', '1964-08-30', 'Afghanistan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (460, 'Natala', 'Chatt', 'nchattcr@cocolog-nifty.com', 'Female', '1976-09-26', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (461, 'Dannye', 'Sanja', 'dsanjacs@salon.com', 'Female', '1977-10-24', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (462, 'Allix', 'Blundell', 'ablundellct@dot.gov', 'Female', '1968-04-02', 'Lebanon');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (463, 'Celestina', 'Fabbro', 'cfabbrocu@sfgate.com', 'Female', '1937-09-19', 'Japan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (464, 'Alexine', 'Blunsen', 'ablunsencv@dailymotion.com', 'Female', '1972-11-05', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (465, 'Kacy', 'Georgeson', 'kgeorgesoncw@ft.com', 'Female', '1963-02-23', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (466, 'Barron', 'McMonies', 'bmcmoniescx@chronoengine.com', 'Male', '1983-06-22', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (467, 'Jerrie', 'Willerton', 'jwillertoncy@opensource.org', 'Male', '1968-12-26', 'Azerbaijan');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (468, 'Lavinie', 'Thurley', 'lthurleycz@ted.com', 'Female', '2003-05-01', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (469, 'Joellyn', 'Goldsby', 'jgoldsbyd0@miibeian.gov.cn', 'Female', '2017-05-16', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (470, 'Ranee', 'Olivetta', 'rolivettad1@pagesperso-orange.fr', 'Female', '1991-02-25', 'Poland');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (471, 'Rafael', 'Moakler', 'rmoaklerd2@soundcloud.com', 'Male', '1994-02-28', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (472, 'Brand', 'Eltone', 'beltoned3@loc.gov', 'Male', '1941-05-17', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (473, 'Chick', 'Pottiphar', 'cpottiphard4@domainmarket.com', 'Male', '1973-04-17', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (474, 'Mike', 'Bolino', 'mbolinod5@marriott.com', 'Male', '1985-02-12', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (475, 'Jamesy', 'Bigmore', 'jbigmored6@purevolume.com', 'Male', '1996-05-31', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (476, 'Petey', 'Curwen', 'pcurwend7@yellowpages.com', 'Male', '2003-05-09', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (477, 'Percival', 'Dowall', 'pdowalld8@google.com', 'Male', '2006-11-04', 'Senegal');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (478, 'Pryce', 'Kettell', 'pkettelld9@yandex.ru', 'Male', '2019-07-15', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (479, 'Von', 'Tipperton', 'vtippertonda@behance.net', 'Male', '1957-10-08', 'Philippines');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (480, 'Carline', 'Evennett', 'cevennettdb@buzzfeed.com', 'Female', '2005-11-13', 'South Korea');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (481, 'Domenico', 'Missington', 'dmissingtondc@omniture.com', 'Male', '1967-03-23', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (482, 'Ricky', 'Mariolle', 'rmariolledd@fastcompany.com', 'Male', '1940-04-04', 'Iran');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (483, 'Wallie', 'Cockshut', 'wcockshutde@cisco.com', 'Female', '1976-07-30', 'United States');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (484, 'Tobye', 'Corkel', 'tcorkeldf@sun.com', 'Female', '2000-06-11', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (485, 'Chic', 'Jerrans', 'cjerransdg@booking.com', 'Male', '2003-02-10', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (486, 'Mikey', 'Neaverson', 'mneaversondh@fema.gov', 'Male', '1989-08-06', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (487, 'Hermie', 'Stuther', 'hstutherdi@dmoz.org', 'Male', '2022-01-25', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (488, 'Carly', 'Chirm', 'cchirmdj@trellian.com', 'Female', '1960-10-12', 'Iran');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (489, 'Celka', 'Heigl', 'cheigldk@zdnet.com', 'Female', '1982-11-24', 'Indonesia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (490, 'Gillie', 'Blackall', 'gblackalldl@oaic.gov.au', 'Female', '2020-10-18', 'Vietnam');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (491, 'Herbert', 'Axten', 'haxtendm@vinaora.com', 'Male', '1990-06-04', 'Ghana');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (492, 'Juditha', 'Helleker', 'jhellekerdn@un.org', 'Female', '1952-03-17', 'Sweden');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (493, 'Honey', 'Pache', 'hpachedo@pinterest.com', 'Female', '1940-08-18', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (494, 'Mathian', 'Buttner', 'mbuttnerdp@pagesperso-orange.fr', 'Male', '2006-03-27', 'Russia');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (495, 'Galvin', 'Lidgley', 'glidgleydq@bigcartel.com', 'Male', '1965-06-10', 'Greece');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (496, 'Kim', 'Huntington', 'khuntingtondr@comsenz.com', 'Male', '2014-07-21', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (497, 'Bel', 'McIlroy', 'bmcilroyds@admin.ch', 'Male', '2006-04-18', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (498, 'Saunders', 'Temprell', 'stemprelldt@jimdo.com', 'Male', '1961-01-21', 'China');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (499, 'Peggie', 'Fitkin', 'pfitkindu@dailymotion.com', 'Female', '1973-06-08', 'Argentina');
insert into passenger (id, first_name, last_name, email, gender, date_of_birth, country) values (500, 'Kaitlynn', 'Garshore', 'kgarshoredv@virginia.edu', 'Female', '1943-10-20', 'United States');


insert into bookingPlatform(id, name, url) values(1,'Make my trip','https://www.makemytrip.com/')
insert into bookingPlatform(id, name, url) values(2,'Trip Ninja','https://www.tripninja.io/')
insert into bookingPlatform(id, name, url) values(3,'Capterra','https://www.capterra.com/')
insert into bookingPlatform(id, name, url) values(4,'CheapOAir','https://www.cheapoair.com/')
insert into bookingPlatform(id, name, url) values(5,'Flight Gorilla','https://flightgorilla.com/')
insert into bookingPlatform(id, name, url) values(6,'Opodo','https://www.opodo.com/')
insert into bookingPlatform(id, name, url) values(7,'At airport',null)
insert into bookingPlatform(id, name, url) values(8,'Amadeus','https://amadeus.com/')
insert into bookingPlatform(id, name, url) values(9,'Expedia','https://www.expedia.com.vn/')

INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (1, 357, 319, 9, CAST(N'2023-03-11T12:39:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (2, 74, 96, 2, CAST(N'2023-03-16T15:49:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (3, 473, 227, 2, CAST(N'2022-05-21T16:06:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (4, 414, 168, 9, CAST(N'2022-06-10T05:55:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (5, 351, 332, 3, CAST(N'2022-06-15T05:47:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (6, 59, 230, 5, CAST(N'2022-12-25T16:36:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (7, 317, 283, 9, CAST(N'2023-04-28T07:05:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (8, 463, 300, 3, CAST(N'2023-01-07T20:15:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (9, 73, 50, 9, CAST(N'2022-06-28T01:01:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (10, 20, 213, 3, CAST(N'2022-07-17T18:31:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (11, 285, 30, 7, CAST(N'2023-02-28T18:38:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (12, 439, 337, 7, CAST(N'2022-08-11T07:41:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (13, 297, 339, 1, CAST(N'2022-09-24T13:12:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (14, 427, 70, 7, CAST(N'2022-06-20T22:32:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (15, 62, 91, 8, CAST(N'2023-04-16T15:05:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (16, 430, 204, 1, CAST(N'2022-07-29T13:53:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (17, 210, 51, 8, CAST(N'2023-04-27T05:44:06.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (18, 384, 140, 2, CAST(N'2022-12-03T22:46:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (19, 15, 190, 1, CAST(N'2022-10-09T03:23:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (20, 268, 56, 5, CAST(N'2023-03-28T02:18:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (21, 493, 333, 4, CAST(N'2022-12-07T15:54:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (22, 245, 325, 7, CAST(N'2022-12-09T15:20:07.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (23, 239, 316, 8, CAST(N'2022-07-20T00:59:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (24, 429, 56, 3, CAST(N'2023-03-28T02:18:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (25, 139, 265, 3, CAST(N'2022-08-03T09:18:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (26, 352, 111, 7, CAST(N'2023-03-10T20:01:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (27, 26, 204, 5, CAST(N'2022-07-29T13:53:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (28, 284, 103, 1, CAST(N'2023-04-24T08:13:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (29, 341, 277, 4, CAST(N'2022-05-23T02:51:20.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (30, 301, 98, 3, CAST(N'2022-09-10T21:09:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (31, 75, 293, 7, CAST(N'2022-05-15T02:42:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (32, 359, 220, 9, CAST(N'2022-10-16T07:44:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (33, 243, 27, 3, CAST(N'2022-05-17T07:47:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (34, 127, 132, 4, CAST(N'2022-05-21T23:02:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (35, 471, 220, 7, CAST(N'2022-10-16T07:44:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (36, 178, 148, 1, CAST(N'2023-02-08T14:29:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (37, 197, 15, 5, CAST(N'2023-04-11T00:53:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (38, 371, 52, 6, CAST(N'2022-10-05T16:47:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (39, 262, 58, 8, CAST(N'2023-02-09T16:23:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (40, 212, 276, 6, CAST(N'2022-05-14T01:49:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (41, 228, 245, 6, CAST(N'2022-06-24T19:13:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (42, 100, 329, 1, CAST(N'2023-04-27T22:20:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (43, 279, 350, 8, CAST(N'2022-11-10T09:24:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (44, 148, 337, 4, CAST(N'2022-08-11T07:41:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (45, 476, 205, 1, CAST(N'2022-07-21T12:17:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (46, 227, 255, 6, CAST(N'2022-06-24T03:16:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (47, 376, 116, 5, CAST(N'2023-04-14T20:08:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (48, 89, 82, 6, CAST(N'2022-05-29T00:58:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (49, 126, 221, 9, CAST(N'2022-07-28T05:31:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (50, 153, 15, 5, CAST(N'2023-04-11T00:53:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (51, 165, 118, 1, CAST(N'2023-04-09T17:28:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (52, 231, 9, 8, CAST(N'2022-11-19T08:35:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (53, 3, 117, 6, CAST(N'2022-11-28T22:45:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (54, 114, 311, 5, CAST(N'2022-07-12T11:27:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (55, 280, 59, 4, CAST(N'2022-12-18T10:35:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (56, 357, 345, 7, CAST(N'2022-07-03T03:16:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (57, 172, 245, 7, CAST(N'2022-06-24T19:13:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (58, 42, 295, 9, CAST(N'2022-10-03T13:37:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (59, 208, 171, 9, CAST(N'2022-11-23T04:37:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (60, 447, 195, 2, CAST(N'2023-03-18T21:24:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (61, 40, 159, 7, CAST(N'2023-02-09T09:00:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (62, 432, 15, 3, CAST(N'2023-04-11T00:53:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (63, 185, 19, 7, CAST(N'2023-03-17T15:20:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (64, 251, 90, 6, CAST(N'2022-11-23T23:34:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (65, 54, 284, 7, CAST(N'2022-09-16T09:12:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (66, 6, 165, 1, CAST(N'2023-02-08T10:23:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (67, 499, 295, 3, CAST(N'2022-10-03T13:37:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (68, 87, 43, 5, CAST(N'2022-05-29T01:11:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (69, 252, 141, 3, CAST(N'2022-08-05T08:08:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (70, 94, 10, 6, CAST(N'2022-10-16T07:52:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (71, 105, 31, 9, CAST(N'2022-12-14T02:32:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (72, 490, 289, 8, CAST(N'2023-04-17T08:58:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (73, 448, 194, 6, CAST(N'2022-12-26T14:26:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (74, 92, 295, 9, CAST(N'2022-10-03T13:37:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (75, 478, 151, 6, CAST(N'2022-09-21T07:49:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (76, 345, 231, 8, CAST(N'2022-11-14T14:22:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (77, 487, 195, 9, CAST(N'2023-03-18T21:24:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (78, 388, 28, 5, CAST(N'2022-09-10T09:33:15.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (79, 303, 76, 5, CAST(N'2023-03-14T11:43:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (80, 142, 222, 9, CAST(N'2023-04-05T09:53:20.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (81, 181, 152, 4, CAST(N'2022-09-05T05:03:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (82, 219, 183, 3, CAST(N'2022-06-21T07:03:07.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (83, 174, 343, 6, CAST(N'2023-03-30T15:37:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (84, 14, 312, 4, CAST(N'2023-02-04T20:31:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (85, 448, 198, 4, CAST(N'2022-05-26T21:54:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (86, 327, 171, 2, CAST(N'2022-11-23T04:37:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (87, 73, 153, 4, CAST(N'2022-06-09T07:14:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (88, 124, 67, 4, CAST(N'2022-06-05T13:30:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (89, 469, 200, 2, CAST(N'2022-09-17T06:11:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (90, 128, 319, 7, CAST(N'2023-03-11T12:39:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (91, 119, 73, 9, CAST(N'2022-10-17T05:32:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (92, 123, 38, 9, CAST(N'2023-05-10T11:32:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (93, 113, 144, 6, CAST(N'2022-07-28T09:51:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (94, 17, 95, 9, CAST(N'2023-03-04T19:58:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (95, 252, 208, 4, CAST(N'2022-06-08T09:50:56.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (96, 362, 157, 3, CAST(N'2022-08-25T04:55:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (97, 494, 277, 3, CAST(N'2022-05-23T02:51:20.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (98, 432, 223, 2, CAST(N'2022-10-11T10:53:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (99, 317, 63, 6, CAST(N'2023-02-03T08:47:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (100, 203, 83, 1, CAST(N'2022-09-18T09:05:19.000' AS DateTime))
GO
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (101, 151, 249, 4, CAST(N'2023-03-25T22:42:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (102, 119, 299, 6, CAST(N'2022-07-27T19:06:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (103, 432, 74, 9, CAST(N'2023-02-21T09:00:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (104, 225, 122, 7, CAST(N'2022-07-26T14:41:15.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (105, 459, 153, 6, CAST(N'2022-06-09T07:14:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (106, 249, 99, 1, CAST(N'2022-12-10T06:05:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (107, 380, 265, 7, CAST(N'2022-08-03T09:18:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (108, 103, 273, 2, CAST(N'2022-10-01T20:32:32.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (109, 339, 297, 8, CAST(N'2022-06-13T15:42:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (110, 259, 255, 9, CAST(N'2022-06-24T03:16:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (111, 186, 117, 4, CAST(N'2022-11-28T22:45:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (112, 468, 66, 5, CAST(N'2022-12-03T05:20:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (113, 46, 233, 1, CAST(N'2022-11-25T11:15:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (114, 163, 184, 6, CAST(N'2022-05-18T09:05:18.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (115, 196, 201, 7, CAST(N'2022-12-22T12:32:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (116, 7, 83, 2, CAST(N'2022-09-18T09:05:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (117, 4, 168, 9, CAST(N'2022-06-10T05:55:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (118, 353, 102, 6, CAST(N'2022-07-20T00:55:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (119, 135, 162, 4, CAST(N'2023-04-26T01:30:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (120, 296, 17, 9, CAST(N'2022-08-14T00:30:54.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (121, 425, 311, 6, CAST(N'2022-07-12T11:27:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (122, 334, 267, 2, CAST(N'2022-07-08T20:34:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (123, 172, 344, 7, CAST(N'2022-06-08T19:38:55.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (124, 419, 175, 9, CAST(N'2022-08-09T08:35:15.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (125, 496, 266, 3, CAST(N'2023-02-10T11:50:18.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (126, 467, 46, 6, CAST(N'2023-01-05T08:28:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (127, 19, 226, 1, CAST(N'2022-08-04T09:32:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (128, 476, 76, 8, CAST(N'2023-03-14T11:43:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (129, 175, 260, 8, CAST(N'2022-06-26T16:16:01.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (130, 433, 161, 8, CAST(N'2022-09-15T05:08:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (131, 342, 219, 9, CAST(N'2022-10-01T10:14:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (132, 297, 68, 7, CAST(N'2023-03-03T06:53:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (133, 324, 67, 2, CAST(N'2022-06-05T13:30:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (134, 191, 59, 1, CAST(N'2022-12-18T10:35:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (135, 1, 243, 1, CAST(N'2022-07-20T11:24:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (136, 176, 138, 8, CAST(N'2023-03-15T03:38:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (137, 161, 318, 5, CAST(N'2022-07-25T12:54:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (138, 198, 80, 3, CAST(N'2022-06-03T16:38:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (139, 207, 91, 2, CAST(N'2023-04-16T15:05:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (140, 414, 153, 8, CAST(N'2022-06-09T07:14:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (141, 182, 278, 7, CAST(N'2022-12-13T10:09:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (142, 69, 264, 7, CAST(N'2022-05-31T12:12:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (143, 45, 202, 2, CAST(N'2023-01-18T21:21:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (144, 493, 155, 9, CAST(N'2023-02-18T14:30:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (145, 135, 344, 9, CAST(N'2022-06-08T19:38:55.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (146, 205, 142, 5, CAST(N'2023-02-08T08:06:57.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (147, 419, 147, 7, CAST(N'2023-01-01T12:13:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (148, 21, 330, 8, CAST(N'2022-05-20T03:04:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (149, 284, 33, 6, CAST(N'2022-12-16T22:34:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (150, 121, 300, 3, CAST(N'2023-01-07T20:15:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (151, 450, 64, 7, CAST(N'2023-01-26T19:05:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (152, 121, 97, 9, CAST(N'2022-11-06T22:01:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (153, 293, 237, 4, CAST(N'2022-09-19T20:09:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (154, 263, 206, 8, CAST(N'2022-07-31T07:22:54.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (155, 439, 148, 6, CAST(N'2023-02-08T14:29:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (156, 337, 28, 8, CAST(N'2022-09-10T09:33:15.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (157, 147, 320, 1, CAST(N'2022-05-15T19:09:06.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (158, 273, 28, 2, CAST(N'2022-09-10T09:33:15.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (159, 418, 316, 3, CAST(N'2022-07-20T00:59:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (160, 399, 305, 5, CAST(N'2022-06-26T13:09:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (161, 196, 220, 4, CAST(N'2022-10-16T07:44:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (162, 418, 6, 9, CAST(N'2022-06-12T19:39:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (163, 80, 342, 9, CAST(N'2023-03-12T05:28:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (164, 339, 332, 8, CAST(N'2022-06-15T05:47:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (165, 151, 43, 5, CAST(N'2022-05-29T01:11:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (166, 386, 100, 7, CAST(N'2023-02-27T04:06:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (167, 138, 312, 4, CAST(N'2023-02-04T20:31:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (168, 395, 104, 6, CAST(N'2022-09-12T03:33:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (169, 325, 157, 3, CAST(N'2022-08-25T04:55:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (170, 63, 152, 1, CAST(N'2022-09-05T05:03:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (171, 250, 148, 8, CAST(N'2023-02-08T14:29:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (172, 495, 196, 4, CAST(N'2022-08-15T17:29:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (173, 217, 161, 5, CAST(N'2022-09-15T05:08:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (174, 240, 147, 1, CAST(N'2023-01-01T12:13:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (175, 251, 264, 9, CAST(N'2022-05-31T12:12:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (176, 326, 293, 7, CAST(N'2022-05-15T02:42:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (177, 307, 178, 5, CAST(N'2022-10-10T18:58:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (178, 169, 95, 2, CAST(N'2023-03-04T19:58:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (179, 248, 107, 6, CAST(N'2022-07-30T11:48:01.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (180, 137, 14, 3, CAST(N'2022-12-19T00:35:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (181, 321, 278, 7, CAST(N'2022-12-13T10:09:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (182, 27, 161, 5, CAST(N'2022-09-15T05:08:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (183, 9, 60, 5, CAST(N'2023-02-05T15:55:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (184, 271, 311, 8, CAST(N'2022-07-12T11:27:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (185, 173, 208, 5, CAST(N'2022-06-08T09:50:56.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (186, 299, 316, 1, CAST(N'2022-07-20T00:59:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (187, 228, 43, 2, CAST(N'2022-05-29T01:11:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (188, 358, 237, 3, CAST(N'2022-09-19T20:09:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (189, 106, 250, 8, CAST(N'2023-01-02T05:34:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (190, 216, 177, 2, CAST(N'2022-12-18T09:58:29.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (191, 287, 271, 1, CAST(N'2022-09-12T12:15:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (192, 186, 41, 7, CAST(N'2023-02-25T03:15:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (193, 25, 315, 1, CAST(N'2023-01-22T00:18:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (194, 422, 342, 3, CAST(N'2023-03-12T05:28:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (195, 152, 88, 2, CAST(N'2022-07-01T18:49:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (196, 398, 36, 9, CAST(N'2022-06-09T19:25:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (197, 316, 187, 6, CAST(N'2023-02-07T09:42:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (198, 237, 208, 9, CAST(N'2022-06-08T09:50:56.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (199, 132, 191, 6, CAST(N'2022-10-05T16:51:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (200, 235, 256, 4, CAST(N'2022-11-30T06:50:21.000' AS DateTime))
GO
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (201, 427, 55, 6, CAST(N'2023-05-01T13:54:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (202, 214, 58, 1, CAST(N'2023-02-09T16:23:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (203, 320, 341, 3, CAST(N'2022-07-22T16:51:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (204, 195, 229, 6, CAST(N'2022-10-30T17:36:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (205, 210, 85, 1, CAST(N'2022-05-15T16:21:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (206, 214, 160, 6, CAST(N'2023-01-31T08:00:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (207, 463, 106, 1, CAST(N'2023-02-09T13:24:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (208, 273, 30, 3, CAST(N'2023-02-28T18:38:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (209, 455, 41, 3, CAST(N'2023-02-25T03:15:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (210, 210, 183, 2, CAST(N'2022-06-21T07:03:07.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (211, 211, 347, 2, CAST(N'2022-09-13T11:13:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (212, 245, 261, 3, CAST(N'2023-04-29T00:54:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (213, 392, 195, 7, CAST(N'2023-03-18T21:24:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (214, 15, 13, 7, CAST(N'2023-02-05T09:50:26.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (215, 491, 66, 2, CAST(N'2022-12-03T05:20:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (216, 274, 190, 3, CAST(N'2022-10-09T03:23:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (217, 63, 295, 9, CAST(N'2022-10-03T13:37:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (218, 178, 7, 6, CAST(N'2022-07-26T19:55:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (219, 59, 232, 2, CAST(N'2022-10-23T19:18:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (220, 123, 141, 5, CAST(N'2022-08-05T08:08:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (221, 296, 6, 9, CAST(N'2022-06-12T19:39:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (222, 136, 253, 8, CAST(N'2022-11-06T23:44:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (223, 150, 282, 2, CAST(N'2023-01-24T06:31:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (224, 264, 275, 4, CAST(N'2022-07-06T00:33:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (225, 210, 184, 4, CAST(N'2022-05-18T09:05:18.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (226, 41, 47, 1, CAST(N'2023-01-08T13:34:56.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (227, 322, 38, 5, CAST(N'2023-05-10T11:32:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (228, 186, 152, 1, CAST(N'2022-09-05T05:03:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (229, 5, 305, 5, CAST(N'2022-06-26T13:09:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (230, 399, 294, 5, CAST(N'2023-03-06T21:19:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (231, 43, 321, 7, CAST(N'2022-10-22T20:26:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (232, 430, 87, 2, CAST(N'2022-07-20T05:31:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (233, 397, 8, 4, CAST(N'2022-12-13T11:12:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (234, 318, 256, 6, CAST(N'2022-11-30T06:50:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (235, 257, 278, 8, CAST(N'2022-12-13T10:09:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (236, 431, 301, 1, CAST(N'2023-03-19T13:00:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (237, 31, 177, 5, CAST(N'2022-12-18T09:58:29.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (238, 335, 310, 5, CAST(N'2022-09-28T18:59:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (239, 243, 308, 8, CAST(N'2022-12-22T12:46:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (240, 111, 274, 2, CAST(N'2022-12-24T02:29:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (241, 146, 305, 3, CAST(N'2022-06-26T13:09:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (242, 59, 264, 9, CAST(N'2022-05-31T12:12:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (243, 300, 230, 8, CAST(N'2022-12-25T16:36:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (244, 385, 168, 2, CAST(N'2022-06-10T05:55:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (245, 199, 264, 4, CAST(N'2022-05-31T12:12:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (246, 352, 61, 2, CAST(N'2022-05-28T18:26:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (247, 190, 44, 1, CAST(N'2023-05-03T16:49:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (248, 338, 215, 3, CAST(N'2022-08-13T09:26:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (249, 417, 317, 8, CAST(N'2022-09-25T19:03:54.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (250, 127, 86, 4, CAST(N'2022-05-28T10:29:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (251, 164, 343, 9, CAST(N'2023-03-30T15:37:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (252, 215, 98, 3, CAST(N'2022-09-10T21:09:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (253, 250, 245, 3, CAST(N'2022-06-24T19:13:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (254, 299, 37, 4, CAST(N'2022-09-26T14:18:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (255, 321, 314, 9, CAST(N'2022-12-17T06:34:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (256, 365, 271, 5, CAST(N'2022-09-12T12:15:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (257, 249, 176, 9, CAST(N'2023-03-28T21:19:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (258, 373, 297, 3, CAST(N'2022-06-13T15:42:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (259, 486, 169, 6, CAST(N'2022-10-10T10:52:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (260, 292, 349, 8, CAST(N'2022-10-08T11:43:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (261, 213, 14, 1, CAST(N'2022-12-19T00:35:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (262, 285, 164, 3, CAST(N'2023-01-17T19:56:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (263, 209, 211, 5, CAST(N'2022-05-28T09:23:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (264, 314, 75, 6, CAST(N'2023-03-30T09:20:26.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (265, 375, 248, 6, CAST(N'2023-01-16T07:30:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (266, 125, 273, 4, CAST(N'2022-10-01T20:32:32.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (267, 153, 299, 3, CAST(N'2022-07-27T19:06:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (268, 395, 272, 9, CAST(N'2022-05-29T23:27:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (269, 206, 283, 4, CAST(N'2023-04-28T07:05:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (270, 336, 229, 4, CAST(N'2022-10-30T17:36:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (271, 27, 152, 9, CAST(N'2022-09-05T05:03:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (272, 313, 348, 7, CAST(N'2023-04-24T16:52:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (273, 105, 245, 1, CAST(N'2022-06-24T19:13:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (274, 76, 182, 7, CAST(N'2023-03-19T06:39:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (275, 338, 129, 9, CAST(N'2022-10-14T11:07:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (276, 454, 217, 8, CAST(N'2022-06-28T22:08:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (277, 14, 167, 1, CAST(N'2022-10-10T22:45:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (278, 248, 194, 3, CAST(N'2022-12-26T14:26:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (279, 495, 51, 8, CAST(N'2023-04-27T05:44:06.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (280, 300, 344, 2, CAST(N'2022-06-08T19:38:55.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (281, 101, 130, 5, CAST(N'2022-10-12T01:14:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (282, 474, 133, 6, CAST(N'2023-03-10T01:23:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (283, 290, 281, 6, CAST(N'2022-05-21T14:14:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (284, 31, 317, 4, CAST(N'2022-09-25T19:03:54.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (285, 31, 211, 3, CAST(N'2022-05-28T09:23:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (286, 155, 303, 4, CAST(N'2022-11-30T01:18:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (287, 156, 49, 7, CAST(N'2023-02-19T03:26:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (288, 308, 308, 1, CAST(N'2022-12-22T12:46:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (289, 268, 83, 8, CAST(N'2022-09-18T09:05:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (290, 72, 105, 8, CAST(N'2022-07-31T07:01:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (291, 261, 288, 3, CAST(N'2022-08-16T07:12:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (292, 120, 342, 1, CAST(N'2023-03-12T05:28:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (293, 36, 234, 1, CAST(N'2022-06-21T07:32:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (294, 114, 188, 1, CAST(N'2022-11-24T17:23:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (295, 56, 86, 9, CAST(N'2022-05-28T10:29:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (296, 417, 108, 3, CAST(N'2022-07-03T07:20:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (297, 218, 298, 1, CAST(N'2022-05-12T01:44:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (298, 235, 320, 2, CAST(N'2022-05-15T19:09:06.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (299, 161, 12, 6, CAST(N'2023-01-19T20:57:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (300, 20, 44, 2, CAST(N'2023-05-03T16:49:51.000' AS DateTime))
GO
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (301, 303, 40, 7, CAST(N'2023-02-02T08:40:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (302, 238, 63, 4, CAST(N'2023-02-03T08:47:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (303, 78, 251, 2, CAST(N'2022-10-23T08:12:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (304, 448, 88, 9, CAST(N'2022-07-01T18:49:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (305, 99, 164, 7, CAST(N'2023-01-17T19:56:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (306, 145, 289, 6, CAST(N'2023-04-17T08:58:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (307, 323, 53, 9, CAST(N'2022-10-07T11:10:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (308, 273, 218, 8, CAST(N'2023-02-26T22:59:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (309, 458, 21, 4, CAST(N'2023-02-10T10:46:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (310, 319, 30, 1, CAST(N'2023-02-28T18:38:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (311, 274, 84, 3, CAST(N'2022-07-13T11:07:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (312, 477, 255, 2, CAST(N'2022-06-24T03:16:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (313, 285, 201, 1, CAST(N'2022-12-22T12:32:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (314, 96, 1, 9, CAST(N'2022-08-23T13:15:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (315, 69, 216, 2, CAST(N'2022-06-15T08:35:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (316, 48, 277, 9, CAST(N'2022-05-23T02:51:20.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (317, 151, 37, 2, CAST(N'2022-09-26T14:18:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (318, 384, 239, 8, CAST(N'2023-04-13T05:53:29.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (319, 14, 155, 6, CAST(N'2023-02-18T14:30:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (320, 290, 60, 5, CAST(N'2023-02-05T15:55:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (321, 425, 204, 2, CAST(N'2022-07-29T13:53:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (322, 247, 275, 2, CAST(N'2022-07-06T00:33:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (323, 150, 149, 7, CAST(N'2022-06-17T16:44:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (324, 312, 128, 6, CAST(N'2023-03-03T02:39:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (325, 214, 120, 4, CAST(N'2022-11-26T21:19:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (326, 78, 250, 5, CAST(N'2023-01-02T05:34:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (327, 15, 81, 3, CAST(N'2022-11-18T02:04:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (328, 453, 322, 7, CAST(N'2023-02-15T05:11:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (329, 235, 186, 9, CAST(N'2022-08-27T23:35:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (330, 465, 182, 8, CAST(N'2023-03-19T06:39:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (331, 139, 27, 2, CAST(N'2022-05-17T07:47:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (332, 492, 287, 8, CAST(N'2022-07-05T15:58:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (333, 156, 214, 8, CAST(N'2023-01-28T20:07:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (334, 427, 279, 2, CAST(N'2022-08-30T15:28:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (335, 396, 205, 2, CAST(N'2022-07-21T12:17:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (336, 368, 164, 6, CAST(N'2023-01-17T19:56:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (337, 18, 148, 6, CAST(N'2023-02-08T14:29:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (338, 337, 98, 2, CAST(N'2022-09-10T21:09:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (339, 319, 52, 7, CAST(N'2022-10-05T16:47:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (340, 407, 152, 4, CAST(N'2022-09-05T05:03:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (341, 31, 162, 2, CAST(N'2023-04-26T01:30:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (342, 305, 259, 3, CAST(N'2022-08-28T18:15:32.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (343, 30, 107, 9, CAST(N'2022-07-30T11:48:01.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (344, 331, 69, 3, CAST(N'2022-12-20T18:24:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (345, 217, 181, 9, CAST(N'2023-04-24T21:02:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (346, 454, 130, 1, CAST(N'2022-10-12T01:14:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (347, 448, 125, 7, CAST(N'2022-09-10T08:10:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (348, 453, 257, 6, CAST(N'2022-09-09T05:55:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (349, 84, 289, 5, CAST(N'2023-04-17T08:58:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (350, 113, 233, 7, CAST(N'2022-11-25T11:15:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (351, 443, 109, 6, CAST(N'2022-09-24T00:50:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (352, 309, 75, 7, CAST(N'2023-03-30T09:20:26.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (353, 351, 6, 7, CAST(N'2022-06-12T19:39:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (354, 375, 13, 9, CAST(N'2023-02-05T09:50:26.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (355, 393, 13, 8, CAST(N'2023-02-05T09:50:26.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (356, 416, 188, 8, CAST(N'2022-11-24T17:23:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (357, 200, 302, 4, CAST(N'2022-05-26T04:22:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (358, 22, 263, 7, CAST(N'2022-09-17T03:47:26.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (359, 420, 198, 8, CAST(N'2022-05-26T21:54:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (360, 30, 237, 9, CAST(N'2022-09-19T20:09:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (361, 308, 117, 4, CAST(N'2022-11-28T22:45:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (362, 367, 99, 6, CAST(N'2022-12-10T06:05:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (363, 45, 136, 8, CAST(N'2022-12-13T07:21:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (364, 174, 127, 1, CAST(N'2022-09-10T08:18:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (365, 145, 300, 8, CAST(N'2023-01-07T20:15:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (366, 184, 236, 7, CAST(N'2022-09-23T22:38:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (367, 481, 193, 9, CAST(N'2022-10-24T08:12:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (368, 263, 63, 3, CAST(N'2023-02-03T08:47:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (369, 180, 11, 3, CAST(N'2022-09-22T18:37:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (370, 488, 67, 7, CAST(N'2022-06-05T13:30:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (371, 337, 332, 5, CAST(N'2022-06-15T05:47:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (372, 359, 198, 8, CAST(N'2022-05-26T21:54:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (373, 436, 307, 5, CAST(N'2022-08-10T06:54:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (374, 74, 154, 3, CAST(N'2023-04-16T02:00:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (375, 405, 120, 9, CAST(N'2022-11-26T21:19:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (376, 55, 251, 7, CAST(N'2022-10-23T08:12:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (377, 288, 110, 2, CAST(N'2022-10-23T13:42:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (378, 467, 220, 2, CAST(N'2022-10-16T07:44:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (379, 84, 311, 4, CAST(N'2022-07-12T11:27:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (380, 495, 284, 4, CAST(N'2022-09-16T09:12:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (381, 113, 309, 5, CAST(N'2022-07-20T17:44:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (382, 256, 128, 6, CAST(N'2023-03-03T02:39:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (383, 444, 85, 7, CAST(N'2022-05-15T16:21:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (384, 214, 294, 9, CAST(N'2023-03-06T21:19:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (385, 147, 31, 8, CAST(N'2022-12-14T02:32:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (386, 334, 281, 5, CAST(N'2022-05-21T14:14:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (387, 466, 90, 2, CAST(N'2022-11-23T23:34:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (388, 352, 57, 6, CAST(N'2023-01-26T21:54:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (389, 309, 292, 5, CAST(N'2022-12-25T04:37:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (390, 83, 294, 3, CAST(N'2023-03-06T21:19:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (391, 261, 247, 7, CAST(N'2022-06-10T19:14:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (392, 253, 173, 8, CAST(N'2022-08-19T18:13:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (393, 460, 331, 3, CAST(N'2022-08-12T00:59:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (394, 214, 86, 8, CAST(N'2022-05-28T10:29:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (395, 195, 117, 5, CAST(N'2022-11-28T22:45:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (396, 95, 239, 7, CAST(N'2023-04-13T05:53:29.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (397, 122, 22, 8, CAST(N'2023-03-29T09:12:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (398, 129, 111, 1, CAST(N'2023-03-10T20:01:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (399, 324, 74, 3, CAST(N'2023-02-21T09:00:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (400, 434, 337, 7, CAST(N'2022-08-11T07:41:14.000' AS DateTime))
GO
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (401, 486, 293, 8, CAST(N'2022-05-15T02:42:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (402, 294, 130, 9, CAST(N'2022-10-12T01:14:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (403, 96, 339, 4, CAST(N'2022-09-24T13:12:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (404, 31, 291, 7, CAST(N'2022-07-04T11:44:00.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (405, 302, 8, 4, CAST(N'2022-12-13T11:12:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (406, 188, 341, 6, CAST(N'2022-07-22T16:51:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (407, 256, 62, 3, CAST(N'2022-12-09T02:41:56.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (408, 279, 92, 6, CAST(N'2022-08-28T14:11:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (409, 424, 199, 1, CAST(N'2023-04-25T22:16:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (410, 28, 76, 3, CAST(N'2023-03-14T11:43:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (411, 286, 61, 3, CAST(N'2022-05-28T18:26:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (412, 40, 306, 6, CAST(N'2022-07-03T09:27:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (413, 398, 195, 3, CAST(N'2023-03-18T21:24:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (414, 45, 127, 7, CAST(N'2022-09-10T08:18:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (415, 339, 289, 5, CAST(N'2023-04-17T08:58:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (416, 161, 233, 5, CAST(N'2022-11-25T11:15:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (417, 53, 330, 4, CAST(N'2022-05-20T03:04:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (418, 87, 88, 2, CAST(N'2022-07-01T18:49:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (419, 329, 142, 8, CAST(N'2023-02-08T08:06:57.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (420, 66, 200, 2, CAST(N'2022-09-17T06:11:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (421, 320, 226, 8, CAST(N'2022-08-04T09:32:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (422, 423, 87, 1, CAST(N'2022-07-20T05:31:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (423, 323, 188, 3, CAST(N'2022-11-24T17:23:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (424, 190, 350, 4, CAST(N'2022-11-10T09:24:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (425, 187, 144, 8, CAST(N'2022-07-28T09:51:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (426, 398, 65, 2, CAST(N'2023-03-08T22:07:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (427, 152, 162, 1, CAST(N'2023-04-26T01:30:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (428, 410, 74, 7, CAST(N'2023-02-21T09:00:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (429, 187, 187, 1, CAST(N'2023-02-07T09:42:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (430, 450, 115, 7, CAST(N'2022-12-28T21:11:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (431, 232, 224, 7, CAST(N'2023-04-09T03:46:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (432, 272, 18, 2, CAST(N'2022-05-27T15:29:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (433, 113, 236, 5, CAST(N'2022-09-23T22:38:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (434, 491, 236, 1, CAST(N'2022-09-23T22:38:24.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (435, 340, 16, 2, CAST(N'2023-04-15T17:51:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (436, 318, 51, 2, CAST(N'2023-04-27T05:44:06.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (437, 294, 82, 1, CAST(N'2022-05-29T00:58:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (438, 211, 182, 1, CAST(N'2023-03-19T06:39:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (439, 6, 221, 8, CAST(N'2022-07-28T05:31:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (440, 89, 321, 5, CAST(N'2022-10-22T20:26:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (441, 87, 57, 8, CAST(N'2023-01-26T21:54:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (442, 282, 105, 1, CAST(N'2022-07-31T07:01:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (443, 399, 79, 7, CAST(N'2022-08-08T02:11:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (444, 339, 123, 1, CAST(N'2022-08-26T05:53:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (445, 45, 38, 7, CAST(N'2023-05-10T11:32:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (446, 476, 78, 3, CAST(N'2022-05-30T09:41:18.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (447, 495, 24, 7, CAST(N'2022-06-22T01:44:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (448, 172, 63, 3, CAST(N'2023-02-03T08:47:34.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (449, 198, 303, 1, CAST(N'2022-11-30T01:18:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (450, 175, 45, 6, CAST(N'2023-03-21T20:47:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (451, 63, 56, 4, CAST(N'2023-03-28T02:18:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (452, 469, 242, 4, CAST(N'2022-07-11T02:07:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (453, 266, 310, 7, CAST(N'2022-09-28T18:59:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (454, 234, 259, 8, CAST(N'2022-08-28T18:15:32.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (455, 227, 46, 7, CAST(N'2023-01-05T08:28:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (456, 76, 127, 9, CAST(N'2022-09-10T08:18:11.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (457, 307, 262, 2, CAST(N'2022-05-28T22:11:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (458, 338, 114, 5, CAST(N'2023-03-08T04:06:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (459, 235, 338, 9, CAST(N'2023-03-06T07:17:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (460, 6, 336, 1, CAST(N'2022-11-22T16:07:12.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (461, 416, 24, 8, CAST(N'2022-06-22T01:44:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (462, 223, 40, 6, CAST(N'2023-02-02T08:40:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (463, 26, 93, 4, CAST(N'2022-06-12T03:42:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (464, 284, 334, 4, CAST(N'2023-04-02T20:48:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (465, 492, 186, 6, CAST(N'2022-08-27T23:35:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (466, 316, 245, 5, CAST(N'2022-06-24T19:13:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (467, 341, 313, 2, CAST(N'2022-11-04T14:17:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (468, 164, 173, 1, CAST(N'2022-08-19T18:13:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (469, 203, 1, 8, CAST(N'2022-08-23T13:15:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (470, 246, 120, 8, CAST(N'2022-11-26T21:19:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (471, 492, 247, 7, CAST(N'2022-06-10T19:14:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (472, 252, 207, 4, CAST(N'2022-10-16T17:52:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (473, 81, 36, 8, CAST(N'2022-06-09T19:25:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (474, 339, 186, 4, CAST(N'2022-08-27T23:35:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (475, 423, 254, 9, CAST(N'2023-02-01T20:34:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (476, 465, 123, 9, CAST(N'2022-08-26T05:53:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (477, 230, 262, 7, CAST(N'2022-05-28T22:11:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (478, 484, 199, 9, CAST(N'2023-04-25T22:16:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (479, 403, 71, 2, CAST(N'2022-06-08T04:46:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (480, 228, 160, 7, CAST(N'2023-01-31T08:00:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (481, 396, 120, 3, CAST(N'2022-11-26T21:19:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (482, 86, 182, 3, CAST(N'2023-03-19T06:39:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (483, 93, 137, 4, CAST(N'2022-05-18T21:34:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (484, 393, 243, 8, CAST(N'2022-07-20T11:24:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (485, 71, 169, 7, CAST(N'2022-10-10T10:52:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (486, 233, 11, 4, CAST(N'2022-09-22T18:37:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (487, 160, 135, 6, CAST(N'2023-01-15T00:11:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (488, 172, 264, 5, CAST(N'2022-05-31T12:12:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (489, 181, 39, 1, CAST(N'2023-02-15T03:48:44.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (490, 188, 130, 1, CAST(N'2022-10-12T01:14:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (491, 226, 142, 8, CAST(N'2023-02-08T08:06:57.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (492, 394, 26, 6, CAST(N'2023-03-14T09:18:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (493, 322, 176, 8, CAST(N'2023-03-28T21:19:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (494, 264, 207, 8, CAST(N'2022-10-16T17:52:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (495, 486, 271, 6, CAST(N'2022-09-12T12:15:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (496, 428, 213, 1, CAST(N'2022-07-17T18:31:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (497, 489, 186, 4, CAST(N'2022-08-27T23:35:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (498, 311, 148, 4, CAST(N'2023-02-08T14:29:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (499, 199, 327, 1, CAST(N'2022-07-15T01:40:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (500, 192, 254, 4, CAST(N'2023-02-01T20:34:25.000' AS DateTime))
GO
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (501, 252, 169, 1, CAST(N'2022-10-10T10:52:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (502, 443, 90, 2, CAST(N'2022-11-23T23:34:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (503, 97, 106, 1, CAST(N'2023-02-09T13:24:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (504, 223, 4, 5, CAST(N'2022-10-12T18:25:38.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (505, 53, 298, 9, CAST(N'2022-05-12T01:44:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (506, 486, 314, 5, CAST(N'2022-12-17T06:34:48.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (507, 171, 71, 6, CAST(N'2022-06-08T04:46:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (508, 275, 113, 9, CAST(N'2023-03-30T10:02:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (509, 183, 208, 4, CAST(N'2022-06-08T09:50:56.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (510, 491, 258, 6, CAST(N'2022-11-27T09:52:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (511, 288, 223, 4, CAST(N'2022-10-11T10:53:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (512, 285, 228, 6, CAST(N'2022-11-30T20:25:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (513, 139, 346, 2, CAST(N'2022-08-31T20:56:33.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (514, 362, 42, 4, CAST(N'2023-04-23T23:05:57.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (515, 116, 44, 2, CAST(N'2023-05-03T16:49:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (516, 107, 92, 6, CAST(N'2022-08-28T14:11:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (517, 231, 270, 9, CAST(N'2023-01-17T18:48:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (518, 108, 184, 4, CAST(N'2022-05-18T09:05:18.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (519, 374, 206, 1, CAST(N'2022-07-31T07:22:54.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (520, 169, 173, 9, CAST(N'2022-08-19T18:13:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (521, 392, 348, 5, CAST(N'2023-04-24T16:52:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (522, 223, 187, 2, CAST(N'2023-02-07T09:42:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (523, 110, 311, 3, CAST(N'2022-07-12T11:27:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (524, 176, 6, 7, CAST(N'2022-06-12T19:39:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (525, 2, 84, 8, CAST(N'2022-07-13T11:07:21.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (526, 374, 212, 9, CAST(N'2022-09-22T06:05:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (527, 468, 244, 3, CAST(N'2023-03-13T08:53:13.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (528, 256, 260, 3, CAST(N'2022-06-26T16:16:01.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (529, 145, 252, 4, CAST(N'2023-05-08T10:52:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (530, 354, 113, 4, CAST(N'2023-03-30T10:02:46.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (531, 380, 128, 2, CAST(N'2023-03-03T02:39:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (532, 277, 290, 2, CAST(N'2023-04-05T22:21:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (533, 86, 212, 3, CAST(N'2022-09-22T06:05:45.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (534, 366, 292, 4, CAST(N'2022-12-25T04:37:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (535, 250, 288, 2, CAST(N'2022-08-16T07:12:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (536, 263, 211, 6, CAST(N'2022-05-28T09:23:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (537, 235, 250, 7, CAST(N'2023-01-02T05:34:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (538, 6, 228, 4, CAST(N'2022-11-30T20:25:04.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (539, 42, 187, 1, CAST(N'2023-02-07T09:42:52.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (540, 345, 123, 6, CAST(N'2022-08-26T05:53:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (541, 211, 3, 3, CAST(N'2023-01-29T23:15:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (542, 107, 195, 3, CAST(N'2023-03-18T21:24:59.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (543, 161, 80, 4, CAST(N'2022-06-03T16:38:10.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (544, 360, 29, 3, CAST(N'2022-12-05T21:01:09.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (545, 436, 61, 3, CAST(N'2022-05-28T18:26:03.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (546, 162, 52, 2, CAST(N'2022-10-05T16:47:43.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (547, 367, 191, 8, CAST(N'2022-10-05T16:51:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (548, 283, 73, 4, CAST(N'2022-10-17T05:32:16.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (549, 410, 333, 9, CAST(N'2022-12-07T15:54:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (550, 286, 253, 1, CAST(N'2022-11-06T23:44:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (551, 233, 161, 6, CAST(N'2022-09-15T05:08:08.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (552, 213, 82, 4, CAST(N'2022-05-29T00:58:02.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (553, 445, 30, 3, CAST(N'2023-02-28T18:38:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (554, 384, 15, 8, CAST(N'2023-04-11T00:53:14.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (555, 111, 331, 9, CAST(N'2022-08-12T00:59:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (556, 394, 313, 7, CAST(N'2022-11-04T14:17:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (557, 306, 253, 4, CAST(N'2022-11-06T23:44:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (558, 111, 192, 4, CAST(N'2022-09-11T06:19:53.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (559, 246, 205, 7, CAST(N'2022-07-21T12:17:19.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (560, 155, 38, 9, CAST(N'2023-05-10T11:32:35.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (561, 125, 92, 5, CAST(N'2022-08-28T14:11:39.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (562, 22, 186, 3, CAST(N'2022-08-27T23:35:22.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (563, 84, 48, 5, CAST(N'2022-11-05T17:00:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (564, 17, 123, 1, CAST(N'2022-08-26T05:53:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (565, 142, 35, 5, CAST(N'2023-02-17T07:18:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (566, 267, 250, 9, CAST(N'2023-01-02T05:34:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (567, 481, 315, 3, CAST(N'2023-01-22T00:18:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (568, 234, 268, 2, CAST(N'2022-06-07T02:05:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (569, 424, 68, 3, CAST(N'2023-03-03T06:53:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (570, 303, 333, 9, CAST(N'2022-12-07T15:54:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (571, 466, 240, 5, CAST(N'2023-01-06T07:19:55.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (572, 80, 146, 7, CAST(N'2022-07-24T23:08:07.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (573, 469, 302, 1, CAST(N'2022-05-26T04:22:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (574, 204, 211, 8, CAST(N'2022-05-28T09:23:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (575, 420, 158, 5, CAST(N'2022-08-21T17:16:42.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (576, 20, 331, 7, CAST(N'2022-08-12T00:59:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (577, 181, 183, 9, CAST(N'2022-06-21T07:03:07.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (578, 366, 121, 5, CAST(N'2023-03-08T19:33:25.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (579, 418, 125, 1, CAST(N'2022-09-10T08:10:30.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (580, 419, 238, 9, CAST(N'2022-05-12T05:45:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (581, 383, 220, 3, CAST(N'2022-10-16T07:44:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (582, 9, 153, 9, CAST(N'2022-06-09T07:14:40.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (583, 434, 59, 7, CAST(N'2022-12-18T10:35:37.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (584, 60, 43, 8, CAST(N'2022-05-29T01:11:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (585, 88, 181, 3, CAST(N'2023-04-24T21:02:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (586, 94, 293, 2, CAST(N'2022-05-15T02:42:05.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (587, 351, 321, 8, CAST(N'2022-10-22T20:26:27.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (588, 465, 285, 9, CAST(N'2023-05-10T20:43:28.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (589, 146, 223, 6, CAST(N'2022-10-11T10:53:50.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (590, 107, 95, 5, CAST(N'2023-03-04T19:58:23.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (591, 76, 318, 2, CAST(N'2022-07-25T12:54:49.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (592, 404, 249, 8, CAST(N'2023-03-25T22:42:17.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (593, 276, 33, 1, CAST(N'2022-12-16T22:34:47.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (594, 230, 224, 2, CAST(N'2023-04-09T03:46:31.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (595, 226, 35, 6, CAST(N'2023-02-17T07:18:36.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (596, 375, 44, 6, CAST(N'2023-05-03T16:49:51.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (597, 374, 58, 5, CAST(N'2023-02-09T16:23:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (598, 466, 213, 8, CAST(N'2022-07-17T18:31:41.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (599, 331, 247, 1, CAST(N'2022-06-10T19:14:58.000' AS DateTime))
INSERT [dbo].[booking] ([id], [passenger_id], [flight_id], [booking_platform_id], [booking_time]) VALUES (600, 250, 101, 5, CAST(N'2022-11-04T23:19:10.000' AS DateTime))

insert into baggage (id, booking_id, weight_in_kg) values (1, 264, 23.1);
insert into baggage (id, booking_id, weight_in_kg) values (2, 316, 23.7);
insert into baggage (id, booking_id, weight_in_kg) values (3, 419, 22.8);
insert into baggage (id, booking_id, weight_in_kg) values (4, 412, 22.0);
insert into baggage (id, booking_id, weight_in_kg) values (5, 471, 24.8);
insert into baggage (id, booking_id, weight_in_kg) values (6, 122, 20.2);
insert into baggage (id, booking_id, weight_in_kg) values (7, 145, 20.3);
insert into baggage (id, booking_id, weight_in_kg) values (8, 516, 23.2);
insert into baggage (id, booking_id, weight_in_kg) values (9, 304, 25.2);
insert into baggage (id, booking_id, weight_in_kg) values (10, 72, 12.2);
insert into baggage (id, booking_id, weight_in_kg) values (11, 69, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (12, 495, 24.6);
insert into baggage (id, booking_id, weight_in_kg) values (13, 425, 26.1);
insert into baggage (id, booking_id, weight_in_kg) values (14, 594, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (15, 551, 16.8);
insert into baggage (id, booking_id, weight_in_kg) values (16, 545, 20.3);
insert into baggage (id, booking_id, weight_in_kg) values (17, 494, 13.1);
insert into baggage (id, booking_id, weight_in_kg) values (18, 317, 19.3);
insert into baggage (id, booking_id, weight_in_kg) values (19, 553, 11.7);
insert into baggage (id, booking_id, weight_in_kg) values (20, 535, 17.6);
insert into baggage (id, booking_id, weight_in_kg) values (21, 156, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (22, 39, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (23, 80, 26.8);
insert into baggage (id, booking_id, weight_in_kg) values (24, 418, 15.3);
insert into baggage (id, booking_id, weight_in_kg) values (25, 269, 23.9);
insert into baggage (id, booking_id, weight_in_kg) values (26, 401, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (27, 44, 24.6);
insert into baggage (id, booking_id, weight_in_kg) values (28, 40, 12.0);
insert into baggage (id, booking_id, weight_in_kg) values (29, 368, 22.3);
insert into baggage (id, booking_id, weight_in_kg) values (30, 381, 21.8);
insert into baggage (id, booking_id, weight_in_kg) values (31, 21, 15.8);
insert into baggage (id, booking_id, weight_in_kg) values (32, 582, 22.9);
insert into baggage (id, booking_id, weight_in_kg) values (33, 579, 19.3);
insert into baggage (id, booking_id, weight_in_kg) values (34, 244, 18.1);
insert into baggage (id, booking_id, weight_in_kg) values (35, 95, 13.9);
insert into baggage (id, booking_id, weight_in_kg) values (36, 96, 12.8);
insert into baggage (id, booking_id, weight_in_kg) values (37, 427, 19.1);
insert into baggage (id, booking_id, weight_in_kg) values (38, 423, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (39, 305, 19.3);
insert into baggage (id, booking_id, weight_in_kg) values (40, 396, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (41, 414, 21.2);
insert into baggage (id, booking_id, weight_in_kg) values (42, 324, 17.9);
insert into baggage (id, booking_id, weight_in_kg) values (43, 79, 24.1);
insert into baggage (id, booking_id, weight_in_kg) values (44, 190, 25.1);
insert into baggage (id, booking_id, weight_in_kg) values (45, 306, 21.0);
insert into baggage (id, booking_id, weight_in_kg) values (46, 334, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (47, 295, 28.9);
insert into baggage (id, booking_id, weight_in_kg) values (48, 239, 18.2);
insert into baggage (id, booking_id, weight_in_kg) values (49, 197, 28.5);
insert into baggage (id, booking_id, weight_in_kg) values (50, 352, 16.7);
insert into baggage (id, booking_id, weight_in_kg) values (51, 203, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (52, 137, 23.0);
insert into baggage (id, booking_id, weight_in_kg) values (53, 160, 29.7);
insert into baggage (id, booking_id, weight_in_kg) values (54, 364, 21.7);
insert into baggage (id, booking_id, weight_in_kg) values (55, 561, 19.6);
insert into baggage (id, booking_id, weight_in_kg) values (56, 541, 20.4);
insert into baggage (id, booking_id, weight_in_kg) values (57, 451, 16.4);
insert into baggage (id, booking_id, weight_in_kg) values (58, 35, 22.4);
insert into baggage (id, booking_id, weight_in_kg) values (59, 349, 16.3);
insert into baggage (id, booking_id, weight_in_kg) values (60, 549, 13.6);
insert into baggage (id, booking_id, weight_in_kg) values (61, 56, 24.3);
insert into baggage (id, booking_id, weight_in_kg) values (62, 451, 16.9);
insert into baggage (id, booking_id, weight_in_kg) values (63, 307, 15.1);
insert into baggage (id, booking_id, weight_in_kg) values (64, 400, 22.3);
insert into baggage (id, booking_id, weight_in_kg) values (65, 186, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (66, 81, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (67, 522, 14.4);
insert into baggage (id, booking_id, weight_in_kg) values (68, 274, 18.4);
insert into baggage (id, booking_id, weight_in_kg) values (69, 309, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (70, 562, 26.9);
insert into baggage (id, booking_id, weight_in_kg) values (71, 511, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (72, 173, 22.3);
insert into baggage (id, booking_id, weight_in_kg) values (73, 360, 12.9);
insert into baggage (id, booking_id, weight_in_kg) values (74, 444, 27.5);
insert into baggage (id, booking_id, weight_in_kg) values (75, 418, 25.6);
insert into baggage (id, booking_id, weight_in_kg) values (76, 463, 19.8);
insert into baggage (id, booking_id, weight_in_kg) values (77, 307, 11.8);
insert into baggage (id, booking_id, weight_in_kg) values (78, 434, 12.8);
insert into baggage (id, booking_id, weight_in_kg) values (79, 172, 17.9);
insert into baggage (id, booking_id, weight_in_kg) values (80, 513, 15.3);
insert into baggage (id, booking_id, weight_in_kg) values (81, 69, 26.9);
insert into baggage (id, booking_id, weight_in_kg) values (82, 123, 10.6);
insert into baggage (id, booking_id, weight_in_kg) values (83, 530, 14.0);
insert into baggage (id, booking_id, weight_in_kg) values (84, 34, 15.2);
insert into baggage (id, booking_id, weight_in_kg) values (85, 444, 18.4);
insert into baggage (id, booking_id, weight_in_kg) values (86, 12, 29.9);
insert into baggage (id, booking_id, weight_in_kg) values (87, 10, 17.9);
insert into baggage (id, booking_id, weight_in_kg) values (88, 305, 16.6);
insert into baggage (id, booking_id, weight_in_kg) values (89, 546, 10.9);
insert into baggage (id, booking_id, weight_in_kg) values (90, 57, 16.9);
insert into baggage (id, booking_id, weight_in_kg) values (91, 177, 14.3);
insert into baggage (id, booking_id, weight_in_kg) values (92, 591, 12.0);
insert into baggage (id, booking_id, weight_in_kg) values (93, 334, 29.5);
insert into baggage (id, booking_id, weight_in_kg) values (94, 161, 29.9);
insert into baggage (id, booking_id, weight_in_kg) values (95, 414, 21.2);
insert into baggage (id, booking_id, weight_in_kg) values (96, 399, 30.0);
insert into baggage (id, booking_id, weight_in_kg) values (97, 361, 18.1);
insert into baggage (id, booking_id, weight_in_kg) values (98, 576, 25.9);
insert into baggage (id, booking_id, weight_in_kg) values (99, 54, 22.2);
insert into baggage (id, booking_id, weight_in_kg) values (100, 595, 18.9);
insert into baggage (id, booking_id, weight_in_kg) values (101, 313, 13.6);
insert into baggage (id, booking_id, weight_in_kg) values (102, 247, 28.4);
insert into baggage (id, booking_id, weight_in_kg) values (103, 97, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (104, 412, 10.3);
insert into baggage (id, booking_id, weight_in_kg) values (105, 137, 13.9);
insert into baggage (id, booking_id, weight_in_kg) values (106, 541, 20.1);
insert into baggage (id, booking_id, weight_in_kg) values (107, 461, 13.8);
insert into baggage (id, booking_id, weight_in_kg) values (108, 74, 26.7);
insert into baggage (id, booking_id, weight_in_kg) values (109, 156, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (110, 499, 29.7);
insert into baggage (id, booking_id, weight_in_kg) values (111, 570, 12.3);
insert into baggage (id, booking_id, weight_in_kg) values (112, 241, 16.8);
insert into baggage (id, booking_id, weight_in_kg) values (113, 97, 10.6);
insert into baggage (id, booking_id, weight_in_kg) values (114, 474, 11.4);
insert into baggage (id, booking_id, weight_in_kg) values (115, 59, 13.5);
insert into baggage (id, booking_id, weight_in_kg) values (116, 562, 26.9);
insert into baggage (id, booking_id, weight_in_kg) values (117, 488, 16.8);
insert into baggage (id, booking_id, weight_in_kg) values (118, 189, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (119, 571, 24.8);
insert into baggage (id, booking_id, weight_in_kg) values (120, 411, 22.2);
insert into baggage (id, booking_id, weight_in_kg) values (121, 446, 11.0);
insert into baggage (id, booking_id, weight_in_kg) values (122, 78, 29.4);
insert into baggage (id, booking_id, weight_in_kg) values (123, 487, 21.3);
insert into baggage (id, booking_id, weight_in_kg) values (124, 549, 24.4);
insert into baggage (id, booking_id, weight_in_kg) values (125, 153, 10.9);
insert into baggage (id, booking_id, weight_in_kg) values (126, 159, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (127, 286, 11.6);
insert into baggage (id, booking_id, weight_in_kg) values (128, 519, 24.3);
insert into baggage (id, booking_id, weight_in_kg) values (129, 536, 10.3);
insert into baggage (id, booking_id, weight_in_kg) values (130, 576, 21.9);
insert into baggage (id, booking_id, weight_in_kg) values (131, 68, 12.6);
insert into baggage (id, booking_id, weight_in_kg) values (132, 460, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (133, 280, 12.1);
insert into baggage (id, booking_id, weight_in_kg) values (134, 467, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (135, 445, 16.7);
insert into baggage (id, booking_id, weight_in_kg) values (136, 391, 28.2);
insert into baggage (id, booking_id, weight_in_kg) values (137, 519, 18.6);
insert into baggage (id, booking_id, weight_in_kg) values (138, 302, 29.6);
insert into baggage (id, booking_id, weight_in_kg) values (139, 112, 18.7);
insert into baggage (id, booking_id, weight_in_kg) values (140, 248, 26.7);
insert into baggage (id, booking_id, weight_in_kg) values (141, 418, 22.6);
insert into baggage (id, booking_id, weight_in_kg) values (142, 532, 26.1);
insert into baggage (id, booking_id, weight_in_kg) values (143, 441, 23.9);
insert into baggage (id, booking_id, weight_in_kg) values (144, 148, 20.3);
insert into baggage (id, booking_id, weight_in_kg) values (145, 442, 11.1);
insert into baggage (id, booking_id, weight_in_kg) values (146, 342, 28.9);
insert into baggage (id, booking_id, weight_in_kg) values (147, 513, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (148, 26, 28.8);
insert into baggage (id, booking_id, weight_in_kg) values (149, 262, 27.3);
insert into baggage (id, booking_id, weight_in_kg) values (150, 251, 19.7);
insert into baggage (id, booking_id, weight_in_kg) values (151, 189, 22.4);
insert into baggage (id, booking_id, weight_in_kg) values (152, 546, 24.8);
insert into baggage (id, booking_id, weight_in_kg) values (153, 420, 13.7);
insert into baggage (id, booking_id, weight_in_kg) values (154, 157, 20.2);
insert into baggage (id, booking_id, weight_in_kg) values (155, 349, 25.7);
insert into baggage (id, booking_id, weight_in_kg) values (156, 103, 23.8);
insert into baggage (id, booking_id, weight_in_kg) values (157, 463, 20.0);
insert into baggage (id, booking_id, weight_in_kg) values (158, 553, 25.3);
insert into baggage (id, booking_id, weight_in_kg) values (159, 65, 14.8);
insert into baggage (id, booking_id, weight_in_kg) values (160, 263, 10.5);
insert into baggage (id, booking_id, weight_in_kg) values (161, 505, 27.7);
insert into baggage (id, booking_id, weight_in_kg) values (162, 436, 15.1);
insert into baggage (id, booking_id, weight_in_kg) values (163, 120, 15.5);
insert into baggage (id, booking_id, weight_in_kg) values (164, 238, 15.2);
insert into baggage (id, booking_id, weight_in_kg) values (165, 303, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (166, 73, 24.2);
insert into baggage (id, booking_id, weight_in_kg) values (167, 530, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (168, 483, 16.3);
insert into baggage (id, booking_id, weight_in_kg) values (169, 52, 18.2);
insert into baggage (id, booking_id, weight_in_kg) values (170, 133, 10.6);
insert into baggage (id, booking_id, weight_in_kg) values (171, 314, 25.7);
insert into baggage (id, booking_id, weight_in_kg) values (172, 555, 22.8);
insert into baggage (id, booking_id, weight_in_kg) values (173, 433, 10.2);
insert into baggage (id, booking_id, weight_in_kg) values (174, 577, 11.8);
insert into baggage (id, booking_id, weight_in_kg) values (175, 414, 26.5);
insert into baggage (id, booking_id, weight_in_kg) values (176, 512, 12.9);
insert into baggage (id, booking_id, weight_in_kg) values (177, 567, 15.9);
insert into baggage (id, booking_id, weight_in_kg) values (178, 42, 26.3);
insert into baggage (id, booking_id, weight_in_kg) values (179, 577, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (180, 286, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (181, 139, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (182, 16, 22.1);
insert into baggage (id, booking_id, weight_in_kg) values (183, 565, 11.3);
insert into baggage (id, booking_id, weight_in_kg) values (184, 88, 26.5);
insert into baggage (id, booking_id, weight_in_kg) values (185, 82, 21.3);
insert into baggage (id, booking_id, weight_in_kg) values (186, 340, 19.3);
insert into baggage (id, booking_id, weight_in_kg) values (187, 25, 24.3);
insert into baggage (id, booking_id, weight_in_kg) values (188, 589, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (189, 596, 14.0);
insert into baggage (id, booking_id, weight_in_kg) values (190, 563, 11.4);
insert into baggage (id, booking_id, weight_in_kg) values (191, 504, 30.0);
insert into baggage (id, booking_id, weight_in_kg) values (192, 87, 23.6);
insert into baggage (id, booking_id, weight_in_kg) values (193, 244, 29.1);
insert into baggage (id, booking_id, weight_in_kg) values (194, 225, 15.6);
insert into baggage (id, booking_id, weight_in_kg) values (195, 429, 14.1);
insert into baggage (id, booking_id, weight_in_kg) values (196, 198, 20.0);
insert into baggage (id, booking_id, weight_in_kg) values (197, 377, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (198, 518, 21.6);
insert into baggage (id, booking_id, weight_in_kg) values (199, 435, 24.6);
insert into baggage (id, booking_id, weight_in_kg) values (200, 130, 23.2);
insert into baggage (id, booking_id, weight_in_kg) values (201, 67, 24.0);
insert into baggage (id, booking_id, weight_in_kg) values (202, 326, 20.2);
insert into baggage (id, booking_id, weight_in_kg) values (203, 316, 27.4);
insert into baggage (id, booking_id, weight_in_kg) values (204, 36, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (205, 528, 28.2);
insert into baggage (id, booking_id, weight_in_kg) values (206, 69, 16.1);
insert into baggage (id, booking_id, weight_in_kg) values (207, 63, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (208, 313, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (209, 521, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (210, 436, 12.1);
insert into baggage (id, booking_id, weight_in_kg) values (211, 400, 21.9);
insert into baggage (id, booking_id, weight_in_kg) values (212, 137, 22.0);
insert into baggage (id, booking_id, weight_in_kg) values (213, 153, 21.1);
insert into baggage (id, booking_id, weight_in_kg) values (214, 200, 26.2);
insert into baggage (id, booking_id, weight_in_kg) values (215, 269, 18.8);
insert into baggage (id, booking_id, weight_in_kg) values (216, 209, 13.2);
insert into baggage (id, booking_id, weight_in_kg) values (217, 518, 24.5);
insert into baggage (id, booking_id, weight_in_kg) values (218, 427, 15.0);
insert into baggage (id, booking_id, weight_in_kg) values (219, 95, 22.5);
insert into baggage (id, booking_id, weight_in_kg) values (220, 209, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (221, 124, 24.5);
insert into baggage (id, booking_id, weight_in_kg) values (222, 178, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (223, 425, 18.6);
insert into baggage (id, booking_id, weight_in_kg) values (224, 362, 24.8);
insert into baggage (id, booking_id, weight_in_kg) values (225, 139, 27.4);
insert into baggage (id, booking_id, weight_in_kg) values (226, 143, 12.0);
insert into baggage (id, booking_id, weight_in_kg) values (227, 537, 28.9);
insert into baggage (id, booking_id, weight_in_kg) values (228, 150, 10.1);
insert into baggage (id, booking_id, weight_in_kg) values (229, 60, 19.7);
insert into baggage (id, booking_id, weight_in_kg) values (230, 121, 17.5);
insert into baggage (id, booking_id, weight_in_kg) values (231, 90, 29.9);
insert into baggage (id, booking_id, weight_in_kg) values (232, 598, 18.7);
insert into baggage (id, booking_id, weight_in_kg) values (233, 411, 28.9);
insert into baggage (id, booking_id, weight_in_kg) values (234, 36, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (235, 129, 23.9);
insert into baggage (id, booking_id, weight_in_kg) values (236, 436, 23.8);
insert into baggage (id, booking_id, weight_in_kg) values (237, 217, 24.4);
insert into baggage (id, booking_id, weight_in_kg) values (238, 420, 29.7);
insert into baggage (id, booking_id, weight_in_kg) values (239, 493, 17.8);
insert into baggage (id, booking_id, weight_in_kg) values (240, 557, 27.0);
insert into baggage (id, booking_id, weight_in_kg) values (241, 443, 15.1);
insert into baggage (id, booking_id, weight_in_kg) values (242, 219, 10.6);
insert into baggage (id, booking_id, weight_in_kg) values (243, 48, 26.3);
insert into baggage (id, booking_id, weight_in_kg) values (244, 337, 14.0);
insert into baggage (id, booking_id, weight_in_kg) values (245, 334, 20.7);
insert into baggage (id, booking_id, weight_in_kg) values (246, 228, 16.4);
insert into baggage (id, booking_id, weight_in_kg) values (247, 445, 27.2);
insert into baggage (id, booking_id, weight_in_kg) values (248, 589, 28.7);
insert into baggage (id, booking_id, weight_in_kg) values (249, 470, 24.5);
insert into baggage (id, booking_id, weight_in_kg) values (250, 416, 24.6);
insert into baggage (id, booking_id, weight_in_kg) values (251, 15, 16.4);
insert into baggage (id, booking_id, weight_in_kg) values (252, 479, 12.5);
insert into baggage (id, booking_id, weight_in_kg) values (253, 327, 23.8);
insert into baggage (id, booking_id, weight_in_kg) values (254, 170, 22.0);
insert into baggage (id, booking_id, weight_in_kg) values (255, 217, 22.5);
insert into baggage (id, booking_id, weight_in_kg) values (256, 158, 27.1);
insert into baggage (id, booking_id, weight_in_kg) values (257, 128, 11.3);
insert into baggage (id, booking_id, weight_in_kg) values (258, 57, 16.6);
insert into baggage (id, booking_id, weight_in_kg) values (259, 25, 18.2);
insert into baggage (id, booking_id, weight_in_kg) values (260, 129, 12.2);
insert into baggage (id, booking_id, weight_in_kg) values (261, 202, 21.4);
insert into baggage (id, booking_id, weight_in_kg) values (262, 496, 27.3);
insert into baggage (id, booking_id, weight_in_kg) values (263, 94, 26.6);
insert into baggage (id, booking_id, weight_in_kg) values (264, 315, 25.3);
insert into baggage (id, booking_id, weight_in_kg) values (265, 576, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (266, 538, 21.0);
insert into baggage (id, booking_id, weight_in_kg) values (267, 505, 16.7);
insert into baggage (id, booking_id, weight_in_kg) values (268, 529, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (269, 158, 18.8);
insert into baggage (id, booking_id, weight_in_kg) values (270, 46, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (271, 461, 26.6);
insert into baggage (id, booking_id, weight_in_kg) values (272, 207, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (273, 278, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (274, 460, 22.1);
insert into baggage (id, booking_id, weight_in_kg) values (275, 368, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (276, 22, 16.1);
insert into baggage (id, booking_id, weight_in_kg) values (277, 517, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (278, 168, 14.2);
insert into baggage (id, booking_id, weight_in_kg) values (279, 294, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (280, 346, 29.7);
insert into baggage (id, booking_id, weight_in_kg) values (281, 318, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (282, 437, 28.3);
insert into baggage (id, booking_id, weight_in_kg) values (283, 254, 20.4);
insert into baggage (id, booking_id, weight_in_kg) values (284, 131, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (285, 406, 13.9);
insert into baggage (id, booking_id, weight_in_kg) values (286, 314, 22.4);
insert into baggage (id, booking_id, weight_in_kg) values (287, 505, 26.6);
insert into baggage (id, booking_id, weight_in_kg) values (288, 256, 21.6);
insert into baggage (id, booking_id, weight_in_kg) values (289, 52, 11.3);
insert into baggage (id, booking_id, weight_in_kg) values (290, 60, 17.6);
insert into baggage (id, booking_id, weight_in_kg) values (291, 425, 11.1);
insert into baggage (id, booking_id, weight_in_kg) values (292, 374, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (293, 218, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (294, 415, 12.6);
insert into baggage (id, booking_id, weight_in_kg) values (295, 122, 28.3);
insert into baggage (id, booking_id, weight_in_kg) values (296, 207, 11.0);
insert into baggage (id, booking_id, weight_in_kg) values (297, 139, 18.8);
insert into baggage (id, booking_id, weight_in_kg) values (298, 150, 18.9);
insert into baggage (id, booking_id, weight_in_kg) values (299, 283, 10.1);
insert into baggage (id, booking_id, weight_in_kg) values (300, 256, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (301, 362, 27.3);
insert into baggage (id, booking_id, weight_in_kg) values (302, 559, 28.2);
insert into baggage (id, booking_id, weight_in_kg) values (303, 105, 27.2);
insert into baggage (id, booking_id, weight_in_kg) values (304, 211, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (305, 14, 16.7);
insert into baggage (id, booking_id, weight_in_kg) values (306, 220, 13.3);
insert into baggage (id, booking_id, weight_in_kg) values (307, 23, 10.4);
insert into baggage (id, booking_id, weight_in_kg) values (308, 293, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (309, 484, 26.8);
insert into baggage (id, booking_id, weight_in_kg) values (310, 345, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (311, 225, 22.8);
insert into baggage (id, booking_id, weight_in_kg) values (312, 61, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (313, 375, 23.7);
insert into baggage (id, booking_id, weight_in_kg) values (314, 520, 11.7);
insert into baggage (id, booking_id, weight_in_kg) values (315, 138, 18.4);
insert into baggage (id, booking_id, weight_in_kg) values (316, 590, 27.3);
insert into baggage (id, booking_id, weight_in_kg) values (317, 119, 22.3);
insert into baggage (id, booking_id, weight_in_kg) values (318, 392, 12.6);
insert into baggage (id, booking_id, weight_in_kg) values (319, 154, 29.5);
insert into baggage (id, booking_id, weight_in_kg) values (320, 240, 19.1);
insert into baggage (id, booking_id, weight_in_kg) values (321, 15, 26.3);
insert into baggage (id, booking_id, weight_in_kg) values (322, 411, 12.4);
insert into baggage (id, booking_id, weight_in_kg) values (323, 414, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (324, 91, 20.3);
insert into baggage (id, booking_id, weight_in_kg) values (325, 490, 29.7);
insert into baggage (id, booking_id, weight_in_kg) values (326, 10, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (327, 41, 29.2);
insert into baggage (id, booking_id, weight_in_kg) values (328, 56, 22.8);
insert into baggage (id, booking_id, weight_in_kg) values (329, 101, 20.3);
insert into baggage (id, booking_id, weight_in_kg) values (330, 377, 29.0);
insert into baggage (id, booking_id, weight_in_kg) values (331, 262, 21.7);
insert into baggage (id, booking_id, weight_in_kg) values (332, 198, 25.8);
insert into baggage (id, booking_id, weight_in_kg) values (333, 85, 15.0);
insert into baggage (id, booking_id, weight_in_kg) values (334, 508, 15.0);
insert into baggage (id, booking_id, weight_in_kg) values (335, 95, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (336, 370, 27.9);
insert into baggage (id, booking_id, weight_in_kg) values (337, 260, 24.7);
insert into baggage (id, booking_id, weight_in_kg) values (338, 12, 22.4);
insert into baggage (id, booking_id, weight_in_kg) values (339, 483, 27.5);
insert into baggage (id, booking_id, weight_in_kg) values (340, 168, 19.7);
insert into baggage (id, booking_id, weight_in_kg) values (341, 401, 25.6);
insert into baggage (id, booking_id, weight_in_kg) values (342, 570, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (343, 169, 19.5);
insert into baggage (id, booking_id, weight_in_kg) values (344, 60, 13.8);
insert into baggage (id, booking_id, weight_in_kg) values (345, 553, 23.4);
insert into baggage (id, booking_id, weight_in_kg) values (346, 66, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (347, 382, 19.1);
insert into baggage (id, booking_id, weight_in_kg) values (348, 19, 16.3);
insert into baggage (id, booking_id, weight_in_kg) values (349, 161, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (350, 427, 11.9);
insert into baggage (id, booking_id, weight_in_kg) values (351, 398, 14.0);
insert into baggage (id, booking_id, weight_in_kg) values (352, 90, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (353, 19, 17.2);
insert into baggage (id, booking_id, weight_in_kg) values (354, 25, 29.3);
insert into baggage (id, booking_id, weight_in_kg) values (355, 14, 22.4);
insert into baggage (id, booking_id, weight_in_kg) values (356, 105, 12.9);
insert into baggage (id, booking_id, weight_in_kg) values (357, 470, 14.8);
insert into baggage (id, booking_id, weight_in_kg) values (358, 576, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (359, 557, 27.0);
insert into baggage (id, booking_id, weight_in_kg) values (360, 449, 20.2);
insert into baggage (id, booking_id, weight_in_kg) values (361, 398, 28.6);
insert into baggage (id, booking_id, weight_in_kg) values (362, 109, 27.4);
insert into baggage (id, booking_id, weight_in_kg) values (363, 376, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (364, 329, 23.4);
insert into baggage (id, booking_id, weight_in_kg) values (365, 551, 17.3);
insert into baggage (id, booking_id, weight_in_kg) values (366, 343, 20.5);
insert into baggage (id, booking_id, weight_in_kg) values (367, 121, 10.1);
insert into baggage (id, booking_id, weight_in_kg) values (368, 138, 29.8);
insert into baggage (id, booking_id, weight_in_kg) values (369, 488, 12.1);
insert into baggage (id, booking_id, weight_in_kg) values (370, 104, 25.5);
insert into baggage (id, booking_id, weight_in_kg) values (371, 408, 20.8);
insert into baggage (id, booking_id, weight_in_kg) values (372, 274, 11.1);
insert into baggage (id, booking_id, weight_in_kg) values (373, 526, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (374, 523, 29.3);
insert into baggage (id, booking_id, weight_in_kg) values (375, 387, 25.6);
insert into baggage (id, booking_id, weight_in_kg) values (376, 185, 29.2);
insert into baggage (id, booking_id, weight_in_kg) values (377, 251, 27.9);
insert into baggage (id, booking_id, weight_in_kg) values (378, 31, 29.5);
insert into baggage (id, booking_id, weight_in_kg) values (379, 179, 12.4);
insert into baggage (id, booking_id, weight_in_kg) values (380, 457, 22.9);
insert into baggage (id, booking_id, weight_in_kg) values (381, 37, 28.3);
insert into baggage (id, booking_id, weight_in_kg) values (382, 122, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (383, 173, 28.7);
insert into baggage (id, booking_id, weight_in_kg) values (384, 451, 29.6);
insert into baggage (id, booking_id, weight_in_kg) values (385, 221, 10.1);
insert into baggage (id, booking_id, weight_in_kg) values (386, 86, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (387, 600, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (388, 407, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (389, 319, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (390, 405, 26.2);
insert into baggage (id, booking_id, weight_in_kg) values (391, 534, 21.5);
insert into baggage (id, booking_id, weight_in_kg) values (392, 360, 11.1);
insert into baggage (id, booking_id, weight_in_kg) values (393, 536, 21.0);
insert into baggage (id, booking_id, weight_in_kg) values (394, 382, 21.4);
insert into baggage (id, booking_id, weight_in_kg) values (395, 51, 15.2);
insert into baggage (id, booking_id, weight_in_kg) values (396, 234, 27.1);
insert into baggage (id, booking_id, weight_in_kg) values (397, 543, 18.6);
insert into baggage (id, booking_id, weight_in_kg) values (398, 44, 27.4);
insert into baggage (id, booking_id, weight_in_kg) values (399, 87, 29.0);
insert into baggage (id, booking_id, weight_in_kg) values (400, 328, 14.8);
insert into baggage (id, booking_id, weight_in_kg) values (401, 282, 11.3);
insert into baggage (id, booking_id, weight_in_kg) values (402, 588, 12.3);
insert into baggage (id, booking_id, weight_in_kg) values (403, 58, 13.0);
insert into baggage (id, booking_id, weight_in_kg) values (404, 216, 12.6);
insert into baggage (id, booking_id, weight_in_kg) values (405, 534, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (406, 461, 24.7);
insert into baggage (id, booking_id, weight_in_kg) values (407, 452, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (408, 293, 25.2);
insert into baggage (id, booking_id, weight_in_kg) values (409, 456, 10.5);
insert into baggage (id, booking_id, weight_in_kg) values (410, 374, 24.8);
insert into baggage (id, booking_id, weight_in_kg) values (411, 420, 22.6);
insert into baggage (id, booking_id, weight_in_kg) values (412, 514, 16.1);
insert into baggage (id, booking_id, weight_in_kg) values (413, 96, 30.0);
insert into baggage (id, booking_id, weight_in_kg) values (414, 318, 21.6);
insert into baggage (id, booking_id, weight_in_kg) values (415, 60, 24.7);
insert into baggage (id, booking_id, weight_in_kg) values (416, 426, 26.5);
insert into baggage (id, booking_id, weight_in_kg) values (417, 599, 10.1);
insert into baggage (id, booking_id, weight_in_kg) values (418, 228, 16.7);
insert into baggage (id, booking_id, weight_in_kg) values (419, 334, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (420, 426, 27.6);
insert into baggage (id, booking_id, weight_in_kg) values (421, 114, 26.5);
insert into baggage (id, booking_id, weight_in_kg) values (422, 78, 23.7);
insert into baggage (id, booking_id, weight_in_kg) values (423, 568, 23.5);
insert into baggage (id, booking_id, weight_in_kg) values (424, 388, 28.9);
insert into baggage (id, booking_id, weight_in_kg) values (425, 597, 17.5);
insert into baggage (id, booking_id, weight_in_kg) values (426, 575, 20.6);
insert into baggage (id, booking_id, weight_in_kg) values (427, 259, 26.3);
insert into baggage (id, booking_id, weight_in_kg) values (428, 71, 25.3);
insert into baggage (id, booking_id, weight_in_kg) values (429, 70, 21.4);
insert into baggage (id, booking_id, weight_in_kg) values (430, 129, 29.1);
insert into baggage (id, booking_id, weight_in_kg) values (431, 283, 21.1);
insert into baggage (id, booking_id, weight_in_kg) values (432, 190, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (433, 425, 13.4);
insert into baggage (id, booking_id, weight_in_kg) values (434, 159, 17.3);
insert into baggage (id, booking_id, weight_in_kg) values (435, 76, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (436, 410, 18.2);
insert into baggage (id, booking_id, weight_in_kg) values (437, 325, 19.8);
insert into baggage (id, booking_id, weight_in_kg) values (438, 36, 27.0);
insert into baggage (id, booking_id, weight_in_kg) values (439, 108, 11.9);
insert into baggage (id, booking_id, weight_in_kg) values (440, 116, 21.5);
insert into baggage (id, booking_id, weight_in_kg) values (441, 225, 29.4);
insert into baggage (id, booking_id, weight_in_kg) values (442, 121, 27.0);
insert into baggage (id, booking_id, weight_in_kg) values (443, 300, 25.5);
insert into baggage (id, booking_id, weight_in_kg) values (444, 279, 19.3);
insert into baggage (id, booking_id, weight_in_kg) values (445, 526, 22.2);
insert into baggage (id, booking_id, weight_in_kg) values (446, 595, 12.1);
insert into baggage (id, booking_id, weight_in_kg) values (447, 112, 24.6);
insert into baggage (id, booking_id, weight_in_kg) values (448, 108, 12.4);
insert into baggage (id, booking_id, weight_in_kg) values (449, 235, 21.3);
insert into baggage (id, booking_id, weight_in_kg) values (450, 258, 24.1);
insert into baggage (id, booking_id, weight_in_kg) values (451, 142, 26.6);
insert into baggage (id, booking_id, weight_in_kg) values (452, 554, 14.7);
insert into baggage (id, booking_id, weight_in_kg) values (453, 70, 25.5);
insert into baggage (id, booking_id, weight_in_kg) values (454, 215, 24.4);
insert into baggage (id, booking_id, weight_in_kg) values (455, 559, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (456, 237, 12.9);
insert into baggage (id, booking_id, weight_in_kg) values (457, 345, 20.2);
insert into baggage (id, booking_id, weight_in_kg) values (458, 338, 24.1);
insert into baggage (id, booking_id, weight_in_kg) values (459, 198, 23.4);
insert into baggage (id, booking_id, weight_in_kg) values (460, 365, 21.7);
insert into baggage (id, booking_id, weight_in_kg) values (461, 117, 15.6);
insert into baggage (id, booking_id, weight_in_kg) values (462, 362, 13.6);
insert into baggage (id, booking_id, weight_in_kg) values (463, 354, 20.1);
insert into baggage (id, booking_id, weight_in_kg) values (464, 350, 21.8);
insert into baggage (id, booking_id, weight_in_kg) values (465, 327, 14.3);
insert into baggage (id, booking_id, weight_in_kg) values (466, 519, 26.0);
insert into baggage (id, booking_id, weight_in_kg) values (467, 48, 10.6);
insert into baggage (id, booking_id, weight_in_kg) values (468, 347, 18.9);
insert into baggage (id, booking_id, weight_in_kg) values (469, 181, 17.9);
insert into baggage (id, booking_id, weight_in_kg) values (470, 559, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (471, 535, 11.9);
insert into baggage (id, booking_id, weight_in_kg) values (472, 146, 25.2);
insert into baggage (id, booking_id, weight_in_kg) values (473, 226, 13.4);
insert into baggage (id, booking_id, weight_in_kg) values (474, 58, 21.7);
insert into baggage (id, booking_id, weight_in_kg) values (475, 74, 12.2);
insert into baggage (id, booking_id, weight_in_kg) values (476, 46, 11.7);
insert into baggage (id, booking_id, weight_in_kg) values (477, 173, 18.9);
insert into baggage (id, booking_id, weight_in_kg) values (478, 398, 14.1);
insert into baggage (id, booking_id, weight_in_kg) values (479, 420, 14.2);
insert into baggage (id, booking_id, weight_in_kg) values (480, 81, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (481, 182, 28.5);
insert into baggage (id, booking_id, weight_in_kg) values (482, 438, 13.0);
insert into baggage (id, booking_id, weight_in_kg) values (483, 427, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (484, 485, 16.3);
insert into baggage (id, booking_id, weight_in_kg) values (485, 288, 10.3);
insert into baggage (id, booking_id, weight_in_kg) values (486, 46, 11.9);
insert into baggage (id, booking_id, weight_in_kg) values (487, 214, 25.7);
insert into baggage (id, booking_id, weight_in_kg) values (488, 340, 26.1);
insert into baggage (id, booking_id, weight_in_kg) values (489, 50, 24.1);
insert into baggage (id, booking_id, weight_in_kg) values (490, 489, 27.9);
insert into baggage (id, booking_id, weight_in_kg) values (491, 96, 27.9);
insert into baggage (id, booking_id, weight_in_kg) values (492, 149, 22.5);
insert into baggage (id, booking_id, weight_in_kg) values (493, 507, 20.9);
insert into baggage (id, booking_id, weight_in_kg) values (494, 545, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (495, 536, 10.1);
insert into baggage (id, booking_id, weight_in_kg) values (496, 168, 11.9);
insert into baggage (id, booking_id, weight_in_kg) values (497, 556, 12.0);
insert into baggage (id, booking_id, weight_in_kg) values (498, 111, 16.3);
insert into baggage (id, booking_id, weight_in_kg) values (499, 93, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (500, 454, 17.4);
insert into baggage (id, booking_id, weight_in_kg) values (501, 128, 16.7);
insert into baggage (id, booking_id, weight_in_kg) values (502, 281, 21.2);
insert into baggage (id, booking_id, weight_in_kg) values (503, 547, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (504, 356, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (505, 224, 26.0);
insert into baggage (id, booking_id, weight_in_kg) values (506, 98, 19.0);
insert into baggage (id, booking_id, weight_in_kg) values (507, 389, 29.3);
insert into baggage (id, booking_id, weight_in_kg) values (508, 588, 27.6);
insert into baggage (id, booking_id, weight_in_kg) values (509, 360, 14.9);
insert into baggage (id, booking_id, weight_in_kg) values (510, 268, 20.7);
insert into baggage (id, booking_id, weight_in_kg) values (511, 227, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (512, 493, 14.7);
insert into baggage (id, booking_id, weight_in_kg) values (513, 61, 11.4);
insert into baggage (id, booking_id, weight_in_kg) values (514, 427, 24.9);
insert into baggage (id, booking_id, weight_in_kg) values (515, 103, 21.2);
insert into baggage (id, booking_id, weight_in_kg) values (516, 193, 24.3);
insert into baggage (id, booking_id, weight_in_kg) values (517, 350, 22.2);
insert into baggage (id, booking_id, weight_in_kg) values (518, 330, 14.0);
insert into baggage (id, booking_id, weight_in_kg) values (519, 270, 14.8);
insert into baggage (id, booking_id, weight_in_kg) values (520, 203, 28.6);
insert into baggage (id, booking_id, weight_in_kg) values (521, 30, 27.8);
insert into baggage (id, booking_id, weight_in_kg) values (522, 117, 16.9);
insert into baggage (id, booking_id, weight_in_kg) values (523, 381, 28.9);
insert into baggage (id, booking_id, weight_in_kg) values (524, 259, 20.6);
insert into baggage (id, booking_id, weight_in_kg) values (525, 128, 16.6);
insert into baggage (id, booking_id, weight_in_kg) values (526, 272, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (527, 364, 17.8);
insert into baggage (id, booking_id, weight_in_kg) values (528, 155, 28.8);
insert into baggage (id, booking_id, weight_in_kg) values (529, 490, 14.3);
insert into baggage (id, booking_id, weight_in_kg) values (530, 224, 20.1);
insert into baggage (id, booking_id, weight_in_kg) values (531, 168, 22.0);
insert into baggage (id, booking_id, weight_in_kg) values (532, 240, 10.4);
insert into baggage (id, booking_id, weight_in_kg) values (533, 117, 27.9);
insert into baggage (id, booking_id, weight_in_kg) values (534, 71, 29.3);
insert into baggage (id, booking_id, weight_in_kg) values (535, 33, 15.9);
insert into baggage (id, booking_id, weight_in_kg) values (536, 550, 18.9);
insert into baggage (id, booking_id, weight_in_kg) values (537, 558, 22.5);
insert into baggage (id, booking_id, weight_in_kg) values (538, 177, 10.2);
insert into baggage (id, booking_id, weight_in_kg) values (539, 256, 29.0);
insert into baggage (id, booking_id, weight_in_kg) values (540, 295, 24.0);
insert into baggage (id, booking_id, weight_in_kg) values (541, 173, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (542, 600, 29.3);
insert into baggage (id, booking_id, weight_in_kg) values (543, 447, 26.5);
insert into baggage (id, booking_id, weight_in_kg) values (544, 110, 25.5);
insert into baggage (id, booking_id, weight_in_kg) values (545, 515, 20.4);
insert into baggage (id, booking_id, weight_in_kg) values (546, 342, 17.4);
insert into baggage (id, booking_id, weight_in_kg) values (547, 65, 10.7);
insert into baggage (id, booking_id, weight_in_kg) values (548, 425, 28.8);
insert into baggage (id, booking_id, weight_in_kg) values (549, 544, 24.4);
insert into baggage (id, booking_id, weight_in_kg) values (550, 305, 10.4);
insert into baggage (id, booking_id, weight_in_kg) values (551, 80, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (552, 467, 24.2);
insert into baggage (id, booking_id, weight_in_kg) values (553, 218, 28.6);
insert into baggage (id, booking_id, weight_in_kg) values (554, 188, 24.0);
insert into baggage (id, booking_id, weight_in_kg) values (555, 561, 25.3);
insert into baggage (id, booking_id, weight_in_kg) values (556, 296, 27.1);
insert into baggage (id, booking_id, weight_in_kg) values (557, 47, 12.6);
insert into baggage (id, booking_id, weight_in_kg) values (558, 341, 21.4);
insert into baggage (id, booking_id, weight_in_kg) values (559, 221, 10.4);
insert into baggage (id, booking_id, weight_in_kg) values (560, 132, 29.0);
insert into baggage (id, booking_id, weight_in_kg) values (561, 486, 11.6);
insert into baggage (id, booking_id, weight_in_kg) values (562, 583, 21.8);
insert into baggage (id, booking_id, weight_in_kg) values (563, 263, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (564, 282, 17.3);
insert into baggage (id, booking_id, weight_in_kg) values (565, 443, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (566, 380, 25.7);
insert into baggage (id, booking_id, weight_in_kg) values (567, 53, 18.7);
insert into baggage (id, booking_id, weight_in_kg) values (568, 242, 13.8);
insert into baggage (id, booking_id, weight_in_kg) values (569, 396, 29.3);
insert into baggage (id, booking_id, weight_in_kg) values (570, 198, 20.1);
insert into baggage (id, booking_id, weight_in_kg) values (571, 135, 29.4);
insert into baggage (id, booking_id, weight_in_kg) values (572, 125, 26.2);
insert into baggage (id, booking_id, weight_in_kg) values (573, 212, 20.7);
insert into baggage (id, booking_id, weight_in_kg) values (574, 528, 11.1);
insert into baggage (id, booking_id, weight_in_kg) values (575, 579, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (576, 209, 22.0);
insert into baggage (id, booking_id, weight_in_kg) values (577, 571, 29.5);
insert into baggage (id, booking_id, weight_in_kg) values (578, 236, 29.2);
insert into baggage (id, booking_id, weight_in_kg) values (579, 371, 15.2);
insert into baggage (id, booking_id, weight_in_kg) values (580, 64, 14.6);
insert into baggage (id, booking_id, weight_in_kg) values (581, 581, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (582, 502, 13.4);
insert into baggage (id, booking_id, weight_in_kg) values (583, 495, 28.8);
insert into baggage (id, booking_id, weight_in_kg) values (584, 531, 21.4);
insert into baggage (id, booking_id, weight_in_kg) values (585, 253, 15.3);
insert into baggage (id, booking_id, weight_in_kg) values (586, 158, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (587, 328, 26.1);
insert into baggage (id, booking_id, weight_in_kg) values (588, 252, 11.3);
insert into baggage (id, booking_id, weight_in_kg) values (589, 544, 15.4);
insert into baggage (id, booking_id, weight_in_kg) values (590, 444, 21.6);
insert into baggage (id, booking_id, weight_in_kg) values (591, 174, 14.6);
insert into baggage (id, booking_id, weight_in_kg) values (592, 420, 15.3);
insert into baggage (id, booking_id, weight_in_kg) values (593, 143, 19.6);
insert into baggage (id, booking_id, weight_in_kg) values (594, 427, 27.0);
insert into baggage (id, booking_id, weight_in_kg) values (595, 400, 13.0);
insert into baggage (id, booking_id, weight_in_kg) values (596, 401, 10.9);
insert into baggage (id, booking_id, weight_in_kg) values (597, 218, 26.9);
insert into baggage (id, booking_id, weight_in_kg) values (598, 539, 29.8);
insert into baggage (id, booking_id, weight_in_kg) values (599, 161, 19.4);
insert into baggage (id, booking_id, weight_in_kg) values (600, 304, 15.1);
insert into baggage (id, booking_id, weight_in_kg) values (601, 514, 13.4);
insert into baggage (id, booking_id, weight_in_kg) values (602, 279, 22.8);
insert into baggage (id, booking_id, weight_in_kg) values (603, 127, 11.8);
insert into baggage (id, booking_id, weight_in_kg) values (604, 368, 17.1);
insert into baggage (id, booking_id, weight_in_kg) values (605, 125, 29.5);
insert into baggage (id, booking_id, weight_in_kg) values (606, 402, 17.5);
insert into baggage (id, booking_id, weight_in_kg) values (607, 536, 18.3);
insert into baggage (id, booking_id, weight_in_kg) values (608, 460, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (609, 315, 26.2);
insert into baggage (id, booking_id, weight_in_kg) values (610, 64, 21.5);
insert into baggage (id, booking_id, weight_in_kg) values (611, 188, 20.8);
insert into baggage (id, booking_id, weight_in_kg) values (612, 552, 25.4);
insert into baggage (id, booking_id, weight_in_kg) values (613, 371, 14.1);
insert into baggage (id, booking_id, weight_in_kg) values (614, 144, 21.3);
insert into baggage (id, booking_id, weight_in_kg) values (615, 97, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (616, 171, 13.1);
insert into baggage (id, booking_id, weight_in_kg) values (617, 27, 18.4);
insert into baggage (id, booking_id, weight_in_kg) values (618, 60, 15.1);
insert into baggage (id, booking_id, weight_in_kg) values (619, 534, 12.4);
insert into baggage (id, booking_id, weight_in_kg) values (620, 488, 24.2);
insert into baggage (id, booking_id, weight_in_kg) values (621, 407, 13.6);
insert into baggage (id, booking_id, weight_in_kg) values (622, 513, 29.9);
insert into baggage (id, booking_id, weight_in_kg) values (623, 25, 29.8);
insert into baggage (id, booking_id, weight_in_kg) values (624, 231, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (625, 420, 20.4);
insert into baggage (id, booking_id, weight_in_kg) values (626, 526, 15.7);
insert into baggage (id, booking_id, weight_in_kg) values (627, 26, 12.1);
insert into baggage (id, booking_id, weight_in_kg) values (628, 33, 21.9);
insert into baggage (id, booking_id, weight_in_kg) values (629, 252, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (630, 435, 26.3);
insert into baggage (id, booking_id, weight_in_kg) values (631, 184, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (632, 597, 12.1);
insert into baggage (id, booking_id, weight_in_kg) values (633, 143, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (634, 18, 18.4);
insert into baggage (id, booking_id, weight_in_kg) values (635, 58, 21.0);
insert into baggage (id, booking_id, weight_in_kg) values (636, 182, 12.2);
insert into baggage (id, booking_id, weight_in_kg) values (637, 401, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (638, 114, 21.1);
insert into baggage (id, booking_id, weight_in_kg) values (639, 497, 18.8);
insert into baggage (id, booking_id, weight_in_kg) values (640, 144, 15.3);
insert into baggage (id, booking_id, weight_in_kg) values (641, 263, 18.7);
insert into baggage (id, booking_id, weight_in_kg) values (642, 187, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (643, 488, 10.9);
insert into baggage (id, booking_id, weight_in_kg) values (644, 330, 26.2);
insert into baggage (id, booking_id, weight_in_kg) values (645, 109, 10.3);
insert into baggage (id, booking_id, weight_in_kg) values (646, 27, 13.6);
insert into baggage (id, booking_id, weight_in_kg) values (647, 320, 26.0);
insert into baggage (id, booking_id, weight_in_kg) values (648, 144, 22.7);
insert into baggage (id, booking_id, weight_in_kg) values (649, 117, 18.5);
insert into baggage (id, booking_id, weight_in_kg) values (650, 411, 25.8);
insert into baggage (id, booking_id, weight_in_kg) values (651, 443, 25.1);
insert into baggage (id, booking_id, weight_in_kg) values (652, 150, 28.0);
insert into baggage (id, booking_id, weight_in_kg) values (653, 42, 14.3);
insert into baggage (id, booking_id, weight_in_kg) values (654, 341, 17.1);
insert into baggage (id, booking_id, weight_in_kg) values (655, 167, 12.9);
insert into baggage (id, booking_id, weight_in_kg) values (656, 57, 23.2);
insert into baggage (id, booking_id, weight_in_kg) values (657, 227, 24.5);
insert into baggage (id, booking_id, weight_in_kg) values (658, 469, 22.8);
insert into baggage (id, booking_id, weight_in_kg) values (659, 483, 24.0);
insert into baggage (id, booking_id, weight_in_kg) values (660, 461, 11.7);
insert into baggage (id, booking_id, weight_in_kg) values (661, 41, 27.3);
insert into baggage (id, booking_id, weight_in_kg) values (662, 25, 23.7);
insert into baggage (id, booking_id, weight_in_kg) values (663, 130, 15.8);
insert into baggage (id, booking_id, weight_in_kg) values (664, 213, 19.2);
insert into baggage (id, booking_id, weight_in_kg) values (665, 126, 21.7);
insert into baggage (id, booking_id, weight_in_kg) values (666, 583, 28.4);
insert into baggage (id, booking_id, weight_in_kg) values (667, 279, 27.1);
insert into baggage (id, booking_id, weight_in_kg) values (668, 534, 14.9);
insert into baggage (id, booking_id, weight_in_kg) values (669, 467, 17.7);
insert into baggage (id, booking_id, weight_in_kg) values (670, 418, 29.4);
insert into baggage (id, booking_id, weight_in_kg) values (671, 308, 21.3);
insert into baggage (id, booking_id, weight_in_kg) values (672, 151, 18.0);
insert into baggage (id, booking_id, weight_in_kg) values (673, 49, 16.8);
insert into baggage (id, booking_id, weight_in_kg) values (674, 455, 19.5);
insert into baggage (id, booking_id, weight_in_kg) values (675, 321, 19.7);
insert into baggage (id, booking_id, weight_in_kg) values (676, 513, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (677, 38, 14.5);
insert into baggage (id, booking_id, weight_in_kg) values (678, 480, 23.8);
insert into baggage (id, booking_id, weight_in_kg) values (679, 263, 25.5);
insert into baggage (id, booking_id, weight_in_kg) values (680, 507, 25.2);
insert into baggage (id, booking_id, weight_in_kg) values (681, 261, 13.4);
insert into baggage (id, booking_id, weight_in_kg) values (682, 152, 28.1);
insert into baggage (id, booking_id, weight_in_kg) values (683, 306, 24.6);
insert into baggage (id, booking_id, weight_in_kg) values (684, 87, 24.1);
insert into baggage (id, booking_id, weight_in_kg) values (685, 76, 16.1);
insert into baggage (id, booking_id, weight_in_kg) values (686, 70, 18.0);
insert into baggage (id, booking_id, weight_in_kg) values (687, 206, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (688, 206, 20.4);
insert into baggage (id, booking_id, weight_in_kg) values (689, 457, 16.2);
insert into baggage (id, booking_id, weight_in_kg) values (690, 317, 20.6);
insert into baggage (id, booking_id, weight_in_kg) values (691, 434, 10.9);
insert into baggage (id, booking_id, weight_in_kg) values (692, 39, 18.4);
insert into baggage (id, booking_id, weight_in_kg) values (693, 211, 19.7);
insert into baggage (id, booking_id, weight_in_kg) values (694, 488, 28.7);
insert into baggage (id, booking_id, weight_in_kg) values (695, 167, 21.4);
insert into baggage (id, booking_id, weight_in_kg) values (696, 327, 19.1);
insert into baggage (id, booking_id, weight_in_kg) values (697, 195, 26.5);
insert into baggage (id, booking_id, weight_in_kg) values (698, 220, 23.2);
insert into baggage (id, booking_id, weight_in_kg) values (699, 62, 25.9);
insert into baggage (id, booking_id, weight_in_kg) values (700, 215, 24.9);
insert into baggage (id, booking_id, weight_in_kg) values (701, 506, 26.4);
insert into baggage (id, booking_id, weight_in_kg) values (702, 385, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (703, 171, 28.3);
insert into baggage (id, booking_id, weight_in_kg) values (704, 436, 16.4);
insert into baggage (id, booking_id, weight_in_kg) values (705, 148, 29.9);
insert into baggage (id, booking_id, weight_in_kg) values (706, 11, 17.6);
insert into baggage (id, booking_id, weight_in_kg) values (707, 556, 17.9);
insert into baggage (id, booking_id, weight_in_kg) values (708, 487, 16.4);
insert into baggage (id, booking_id, weight_in_kg) values (709, 156, 15.7);
insert into baggage (id, booking_id, weight_in_kg) values (710, 451, 21.6);
insert into baggage (id, booking_id, weight_in_kg) values (711, 583, 17.7);
insert into baggage (id, booking_id, weight_in_kg) values (712, 513, 12.5);
insert into baggage (id, booking_id, weight_in_kg) values (713, 493, 23.5);
insert into baggage (id, booking_id, weight_in_kg) values (714, 499, 28.8);
insert into baggage (id, booking_id, weight_in_kg) values (715, 404, 14.2);
insert into baggage (id, booking_id, weight_in_kg) values (716, 205, 13.0);
insert into baggage (id, booking_id, weight_in_kg) values (717, 480, 29.9);
insert into baggage (id, booking_id, weight_in_kg) values (718, 278, 30.0);
insert into baggage (id, booking_id, weight_in_kg) values (719, 107, 18.1);
insert into baggage (id, booking_id, weight_in_kg) values (720, 125, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (721, 81, 26.2);
insert into baggage (id, booking_id, weight_in_kg) values (722, 578, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (723, 266, 25.0);
insert into baggage (id, booking_id, weight_in_kg) values (724, 342, 28.7);
insert into baggage (id, booking_id, weight_in_kg) values (725, 250, 11.5);
insert into baggage (id, booking_id, weight_in_kg) values (726, 488, 28.5);
insert into baggage (id, booking_id, weight_in_kg) values (727, 385, 19.1);
insert into baggage (id, booking_id, weight_in_kg) values (728, 350, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (729, 422, 23.9);
insert into baggage (id, booking_id, weight_in_kg) values (730, 519, 19.1);
insert into baggage (id, booking_id, weight_in_kg) values (731, 27, 22.4);
insert into baggage (id, booking_id, weight_in_kg) values (732, 357, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (733, 206, 10.5);
insert into baggage (id, booking_id, weight_in_kg) values (734, 173, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (735, 373, 23.7);
insert into baggage (id, booking_id, weight_in_kg) values (736, 126, 16.0);
insert into baggage (id, booking_id, weight_in_kg) values (737, 487, 12.7);
insert into baggage (id, booking_id, weight_in_kg) values (738, 162, 12.5);
insert into baggage (id, booking_id, weight_in_kg) values (739, 93, 15.7);
insert into baggage (id, booking_id, weight_in_kg) values (740, 331, 10.2);
insert into baggage (id, booking_id, weight_in_kg) values (741, 83, 23.0);
insert into baggage (id, booking_id, weight_in_kg) values (742, 318, 11.0);
insert into baggage (id, booking_id, weight_in_kg) values (743, 460, 12.3);
insert into baggage (id, booking_id, weight_in_kg) values (744, 526, 22.2);
insert into baggage (id, booking_id, weight_in_kg) values (745, 358, 20.7);
insert into baggage (id, booking_id, weight_in_kg) values (746, 209, 18.0);
insert into baggage (id, booking_id, weight_in_kg) values (747, 519, 26.4);
insert into baggage (id, booking_id, weight_in_kg) values (748, 430, 13.6);
insert into baggage (id, booking_id, weight_in_kg) values (749, 298, 24.4);
insert into baggage (id, booking_id, weight_in_kg) values (750, 507, 22.3);
insert into baggage (id, booking_id, weight_in_kg) values (751, 340, 19.9);
insert into baggage (id, booking_id, weight_in_kg) values (752, 98, 26.9);
insert into baggage (id, booking_id, weight_in_kg) values (753, 305, 11.7);
insert into baggage (id, booking_id, weight_in_kg) values (754, 431, 16.8);
insert into baggage (id, booking_id, weight_in_kg) values (755, 324, 22.5);
insert into baggage (id, booking_id, weight_in_kg) values (756, 462, 23.3);
insert into baggage (id, booking_id, weight_in_kg) values (757, 472, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (758, 280, 21.1);
insert into baggage (id, booking_id, weight_in_kg) values (759, 506, 19.3);
insert into baggage (id, booking_id, weight_in_kg) values (760, 390, 21.0);
insert into baggage (id, booking_id, weight_in_kg) values (761, 228, 19.0);
insert into baggage (id, booking_id, weight_in_kg) values (762, 465, 10.7);
insert into baggage (id, booking_id, weight_in_kg) values (763, 101, 19.8);
insert into baggage (id, booking_id, weight_in_kg) values (764, 459, 11.9);
insert into baggage (id, booking_id, weight_in_kg) values (765, 344, 14.8);
insert into baggage (id, booking_id, weight_in_kg) values (766, 404, 19.6);
insert into baggage (id, booking_id, weight_in_kg) values (767, 562, 21.7);
insert into baggage (id, booking_id, weight_in_kg) values (768, 402, 16.4);
insert into baggage (id, booking_id, weight_in_kg) values (769, 353, 25.1);
insert into baggage (id, booking_id, weight_in_kg) values (770, 416, 21.9);
insert into baggage (id, booking_id, weight_in_kg) values (771, 116, 11.6);
insert into baggage (id, booking_id, weight_in_kg) values (772, 250, 13.9);
insert into baggage (id, booking_id, weight_in_kg) values (773, 535, 19.9);
insert into baggage (id, booking_id, weight_in_kg) values (774, 412, 14.1);
insert into baggage (id, booking_id, weight_in_kg) values (775, 123, 21.3);
insert into baggage (id, booking_id, weight_in_kg) values (776, 329, 20.3);
insert into baggage (id, booking_id, weight_in_kg) values (777, 251, 26.9);
insert into baggage (id, booking_id, weight_in_kg) values (778, 47, 22.3);
insert into baggage (id, booking_id, weight_in_kg) values (779, 141, 10.8);
insert into baggage (id, booking_id, weight_in_kg) values (780, 175, 21.8);
insert into baggage (id, booking_id, weight_in_kg) values (781, 92, 18.7);
insert into baggage (id, booking_id, weight_in_kg) values (782, 600, 12.2);
insert into baggage (id, booking_id, weight_in_kg) values (783, 562, 14.9);
insert into baggage (id, booking_id, weight_in_kg) values (784, 401, 29.4);
insert into baggage (id, booking_id, weight_in_kg) values (785, 417, 21.0);
insert into baggage (id, booking_id, weight_in_kg) values (786, 507, 14.1);
insert into baggage (id, booking_id, weight_in_kg) values (787, 508, 19.4);
insert into baggage (id, booking_id, weight_in_kg) values (788, 429, 14.6);
insert into baggage (id, booking_id, weight_in_kg) values (789, 272, 18.8);
insert into baggage (id, booking_id, weight_in_kg) values (790, 353, 29.0);
insert into baggage (id, booking_id, weight_in_kg) values (791, 455, 23.8);
insert into baggage (id, booking_id, weight_in_kg) values (792, 406, 16.5);
insert into baggage (id, booking_id, weight_in_kg) values (793, 417, 10.0);
insert into baggage (id, booking_id, weight_in_kg) values (794, 280, 29.6);
insert into baggage (id, booking_id, weight_in_kg) values (795, 102, 19.5);
insert into baggage (id, booking_id, weight_in_kg) values (796, 20, 23.0);
insert into baggage (id, booking_id, weight_in_kg) values (797, 248, 25.1);
insert into baggage (id, booking_id, weight_in_kg) values (798, 593, 29.7);
insert into baggage (id, booking_id, weight_in_kg) values (799, 247, 28.4);
insert into baggage (id, booking_id, weight_in_kg) values (800, 430, 29.8);


