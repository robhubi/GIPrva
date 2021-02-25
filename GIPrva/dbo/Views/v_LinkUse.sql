CREATE VIEW dbo.[v_LinkUse]
AS
SELECT        dbo.Link.LINK_ID, dbo.LinkUse.USE_ID, dbo.LUT_BASETYPE.NAME_LONG, (dbo.LinkUse.USE_ACCESS_TOW | dbo.LinkUse.USE_ACCESS_BKW & 0x2) / 2 AS cACC_BIKE, 
                         ((dbo.LinkUse.USE_ACCESS_TOW & 0x2) - (dbo.LinkUse.USE_ACCESS_BKW & 0x2)) / 2 AS cACC_BIKE_ONEWAY, dbo.LinkUse.USE_ACCESS_TOW | dbo.LinkUse.USE_ACCESS_BKW & 0x1 AS cACC_Hike, 
                         (dbo.LinkUse.USE_ACCESS_TOW | dbo.LinkUse.USE_ACCESS_BKW & 0x4) / 4 AS cACC_Car, dbo.LinkUse.BASETYPE, dbo.LinkUse.USE_ACCESS_TOW, dbo.LinkUse.USE_ACCESS_BKW, dbo.Link.cLONx100, 
                         dbo.Link.cLATx100, dbo.Link.LINE_GEO
FROM            dbo.Link INNER JOIN
                         dbo.LinkUse ON dbo.Link.LINK_ID = dbo.LinkUse.LINK_ID LEFT OUTER JOIN
                         dbo.LUT_BASETYPE ON dbo.LinkUse.BASETYPE = dbo.LUT_BASETYPE.bt_ID
