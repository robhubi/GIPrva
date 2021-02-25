## Zweck

Import der Verkehrsinfrastrukturdaten von GIP.at

## Dokumentation

Siehe: [GIPrva.pdf](p_GIPrva_V0.pdf)

## Projekt installieren

In Visual Studio Startfenster das Projekt klonen (Clone a repository). 
Git Repository URL: https://github.com/robhubi/GIPrva.git
Solution File: "Import GIP RVA.sln"

## Projekt anpassen

Die Pfade sind über die Connection Managers der SSIS Pakete zugänglich. Default-Werte:

* Path CSV-Tabellen: "T:\Robert\Maps\GIP"
* Eigenschaften SQL-Server: Name="TummiSS"; Database= "GIPrva"; LocaleID="German"

## Download Daten

1. Download "A - Routingexport: ZIP Archiv mit den einzelnen IDF Tabellen" von http://open.gip.gv.at/ogd/A_routingexport_ogd_split.zip
2. Entpacken

## Import Daten

1. In VS Solution "GIPrva_DBproj2" öffnen. Am Beginn werden die Anmeldeinformationen zur Backend Datenbank abgefragt
2. Rechtsklick auf SSIS-Paket "SSIS_MASTER.dtsx" - Execute Package