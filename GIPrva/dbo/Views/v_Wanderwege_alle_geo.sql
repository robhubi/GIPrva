CREATE VIEW dbo.v_Wanderwege_alle_geo
AS
WITH WWalle_CTE AS (SELECT        LINK_ID, NAME1, NAME2, LINE_GEO, STREETCAT, FUNCROADCLASS, FORMOFWAY, SUSTAINER
                                                   FROM            dbo.Link
                                                   WHERE        (STREETCAT = 'WA') OR
                                                                             (FUNCROADCLASS = 300))
    SELECT        WWalle_CTE_1.LINK_ID, WWalle_CTE_1.LINE_GEO, WWalle_CTE_1.NAME1, WWalle_CTE_1.NAME2, dbo.LUT_StreetCategory.NAME AS StreetCategory, dbo.LUT_FRC.NAME AS FRC, 
                              dbo.LUT_FOW.NAME AS FOW, dbo.LUT_SUSTAINER.NAME AS Sustainer, WWalle_CTE_1.STREETCAT AS ID_StreetCat, WWalle_CTE_1.FORMOFWAY AS ID_FOW, 
                              WWalle_CTE_1.FUNCROADCLASS AS ID_FRC, WWalle_CTE_1.SUSTAINER AS ID_Sust
     FROM            WWalle_CTE AS WWalle_CTE_1 INNER JOIN
                              dbo.LUT_StreetCategory ON WWalle_CTE_1.STREETCAT = dbo.LUT_StreetCategory.ID INNER JOIN
                              dbo.LUT_FRC ON WWalle_CTE_1.FUNCROADCLASS = dbo.LUT_FRC.ID INNER JOIN
                              dbo.LUT_FOW ON WWalle_CTE_1.FORMOFWAY = dbo.LUT_FOW.ID LEFT OUTER JOIN
                              dbo.LUT_SUSTAINER ON WWalle_CTE_1.SUSTAINER = dbo.LUT_SUSTAINER.ID
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_Wanderwege_alle_geo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'd
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2415
         Alias = 1755
         Table = 2160
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_Wanderwege_alle_geo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[39] 4[23] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "LUT_StreetCategory"
            Begin Extent = 
               Top = 0
               Left = 34
               Bottom = 97
               Right = 238
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LUT_FRC"
            Begin Extent = 
               Top = 0
               Left = 662
               Bottom = 123
               Right = 866
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LUT_FOW"
            Begin Extent = 
               Top = 124
               Left = 660
               Bottom = 254
               Right = 864
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LUT_SUSTAINER"
            Begin Extent = 
               Top = 104
               Left = 33
               Bottom = 224
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WWalle_CTE_1"
            Begin Extent = 
               Top = 0
               Left = 329
               Bottom = 204
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   En', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_Wanderwege_alle_geo';

