USE [master]
GO
/****** Object:  Database [InterChange]    Script Date: 23.03.2021 14:58:26 ******/
CREATE DATABASE [InterChange]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'InterChange', FILENAME = N'D:\database\InterChange.mdf' , SIZE = 68608KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'InterChange_log', FILENAME = N'D:\database\InterChange_log.ldf' , SIZE = 265344KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [InterChange] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [InterChange].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [InterChange] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [InterChange] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [InterChange] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [InterChange] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [InterChange] SET ARITHABORT OFF 
GO
ALTER DATABASE [InterChange] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [InterChange] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [InterChange] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [InterChange] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [InterChange] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [InterChange] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [InterChange] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [InterChange] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [InterChange] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [InterChange] SET  DISABLE_BROKER 
GO
ALTER DATABASE [InterChange] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [InterChange] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [InterChange] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [InterChange] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [InterChange] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [InterChange] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [InterChange] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [InterChange] SET RECOVERY FULL 
GO
ALTER DATABASE [InterChange] SET  MULTI_USER 
GO
ALTER DATABASE [InterChange] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [InterChange] SET DB_CHAINING OFF 
GO
ALTER DATABASE [InterChange] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [InterChange] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [InterChange] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'InterChange', N'ON'
GO
ALTER DATABASE [InterChange] SET QUERY_STORE = OFF
GO
USE [InterChange]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [InterChange]
GO
/****** Object:  Table [dbo].[PaymentSystemSpr]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentSystemSpr](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](100) NOT NULL,
	[Participates] [bit] NOT NULL,
 CONSTRAINT [PK_PaymentSystemSpr] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CurrencyRate]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrencyRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Currency] [nchar](3) NULL,
	[Rate] [numeric](18, 6) NULL,
 CONSTRAINT [PK_CurrencyRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tarif]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tarif](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTypePS] [int] NOT NULL,
	[IdCurrencyRate] [int] NULL,
	[TypeOperation] [nchar](3) NOT NULL,
	[MCC] [nchar](4) NULL,
	[Percentage] [numeric](18, 3) NOT NULL,
	[PayOperation] [int] NOT NULL,
 CONSTRAINT [PK_Tarif] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vTarif]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTarif]
AS
SELECT        TOP (100) PERCENT p.Name AS PSName, CASE t .[IdCurrencyRate] WHEN 0 THEN 'ALL' ELSE c.[Currency] END AS Currency, ISNULL(c.Rate, 0) AS Rate, t.TypeOperation, ISNULL(t.MCC, '') AS MCC, t.Percentage, 
                         CASE t .PayOperation WHEN 1 THEN 'доход' WHEN 0 THEN 'расход ПС' WHEN 2 THEN 'расход Процессинг' ELSE CAST(t .PayOperation AS varchar(MAX)) END AS PayOperation, t.Id, p.Id AS PSId
FROM            dbo.PaymentSystemSpr AS p LEFT OUTER JOIN
                         dbo.Tarif AS t ON p.Id = t.IdTypePS LEFT OUTER JOIN
                         dbo.CurrencyRate AS c ON c.Id = t.IdCurrencyRate
WHERE        (p.Participates = 1)
ORDER BY PSName, Currency, t.TypeOperation, PayOperation
GO
/****** Object:  View [dbo].[vCurRate]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCurRate]
AS
SELECT        dbo.CurrencyRate.*
FROM            dbo.CurrencyRate
GO
/****** Object:  View [dbo].[vPSSpr]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vPSSpr]
AS
SELECT        TOP (100) PERCENT Id, Name AS pName
FROM            dbo.PaymentSystemSpr
WHERE        (Participates = 1)
GO
/****** Object:  Table [dbo].[FinRez]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinRez](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Dogovor] [varchar](255) NOT NULL,
	[NameCustomer] [varchar](255) NOT NULL,
	[UNP] [char](9) NOT NULL,
	[BranchDogovor] [char](3) NOT NULL,
	[DateDogovor] [date] NOT NULL,
	[Count] [int] NOT NULL,
	[IncomeLOC] [decimal](18, 2) NOT NULL,
	[CostLOC] [decimal](18, 2) NOT NULL,
	[FinRezLOC] [decimal](18, 2) NOT NULL,
	[IncomeDOM] [decimal](18, 2) NOT NULL,
	[CostDOM] [decimal](18, 2) NOT NULL,
	[FinRezDOM] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_FinRez] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentSystems]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentSystems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPTS] [int] NOT NULL,
	[IdPSSpr] [int] NOT NULL,
	[ISO] [nchar](3) NOT NULL,
	[Count] [int] NOT NULL,
	[Circulation] [numeric](18, 2) NOT NULL,
	[Commission] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_PaymentSystems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PTS3]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PTS3](
	[Id] [int] NOT NULL,
	[DateLoad] [datetime] NULL,
	[MerchID] [int] NULL,
	[TypeTermID] [char](3) NULL,
	[TermID] [int] NULL,
	[OTS] [varchar](250) NULL,
	[TypeOTS] [varchar](250) NULL,
	[LegalEntity] [varchar](250) NULL,
	[NameCustomer] [varchar](250) NULL,
	[UNP] [char](9) NULL,
	[DirectionActivity] [varchar](250) NULL,
	[Ndogovor] [varchar](250) NULL,
	[DateDogovor] [date] NULL,
	[DateRegistration] [date] NULL,
	[EquipmentCost] [varchar](250) NULL,
	[OrganizationService] [varchar](250) NULL,
	[Region] [varchar](250) NULL,
	[Area] [varchar](250) NULL,
	[ShortCity] [varchar](250) NULL,
	[City] [varchar](250) NULL,
	[Street] [varchar](250) NULL,
	[Address] [varchar](250) NULL,
	[House] [varchar](250) NULL,
	[BranchRequest] [varchar](250) NULL,
	[BranchOTS] [varchar](250) NULL,
	[BranchDogovor] [varchar](250) NULL,
	[NMSTID] [varchar](250) NULL,
 CONSTRAINT [PK_PTS3] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[XLSSetting]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[XLSSetting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPSSpr] [int] NOT NULL,
	[ISO] [nchar](3) NOT NULL,
	[Count] [int] NOT NULL,
	[Circulation] [int] NOT NULL,
	[Commission] [int] NOT NULL,
 CONSTRAINT [PK_XLSSetting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CurrencyRate] ON 

INSERT [dbo].[CurrencyRate] ([Id], [Currency], [Rate]) VALUES (1, N'BYN', CAST(1.000000 AS Numeric(18, 6)))
INSERT [dbo].[CurrencyRate] ([Id], [Currency], [Rate]) VALUES (2, N'USD', CAST(2.622800 AS Numeric(18, 6)))
INSERT [dbo].[CurrencyRate] ([Id], [Currency], [Rate]) VALUES (3, N'EUR', CAST(3.171100 AS Numeric(18, 6)))
INSERT [dbo].[CurrencyRate] ([Id], [Currency], [Rate]) VALUES (4, N'RUB', CAST(0.034362 AS Numeric(18, 6)))
SET IDENTITY_INSERT [dbo].[CurrencyRate] OFF
GO
SET IDENTITY_INSERT [dbo].[FinRez] ON 

INSERT [dbo].[FinRez] ([Id], [Dogovor], [NameCustomer], [UNP], [BranchDogovor], [DateDogovor], [Count], [IncomeLOC], [CostLOC], [FinRezLOC], [IncomeDOM], [CostDOM], [FinRezDOM]) VALUES (1, N'4237-К', N'С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ФАЙВ СТАРС', N'200027624', N'100', CAST(N'2011-07-04' AS Date), 10, CAST(10.00 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)), CAST(30.00 AS Decimal(18, 2)), CAST(31.00 AS Decimal(18, 2)), CAST(32.00 AS Decimal(18, 2)), CAST(52.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[FinRez] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentSystems] ON 

INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (1, 1, 1, N'BYN', 245, CAST(6119.12 AS Numeric(18, 2)), CAST(61.45 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (2, 1, 1, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (3, 1, 1, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (4, 1, 1, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (5, 1, 3, N'BYN', 6, CAST(54.07 AS Numeric(18, 2)), CAST(0.54 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (6, 1, 3, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (7, 1, 3, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (8, 1, 3, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (9, 1, 8, N'BYN', 326, CAST(8021.29 AS Numeric(18, 2)), CAST(88.83 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (10, 1, 8, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (11, 1, 8, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (12, 1, 8, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (13, 1, 13, N'BYN', 195, CAST(3942.26 AS Numeric(18, 2)), CAST(39.47 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (14, 1, 13, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (15, 1, 13, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (16, 1, 13, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (17, 2, 1, N'BYN', 34, CAST(637.23 AS Numeric(18, 2)), CAST(6.39 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (18, 2, 1, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (19, 2, 1, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (20, 2, 1, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (21, 2, 3, N'BYN', 1, CAST(14.99 AS Numeric(18, 2)), CAST(0.15 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (22, 2, 3, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (23, 2, 3, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (24, 2, 3, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (25, 2, 8, N'BYN', 43, CAST(1108.98 AS Numeric(18, 2)), CAST(12.24 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (26, 2, 8, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (27, 2, 8, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (28, 2, 8, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (29, 2, 13, N'BYN', 24, CAST(429.52 AS Numeric(18, 2)), CAST(4.32 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (30, 2, 13, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (31, 2, 13, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (32, 2, 13, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (33, 3, 1, N'BYN', 229, CAST(5555.07 AS Numeric(18, 2)), CAST(56.28 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (34, 3, 1, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (35, 3, 1, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (36, 3, 1, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (37, 3, 3, N'BYN', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (38, 3, 3, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (39, 3, 3, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (40, 3, 3, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (41, 3, 8, N'BYN', 312, CAST(7556.51 AS Numeric(18, 2)), CAST(87.55 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (42, 3, 8, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (43, 3, 8, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (44, 3, 8, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (45, 3, 13, N'BYN', 189, CAST(4218.42 AS Numeric(18, 2)), CAST(42.34 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (46, 3, 13, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (47, 3, 13, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (48, 3, 13, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (49, 4, 1, N'BYN', 105, CAST(1949.31 AS Numeric(18, 2)), CAST(19.52 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (50, 4, 1, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (51, 4, 1, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (52, 4, 1, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (53, 4, 3, N'BYN', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (54, 4, 3, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (55, 4, 3, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (56, 4, 3, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (57, 4, 8, N'BYN', 143, CAST(3397.71 AS Numeric(18, 2)), CAST(38.30 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (58, 4, 8, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (59, 4, 8, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (60, 4, 8, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (61, 4, 13, N'BYN', 71, CAST(1356.11 AS Numeric(18, 2)), CAST(13.59 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (62, 4, 13, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (63, 4, 13, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (64, 4, 13, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (65, 5, 1, N'BYN', 257, CAST(6603.50 AS Numeric(18, 2)), CAST(67.01 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (66, 5, 1, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (67, 5, 1, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (68, 5, 1, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (69, 5, 3, N'BYN', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (70, 5, 3, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (71, 5, 3, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (72, 5, 3, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (73, 5, 8, N'BYN', 500, CAST(13555.13 AS Numeric(18, 2)), CAST(155.37 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (74, 5, 8, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (75, 5, 8, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (76, 5, 8, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (77, 5, 13, N'BYN', 255, CAST(5535.95 AS Numeric(18, 2)), CAST(55.45 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (78, 5, 13, N'EUR', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (79, 5, 13, N'RUB', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
INSERT [dbo].[PaymentSystems] ([Id], [IdPTS], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (80, 5, 13, N'USD', 0, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)))
SET IDENTITY_INSERT [dbo].[PaymentSystems] OFF
GO
SET IDENTITY_INSERT [dbo].[PaymentSystemSpr] ON 

INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (1, N'БЕЛКАРТ - ON-US                                                                                     ', 1)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (2, N'БЕЛКАРТ - LOC                                                                                       ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (3, N'Maestro - ON-US                                                                                     ', 1)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (4, N'Maestro - LOC                                                                                       ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (5, N'Maestro - DOM                                                                                       ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (6, N'Maestro - INT - резидент                                                                            ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (7, N'Maestro - INT - нерезидент                                                                          ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (8, N'MasterCard - ON-US                                                                                  ', 1)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (9, N'MasterCard - LOC                                                                                    ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (10, N'MasterCard - DOM                                                                                    ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (11, N'MasterCard - INT - резидент                                                                         ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (12, N'MasterCard - INT - нерезидент                                                                       ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (13, N'VISA - ON-US                                                                                        ', 1)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (14, N'VISA - LOC                                                                                          ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (15, N'VISA - DOM                                                                                          ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (16, N'VISA - INT - резидент                                                                               ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (17, N'VISA - INT - нерезидент                                                                             ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (18, N'UPI - ON-US                                                                                         ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (19, N'UPI - LOC                                                                                           ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (20, N'UPI - DOM                                                                                           ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (21, N'UPI - INT - резидент                                                                                ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (22, N'UPI - INT - нерезидент                                                                              ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (23, N'МИР - ON-US                                                                                         ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (24, N'МИР - LOC                                                                                           ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (25, N'МИР - DOM                                                                                           ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (26, N'МИР - INT - резидент                                                                                ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (27, N'МИР - INT - нерезидент                                                                              ', 0)
INSERT [dbo].[PaymentSystemSpr] ([Id], [Name], [Participates]) VALUES (28, N'TotalPaymentSystem                                                                                  ', 0)
SET IDENTITY_INSERT [dbo].[PaymentSystemSpr] OFF
GO
INSERT [dbo].[PTS3] ([Id], [DateLoad], [MerchID], [TypeTermID], [TermID], [OTS], [TypeOTS], [LegalEntity], [NameCustomer], [UNP], [DirectionActivity], [Ndogovor], [DateDogovor], [DateRegistration], [EquipmentCost], [OrganizationService], [Region], [Area], [ShortCity], [City], [Street], [Address], [House], [BranchRequest], [BranchOTS], [BranchDogovor], [NMSTID]) VALUES (1, CAST(N'2021-03-17T17:08:31.910' AS DateTime), 12390, N'SHG', 48164, N'АЗС', N'Блок', N'ООО ', N'БЛОК', N'300220961', N'5541, АЗС (Бензин, дизель, газ) Станции техоб', N'4416-К', CAST(N'2011-08-22' AS Date), CAST(N'2012-06-14' AS Date), N'Банк', N'ОАО БПЦ', N'Витебская', N'Витебский', N'г.', N'Витебск', N'ул.', N'В.Интернационалистов', N'-', N'795/722', N'795/722', N'795/722', N'')
INSERT [dbo].[PTS3] ([Id], [DateLoad], [MerchID], [TypeTermID], [TermID], [OTS], [TypeOTS], [LegalEntity], [NameCustomer], [UNP], [DirectionActivity], [Ndogovor], [DateDogovor], [DateRegistration], [EquipmentCost], [OrganizationService], [Region], [Area], [ShortCity], [City], [Street], [Address], [House], [BranchRequest], [BranchOTS], [BranchDogovor], [NMSTID]) VALUES (2, CAST(N'2021-03-17T17:08:31.913' AS DateTime), 12390, N'SHG', 85524, N'АЗС', N'Блок', N'ООО ', N'БЛОК', N'300220961', N'5541, АЗС (Бензин, дизель, газ) Станции техоб', N'4416-К', CAST(N'2011-08-22' AS Date), CAST(N'2019-01-18' AS Date), N'ОТС', N'ОАО БПЦ', N'Витебская', N'Витебский', N'г.', N'Витебск', N'ул.', N'В.Интернационалистов', N'-', N'795/722', N'795/722', N'795/722', N'')
INSERT [dbo].[PTS3] ([Id], [DateLoad], [MerchID], [TypeTermID], [TermID], [OTS], [TypeOTS], [LegalEntity], [NameCustomer], [UNP], [DirectionActivity], [Ndogovor], [DateDogovor], [DateRegistration], [EquipmentCost], [OrganizationService], [Region], [Area], [ShortCity], [City], [Street], [Address], [House], [BranchRequest], [BranchOTS], [BranchDogovor], [NMSTID]) VALUES (3, CAST(N'2021-03-17T17:08:31.913' AS DateTime), 21849, N'SHG', 50104, N'АЗС', N'1 Блок', N'ООО ', N'БЛОК', N'300220961', N'5541, АЗС (Бензин, дизель, газ) Станции техоб', N'4416-К', CAST(N'2011-08-22' AS Date), CAST(N'2012-11-02' AS Date), N'Банк', N'ОАО БПЦ', N'Витебская', N'Витебский', N'г.', N'Витебск', N'ул.', N'Терешковой', N'9а', N'795/612', N'795/612', N'795/612', N'')
INSERT [dbo].[PTS3] ([Id], [DateLoad], [MerchID], [TypeTermID], [TermID], [OTS], [TypeOTS], [LegalEntity], [NameCustomer], [UNP], [DirectionActivity], [Ndogovor], [DateDogovor], [DateRegistration], [EquipmentCost], [OrganizationService], [Region], [Area], [ShortCity], [City], [Street], [Address], [House], [BranchRequest], [BranchOTS], [BranchDogovor], [NMSTID]) VALUES (4, CAST(N'2021-03-17T17:08:31.913' AS DateTime), 34093, N'SHG', 61467, N'магазин при АЗС', N'№1 Блок', N'ООО ', N'БЛОК', N'300220961', N'5411, Продукты питания, бакалейные магазины, ', N'4416-К', CAST(N'2011-08-22' AS Date), CAST(N'2014-02-17' AS Date), N'Банк', N'ОАО БПЦ', N'Витебская', N'Витебский', N'г.', N'Витебск', N'ул.', N'Терешковой', N'9а', N'795/100', N'795/100', N'795/100', N'')
INSERT [dbo].[PTS3] ([Id], [DateLoad], [MerchID], [TypeTermID], [TermID], [OTS], [TypeOTS], [LegalEntity], [NameCustomer], [UNP], [DirectionActivity], [Ndogovor], [DateDogovor], [DateRegistration], [EquipmentCost], [OrganizationService], [Region], [Area], [ShortCity], [City], [Street], [Address], [House], [BranchRequest], [BranchOTS], [BranchDogovor], [NMSTID]) VALUES (5, CAST(N'2021-03-17T17:08:31.920' AS DateTime), 70367, N'SHC', 2086, N'АЗС', N'Блок', N'ООО ', N'БЛОК', N'300220961', N'5541, АЗС (Бензин, дизель, газ) Станции техоб', N'4416-К', CAST(N'2011-08-22' AS Date), CAST(N'2019-09-12' AS Date), N'Банк', N'ОАО БПЦ', N'Витебская', N'Полоцкий', N'г.', N'Новополоцк', N'ул.', N'Калинина', N'2Б', N'795/529', N'795/529', N'795/529', N'')
GO
SET IDENTITY_INSERT [dbo].[Tarif] ON 

INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (1, 1, 0, N'LOC', N'    ', CAST(1.430 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (2, 1, 0, N'DOM', N'    ', CAST(1.430 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (3, 1, 0, N'LOC', N'    ', CAST(0.012 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (4, 1, 0, N'DOM', N'    ', CAST(0.012 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (5, 1, 0, N'LOC', N'    ', CAST(0.006 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (6, 1, 0, N'DOM', N'    ', CAST(0.006 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (7, 3, 0, N'LOC', N'    ', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (8, 3, 0, N'DOM', N'    ', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (9, 3, 0, N'LOC', N'    ', CAST(0.012 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (10, 3, 0, N'DOM', N'    ', CAST(0.018 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (11, 3, 0, N'LOC', N'    ', CAST(0.025 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (12, 3, 0, N'DOM', N'    ', CAST(0.025 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (13, 8, 0, N'LOC', N'    ', CAST(1.350 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (14, 8, 0, N'LOC', N'5541', CAST(0.700 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (15, 8, 0, N'LOC', N'5542', CAST(0.700 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (16, 8, 0, N'LOC', N'9311', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (17, 8, 0, N'LOC', N'9399', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (18, 8, 0, N'LOC', N'9222', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (19, 8, 0, N'DOM', N'    ', CAST(1.530 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (20, 8, 0, N'DOM', N'9311', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (21, 8, 0, N'DOM', N'9399', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (22, 8, 0, N'DOM', N'9222', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (23, 8, 0, N'LOC', N'    ', CAST(0.012 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (24, 8, 0, N'DOM', N'    ', CAST(0.018 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (25, 8, 0, N'LOC', N'    ', CAST(0.025 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (26, 8, 0, N'DOM', N'    ', CAST(0.175 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (27, 13, 0, N'LOC', N'    ', CAST(1.180 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (28, 13, 0, N'LOC', N'5541', CAST(0.700 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (29, 13, 0, N'LOC', N'5542', CAST(0.700 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (30, 13, 0, N'LOC', N'9311', CAST(0.300 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (31, 13, 0, N'LOC', N'9399', CAST(0.300 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (32, 13, 0, N'LOC', N'9222', CAST(0.300 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (33, 13, 0, N'DOM', N'    ', CAST(1.520 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (34, 13, 0, N'DOM', N'5541', CAST(0.700 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (35, 13, 0, N'DOM', N'5542', CAST(0.700 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (36, 13, 0, N'DOM', N'9311', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (37, 13, 0, N'DOM', N'9399', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (38, 13, 0, N'DOM', N'9222', CAST(0.500 AS Numeric(18, 3)), 1)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (39, 13, 0, N'LOC', N'    ', CAST(0.012 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (40, 13, 0, N'DOM', N'    ', CAST(0.018 AS Numeric(18, 3)), 2)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (41, 13, 0, N'LOC', N'    ', CAST(0.077 AS Numeric(18, 3)), 0)
INSERT [dbo].[Tarif] ([Id], [IdTypePS], [IdCurrencyRate], [TypeOperation], [MCC], [Percentage], [PayOperation]) VALUES (42, 13, 0, N'DOM', N'    ', CAST(0.077 AS Numeric(18, 3)), 0)
SET IDENTITY_INSERT [dbo].[Tarif] OFF
GO
SET IDENTITY_INSERT [dbo].[XLSSetting] ON 

INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (1, 1, N'BYN', 26, 27, 28)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (2, 1, N'EUR', 29, 30, 31)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (3, 1, N'RUB', 32, 33, 34)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (4, 1, N'USD', 35, 36, 37)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (6, 3, N'BYN', 50, 51, 52)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (7, 3, N'EUR', 53, 54, 55)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (8, 3, N'RUB', 56, 57, 58)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (9, 3, N'USD', 59, 60, 61)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (10, 8, N'BYN', 107, 108, 109)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (11, 8, N'EUR', 110, 111, 112)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (12, 8, N'RUB', 113, 114, 115)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (13, 8, N'USD', 116, 117, 118)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (14, 13, N'BYN', 164, 165, 166)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (15, 13, N'EUR', 167, 168, 169)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (16, 13, N'RUB', 170, 171, 172)
INSERT [dbo].[XLSSetting] ([Id], [IdPSSpr], [ISO], [Count], [Circulation], [Commission]) VALUES (17, 13, N'USD', 173, 174, 175)
SET IDENTITY_INSERT [dbo].[XLSSetting] OFF
GO
/****** Object:  StoredProcedure [dbo].[CalculateFinRez]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalculateFinRez] 
	-- Add the parameters for the stored procedure here
	@dogovor varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


with myTable as (
--ДОХОД INCOME с МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' as 'Operation' /*MCC*/
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor)
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id]

