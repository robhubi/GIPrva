CREATE TABLE [dbo].[Link_ImpError] (
    [LINK_ID]       INT            NULL,
    [FROM_NODE]     INT            NULL,
    [TO_NODE]       INT            NULL,
    [ACCESS_TOW]    INT            NULL,
    [ACCESS_BKW]    INT            NULL,
    [NAME1]         NVARCHAR (254) NULL,
    [NAME2]         NVARCHAR (254) NULL,
    [STREETCAT]     CHAR (3)       NULL,
    [FUNCROADCLASS] INT            NULL,
    [FORMOFWAY]     INT            NULL,
    [SUSTAINER]     NVARCHAR (50)  NULL,
    [ErrorCode]     INT            NULL,
    [ErrorColumn]   INT            NULL
);



