/*
**
** This script is used in a SSIS execute SQL Task
**
*/


/*
* Add Center Coordinates of lines
* to speed up spatial queries against a bounding box
* use view "v_L3_centerFromTo"
*/
UPDATE dbo.Link
SET    dbo.Link.cLONx100 = v.cLONx100,  dbo.Link.cLATx100 = v.cLATx100
FROM   dbo.v_L3_centerFromTo AS v
WHERE  dbo.Link.LINK_ID = v.LINK_ID
GO 

/*
* Add geography line from group of points to table "Link"
* use view "v_L2_Pts2Line"
* this update needs time!
*/
UPDATE dbo.Link
SET    dbo.Link.LINE_GEO = v.LINE_GEO 
FROM   dbo.v_L2_Pts2Line AS v
WHERE  dbo.Link.LINK_ID = v.LINK_ID
GO

/*
*Create Index for center coordinates X und Y:
*/
CREATE INDEX cXY_index ON dbo.Link (cLONx100, cLATx100);
GO
