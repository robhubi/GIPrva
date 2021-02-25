
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
USE [GIPrva];
GO

DROP TABLE [dbo].[Node_ImpError];
GO

DROP TABLE [dbo].[LinkUse_ImpError];
GO

DROP TABLE [dbo].[LinkCoordinate_ImpError];
GO

DROP TABLE [dbo].[Link_ImpError];
GO

DROP TABLE [dbo].[BikeHike_ImpError];
GO

DROP TABLE [dbo].[BikeHike];
GO

DROP TABLE [dbo].[LinkCoordinate];
GO

DROP TABLE [dbo].[LinkUse];
GO

DROP TABLE [dbo].[Link];
GO

DROP TABLE [dbo].[Node];
GO
