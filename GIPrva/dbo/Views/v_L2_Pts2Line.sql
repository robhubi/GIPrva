
/*
* Create geography polyline from points (lat,lon)
* for each group LINK_ID
*
* Ref.: https://stackoverflow.com/questions/48241483
*/

CREATE VIEW [dbo].[v_L2_Pts2Line]
AS
SELECT        LINK_ID, geography::STLineFromText('LINESTRING(' + STUFF
                             ((SELECT        ',' + CONCAT([X], ' ', [Y])
                                 FROM            v_L1_allPts AS t2
                                 WHERE        t1.LINK_ID = t2.LINK_ID
                                 ORDER BY [COUNT] FOR XML PATH('')), 1, 1, '') + ')', 4326) AS LINE_GEO
FROM            v_L1_allPts AS t1
GROUP BY LINK_ID;
