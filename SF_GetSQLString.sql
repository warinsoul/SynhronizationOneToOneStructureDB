USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetSQLString]    Script Date: 06.03.21 16:08:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		warinsoul
-- Create date: 23.07.2020
-- Description:	Формирование SQL запроса
-- =============================================
ALTER FUNCTION [dbo].[GetSQLString] 
(
	-- Add the parameters for the function here
	@databasename sysname,
	@TableName sysname
)
RETURNS NVarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SQLString NVarchar(max)

	-- Add the T-SQL statements to compute the return value here
	SELECT @SQLString = 'select c.name,row_number() over (order by c.column_id) as column_id,tp.name as type_id  from '+ quotename(@databasename) +'.sys.tables as t
				join '+quotename(@databasename) +'.sys.all_columns  as  c on c.object_id=t.object_id
				join '+quotename(@databasename) +'.sys.types as tp on tp.user_type_id=c.user_type_id
				where t.name like '''+@TableName+''' and c.name not in (''_Version'')' --and tp.name not in(''ntext'')'

	-- Return the result of the function
	RETURN @SQLString

END
