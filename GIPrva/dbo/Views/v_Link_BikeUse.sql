﻿CREATE VIEW dbo.v_Link_BikeUse
AS
SELECT        LINK_ID, 
    (ACCESS_TOW | ACCESS_BKW & 0x2) / 2 AS cACC_BIKE,
    ((ACCESS_TOW & 0x2) - (ACCESS_BKW & 0x2)) / 2 AS cACC_BIKE_ONEWAY, 
    ACCESS_TOW | ACCESS_BKW & 0x1 AS cACC_Hike, 
    (ACCESS_TOW | ACCESS_BKW & 0x4) / 4 AS cACC_Car, 
    ((ACCESS_TOW & 0x4) - (ACCESS_BKW & 0x4)) / 4 AS cACC_Car_Oneway,
    ACCESS_TOW, ACCESS_BKW, cLONx100, cLATx100, LINE_GEO
FROM            dbo.Link
