CREATE TABLE [dbo].[LinkCoordinate] (
    [LINK_ID] INT             NOT NULL,
    [COUNT]   INT             NOT NULL,
    [X]       DECIMAL (9, 7)  NULL,
    [Y]       DECIMAL (9, 7)  NULL,
    [Z]       DECIMAL (10, 2) NULL,
    CONSTRAINT [PK_LinkCoordinate] PRIMARY KEY CLUSTERED ([LINK_ID] ASC, [COUNT] ASC),
    CONSTRAINT [FK_LinkCoordinate_Link] FOREIGN KEY ([LINK_ID]) REFERENCES [dbo].[Link] ([LINK_ID])
);

