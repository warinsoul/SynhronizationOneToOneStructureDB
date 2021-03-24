USE [obmen_rn]
GO

/****** Object:  Table [dbo].[LoadParametrs]    Script Date: 06.03.21 15:55:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LoadParametrs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [sysname] NOT NULL,
	[db_name_from] [sysname] NOT NULL,
	[db_name_to] [sysname] NOT NULL,
	[history_day] [int] NOT NULL,
	[PrimaryKeys] [sysname] NULL
) ON [PRIMARY]
GO


