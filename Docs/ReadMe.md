## Purpose

Import of transport infrastructure data from GIP.at

## Documentation

See: [GIPrva.pdf](p_GIPrva_V0.pdf)

## Install project

In Visual Studio start window: "Clone a repository" <br/>
Git repository URL: https://github.com/robhubi/GIPrva.git <br/>
Solution File: "Import GIP RVA.sln"

## Customise the project

The values are accessible via the connection managers of the SSIS packages:

* Edit Flat File Connection Managers: Path to CSV tables
* Edit (project) OLE DB connection Manager: Server name; Authentication, database name = "GIPrva"

## Download data

1. download "A - Routing export: ZIP archive with the individual IDF tables" from http://open.gip.gv.at/ogd/A_routingexport_ogd_split.zip
2. unpack

## Import data

1. in VS: open solution "GIPrva_DBproj2". Enter the password to decrypt the sensitive data. 
2. right click on SSIS package "SSIS_MASTER.dtsx" - Execute Package