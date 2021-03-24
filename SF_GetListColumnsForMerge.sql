USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetListColumnsForMerge]    Script Date: 06.03.21 16:19:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		warinsoul
-- Create date: 26.07.2020
-- Description:	Фукция переводящая список таблиц в строку
-- =============================================
ALTER FUNCTION [dbo].[GetListColumnsForMerge] 
(
	-- Add the parameters for the function here
	@ListColumns  ColNames readonly,
	@TableName sysname=''
)
RETURNS NVarchar(max)
AS
BEGIN
	-- Declare the return variable here
	declare @ListColNames NVarchar(max)=''
	declare @ColName NVarchar(256)
	declare @ColId int
	declare @ColCount int
	/*declare curs cursor LOCAL SCROLL  for 
						select 
							ColName,ColId,count(*) over () 
						from @ListColumns
						order by 2
					for  read only
		open curs
		fetch next from curs into @ColName,@ColId, @ColCount
		while (@@FETCH_STATUS=0 )
		begin 
			if @ColId!=2 and @ColCount!=1
				set @ListColNames+=','
			if @ColName!='_Version'
				set @ListColNames+=@ColName+'='+'Source_table.'+@ColName
			fetch next from  curs into @ColName,@ColId, @ColCount
		end
		close curs
		deallocate curs*/

			SELECT @ListColNames = STUFF(CAST((
				SELECT [text()] = ', '+@TableName+case when @TableName is not null then '.' else '' end + CONVERT(varchar(max),[ColName],1)+'='+'Source_table.'+CONVERT(varchar(max),[ColName],1)
			from @ListColumns  as lc
				FOR XML PATH(''), TYPE
				) AS VARCHAR(max)), 1, 2, '')

	-- Return the result of the function
	RETURN @ListColNames
END