UNION ALL
--ДОХОД INCOME LOC без МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
				AND ps.[Id] not in (
					SELECT ps.[Id] FROM [dbo].[PaymentSystems] as ps
					JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
					JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
					JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
					JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
					WHERE t.[TypeOperation]='LOC'
				)
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/
						/*AND t.[IdCurrencyRate]=c.[Id]*/ /*доход*/
						AND LEN(t.[MCC])=0 
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) AND t.[TypeOperation]='LOC'
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id]
UNION ALL
--ДОХОД INCOME DOM без МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
				AND ps.[Id] not in (
					SELECT ps.[Id] FROM [dbo].[PaymentSystems] as ps
					JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
					JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
					JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
					JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
					WHERE t.[TypeOperation]='DOM'
				)
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/
						/*AND t.[IdCurrencyRate]=c.[Id]*/ /*доход*/
						AND LEN(t.[MCC])=0 
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) AND t.[TypeOperation]='DOM'
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id]
UNION ALL

--Расход ПС COST PS
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation]+' Cost PS' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id]AND t.[PayOperation]=0 /*расход ПС*/
--JOIN [dbo].[CurrencyRate] as c ON c.[Id]=t.[IdCurrencyRate]
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]

WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor)
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id]
UNION ALL
--Расход Процессинг COST Proc
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation]+' Cost Proc' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id]AND t.[PayOperation]=2 /*расход Процессинг*/
--JOIN [dbo].[CurrencyRate] as c ON c.[Id]=t.[IdCurrencyRate]
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor)
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id]

) 
SELECT * FROM myTable as m
PIVOT (SUM([Action]) FOR [Operation] in ([LOC income],[LOC Cost PS],[LOC Cost Proc],[DOM income], [DOM Cost Proc], [DOM Cost PS]))p 

