CREATE TABLE [dbo].[LinkUse_ImpError] (
    [USE_ID]         INT            NULL,
    [LINK_ID]        INT            NULL,
    [OFFSET]         DECIMAL (4, 1) NULL,
    [FROM_PERCENT]   DECIMAL (7, 4) NULL,
    [TO_PERCENT]     DECIMAL (7, 4) NULL,
    [BASETYPE]       INT            NULL,
    [USE_ACCESS_TOW] INT            NULL,
    [USE_ACCESS_BKW] INT            NULL,
    [ErrorCode]      INT            NULL,
    [ErrorColumn]    INT            NULL
);

