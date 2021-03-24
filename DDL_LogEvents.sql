USE [obmen_rn]
GO

/****** Object:  Table [dbo].[LoadEvents]    Script Date: 07.03.21 22:09:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LoadEvents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DateTimeEvent] [datetime] NOT NULL,
	[Flag] [bit] NOT NULL,
	[CountRow] [int] NULL
) ON [PRIMARY]
GO

