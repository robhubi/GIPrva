/*
**
** This script is used once after first import
** it creates 2 Look Up Tables and 3 Views for QGIS
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
