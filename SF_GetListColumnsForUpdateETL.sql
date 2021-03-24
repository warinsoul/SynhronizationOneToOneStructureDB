USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetListColumnsForUpdateETL]    Script Date: 06.03.21 16:20:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		warinsoul
-- Create date: 06.08.2020
-- Description:	Фукция переводящая список таблиц в строку для определения полей для обновления
-- =============================================
ALTER FUNCTION [dbo].[GetListColumnsForUpdateETL] 
(
	-- Add the parameters for the function here
	@ListColumns  ColNames readonly,
	@TableName sysname
)
RETURNS NVarchar(max)
AS
BEGIN
	-- Declare the return variable here
	declare @ListColNames NVarchar(max)=''
	SELECT @ListColNames = STUFF(CAST((
				SELECT [text()] =' and '+@TableName+'.'+CONVERT(varchar(max),[ColName],1)+ ' = ' +'Source_table.'+  CONVERT(varchar(max),[ColName],1)
			from @ListColumns  as lc
				FOR XML PATH(''), TYPE
				) AS VARCHAR(max)), 1, 4, '')
	-- Return the result of the function
	RETURN @ListColNames

END

