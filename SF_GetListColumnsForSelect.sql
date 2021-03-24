USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetListColumnsForSelect]    Script Date: 06.03.21 16:16:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		warinsoul
-- Create date: 26.07.2020
-- Description:	Фукция переводящая список таблиц в строку
-- =============================================
ALTER FUNCTION [dbo].[GetListColumnsForSelect] 
(
	-- Add the parameters for the function here
	@ListColumns  ColNames readonly
)
RETURNS NVarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SQLColumns NVarchar(max)
	declare @ListColNames NVarchar(max)=''
	declare @ColName NVarchar(256)
	declare @ColId int
	/*declare curs cursor LOCAL SCROLL  for 
						select 
							ColName,
							ColId
						from @ListColumns
					for  read only
		open curs
		fetch next from curs into @ColName, @ColId
		while (@@FETCH_STATUS=0 )
		begin 
			if @ColId!=1
				set @ListColNames+=','
			set @ListColNames+=@ColName
		fetch next from  curs into @ColName,@ColId
		end
		close curs
		deallocate curs*/
	-- Add the T-SQL statements to compute the return value here
	SELECT @ListColNames = STUFF(CAST((
				SELECT [text()] = ', ' +  CONVERT(varchar(max),[ColName],1)
			from @ListColumns  as lc
				FOR XML PATH(''), TYPE
				) AS VARCHAR(max)), 1, 2, '')
	-- Return the result of the function
	RETURN @ListColNames

END

