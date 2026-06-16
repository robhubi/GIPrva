/*
* All walking and hiking paths
* 
*  Provided for QGIS
*/
CREATE VIEW dbo.v_Wanderwege_alle_geo
AS
WITH WWalle_CTE AS (SELECT        LINK_ID, NAME1, NAME2, LINE_GEO, STREETCAT, FUNCROADCLASS, FORMOFWAY, SUSTAINER
                                                   FROM            dbo.Link
                                                   WHERE        (STREETCAT = 'WA') OR
                                                                             (FUNCROADCLASS = 300))
    SELECT        WWalle_CTE_1.LINK_ID, WWalle_CTE_1.LINE_GEO, WWalle_CTE_1.NAME1, WWalle_CTE_1.NAME2, dbo.LUT_StreetCategory.NAME AS StreetCategory, dbo.LUT_FRC.NAME AS FRC, 
                              dbo.LUT_FOW.NAME AS FOW, dbo.LUT_SUSTAINER.NAME AS Sustainer, WWalle_CTE_1.STREETCAT AS ID_StreetCat, WWalle_CTE_1.FORMOFWAY AS ID_FOW, 
                              WWalle_CTE_1.FUNCROADCLASS AS ID_FRC, WWalle_CTE_1.SUSTAINER AS ID_Sust
     FROM            WWalle_CTE AS WWalle_CTE_1 INNER JOIN
                              dbo.LUT_StreetCategory ON WWalle_CTE_1.STREETCAT = dbo.LUT_StreetCategory.ID INNER JOIN
                              dbo.LUT_FRC ON WWalle_CTE_1.FUNCROADCLASS = dbo.LUT_FRC.ID INNER JOIN
                              dbo.LUT_FOW ON WWalle_CTE_1.FORMOFWAY = dbo.LUT_FOW.ID LEFT OUTER JOIN
                              dbo.LUT_SUSTAINER ON WWalle_CTE_1.SUSTAINER = dbo.LUT_SUSTAINER.ID ;

