USE [master]
GO
/****** Object:  Database [MyCos]    Script Date: 3/15/2020 1:17:04 AM ******/
CREATE DATABASE [MyCos]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'JupyterDatabase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\JupyterDatabase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'JupyterDatabase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\JupyterDatabase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MyCos] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MyCos].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MyCos] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MyCos] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MyCos] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MyCos] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MyCos] SET ARITHABORT OFF 
GO
ALTER DATABASE [MyCos] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MyCos] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MyCos] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MyCos] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MyCos] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MyCos] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MyCos] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MyCos] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MyCos] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MyCos] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MyCos] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MyCos] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MyCos] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MyCos] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MyCos] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MyCos] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MyCos] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MyCos] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MyCos] SET  MULTI_USER 
GO
ALTER DATABASE [MyCos] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MyCos] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MyCos] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MyCos] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MyCos] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MyCos] SET QUERY_STORE = OFF
GO
USE [MyCos]
GO
/****** Object:  User [user01]    Script Date: 3/15/2020 1:17:04 AM ******/
CREATE USER [user01] FOR LOGIN [user01] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [MySQLUser]    Script Date: 3/15/2020 1:17:04 AM ******/
CREATE USER [MySQLUser] FOR LOGIN [MySQLUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MySQLUser]
GO
/****** Object:  Table [dbo].[EMPLOYEEDATA]    Script Date: 3/15/2020 1:17:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYEEDATA](
	[ID] [varchar](36) NOT NULL,
	[FNAME] [varchar](50) NOT NULL,
	[LNAME] [varchar](50) NOT NULL,
	[BIRTHDATE] [date] NOT NULL,
	[EMPLOYDATE] [date] NOT NULL,
	[SALARY] [numeric](6, 0) NOT NULL,
	[PVDRATE] [numeric](3, 0) NOT NULL,
	[LASTUPDATE] [timestamp] NOT NULL,
 CONSTRAINT [PK_EMPLOYEEDATA2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_TRANSACTION]    Script Date: 3/15/2020 1:17:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_TRANSACTION]
AS
SELECT        ID, FNAME, LNAME, FORMAT(BIRTHDATE, 'yyyy-MM-dd') AS BIRTHDATE, FORMAT(EMPLOYDATE, 'yyyy-MM-dd') AS EMPLOYDATE, SALARY, PVDRATE, DATEDIFF(month, EMPLOYDATE, GETDATE()) AS WMONTH, LASTUPDATE, 
                         '' AS PVDTOTAL
FROM            dbo.EMPLOYEEDATA AS MAIN
GO
/****** Object:  Table [dbo].[PVDCONFIG]    Script Date: 3/15/2020 1:17:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PVDCONFIG](
	[ID] [nchar](10) NOT NULL,
	[WORKMIN] [numeric](4, 0) NULL,
	[WORKMAX] [numeric](4, 0) NULL,
	[PAIDPERCENT] [numeric](3, 0) NULL,
	[MAXPVDRATE] [numeric](3, 0) NULL,
 CONSTRAINT [PK_PVDCONFIG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PVDTRANSACTION]    Script Date: 3/15/2020 1:17:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PVDTRANSACTION](
	[ID] [nchar](10) NOT NULL,
	[EMPLOYEEID] [nchar](10) NOT NULL,
	[COMPANYYEAR] [numeric](4, 0) NOT NULL,
	[PVDRATE] [numeric](3, 0) NOT NULL,
	[PAID] [numeric](7, 0) NOT NULL,
	[LASTUPDATE] [timestamp] NOT NULL,
 CONSTRAINT [PK_PVDHISTORY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'066c91dd-fd85-4f9e-a543-2fb719ad49b2', N'Justin', N'Timberlake', CAST(N'1981-01-31' AS Date), CAST(N'2014-01-20' AS Date), CAST(35000 AS Numeric(6, 0)), CAST(10 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'2e455fa4-9fcc-45a2-9aa2-c7a844e0a174', N'Justin', N'Bieber', CAST(N'1994-03-01' AS Date), CAST(N'2016-12-01' AS Date), CAST(21000 AS Numeric(6, 0)), CAST(3 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'810997d9-a1fa-4585-a23e-1703f754404e', N'Beyonce', N'Knowles', CAST(N'1981-09-04' AS Date), CAST(N'2008-09-16' AS Date), CAST(25000 AS Numeric(6, 0)), CAST(3 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'8ace1adc-9ada-4622-8d05-03238c3e3131', N'Tom', N'Holland', CAST(N'1996-06-01' AS Date), CAST(N'2017-03-05' AS Date), CAST(35000 AS Numeric(6, 0)), CAST(7 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'93289c8e-0f65-4e4d-8b35-e10bb46b1619', N'Kang-Ho', N'Song', CAST(N'1967-01-17' AS Date), CAST(N'2019-06-01' AS Date), CAST(20000 AS Numeric(6, 0)), CAST(3 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'baa074e7-d35f-4de0-985f-2fa7b55d7d8a', N'Taylor', N'Swift', CAST(N'1989-12-13' AS Date), CAST(N'2018-05-01' AS Date), CAST(23000 AS Numeric(6, 0)), CAST(4 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'bf9b0be6-e50e-4a41-86c8-08f3699b9a42', N'Jeff', N'Goldblum', CAST(N'1952-10-22' AS Date), CAST(N'2020-01-01' AS Date), CAST(20000 AS Numeric(6, 0)), CAST(3 AS Numeric(3, 0)))
INSERT [dbo].[EMPLOYEEDATA] ([ID], [FNAME], [LNAME], [BIRTHDATE], [EMPLOYDATE], [SALARY], [PVDRATE]) VALUES (N'f3755211-f82c-4a39-9e2c-3f110d5b03a1', N'John', N'Wick', CAST(N'1964-09-02' AS Date), CAST(N'2004-03-01' AS Date), CAST(46000 AS Numeric(6, 0)), CAST(10 AS Numeric(3, 0)))
INSERT [dbo].[PVDCONFIG] ([ID], [WORKMIN], [WORKMAX], [PAIDPERCENT], [MAXPVDRATE]) VALUES (N'001       ', CAST(0 AS Numeric(4, 0)), CAST(2 AS Numeric(4, 0)), CAST(0 AS Numeric(3, 0)), CAST(0 AS Numeric(3, 0)))
INSERT [dbo].[PVDCONFIG] ([ID], [WORKMIN], [WORKMAX], [PAIDPERCENT], [MAXPVDRATE]) VALUES (N'002       ', CAST(3 AS Numeric(4, 0)), CAST(11 AS Numeric(4, 0)), CAST(10 AS Numeric(3, 0)), CAST(3 AS Numeric(3, 0)))
INSERT [dbo].[PVDCONFIG] ([ID], [WORKMIN], [WORKMAX], [PAIDPERCENT], [MAXPVDRATE]) VALUES (N'003       ', CAST(12 AS Numeric(4, 0)), CAST(35 AS Numeric(4, 0)), CAST(30 AS Numeric(3, 0)), CAST(5 AS Numeric(3, 0)))
INSERT [dbo].[PVDCONFIG] ([ID], [WORKMIN], [WORKMAX], [PAIDPERCENT], [MAXPVDRATE]) VALUES (N'004       ', CAST(36 AS Numeric(4, 0)), CAST(59 AS Numeric(4, 0)), CAST(50 AS Numeric(3, 0)), CAST(8 AS Numeric(3, 0)))
INSERT [dbo].[PVDCONFIG] ([ID], [WORKMIN], [WORKMAX], [PAIDPERCENT], [MAXPVDRATE]) VALUES (N'005       ', CAST(60 AS Numeric(4, 0)), CAST(9999 AS Numeric(4, 0)), CAST(80 AS Numeric(3, 0)), CAST(12 AS Numeric(3, 0)))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[27] 2[24] 3) )"
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
         Begin Table = "MAIN"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 268
               Right = 208
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 1395
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_TRANSACTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_TRANSACTION'
GO
USE [master]
GO
ALTER DATABASE [MyCos] SET  READ_WRITE 
GO
