CREATE TABLE [dbo].[Link] (
    [LINK_ID]    INT               NOT NULL,
    [FROM_NODE]  INT               NOT NULL,
    [TO_NODE]    INT               NOT NULL,
    [ACCESS_TOW] INT               NULL,
    [ACCESS_BKW] INT               NULL,
    [cLONx100]   INT               NULL,
    [cLATx100]   INT               NULL,
    [LINE_GEO]   [sys].[geography] NULL,
    PRIMARY KEY CLUSTERED ([LINK_ID] ASC),
    CONSTRAINT [FK_foLink_Node] FOREIGN KEY ([FROM_NODE]) REFERENCES [dbo].[Node] ([NODE_ID]),
    CONSTRAINT [FK_toLink_Node] FOREIGN KEY ([TO_NODE]) REFERENCES [dbo].[Node] ([NODE_ID])
);


GO
CREATE NONCLUSTERED INDEX [cXY_index]
    ON [dbo].[Link]([cLONx100] ASC, [cLATx100] ASC);

