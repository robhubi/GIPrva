/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2014 (12.0.5000)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2014
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

/*
** Drop Tables and Views if exist
*/
GO
IF OBJECT_ID('Node_ImpError', 'U') IS NOT NULL
DROP TABLE [dbo].[Node_ImpError];
GO
IF OBJECT_ID('LinkUse_ImpError', 'U') IS NOT NULL
DROP TABLE [dbo].[LinkUse_ImpError];
GO
IF OBJECT_ID('LinkCoordinate_ImpError', 'U') IS NOT NULL
DROP TABLE [dbo].[LinkCoordinate_ImpError];
GO
IF OBJECT_ID('Link_ImpError', 'U') IS NOT NULL
DROP TABLE [dbo].[Link_ImpError];
GO
IF OBJECT_ID('BikeHike_ImpError', 'U') IS NOT NULL
DROP TABLE [dbo].[BikeHike_ImpError];
GO

IF OBJECT_ID('BikeHike', 'U') IS NOT NULL
DROP TABLE [dbo].[BikeHike];
GO
IF OBJECT_ID('LinkCoordinate', 'U') IS NOT NULL
DROP TABLE [dbo].[LinkCoordinate];
GO
IF OBJECT_ID('LinkUse', 'U') IS NOT NULL
DROP TABLE [dbo].[LinkUse];
GO
IF OBJECT_ID('Link', 'U') IS NOT NULL
DROP TABLE [dbo].[Link];
GO
IF OBJECT_ID('Node', 'U') IS NOT NULL
DROP TABLE [dbo].[Node];
GO

IF OBJECT_ID('v_L1_allPts', 'V') IS NOT NULL
DROP VIEW [dbo].[v_L1_allPts];
GO
IF OBJECT_ID('v_L2_Pts2Line', 'V') IS NOT NULL
DROP VIEW [dbo].[v_L2_Pts2Line];
GO
IF OBJECT_ID('v_L3_centerFromTo', 'V') IS NOT NULL
DROP VIEW [dbo].[v_L3_centerFromTo];
GO



/*
** Create Tables and Views
*/

