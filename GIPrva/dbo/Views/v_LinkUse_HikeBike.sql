CREATE VIEW dbo.v_LinkUse_HikeBike
AS
SELECT        dbo.Link.LINK_ID, dbo.BikeHike.USE_ID, dbo.LUT_BASETYPE.NAME_LONG AS BaseTypeName, dbo.LUT_BIKEMERKMAL.NAME_LONG AS BikeFeatureNameTOW, 
                         LUT_BIKEMERKMAL_1.NAME_LONG AS BikeFeatureNameBKW, (dbo.BikeHike.USE_ACCESS_TOW | dbo.BikeHike.USE_ACCESS_BKW & 0x2) / 2 AS cACC_BIKE, ((dbo.BikeHike.USE_ACCESS_TOW & 0x2) 
                         - (dbo.BikeHike.USE_ACCESS_BKW & 0x2)) / 2 AS cACC_BIKE_ONEWAY, dbo.BikeHike.USE_ACCESS_TOW | dbo.BikeHike.USE_ACCESS_BKW & 0x1 AS cACC_Hike, 
                         (dbo.BikeHike.USE_ACCESS_TOW | dbo.BikeHike.USE_ACCESS_BKW & 0x4) / 4 AS cACC_Car, dbo.BikeHike.BIKESIGNEDTOW, dbo.BikeHike.BIKESIGNEDBKW, dbo.LinkUse.BASETYPE, 
                         dbo.BikeHike.USE_ACCESS_TOW, dbo.BikeHike.USE_ACCESS_BKW, dbo.Link.cLONx100, dbo.Link.cLATx100, dbo.Link.LINE_GEO, dbo.BikeHike.BIKEFEATURETOW, dbo.BikeHike.BIKEFEATUREBKW
FROM            dbo.Link INNER JOIN
                         dbo.LinkUse ON dbo.Link.LINK_ID = dbo.LinkUse.LINK_ID INNER JOIN
                         dbo.BikeHike ON dbo.LinkUse.USE_ID = dbo.BikeHike.USE_ID LEFT OUTER JOIN
                         dbo.LUT_BIKEMERKMAL AS LUT_BIKEMERKMAL_1 ON dbo.BikeHike.BIKEFEATUREBKW = LUT_BIKEMERKMAL_1.ID LEFT OUTER JOIN
                         dbo.LUT_BIKEMERKMAL ON dbo.BikeHike.BIKEFEATURETOW = dbo.LUT_BIKEMERKMAL.ID LEFT OUTER JOIN
                         dbo.LUT_BASETYPE ON dbo.LinkUse.BASETYPE = dbo.LUT_BASETYPE.bt_ID
