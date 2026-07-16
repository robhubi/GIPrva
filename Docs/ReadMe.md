### Purpose

Import of bicycle infrastructure data from GIP.at

### Documentation

See: [GIPrva.pdf](p_GIPrva_V0.pdf)

### Current Status

Working 

### Prerequisites

Visual Studio 2017 + SQL Server Integration Services Projects Extension, SQL Server 2014. Or higher.

### Install project

In Visual Studio start window: "Clone a repository" <br/>
Git repository URL: https://github.com/robhubi/GIPrva.git <br/>
Solution File: "GIP2rva.sln"

### Check Settings
* GIP2rva.Database/Properties/Debug: "Always re-create database" = YES
* SSIS GIPrva data/Properties/Configuration Properties: TargetServerVersion = \<*Your SQL Server Version*>
* Log on to the SQL Server: Windows Authentication

### Create Database
- Publish GIP2rva.Database

### Customise the project

The values are accessible via the connection managers of the SSIS packages:

* For Flat File Connection Managers: Map path to CSV data tables to drive letter "G:" (look-up tables should be in G:\LUTs)
* Edit Flat File Connection Managers: Edit path to SQL scripts
* Edit (project) OLE DB connection Manager: SSIS GIPrva data/Connection Managers/*Entry*/Open: Server name; Authentication, database name = "GIPrva"

### Download data

1. Download "A - Routing export: ZIP archive with the individual IDF tables" from http://open.gip.gv.at/ogd/A_routingexport_ogd_split.zip
2. Unpack in G:
3. Download "D - Lookuptabellen" from https://open.gip.gv.at/ogd/D_lookuptabellen.zip
4. Unpack in G:\LUTs

### Import data

1. in VS: open solution "GIP2rva".
2. Publish "GIP2rva.Database"
3. right click on SSIS package "SSIS_MASTER.dtsx" - Execute Package