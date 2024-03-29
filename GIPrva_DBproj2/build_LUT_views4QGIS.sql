/*
**
** This script is only needed once to build the database.
** The import tables must already be created.
** It creates 6 lookup tables and 3 views for QGIS
**
*/
USE [GIPrva]
GO
/****** Object:  Table [dbo].[LUT_BASETYPE]    Script Date: 20.01.2021 23:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LUT_BASETYPE](
	[bt_ID] [numeric](20, 0) NOT NULL,
	[NAME] [varchar](50) NULL,
	[NAME_LONG] [varchar](50) NULL,
	[DESCRIPTION] [varchar](50) NULL,
	[MODIFY_TIMESTAMP] [varchar](50) NULL,
 CONSTRAINT [PK_LUT_BASETYPE] PRIMARY KEY CLUSTERED 
(
	[bt_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[LUT_BIKEMERKMAL]    Script Date: 20.01.2021 23:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LUT_BIKEMERKMAL](
	[ID] [varchar](20) NOT NULL,
	[NAME] [varchar](99) NULL,
	[NAME_LONG] [varchar](99) NULL,
	[DESCRIPTION] [varchar](99) NULL,
	[MODIFY_TIMESTAMP] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO

/****** Object:  Table [dbo].[LUT_FOW]    Script Date: 28.05.2023 23:35:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LUT_FOW](
	[ID] [int] NULL,
	[NAME] [nvarchar](254) NULL,
	[NAME_LONG] [nvarchar](254) NULL,
	[DESCRIPTION] [nvarchar](254) NULL,
	[MODIFY_TIMESTAMP] [date] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LUT_FRC]    Script Date: 28.05.2023 23:35:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LUT_FRC](
	[ID] [int] NULL,
	[NAME] [nvarchar](254) NULL,
	[NAME_ENGLISH] [nvarchar](254) NULL,
	[NAME_LONG] [nvarchar](254) NULL,
	[DESCRIPTION] [nvarchar](254) NULL,
	[MODIFY_TIMESTAMP] [date] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LUT_StreetCategory]    Script Date: 28.05.2023 23:35:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LUT_StreetCategory](
	[ID] [char](3) NULL,
	[NAME] [nvarchar](254) NULL,
	[DESCRIPTION] [nvarchar](254) NULL,
	[MODIFY_TIMESTAMP] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[LUT_SUSTAINER]    Script Date: 28.05.2023 23:35:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LUT_SUSTAINER](
	[ID] [nvarchar](50) NULL,
	[NAME] [nvarchar](254) NULL,
	[NAME_LONG] [nvarchar](254) NULL,
	[DESCRIPTION] [nvarchar](254) NULL,
	[MODIFY_TIMESTAMP] [date] NULL
) ON [PRIMARY]
GO


/****** Object:  View [dbo].[v_Link_BikeUse]    Script Date: 20.01.2021 23:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_Link_BikeUse]
AS
SELECT        LINK_ID, (ACCESS_TOW | ACCESS_BKW & 0x2) / 2 AS cACC_BIKE, ((ACCESS_TOW & 0x2) - (ACCESS_BKW & 0x2)) / 2 AS cACC_BIKE_ONEWAY, ACCESS_TOW | ACCESS_BKW & 0x1 AS cACC_Hike, 
                         (ACCESS_TOW | ACCESS_BKW & 0x4) / 4 AS cACC_Car, ACCESS_TOW, ACCESS_BKW, cLONx100, cLATx100, LINE_GEO
FROM            dbo.Link

GO
/****** Object:  View [dbo].[v_LinkUse]    Script Date: 20.01.2021 23:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_LinkUse]
AS
SELECT        dbo.Link.LINK_ID, dbo.LinkUse.USE_ID, dbo.LUT_BASETYPE.NAME_LONG, (dbo.LinkUse.USE_ACCESS_TOW | dbo.LinkUse.USE_ACCESS_BKW & 0x2) / 2 AS cACC_BIKE, 
                         ((dbo.LinkUse.USE_ACCESS_TOW & 0x2) - (dbo.LinkUse.USE_ACCESS_BKW & 0x2)) / 2 AS cACC_BIKE_ONEWAY, dbo.LinkUse.USE_ACCESS_TOW | dbo.LinkUse.USE_ACCESS_BKW & 0x1 AS cACC_Hike, 
                         (dbo.LinkUse.USE_ACCESS_TOW | dbo.LinkUse.USE_ACCESS_BKW & 0x4) / 4 AS cACC_Car, dbo.LinkUse.BASETYPE, dbo.LinkUse.USE_ACCESS_TOW, dbo.LinkUse.USE_ACCESS_BKW, dbo.Link.cLONx100, 
                         dbo.Link.cLATx100, dbo.Link.LINE_GEO
FROM            dbo.Link INNER JOIN
                         dbo.LinkUse ON dbo.Link.LINK_ID = dbo.LinkUse.LINK_ID LEFT OUTER JOIN
                         dbo.LUT_BASETYPE ON dbo.LinkUse.BASETYPE = dbo.LUT_BASETYPE.bt_ID

GO
/****** Object:  View [dbo].[v_LinkUse_HikeBike]    Script Date: 20.01.2021 23:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_LinkUse_HikeBike]
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

GO
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(1 AS Numeric(20, 0)), N'Fahrbahn', N'Fahrbahn', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(2 AS Numeric(20, 0)), N'Radweg', N'Radweg', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(4 AS Numeric(20, 0)), N'Schienenweg', N'Schienenweg', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(5 AS Numeric(20, 0)), N'Verkehrsinsel', N'Verkehrsinsel', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(6 AS Numeric(20, 0)), N'Stiege', N'Stiege', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(7 AS Numeric(20, 0)), N'Gehweg', N'Gehweg', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(8 AS Numeric(20, 0)), N'Parkstreifen', N'Parkstreifen', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(9 AS Numeric(20, 0)), N'Grünstreifen', N'Grünstreifen', N'', N'11.06.2019')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(11 AS Numeric(20, 0)), N'Fahrstreifen', N'Fahrstreifen', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(12 AS Numeric(20, 0)), N'Wasserweg', N'Wasserweg', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(13 AS Numeric(20, 0)), N'Aufstiegshilfe', N'Aufstiegshilfe', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(14 AS Numeric(20, 0)), N'Rechtsabbiegestreifen', N'Rechtsabbiegestreifen', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(21 AS Numeric(20, 0)), N'Schutzweg', N'Schutzweg', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(22 AS Numeric(20, 0)), N'Radfahrerüberfahrt', N'Radfahrerüberfahrt', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(23 AS Numeric(20, 0)), N'Schutzweg und Radfahrerüberfahrt', N'Schutzweg und Radfahrerüberfahrt', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(24 AS Numeric(20, 0)), N'Unterführung', N'Unterführung', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(25 AS Numeric(20, 0)), N'Überführung', N'Überführung', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(31 AS Numeric(20, 0)), N'Radweg mit angrenzendem Gehweg', N'Radweg mit angrenzendem Gehweg', N'Fahrstreifen (ist Teil eines Geh- und Radweges)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(32 AS Numeric(20, 0)), N'Mehrzweckstreifen', N'Mehrzweckstreifen', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(33 AS Numeric(20, 0)), N'Radfahrstreifen', N'Radfahrstreifen', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(34 AS Numeric(20, 0)), N'Busspur', N'Busspur', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(35 AS Numeric(20, 0)), N'Radfahrstreifen gegen die Einbahn', N'Radfahrstreifen gegen die Einbahn', N'Fahrstreifen (ist Teil einer Fahrbahn)', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(36 AS Numeric(20, 0)), N'Geh- und Radweg', N'Geh- und Radweg', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(42 AS Numeric(20, 0)), N'Rolltreppe', N'Rolltreppe', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(43 AS Numeric(20, 0)), N'Aufzug', N'Aufzug', N'', N'05.02.2017')
INSERT [dbo].[LUT_BASETYPE] ([bt_ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (CAST(51 AS Numeric(20, 0)), N'Reitweg', N'Reitweg', N'', N'11.06.2019')
GO
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'-1', N'unbekannt', N'unbekannt', N'nur in Wien verwendet', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'BS', N'Radfahren auf Busspuren', N'Radfahren auf Busspuren', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'FUZO', N'Radfahren in Fußgängerzonen', N'Radfahren in Fußgängerzonen', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'FUZO_N', N'Radfahren in Fußgängerzonen (Nebenfahrbahn)', N'Radfahren in Fußgängerzonen (Nebenfahrbahn)', N'nur in Wien verwendet', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'GRW_M', N'Gemischter Geh- und Radweg', N'Gemischter Geh- und Radweg', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'GRW_T', N'Getrennter Geh- und Radweg', N'Getrennter Geh- und Radweg', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'MTB', N'Mountainbikestrecke (Radfahren im Wald)', N'Mountainbikestrecke (Radfahren im Wald)', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'MZSTR', N'Mehrzweckstreifen', N'Mehrzweckstreifen', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RF', N'Radfahrstreifen', N'Radfahrstreifen', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RFGE', N'Radfahren gegen die Einbahn', N'Radfahren gegen die Einbahn', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RFGE_N', N'Radfahren gegen die Einbahn (Nebenfahrbahn)', N'Radfahren gegen die Einbahn (Nebenfahrbahn)', N'nur in Wien verwendet', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RFUE', N'Radfahrerüberfahrt', N'Radfahrerüberfahrt', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RR', N'Radroute (beschilderte Route, Radverkehr wird im Mischverkehr geführt)', N'Radroute (beschilderte Route, Radverkehr wird im Mischverkehr geführt)', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RW', N'Baulicher Radweg', N'Baulicher Radweg', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'VK_BE', N'Verkehrsberuhigte Bereiche', N'Verkehrsberuhigte Bereiche', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'WSTR', N'Radfahren in Wohnstraßen', N'Radfahren in Wohnstraßen', N'nur in Wien verwendet', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'WSTR_N', N'Radfahren in Wohnstraßen (Nebenfahrbahn)', N'Radfahren in Wohnstraßen (Nebenfahrbahn)', N'nur in Wien verwendet', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RRN', N'Hauptradroute', N'Hauptradroute', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'FRS', N'Fahrradstraße', N'Fahrradstraße', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'BGZ', N'Begegnungszone', N'Begegnungszone', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RWO', N'Radweg ohne Benützungspflicht', N'Radweg ohne Benützungspflicht', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'GRW_MO', N'Gemischter Geh- und Radweg ohne Benützungspflicht', N'Gemischter Geh- und Radweg ohne Benützungspflicht', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'GRW_TO', N'Getrennter Geh- und Radweg ohne Benützungspflicht', N'Getrennter Geh- und Radweg ohne Benützungspflicht', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'TRR', N'Treppe auch für Radfahrer geeignet', N'Treppe auch für Radfahrer', N'', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'TRF', N'Trasse nur für Fußgänger', N'Treppe oder Trasse nur für Fußgänger', N'führt dazu, dass in VAO das Rad nicht geschoben wird', N'28.11.2017')
INSERT [dbo].[LUT_BIKEMERKMAL] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'SGT', N'Singletrail', N'Singletrail', N'', N'28.11.2017')
GO
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'A  ', N'Autobahn', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'AW ', N'Almweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'B  ', N'Landesstraße B', N'Wien: Hauptstraße B', N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'BA ', N'Bringungsanlage', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'BS ', N'Bundesstraße Deutschland', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'EA ', N'Eisenbahn Anschlussbahn', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'EH ', N'Eisenbahn hochrangig', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'EN ', N'Eisenbahn Nebenbahn', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'ES ', N'Sonstige Eisenbahn', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'EU ', N'Eisenbahn Ubahn', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'FS ', N'Forststraße/- weg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'FW ', N'Fußweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'G  ', N'Gemeindestraße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'GS ', N'Genossenschaftsstraße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'GW ', N'Güterweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'H  ', N'Hauptstraße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'HA ', N'Hauptstraße A', N'Wien', N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'HB ', N'Hauptstraße B', N'Wien', N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'I  ', N'Interessentenweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'IO ', N'Interessentenstraße öffentlich', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'KR ', N'Kreisstraße Deutschland', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'L  ', N'Landesstraße L', N'Wien: Hauptstraße A', N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'LD ', N'Landesstraße Deutschland', NULL, N'2020-01-31')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'LS ', N'Landesstraße Italien', NULL, N'2020-01-31')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'M  ', N'Mountainbikeweg', NULL, N'2021-01-29')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'MW ', N'Mountainbike-, Wanderweg', NULL, N'2021-01-29')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'N  ', N'nicht bekannt', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'OW ', N'ÖWG Instandhaltungsweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'P  ', N'hochrangige Privatstraße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'PO ', N'Privatstraße mit Öffentlichkeitscharakter', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'PS ', N'Privatstraße/-weg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'PW ', N'Privatweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'R  ', N'andere Straße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'RW ', N'Radweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'S  ', N'Schnellstraße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'SB ', N'Seilbahn', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'SD ', N'Staatsstraße Deutschland', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'SS ', N'Staatsstraße Italien', NULL, N'2020-01-31')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'ST ', N'Straßenbahntrasse', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'SW ', N'stillschweigend gewidmete Straße', NULL, N'2020-01-31')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'T  ', N'Tourismus', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'TW ', N'Treppelweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'U  ', N'Rad bzw. Fußweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'UR ', N'überregionaler Radweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'VS ', N'Verbindungsstraße', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'VW ', N'Verbindungsweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'W  ', N'Weg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'WA ', N'Wanderweg', NULL, N'2017-11-21')
INSERT INTO [dbo].[LUT_StreetCategory] ([ID], [NAME], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'WW ', N'Wirtschaftsweg', NULL, N'2017-11-21')
GO
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (-1, N'Unbekannt', NULL, N'Unbekannt', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (0, N'000 - Straßen des transnationalen Netzes', N'transnational road', N'000 - Straßen des transnationalen Netzes (Kategorie I)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (1, N'001 - Straßen des transregionalen Netzes', N'transregional road', N'001 - Straßen des transregionalen Netzes (Kategorie II)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (2, N'002 - Straßen des zentralörtlichen Netzes', N'road connecting to centers', N'002 - Straßen des zentralörtlichen Netzes (Kategorie III)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (3, N'003 - Straßen des regionalen Netzes', N'regional road', N'003 - Straßen des regionalen Netzes (Kategorie IV)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (4, N'004 - Gemeindeverbindungen', N'connection between communities', N'004 - Gemeindeverbindungen (Kategorie V)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (5, N'005 - Straßen des innerörtlichen Netzes', N'road within a community', N'005 - Straßen des innerörtlichen Netzes (Kategorie V)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (6, N'006 - Sammelstraßen', N'collector road', N'006 - Sammelstraßen', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (7, N'007 - Straßen der internen Erschließung', N'internal collector road', N'007 - Straßen der internen Erschließung', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (8, N'008 - Sonstige Straße', N'other road', N'008 - Sonstige Straße', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (10, N'010 - Rad-/Fußweg', N'pedestrian / bicycle path', N'010 - Rad-/Fußweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (11, N'011 - Wirtschaftsweg', NULL, N'011 - Wirtschaftsweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (12, N'012 - Sonstiger Weg', NULL, N'012 - Sonstiger Weg', N'Sonstige Wege, z.b. Feldwege, Trampelpfade oder nicht zugängliche Wege', N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (20, N'020 - Bahntrasse Hauptnetz', NULL, N'020 - Bahntrasse Hauptnetz', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (21, N'021 - Bahntrasse Ergänzungsnetz', NULL, N'021 - Bahntrasse Ergänzungsnetz', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (22, N'022 - Bahntrasse Anschlussbahn, Verbindungsgleis, sonstiges Gleis', NULL, N'022 - Bahntrasse Anschlussbahn, Verbindungsgleis, sonstiges Gleis', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (24, N'024 - Straßenbahntrasse', NULL, N'024 - Straßenbahntrasse', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (25, N'025 - U-Bahn-Trasse', NULL, N'025 - U-Bahn-Trasse', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (31, N'031 - Fähre', NULL, N'031 - Fähre', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (45, N'045 - Treppe', NULL, N'045 - Treppe', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (46, N'046 - Rolltreppe', NULL, N'046 - Rolltreppe', N'Rolltreppe als spezielle Formen des Fußwegs', N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (47, N'047 - Aufzug', NULL, N'047 - Aufzug', N'Aufzug als spezielle Formen des Fußwegs', N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (48, N'048 - Rampe für den nichtmotorisierten Verkehr', NULL, N'048 - Rampe für den nichtmotorisierten Verkehr', N'Rampe als spezielle Formen des Fußwegs', N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (98, N'098 - Betriebsumkehr', NULL, N'098 - Betriebsumkehr', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (99, N'099 - Betriebsweg', NULL, N'099 - Betriebsweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (101, N'101 - Fußweg ohne Anzeige', NULL, N'101 - Fußweg ohne Anzeige', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (102, N'102 - Fußwegpassage', NULL, N'102 - Fußwegpassage', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (103, N'103 - Seilbahn und Sonstige', NULL, N'103 - Seilbahn und Sonstige', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (105, N'105 - Almaufschließungsweg', NULL, N'105 - Almaufschließungsweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (106, N'106 - Forstaufschließungsweg', NULL, N'106 - Forstaufschließungsweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (107, N'107 - Gebäudezufahrt', NULL, N'107 - Gebäudezufahrt', N'Zufahrt zu einer landwirtschaftlichen Hofstelle', N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (115, N'115 - Friedhofsweg', NULL, N'115 - Friedhofsweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (200, N'200 - Singletrail (MTB)', NULL, N'200 - Singletrail (MTB)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (201, N'201 - Shared Trail', NULL, N'201 - Shared Trail', N'Wanderweg auf dem Radfahren erlaubt ist', N'2017-08-20')
INSERT INTO [dbo].[LUT_FRC] ([ID], [NAME], [NAME_ENGLISH], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (300, N'300 - Wanderweg', NULL, N'300 - Wanderweg', NULL, N'2017-08-20')
GO
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (-1, N'Unbekannt', N'Unbekannt', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (1, N'001 - Autobahn', N'001 - Autobahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (2, N'002 - Fahrbahnteilung (keine Autobahn)', N'002 - Fahrbahnteilung (keine Autobahn)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (3, N'003 - Ungeteilte Fahrbahn', N'003 - Ungeteilte Fahrbahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (4, N'004 - Kreisverkehr', N'004 - Kreisverkehr', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (6, N'006 - Parkplatz', N'006 - Parkplatz', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (7, N'007 - Parkgarage', N'007 - Parkgarage', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (8, N'008 - Unstrukturierte Kreuzung', N'008 - Unstrukturierte Kreuzung', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (10, N'010 - Ab-/ Einbiegefahrbahn', N'010 - Ab-/ Einbiegefahrbahn', N'Rampe zwischen Landesstraßen oder Autobahnen', N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (11, N'011 - Servicestraße-Fahrbahn/Pannenstreifen', N'011 - Servicestraße-Fahrbahn/Pannenstreifen', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (12, N'012 - Ausfahrt/Einfahrt von/zu einem Parkplatz', N'012 - Ausfahrt/Einfahrt von/zu einem Parkplatz', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (13, N'013 - Straße (teilweise) im Objekt', N'013 - Straße (teilweise) im Objekt', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (14, N'014 - Fußgängerzone', N'014 - Fußgängerzone', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (15, N'015 - Fußweg', N'015 - Fußweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (16, N'016 - Fußweg (teilweise) im Objekt', N'016 - Fußweg (teilweise) im Objekt', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (17, N'017 - Spezielle Fahrbahnführung', N'017 - Spezielle Fahrbahnführung', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (18, N'018 - Stiege', N'018 - Stiege', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (19, N'019 - Furt', N'019 - Furt', NULL, N'2020-10-09')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (20, N'020 - Straße für Berechtigte/Behörden', N'020 - Straße für Berechtigte/Behörden', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (101, N'101 - Straßenbahn', N'101 - Straßenbahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (102, N'102 - U-Bahn', N'102 - U-Bahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (103, N'103 - Bahn', N'103 - Bahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (200, N'200 - Singletrail-Strecke (MTB)', N'200 - Singletrail-Strecke (MTB)', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (220, N'220 - MTB Strecke', N'220 - MTB Strecke', NULL, N'2022-04-06')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (301, N'301 - Betriebsumkehr', N'301 - Betriebsumkehr', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (400, N'400 - Traktorweg', N'400 - Traktorweg', NULL, N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (401, N'401 - Steig', N'401 - Steig', N'BEV: Fußweg', N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (402, N'402 - Steigspuren', N'402 - Steigspuren', N'BEV: Fußspur', N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (403, N'403 - Klettersteig', N'403 - Klettersteig', NULL, N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (404, N'404 - Alpine Route', N'404 - Alpine Route', NULL, N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (405, N'405 - Gletscherroute', N'405 - Gletscherroute', NULL, N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (406, N'406 - Schluchtweg', N'406 - Schluchtweg', N'Tiroler Bergwegekonzept', N'2019-07-29')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (504, N'504 - Geh- und Radweg', N'504 - Geh- und Radweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (505, N'505 - Radweg', N'505 - Radweg', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (506, N'506 - Normalspurbahn mehrgleisig', N'506 - Normalspurbahn mehrgleisig', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (507, N'507 - Normalspurbahn eingleisig', N'507 - Normalspurbahn eingleisig', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (508, N'508 - Schmalspurbahn', N'508 - Schmalspurbahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (509, N'509 - Zahnradbahn', N'509 - Zahnradbahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (510, N'510 - Breitspurbahn', N'510 - Breitspurbahn', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (511, N'511 - Seilschwebebahn', N'511 - Seilschwebebahn', N'Seilbahnen, deren Fahrzeuge von einem oder mehreren Seilen getragen und bewegt werden', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (512, N'512 - Standseilbahn', N'512 - Standseilbahn', N'Seilbahnen, deren Fahrzeuge durch ein oder mehrere Seile auf einer Fahrbahn gezogen werden, die auf dem Boden aufliegt oder durch feste Bauwerke gestützt ist', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (513, N'513 - Magnetschwebebahn', N'513 - Magnetschwebebahn', NULL, N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (514, N'514 - Monorail', N'514 - Monorail', NULL, N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (515, N'515 - Schwebebahn', N'515 - Schwebebahn', NULL, N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (516, N'516 - Schlepplift', N'516 - Schlepplift', N'Schlepplifte, bei denen die Fahrgäste mit geeigneter Ausrüstung entlang einer vorbereiteten Fahrbahn gezogen werden', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (517, N'517 - Materialseilbahn', N'517 - Materialseilbahn', N'Seilbahnen, die ausschließlich der Materialbeförderung dienen', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (518, N'518 - Kombilift', N'518 - Kombilift', N'Seilschwebebahnen, die wahlweise als Schlepplifte betrieben werden können', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (519, N'519 - Sessellift', N'511.1.4', N'Umlaufbahnen, deren Sessel mit dem Seil betrieblich nicht lösbar verbunden sind', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (520, N'520 - Babylift', N'520 - Babylift', NULL, N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (521, N'521 - Umlaufbahn', N'511.1', N'Seilschwebebahnen, deren Fahrzeuge auf beiden Fahrbahnseiten umlaufend bewegt werden', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (522, N'522 - Zweiseilpendelbahn', N'511.2.1', N'Detaillierung der Pendelbahn, bei der die Fahrzeuge durch funktionell getrennte Seile getragen und bewegt werden und im Pendelbetrieb verkehren', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (523, N'523 - Schrägaufzug', N'523 - Schrägaufzug', N'Aufzug, dessen Fahrzeug auf Schienen fährt, und durch mehrere Seile bewegt wird (Neigung: 15 - 75°)', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (524, N'524 - Pendelbahn', N'511.2', N'Seilschwebebahnen, deren Fahrzeuge ohne Wechsel der Fahrbahnseite zwischen den Stationen bewegt werden', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (525, N'525 - Sesselbahn', N'511.1.3', N'Umlaufbahnen, deren Sessel mit dem Seil betrieblich lösbar verbunden sind', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (526, N'526 - Kabinenbahn', N'511.1.1', N'Umlaufbahn mit Kabinen', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (527, N'527 - Kombibahn', N'511.1.2', N'Umlaufbahn mit Kabinen und Sesseln', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (528, N'528 - Korblift', N'511.3', N'Seilschwebebahn, bei der festverbundene Fahrzeuge (Körbe) in gleichbleibender Fahrtrichtung verkehren', N'2022-11-30')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (599, N'599 - Sonstige', N'599 - Sonstige', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (601, N'601 - Wasserweg / Fähre', N'601 - Wasserweg / Fähre', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (701, N'701 - Rampe für nichtmotorisierten Verkehr', N'701 - Rampe für nichtmotorisierten Verkehr', NULL, N'2017-08-20')
INSERT INTO [dbo].[LUT_FOW] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (702, N'702 - Einschließlichstrecke', N'702 - Einschließlichstrecke', NULL, N'2017-08-20')
GO
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'0', N'Österreich', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'1', N'Land Burgenland', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'2', N'Land Kärnten', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'3', N'Land Niederösterreich', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'4', N'Land Oberösterreich', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'5', N'Land Salzburg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'6', N'Land Steiermark', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'7', N'Land Tirol', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'8', N'Land Vorarlberg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'9', N'Land Wien', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'101', N'Bezirk Eisenstadt(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'102', N'Bezirk Rust(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'103', N'Bezirk Eisenstadt-Umgebung', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'104', N'Bezirk Güssing', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'105', N'Bezirk Jennersdorf', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'106', N'Bezirk Mattersburg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'107', N'Bezirk Neusiedl am See', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'108', N'Bezirk Oberpullendorf', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'109', N'Bezirk Oberwart', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'201', N'Bezirk Klagenfurt(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'202', N'Bezirk Villach(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'203', N'Bezirk Hermagor', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'204', N'Bezirk Klagenfurt Land', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'205', N'Bezirk Sankt Veit an der Glan', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'206', N'Bezirk Spittal an der Drau', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'207', N'Bezirk Villach Land', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'208', N'Bezirk Völkermarkt', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'209', N'Bezirk Wolfsberg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'210', N'Bezirk Feldkirchen', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'301', N'Bezirk Krems an der Donau(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'302', N'Bezirk Sankt Pölten(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'303', N'Bezirk Waidhofen an der Ybbs(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'304', N'Bezirk Wiener Neustadt(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'305', N'Bezirk Amstetten', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'306', N'Bezirk Baden', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'307', N'Bezirk Bruck an der Leitha', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'308', N'Bezirk Gänserndorf', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'309', N'Bezirk Gmünd', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'310', N'Bezirk Hollabrunn', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'311', N'Bezirk Horn', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'312', N'Bezirk Korneuburg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'313', N'Bezirk Krems(Land)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'314', N'Bezirk Lilienfeld', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'315', N'Bezirk Melk', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'316', N'Bezirk Mistelbach', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'317', N'Bezirk Mödling', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'318', N'Bezirk Neunkirchen', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'319', N'Bezirk Sankt Pölten(Land)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'320', N'Bezirk Scheibbs', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'321', N'Bezirk Tulln', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'322', N'Bezirk Waidhofen an der Thaya', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'323', N'Bezirk Wiener Neustadt(Land)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'325', N'Bezirk Zwettl', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'400', N'Magistrat', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'401', N'Bezirk Linz(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'402', N'Bezirk Steyr(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'403', N'Bezirk Wels(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'404', N'Bezirk Braunau am Inn', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'405', N'Bezirk Eferding', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'406', N'Bezirk Freistadt', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'407', N'Bezirk Gmunden', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'408', N'Bezirk Grieskirchen', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'409', N'Bezirk Kirchdorf an der Krems', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'410', N'Bezirk Linz-Land', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'411', N'Bezirk Perg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'412', N'Bezirk Ried im Innkreis', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'413', N'Bezirk Rohrbach', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'414', N'Bezirk Schärding', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'415', N'Bezirk Steyr-Land', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'416', N'Bezirk Urfahr-Umgebung', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'417', N'Bezirk Vöcklabruck', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'418', N'Bezirk Wels-Land', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'501', N'Bezirk Salzburg(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'502', N'Bezirk Hallein', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'503', N'Bezirk Salzburg-Umgebung', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'504', N'Bezirk Sankt Johann im Pongau', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'505', N'Bezirk Tamsweg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'506', N'Bezirk Zell am See', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'601', N'Bezirk Graz(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'603', N'Bezirk Deutschlandsberg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'606', N'Bezirk Graz-Umgebung', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'610', N'Bezirk Leibnitz', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'611', N'Bezirk Leoben', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'612', N'Bezirk Liezen', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'614', N'Bezirk Murau', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'616', N'Bezirk Voitsberg', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'617', N'Bezirk Weiz', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'620', N'Bezirk Murtal', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'621', N'Bezirk Bruck-Mürzzuschlag', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'622', N'Bezirk Hartberg-Fürstenfeld', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'623', N'Bezirk Südoststeiermark', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'701', N'Bezirk Innsbruck-Stadt', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'702', N'Bezirk Imst', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'703', N'Bezirk Innsbruck-Land', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'704', N'Bezirk Kitzbühel', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'705', N'Bezirk Kufstein', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'706', N'Bezirk Landeck', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'707', N'Bezirk Lienz', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'708', N'Bezirk Reutte', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'709', N'Bezirk Schwaz', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'801', N'Bezirk Bludenz', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'802', N'Bezirk Bregenz', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'803', N'Bezirk Dornbirn', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'804', N'Bezirk Feldkirch', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'900', N'Bezirk Wien(Stadt)', NULL, NULL, N'2020-12-02')
INSERT INTO [dbo].[LUT_SUSTAINER] ([ID], [NAME], [NAME_LONG], [DESCRIPTION], [MODIFY_TIMESTAMP]) VALUES (N'5001', N'Österreichischen Bundesforste (ÖBF)', NULL, NULL, N'2020-12-02')
GO

