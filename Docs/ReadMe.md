## Purpose

Import of transport infrastructure data from GIP.at

## Documentation

See: [GIPrva.pdf](p_GIPrva_V0.pdf)

## Install project

In Visual Studio start window: "Clone a repository" 
Git repository URL: https://github.com/robhubi/GIPrva.git
Solution File: "Import GIP RVA.sln"

## Customise the project

The paths are accessible via the connection managers of the SSIS packages. Default values:

* Path CSV tables: "T:\Robert\Maps\GIP"
* Properties SQL server: Name="TummiSS"; Database="GIPrva"; LocaleID="German"

## Download data

1. download "A - Routing export: ZIP archive with the individual IDF tables" from http://open.gip.gv.at/ogd/A_routingexport_ogd_split.zip
2. unpack

## Import data

1. in VS: open solution "GIPrva_DBproj2"  . At the beginning the login information for the backend database is requested. 
2. right click on SSIS package "SSIS_MASTER.dtsx" - Execute Package