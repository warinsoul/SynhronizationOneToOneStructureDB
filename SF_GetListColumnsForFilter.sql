USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetListColumnsForFilter]    Script Date: 06.03.21 16:09:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		warinsoul
-- Create date: 26.07.2020
-- Description:	Фукция переводящая список таблиц в строку
-- =============================================
ALTER FUNCTION [dbo].[GetListColumnsForFilter] 
(
	-- Add the parameters for the function here
	@ListColumns  ColNames readonly
)
RETURNS NVarchar(max)
AS
BEGIN
	-- Declare the return variable here
	declare @ListColNames NVarchar(max)=''

		SELECT @ListColNames =+STUFF(CAST((
				SELECT [text()] = ' AND '+'Source_table.'+ CONVERT(varchar(max),[ColName],1)+'='+'Destany_table.'+ CONVERT(varchar(max),[ColName],1)
			from @ListColumns  as lc
				FOR XML PATH(''), TYPE
				) AS VARCHAR(max)), 1, 5, '')

	-- Return the result of the function
	RETURN @ListColNames
END

