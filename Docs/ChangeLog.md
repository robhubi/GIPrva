# Changelog

All notable changes to this project will be documented in this file.



#

## [0.3.0] - 2026-06-07
Solution "Import GIP RVA" completly refactored. 
Force push for the new ‘GIP2rva’ solution.

### Added

- Solution "GIP2rva" (2 Projects)

### Removed

- History, because of Force Push

=====================================================
## ## [0.2.0] - 2023-06-05

### Added

- 4 lookup tables: LUT_StreetCategory; LUT_FRC; LUT_FOW; LUT_SUSTAINER (only subset)
- Column LINK.NAME1
- Column LINK.NAME2
- Column LINK.STREETCAT
- Column LINK.FUNCROADCLASS
- Column LINK.FORMOFWAY
- Column LINK.SUSTAINER
- View v_Wanderwege_alle_geo


### Changed

- Path to the CSV tables replaced by drive letter "G".  
  Example: `C:\Maps\GIP\Node.txt --> G:\Node.txt`
- CREATE TABLE [dbo].[Link] in createAllTbls.sql
- CREATE TABLE [dbo].[Link_ImpError] in createAllTbls.sql
- All components (incl. FF Mngr) from SSIS package "Import Link Data" adapted to the additional columns


  

## [0.1.0] - 2021-03-01

### Added

- Solution "Import GIP RVA" (3 Projects)
  
=====================================================

# Template
## ## [0.0.0] - 2026-06-07

### Added

- x

### Fixed

- x

### Changed

- x
### Removed

- x

  