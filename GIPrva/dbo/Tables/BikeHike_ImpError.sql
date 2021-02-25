CREATE TABLE [dbo].[BikeHike_ImpError] (
    [USE_ID]         INT            NULL,
    [USE_ACCESS_TOW] INT            NULL,
    [USE_ACCESS_BKW] INT            NULL,
    [BIKESIGNEDTOW]  DECIMAL (1)    NULL,
    [BIKESIGNEDBKW]  DECIMAL (1)    NULL,
    [BIKEFEATURETOW] NVARCHAR (254) NULL,
    [BIKEFEATUREBKW] NVARCHAR (254) NULL,
    [ErrorCode]      INT            NULL,
    [ErrorColumn]    INT            NULL,
    UNIQUE NONCLUSTERED ([USE_ID] ASC)
);

