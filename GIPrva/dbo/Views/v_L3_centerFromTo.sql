/*
* Calculate Center Coordinates of lines
* to speed up spatial queries against a bounding box
*/
CREATE VIEW dbo.v_L3_centerFromTo
AS
SELECT        L.LINK_ID, CAST((N1.X + N2.X) * 50 AS INT) AS cLONx100, CAST((N1.Y + N2.Y) * 50 AS INT) AS cLATx100
FROM            dbo.Link AS L INNER JOIN
                         dbo.Node AS N1 ON L.FROM_NODE = N1.NODE_ID INNER JOIN
                         dbo.Node AS N2 ON L.TO_NODE = N2.NODE_ID
