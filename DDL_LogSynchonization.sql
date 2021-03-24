USE [obmen_rn]
GO

/****** Object:  Table [dbo].[LogSynchonization]    Script Date: 06.03.21 15:58:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LogSynchonization](
	[PrKey] [binary](16) NULL,
	[ColName] [nvarchar](256) NULL,
	[TableName] [nvarchar](256) NULL,
	[value_upsert_new] [sql_variant] NULL,
	[value_upsert_old] [sql_variant] NULL,
	[create_date] [datetime] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO


