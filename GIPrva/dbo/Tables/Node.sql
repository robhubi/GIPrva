CREATE TABLE [dbo].[Node] (
    [NODE_ID] INT             NOT NULL,
    [X]       DECIMAL (9, 7)  NOT NULL,
    [Y]       DECIMAL (9, 7)  NOT NULL,
    [Z]       DECIMAL (10, 2) NULL,
    PRIMARY KEY CLUSTERED ([NODE_ID] ASC),
    CONSTRAINT [CHK_zero] CHECK ([X]<>(0) AND [Y]<>(0))
);

