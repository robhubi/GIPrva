### Purpose

Import of transport infrastructure data from GIP.at

### Documentation

See: [GIPrva.pdf](p_GIPrva_V0.pdf)

### Current Status

Proof of concept achieved 

### Prerequisites

Visual Studio 2017 or VS2019 + SQL Server Integration Services Projects Extension, SQL Server

### Install project

In Visual Studio start window: "Clone a repository" <br/>
Git repository URL: https://github.com/robhubi/GIPrva.git <br/>
Solution File: "Import GIP RVA.sln"

### Create Database
- Add a new database "GIPrva" to your SQL Server
- Start script "createAllTbls.sql" 

### Customise the project

The values are accessible via the connection managers of the SSIS packages:

* For Flat File Connection Managers: Map path to CSV tables to drive letter "G"
* Edit Flat File Connection Managers: Edit path to SQL scripts
* Edit (project) OLE DB connection Manager: Server name; Authentication, database name = "GIPrva"

### Download data

1. download "A - Routing export: ZIP archive with the individual IDF tables" from http://open.gip.gv.at/ogd/A_routingexport_ogd_split.zip
2. unpack

### Import data

1. in VS: open solution "GIPrva_DBproj2". Enter the password to decrypt the sensitive data. 
2. right click on SSIS package "SSIS_MASTER.dtsx" - Execute Package