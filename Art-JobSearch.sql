USE MASTER;

if (select count(*) 
    from sys.databases where name = 'JobSearch') > 0
BEGIN
    DROP DATABASE JobSearch;
END

CREATE DATABASE JobSearch

GO

USE JobSearch
GO
CREATE TABLE Activities 
	(
	ActivityID int not null identity(1,1),
	LeadID int not null,
	ActivityDate date not null default getdate(),
	ActivityType varchar(25) not null,
	ActivityDetails varchar(255) null,
	Complete bit not null default (0), 
	ReferenceLink varchar(255) null, 
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    
	PRIMARY KEY (ActivityID),
	CONSTRAINT Ck_ACTIVITYTYPE Check ([ACTIVITYTYPE] IN ('Inquiry','Application','Contact','Interview','Follow-up','Correspondence','Documentation','Closure','Other'))
	)
	GO
	

	Print 'Activities Table Created'
	GO
	Create Trigger Trg_afteractivitymodified on Activities  After insert,update 
	AS
	Begin
	update		A
	set			A.ModifiedDate = getdate()
	From		Activities A
	Inner Join	inserted i
	on			i.ActivityID = A.ActivityID
	end
	Print 'AfterActivityModified Trigger created';
GO
CREATE TABLE Sources
	(
	SourceID int not null identity(1,1),
	SourceName varchar(75) not null,
	SourceType varchar(35) null,
	SourceLink varchar(255) null,
	Descript varchar(255) null
	PRIMARY KEY (SourceID)
	)

	print 'Sources Table Created'

	GO
CREATE TABLE Leads
	(
	LeadID int not null identity(1,1),
	RecordDate Date not null default getdate(),
	JobTitle varchar(75) not null,
	Descript varchar(255) null,
	EmploymentType varchar(25) null,
	Location varchar(50) null,
	Activity bit default (-1),
	CompanyId int null, 
	AgencyID int null, 
	ContactID int null,
	SourceID int null,
	Selected bit default (0),
	ModifiedDate datetime NULL DEFAULT GETDATE(),
  
	PRIMARY KEY (LeadID),
	CONSTRAINT CK_RecordedDate CHECK ([RecordDate] <= GETDATE()),
	CONSTRAINT Ck_EmploymentType Check ([EmploymentType] IN ('Full-time','Part-time','Contractor','Temporary','Seasonal','Intern','Freelance','Volunteer'))
	)
    Print 'Leads Table Created'

	GO
	Create Trigger Trg_afterLeadmodified on Leads  After insert,update 
	AS
	Begin
	update		L
	set			L.ModifiedDate = getdate()
	From		Leads L
	Inner Join	inserted i
	on			i.LeadID = L.LeadID
	end

	Print 'AfterLeadModified Trigger created';
	GO
CREATE TABLE Contacts
	(
	ContactID int not null identity(1,1),
	CompanyID int not null ,
	CourtesyTitle varchar(25)  null,
	ContactFirstName varchar(50) null,
	ContactLastName varchar(50) null,
	Title varchar(50) null,
	Phone varchar (14) null,
	Extension varchar(10) null, 
	Fax varchar (14) null, 
	Email varchar(50) null,
	Comments varchar (255) null,
	Active bit default (-1) 

	PRIMARY KEY (ContactID),
	CONSTRAINT Ck_COURTESYTITLE Check ([COURTESYTITLE] IN ('Mr.','Ms.','Miss','Mrs.','Dr.','Rev.'))
	)

	Print 'Contacts Table Created'
GO
CREATE TABLE Companies 
	(
	CompanyID int not null identity(1,1),
	CompanyName varchar(75) not null,
	Address1 varchar(75)  null,
	Address2 varchar(75) null,
	City varchar(50) null,
	State varchar(2) null,
	Zip varchar (10) null,
	Phone varchar(14) null, 
	Fax varchar (14) null, 
	Email varchar(50) null,
	Website varchar (50) null,
	Discript varchar (255) null,
	BusinessType varchar(255) null,
	Agency bit default (0)

	PRIMARY KEY (CompanyID)
	)	

	Print 'Companies Table Created'

	GO
	
	CREATE TABLE BusinessTypes
	(
	BusinessType varchar(255)
	Primary Key (BusinessType)
	)
	Print 'BusinessTypes Table Created'


