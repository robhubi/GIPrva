/*
* Add From/To-coordinates to LinkCoorddinate table
*  From-coordinates gets count=0
*  To-coordinates gets counts=99999
*/
CREATE VIEW [dbo].[v_L1_allPts]
AS
/* Get FROM-Coordinates, set COUNT=0 */ 
SELECT Link.LINK_ID, 0 AS [COUNT], NodeF.X, NodeF.Y
FROM            Link INNER JOIN
                         Node AS NodeF ON Link.FROM_NODE = NodeF.NODE_ID

/* Get TO-Coordinates, set COUNT=99999, UNION */ 
UNION ALL
SELECT        Link.LINK_ID, 99999 AS [COUNT], NodeT.X, NodeT.Y
FROM            Link INNER JOIN
                         Node AS NodeT ON Link.TO_NODE = NodeT.NODE_ID

/* Get all other Intermediate-Coordinates, UNION */ 
UNION ALL
SELECT        LINK_ID, [COUNT], X, Y
FROM            LinkCoordinate
