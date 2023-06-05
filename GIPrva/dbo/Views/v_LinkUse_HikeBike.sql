CREATE VIEW dbo.v_LinkUse_HikeBike
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
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LinkUse_HikeBike';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'   Width = 1500
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7365
         Alias = 2025
         Table = 2370
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LinkUse_HikeBike';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[31] 2[9] 3) )"
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Link"
            Begin Extent = 
               Top = 7
               Left = 4
               Bottom = 210
               Right = 174
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LinkUse"
            Begin Extent = 
               Top = 24
               Left = 209
               Bottom = 256
               Right = 384
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LUT_BASETYPE"
            Begin Extent = 
               Top = 143
               Left = 425
               Bottom = 290
               Right = 620
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LUT_BIKEMERKMAL"
            Begin Extent = 
               Top = 8
               Left = 856
               Bottom = 178
               Right = 1076
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BikeHike"
            Begin Extent = 
               Top = 32
               Left = 633
               Bottom = 216
               Right = 808
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LUT_BIKEMERKMAL_1"
            Begin Extent = 
               Top = 131
               Left = 1127
               Bottom = 275
               Right = 1356
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
      Begin ColumnWidths = 20
         Width = 284
         Width = 1500
      ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'v_LinkUse_HikeBike';