END
GO
/****** Object:  StoredProcedure [dbo].[CalculateFinRez2]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalculateFinRez2] 
	-- Add the parameters for the stored procedure here
	--@dogovor varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


with myTable as (
--ДОХОД INCOME с МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, pc3.[count]
	--, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' as 'Operation' /*MCC*/
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
JOIN (SELECT p3.[Ndogovor], count(*) as 'count' FROM [InterChange].[dbo].[PTS3] as p3 GROUP BY p3.[Ndogovor]) as pc3 ON pc3.[Ndogovor]=p3.Ndogovor
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor] in (SELECT distinct [Ndogovor] FROM [InterChange].[dbo].[PTS3]))
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], pc3.[count]

UNION ALL
--ДОХОД INCOME LOC без МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, pc3.[count]
	--, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
				AND ps.[Id] not in (
					SELECT ps.[Id] FROM [dbo].[PaymentSystems] as ps
					JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
					JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
					JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
					JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
					WHERE t.[TypeOperation]='LOC'
				)
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/
						/*AND t.[IdCurrencyRate]=c.[Id]*/ /*доход*/
						AND LEN(t.[MCC])=0 
JOIN (SELECT p3.[Ndogovor], count(*) as 'count' FROM [InterChange].[dbo].[PTS3] as p3 GROUP BY p3.[Ndogovor]) as pc3 ON pc3.[Ndogovor]=p3.Ndogovor

WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor] in (SELECT distinct [Ndogovor] FROM [InterChange].[dbo].[PTS3])) AND t.[TypeOperation]='LOC'
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], pc3.[count]
UNION ALL
--ДОХОД INCOME DOM без МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, pc3.[count]
	--, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
				AND ps.[Id] not in (
					SELECT ps.[Id] FROM [dbo].[PaymentSystems] as ps
					JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
					JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
					JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
					JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
					WHERE t.[TypeOperation]='DOM'
				)
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/
						/*AND t.[IdCurrencyRate]=c.[Id]*/ /*доход*/
						AND LEN(t.[MCC])=0 
JOIN (SELECT p3.[Ndogovor], count(*) as 'count' FROM [InterChange].[dbo].[PTS3] as p3 GROUP BY p3.[Ndogovor]) as pc3 ON pc3.[Ndogovor]=p3.Ndogovor

WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor] in (SELECT distinct [Ndogovor] FROM [InterChange].[dbo].[PTS3])) AND t.[TypeOperation]='DOM'
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], pc3.[count]
UNION ALL

--Расход ПС COST PS
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, pc3.[count]

	--, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation]+' Cost PS' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=0 /*расход ПС*/
--JOIN [dbo].[CurrencyRate] as c ON c.[Id]=t.[IdCurrencyRate]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN (SELECT p3.[Ndogovor], count(*) as 'count' FROM [InterChange].[dbo].[PTS3] as p3 GROUP BY p3.[Ndogovor]) as pc3 ON pc3.[Ndogovor]=p3.Ndogovor

WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor] in (SELECT distinct [Ndogovor] FROM [InterChange].[dbo].[PTS3]))
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], pc3.[count]
UNION ALL
--Расход Процессинг COST Proc
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, pc3.[count]

	--, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation]+' Cost Proc' as 'Operation'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action'
FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id]AND t.[PayOperation]=2 /*расход Процессинг*/
--JOIN [dbo].[CurrencyRate] as c ON c.[Id]=t.[IdCurrencyRate]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN (SELECT p3.[Ndogovor], count(*) as 'count' FROM [InterChange].[dbo].[PTS3] as p3 GROUP BY p3.[Ndogovor]) as pc3 ON pc3.[Ndogovor]=p3.Ndogovor

WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor] in (SELECT distinct [Ndogovor] FROM [InterChange].[dbo].[PTS3]))
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], pc3.[count]

) 
SELECT *
  --[Ndogovor],
  --[NameCustomer],
  --[UNP],
  --[BranchDogovor],
  --[DateDogovor],
  --(SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=m.[Ndogovor]) as 'Терминалов',
  --[Operation],
  --[Action]

FROM myTable as m
PIVOT (SUM([Action]) FOR [Operation] in ([LOC income],[LOC Cost PS],[LOC Cost Proc],[DOM income], [DOM Cost Proc], [DOM Cost PS]))p 

