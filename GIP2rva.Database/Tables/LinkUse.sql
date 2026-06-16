CREATE TABLE [dbo].[LinkUse] (
    [USE_ID]         INT            NOT NULL,
    [LINK_ID]        INT            NOT NULL,
    [OFFSET]         DECIMAL (4, 1) NULL,
    [FROM_PERCENT]   DECIMAL (7, 4) NULL,
    [TO_PERCENT]     DECIMAL (7, 4) NULL,
    [BASETYPE]       INT            NULL,
    [USE_ACCESS_TOW] INT            NULL,
    [USE_ACCESS_BKW] INT            NULL,
    PRIMARY KEY CLUSTERED ([USE_ID] ASC),
    CONSTRAINT [FK_LinkUse_Link] FOREIGN KEY ([LINK_ID]) REFERENCES [dbo].[Link] ([LINK_ID])
);