CREATE TABLE [dbo].[Node]
(
	[NODE_ID] INT NOT NULL PRIMARY KEY, 
    [X] DECIMAL(9, 7) NOT NULL, 
    [Y] DECIMAL(9, 7) NOT NULL, 
    [Z] DECIMAL(10, 2) NULL, 
--  [GeoLoc] as geography::Point([Y],[X],4326) PERSISTED,
	CONSTRAINT CHK_zero CHECK ([X]<>0 AND [Y]<>0)
);
GO
CREATE TABLE [dbo].[Link]
(
    [LINK_ID] INT NOT NULL PRIMARY KEY, 
    [FROM_NODE] INT NOT NULL, 
    [TO_NODE] INT NOT NULL, 
    [ACCESS_TOW] INT NULL, 
    [ACCESS_BKW] INT NULL, 
	[cLONx100] INT NULL,
	[cLATx100] INT NULL,
    [LINE_GEO] GEOGRAPHY NULL, 
    CONSTRAINT [FK_foLink_Node] FOREIGN KEY (FROM_NODE) REFERENCES NODE(NODE_ID),
	CONSTRAINT [FK_toLink_Node] FOREIGN KEY (TO_NODE) REFERENCES NODE(NODE_ID)
);
GO
CREATE TABLE [dbo].[LinkUse]
(
	[USE_ID] INT NOT NULL PRIMARY KEY, 
    [LINK_ID] INT NOT NULL,
    [OFFSET] DECIMAL(4, 1) NULL, 
    [FROM_PERCENT] DECIMAL(7, 4) NULL, 
    [TO_PERCENT] DECIMAL(7, 4) NULL, 
    [BASETYPE] INT NULL, 
    [USE_ACCESS_TOW] INT NULL, 
    [USE_ACCESS_BKW] INT NULL,
	CONSTRAINT [FK_LinkUse_Link] FOREIGN KEY (LINK_ID) REFERENCES Link(LINK_ID)
);
GO
CREATE TABLE [dbo].[LinkCoordinate]
(
	[LINK_ID] INT NOT NULL, 
    [COUNT] INT NOT NULL, 
    [X] DECIMAL(9, 7) NULL, 
    [Y] DECIMAL(9, 7) NULL, 
    [Z] DECIMAL(10, 2) NULL, 
    CONSTRAINT [PK_LinkCoordinate] PRIMARY KEY ([LINK_ID], [COUNT]), 
    CONSTRAINT [FK_LinkCoordinate_Link] FOREIGN KEY (LINK_ID) REFERENCES Link(LINK_ID)
);
GO
CREATE TABLE [dbo].[BikeHike]
(
	[USE_ID] INT  UNIQUE NOT NULL, 
    [USE_ACCESS_TOW] INT NULL, 
    [USE_ACCESS_BKW] INT NULL, 
    [BIKESIGNEDTOW] DECIMAL(1) NULL, 
    [BIKESIGNEDBKW] DECIMAL(1) NULL, 
    [BIKEFEATURETOW] NVARCHAR(254) NULL, 
    [BIKEFEATUREBKW] NVARCHAR(254) NULL, 
    CONSTRAINT [FK_BikeHike_LinkUse] FOREIGN KEY (USE_ID) REFERENCES LinkUse(Use_ID)
);
GO
/* ===== all Error Tables ===== */
CREATE TABLE [dbo].[Node_ImpError]
(
	[NODE_ID] INT NULL, 
    [X] DECIMAL(9, 7) NULL, 
    [Y] DECIMAL(9, 7) NULL, 
    [Z] DECIMAL(10, 2) NULL, 
    [ErrorCode] INT NULL, 
    [ErrorColumn] INT NULL,     
);
GO
CREATE TABLE [dbo].[Link_ImpError]
(
    [LINK_ID] INT NULL, 
    [FROM_NODE] INT NULL, 
    [TO_NODE] INT NULL, 
    [ACCESS_TOW] INT NULL, 
    [ACCESS_BKW] INT NULL, 
    [ErrorCode] INT NULL, 
    [ErrorColumn] INT NULL, 
);
GO
CREATE TABLE [dbo].[LinkUse_ImpError]
(
	[USE_ID] INT NULL, 
    [LINK_ID] INT NULL,
    [OFFSET] DECIMAL(4, 1) NULL, 
    [FROM_PERCENT] DECIMAL(7, 4) NULL, 
    [TO_PERCENT] DECIMAL(7, 4) NULL, 
    [BASETYPE] INT NULL, 
    [USE_ACCESS_TOW] INT NULL, 
    [USE_ACCESS_BKW] INT NULL,
	[ErrorCode] INT NULL, 
    [ErrorColumn] INT NULL
);
GO
CREATE TABLE [dbo].[LinkCoordinate_ImpError]
(
	[LINK_ID] INT NULL, 
    [COUNT] INT NULL, 
    [X] DECIMAL(9, 7) NULL, 
    [Y] DECIMAL(9, 7) NULL, 
    [Z] DECIMAL(10, 2) NULL, 
    [ErrorCode] INT NULL, 
    [ErrorColumn] INT NULL 
);
GO
CREATE TABLE [dbo].[BikeHike_ImpError]
(
	[USE_ID] INT  UNIQUE NULL, 
    [USE_ACCESS_TOW] INT NULL, 
    [USE_ACCESS_BKW] INT NULL, 
    [BIKESIGNEDTOW] DECIMAL(1) NULL, 
    [BIKESIGNEDBKW] DECIMAL(1) NULL, 
    [BIKEFEATURETOW] NVARCHAR(254) NULL, 
    [BIKEFEATUREBKW] NVARCHAR(254) NULL,
	[ErrorCode] INT NULL, 
    [ErrorColumn] INT NULL
);
GO
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
GO

/*
* Create geography line from points (lat,lon)
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
GO

/*
* Calculate Center Coordinates of lines
* to speed up spatial queries against a bounding box
*/

CREATE VIEW [dbo].[v_L3_centerFromTo]
AS
SELECT        L.LINK_ID, CAST((N1.X + N2.X) * 50 AS INT) AS cLONx100, CAST((N1.Y + N2.Y) * 50 AS INT) AS cLATx100
FROM            dbo.Link AS L INNER JOIN
                         dbo.Node AS N1 ON L.FROM_NODE = N1.NODE_ID INNER JOIN
                         dbo.Node AS N2 ON L.TO_NODE = N2.NODE_ID
GO