END
GO
/****** Object:  StoredProcedure [dbo].[CalculateFinRez3]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CalculateFinRez3] 
	-- Add the parameters for the stored procedure here
	@dogovor varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


with myTable as (
--ДОХОД INCOME с МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income MCC:'+t.[MCC] + ' '+spr.[Name] as 'Operation' /*MCC*/
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100' as 'Action'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action2'

FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor)
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], t.[MCC], spr.[Name]
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100'
			


UNION ALL
--ДОХОД INCOME LOC без МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' + ' '+spr.[Name]  as 'Operation'
	--, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]) as 'Action'
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100' as 'Action'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action2'

FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
				AND ps.[Id] not in (
					SELECT DISTINCT ps.[Id] FROM [dbo].[PaymentSystems] as ps
					JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
					JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
					JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
					JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
					WHERE t.[TypeOperation]='LOC'
				)
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/
						/*AND t.[IdCurrencyRate]=c.[Id]*/ /*доход*/
						AND LEN(t.[MCC])=0 
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) AND t.[TypeOperation]='LOC'
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], spr.[Name]
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100'
		
UNION ALL
--ДОХОД INCOME DOM без МСС
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation] + ' income' + ' '+spr.[Name]  as 'Operation'
	--, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]) as 'Action'
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100' as 'Action'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action2'

FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
				AND ps.[Id] not in (
					SELECT DISTINCT ps.[Id] FROM [dbo].[PaymentSystems] as ps
					JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
					JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
					JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/AND p3.[DirectionActivity] like '%' + t.[MCC] + '%'
					JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
					WHERE t.[TypeOperation]='DOM'
				)
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[CurrencyRate] as c ON c.[Currency]=ps.[ISO]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id] AND t.[PayOperation]=1 /*доход*/
						/*AND t.[IdCurrencyRate]=c.[Id]*/ /*доход*/
						AND LEN(t.[MCC])=0 
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) AND t.[TypeOperation]='DOM'
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], spr.[Name]
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100'


UNION ALL

--Расход ПС COST PS
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation]+' Cost PS' + ' '+spr.[Name]  as 'Operation'
	--, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]) as 'Action'
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100' as 'Action'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action2'

FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id]AND t.[PayOperation]=0 /*расход ПС*/
--JOIN [dbo].[CurrencyRate] as c ON c.[Id]=t.[IdCurrencyRate]
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]

WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor)
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], spr.[Name]
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100'
			
UNION ALL
--Расход Процессинг COST Proc
SELECT 
	p3.[Ndogovor]
	, p3.[NameCustomer]
	, p3.[UNP]
	, p3.[BranchDogovor]
	, p3.[DateDogovor]
	, (SELECT count(*) FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor) as 'Терминалов'
	, /*rtrim(ltrim(spr.[Id]))+' '+*/t.[TypeOperation]+' Cost Proc' + ' '+spr.[Name]  as 'Operation'
	--, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]) as 'Action'
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100' as 'Action'
	, sum(ps.[Circulation]*t.[Percentage]*c.[Rate]/100) as 'Action2'

