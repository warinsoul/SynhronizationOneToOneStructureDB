USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetListColumnsForChecksum]    Script Date: 06.03.21 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		warinsoul
-- Create date: 06.08.2020
-- Description:	Фукция формирующие строку checksum
-- =============================================
ALTER FUNCTION [dbo].[GetListColumnsForChecksum] 
(
	-- Add the parameters for the function here
	@ColName sysname,
	@ColType sysname,
	@Filter bit=0
)
RETURNS NVarchar(max)
AS
BEGIN
declare @ChecksumString nvarchar(max)
if @Filter=1
	select @ChecksumString=case   @ColType when 'ntext' then 'CHECKSUM(convert(Nvarchar(4000),Source_table.'+@ColName+'))!=  CHECKSUM(convert(Nvarchar(4000),Destany_table.'+@ColName+'))' 
										   when 'image' then 'CHECKSUM(convert(varbinary,Source_table.'+@ColName+'))!=  CHECKSUM(convert(varbinary,Destany_table.'+@ColName+'))' 
											else 'CHECKSUM(Source_table.'+@ColName+')!=  CHECKSUM(Destany_table.'+@ColName+')'
																	end
else 
	select @ChecksumString=case   @ColType when 'ntext' then 'convert(Nvarchar(4000),Source_table.'+@ColName+') ,convert(Nvarchar(4000),Destany_table.'+@ColName+')'
										   when 'image' then 'convert(varbinary,Source_table.'+@ColName+') ,convert(varbinary,Destany_table.'+@ColName+')'
																	else 'Source_table.'+@ColName+' ,Destany_table.'+@ColName
																	end
	RETURN @ChecksumString
END

