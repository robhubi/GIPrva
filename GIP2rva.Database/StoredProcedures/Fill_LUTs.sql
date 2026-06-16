/****** Object:  StoredProcedure [dbo].[BulkImport_all7LUTs]    Script Date: 10.06.2026 21:21:26 ******/



-- =============================================
-- Author:		RG
-- Create date: 2025-09-16
-- Description:	Import GIP Lookup Tables:
--    LUT_BASETYPE_csv.csv
--    LUT_BIKEMERKMAL_csv.csv
--    LUT_FOW_csv.csv
--    LUT_FRC_csv.csv
--    LUT_INTREST_BIT_csv.csv
--    LUT_STREETCATEGORY_csv.csv
--    LUT_SUSTAINER_csv.csv

--   All tables have to be in  Shared Folder "\\Vboxsvr\gip2\LUTs\"
--
-- =============================================
CREATE PROCEDURE [dbo].[BulkImport_all7LUTs] 

AS
BEGIN

-- truncate 1. table first then import
TRUNCATE TABLE dbo.LUT_BASETYPE;
BULK INSERT dbo.LUT_BASETYPE
FROM '\\Vboxsvr\gip2\LUTs\LUT_BASETYPE_csv.csv'
WITH
(
        FIRSTROW=2,
        FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = 1252
)

-- truncate 2. table first then import
TRUNCATE TABLE dbo.LUT_BIKEMERKMAL;
BULK INSERT dbo.LUT_BIKEMERKMAL
FROM '\\Vboxsvr\gip2\LUTs\LUT_BIKEMERKMAL_csv.csv'
WITH
(
    FORMATFILE = '\\Vboxsvr\gip2\LUTs\LUT_BIKEMERKMAL.fmt',
    CODEPAGE = 1252,
    FIRSTROW = 2
)

-- truncate the 3. table then import
TRUNCATE TABLE dbo.LUT_FOW;
BULK INSERT dbo.LUT_FOW
FROM '\\Vboxsvr\gip2\LUTs\LUT_FOW_csv.csv'
WITH
(
        FIRSTROW=2,
        FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = 1252
)

-- truncate the 4. table then import
TRUNCATE TABLE dbo.LUT_FRC;
BULK INSERT dbo.LUT_FRC
FROM '\\Vboxsvr\gip2\LUTs\LUT_FRC_csv.csv'
WITH
(
        FIRSTROW=2,
        FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = 1252
)

-- truncate 5. table then import
TRUNCATE TABLE dbo.LUT_INTREST_BIT;
BULK INSERT dbo.LUT_INTREST_BIT
FROM '\\Vboxsvr\gip2\LUTs\LUT_INTREST_BIT_csv.csv'
WITH
(
        FIRSTROW=2,
        FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = 1252
)

-- truncate 6. table then import
TRUNCATE TABLE dbo.LUT_StreetCategory;
BULK INSERT dbo.LUT_StreetCategory
FROM '\\Vboxsvr\gip2\LUTs\LUT_StreetCategory_csv.csv'
WITH
(
        FIRSTROW=2,
        FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = 1252
)

-- truncate 7. table then import
TRUNCATE TABLE dbo.LUT_SUSTAINER;
BULK INSERT dbo.LUT_Sustainer
FROM '\\Vboxsvr\gip2\LUTs\LUT_Sustainer_csv.csv'
WITH
(
        FIRSTROW=2,
        FIELDTERMINATOR = ';',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = 1252
)

END

GO