FROM [dbo].[PaymentSystems] as ps
JOIN [dbo].[PTS3] as p3 ON p3.[Id]=ps.[IdPTS]
JOIN [dbo].[PaymentSystemSpr] spr ON spr.[Id]=ps.[IdPSSpr]
JOIN [dbo].[Tarif] as t ON t.[IdTypePS]=spr.[Id]AND t.[PayOperation]=2 /*расход Процессинг*/
--JOIN [dbo].[CurrencyRate] as c ON c.[Id]=t.[IdCurrencyRate]
JOIN [dbo].[CurrencyRate] as c ON /*c.[Id]=t.[IdCurrencyRate] AND*/ c.[Currency]=ps.[ISO]
WHERE ps.[IdPTS] in ( SELECT [Id] FROM [InterChange].[dbo].[PTS3] as p3 WHERE p3.[ndogovor]=@dogovor)
GROUP BY t.[TypeOperation], p3.[Ndogovor], p3.[NameCustomer], p3.[UNP], p3.[BranchDogovor], p3.[DateDogovor], spr.[Id], spr.[Name]
	, cast(ps.[Circulation] as varchar(max))+'x'+cast(t.[Percentage] as varchar(max))+'x'+cast(c.[Rate] as varchar(max))+' ('+cast(c.[Currency] as varchar(max))+')/100'
		

) 
SELECT * FROM myTable as m
ORDER BY m.[Operation], m.[Терминалов]
--PIVOT ([Action] FOR [Operation] in ([LOC income],[LOC Cost PS],[LOC Cost Proc],[DOM income], [DOM Cost Proc], [DOM Cost PS]))p 

END
GO
/****** Object:  StoredProcedure [dbo].[GetTarifDetails]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTarifDetails]  
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	p.Id as 'PSId',
	p.[Name] AS PSName, 
	isnull(c.[Currency], '') as 'Currency', 
	isnull(c.[Rate], 0) as 'Rate', 
	t.[TypeOperation], 
	t.[MCC], 
	t.[Percentage], 
    CASE t.[PayOperation] WHEN 1 THEN 'доход' WHEN 0 THEN 'расход ПС' WHEN 2 THEN 'расход Процессинг' ELSE CAST(t.[PayOperation] AS varchar(MAX)) END AS PayOperation, 
	t.[Id]
FROM [dbo].[PaymentSystemSpr] AS p 
	LEFT OUTER JOIN [dbo].[Tarif] AS t ON p.[Id] = t.[IdTypePS] 
	LEFT OUTER JOIN [dbo].[CurrencyRate] AS c ON c.[Id] = t.[IdCurrencyRate]
WHERE        (p.[Participates] = 1) AND t.[Id]=@id
END
GO
/****** Object:  StoredProcedure [dbo].[spCurRate]    Script Date: 23.03.2021 14:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCurRate]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id]
      ,[Currency]
      ,[Rate]
  FROM [InterChange].[dbo].[vCurRate]
  UNION ALL
  SELECT 0,'ALL',0
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "CurrencyRate"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
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
      Begin ColumnWidths = 9
         Width = 284
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
         Column = 1440
         Alias = 900
         Table = 1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vCurRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vCurRate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[12] 3) )"
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
         Begin Table = "PaymentSystemSpr"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2580
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
         Column = 1440
         Alias = 900
         Table = 1170
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPSSpr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPSSpr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[38] 2[8] 3) )"
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
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 158
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 185
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 119
               Right = 624
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
      Begin ColumnWidths = 10
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4170
         Alias = 1680
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1665
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vTarif'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vTarif'
GO
USE [master]
GO
ALTER DATABASE [InterChange] SET  READ_WRITE 
GO