-- INDEXES
    CREATE INDEX idx_activities ON Activities (LeadID,ActivityDate,ActivityType);
	Print 'Index idx_activities created';

	CREATE Unique Index idx_BusinessType ON BusinessTypes(BusinessType);
	Print 'Unique index idx_BusinesType created';

	CREATE  Index idx_Companies ON Companies (City,state,zip);
	Print 'Index idx_Companies created';

	CREATE  Index idx_Contacts ON Contacts (CompanyID,ContactLastName,Title);
	Print 'Index idx_Contacts created';

	CREATE  Index idx_Leads ON Leads (RecordDate,EmploymentType,Location,CompanyID,AgencyID,ContactID,SourceID);
	Print 'Index idx_Leads created';

	CREATE  Index idx_Sources ON Sources (SourceName,SourceType);
	Print 'Index idx_Sources created';
	
--FOREIGN KEYS ADDED

	ALTER TABLE Activities ADD FOREIGN KEY(LeadID) REFERENCES leads; PRINT 'FK LeadID Added';
	ALTER TABLE Leads ADD FOREIGN KEY(SourceID) References Sources; PRINT 'FK SourceID Added'
	ALTER TABLE Leads ADD FOREIGN KEY(ContactID) References Contacts; PRINT 'FK ContactID Added'
	ALTER TABLE Leads ADD FOREIGN KEY(CompanyID) References Companies; PRINT 'FK CompanyID Added'
	ALTER TABLE Contacts  ADD FOREIGN KEY(CompanyID) References Companies; PRINT 'FK CompanyID Added'
	ALTER TABLE Companies ADD FOREIGN KEY(BusinessType) References BusinessTypes; PRINT 'FK BusinessType Added'

USE [JobSearch]

--INSERTS

INSERT INTO [BusinessTypes]
           ([BusinessType])
     VALUES
('Accounting'),
('Advertising/Marketing'),
('Agriculture'),
('Architecture'),
('Arts/Entertainment'),
('Aviation'),
('Beauty/Fitness'),
('Business Services'),
('Communications'),
('Computer/Hardware'),
('Computer/Services'),
('Computer/Software'),
('Computer/Training'),
('Construction'),
('Consulting'),
('Crafts/Hobbies'),
('Education'),
('Electrical'),
('Electronics'),
('Employment'),
('Engineering'),
('Environmental'),
('Fashion'),
('Financial'),
('Food/Beverage'),
('Government'),
('Health/Medicine'),
('Home & Garden'),
('Immigration'),
('Import/Export'),
('Industrial'),
('Industrial Medicine'),
('Information Services'),
('Insurance'),
('Internet'),
('Legal & Law'),
('Logistics'),
('Manufacturing'),
('Mapping/Surveying'),
('Marine/Maritime'),
('Motor Vehicle'),
('Multimedia'),
('Network Marketing'),
('News & Weather'),
('Non-Profit'),
('Petrochemical'),
('Pharmaceutical'),
('Printing/Publishing'),
('Real Estate'),
('Restaurants'),
('Restaurants Services'),
('Service Clubs'),
('Service Industry'),
('Shopping/Retail'),
('Spiritual/Religious'),
('Sports/Recreation'),
('Storage/Warehousing'),
('Technologies'),
('Transportation'),
('Travel'),
('Utilities'),
('Venture Capital'),
('Wholesale')


Print 'Insert into BusinessTypes completed'

USE [JobSearch]
GO

INSERT INTO [dbo].[Sources]([SourceName],[SourceType],[SourceLink])
     VALUES('EmployFlorida','Online','https://www.employflorida.com/jobbanks/joblist.asp?'),
			('JobSeeker','Online','https://www.jobseeker.com/jobbank/joblist.asp?')

GO
INSERT INTO [dbo].[Companies]([CompanyName],[BusinessType])
     VALUES('Pinnacle Executive Search','Computer/Software'),
			('Sentry Data Systems', 'Computer/Software')
GO

INSERT INTO [dbo].[Contacts]([CompanyID])
     VALUES (1),(2)
GO

INSERT INTO [dbo].[Leads]
           
           ([JobTitle],[EmploymentType],[Location],[Activity],[CompanyId],[ContactID]
           ,[SourceID],[Selected])
     VALUES('Software Developer','full-time','Oviedo,Fl',1,1,1,1,1),
			('Software Developer','full-time','Deerfield Beach,Fl',1,2,2,2,1)
GO
INSERT INTO [dbo].[Activities]([LeadID],[ActivityType],[Complete])
		VALUES (1,'CONTACT',0), 
				(2,'CONTACT',0)