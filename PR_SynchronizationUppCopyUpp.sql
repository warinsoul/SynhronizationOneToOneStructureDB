USE [obmen_rn]
GO
/****** Object:  StoredProcedure [dbo].[SynchronizationUppCopyUpp]    Script Date: 06.03.21 17:22:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery17.sql|7|0|C:\Users\r.gadylgareev\AppData\Local\Temp\~vs60CA.sql
-- =============================================
-- Author:		warinsoul
-- Create date: 28.07.2020
-- Description:	Ïðîöåäóðà ñèõðàíèçàöèè òàáëèö 1Ñ Copyupp è uppunggf
-- =============================================
CREATE PROCEDURE [dbo].[SynchronizationUppCopyUpp] 
	-- Add the parameters for the stored procedure here
	@dbname_from sysname, 
	@TableName sysname,
	@dbname_to sysname,
	@PrimaryKey sysname

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @TablCol ColNames
declare @databasename sysname
declare @sql_query nvarchar(max)
declare @DSchema Nvarchar(6)='.dbo.'
declare @ColName NVarchar(256)
declare @ColId int
declare @ActionType nvarchar(256)
declare @TableScript TableScript
declare @TablPrimaries ColNames
declare @ChecksumString sysname
declare @ColType NVarchar(256)
declare @out_count_row int

declare cursDB cursor for
            select
                name
            from
                sys.databases d
            where
				(@dbname_from is null or (@dbname_from is not null and d.name=@dbname_from)) and 
                d.name <> 'model' and
                has_dbaccess(d.name)=1
            for read only
open cursDB
fetch next from cursDB into @databasename
while (@@FETCH_STATUS <> -1)
	begin
		select @sql_query=dbo.GetSQLString(@dbname_from,@TableName)
		insert  @TablCol
		exec sp_executesql @sql_query
		fetch next from cursDB into @databasename
	end
close cursDB
deallocate cursDB
insert into @TablPrimaries
select * from dbo.[IterCharlistToTable](@PrimaryKey,default)
	
declare curs cursor for
				select ColName,ColType
				from @TablCol
open curs
fetch next from curs into @ColName, @ColType
while (@@FETCH_STATUS<>-1)
	begin
		select @sql_query='select checksum('+dbo.GetListColumnsForSelectETL(@TablPrimaries)+'),'''+@ColName+''''+','+''''+@TableName+''','+[dbo].[GetListColumnsForChecksum](@ColName,@ColType,0)+', CURRENT_TIMESTAMP 
				from '+@dbname_from+@DSchema+@TableName+' as Source_table
									left join '+@dbname_to+@DSchema+@TableName+' as Destany_table on '+[dbo].[GetListColumnsForFilter](@TablPrimaries)+'
									where '+[dbo].[GetListColumnsForChecksum](@ColName,@ColType,1)
		insert into @TableScript
		exec sp_executesql @sql_query
		fetch next from curs into @ColName,@ColType
	end
close curs
deallocate curs
set @ActionType='insert'
select @sql_query=@ActionType+' into '+@dbname_to+@DSchema+@TableName + '('+[dbo].[GetListColumnsForSelect](@TablCol)+')'+
		' select '+
			[dbo].[GetListColumnsForSelect](@TablCol)+' from '+@dbname_from+@DSchema+@TableName+' as Source_table 
			Where checksum('+dbo.GetListColumnsForSelect(@TablPrimaries)+ ') in ('
			+dbo.GetIDRRefList(@TableScript,@ActionType,@TablPrimaries, default)+')'
exec sp_executesql @sql_query

set @ActionType='update'
declare cursor_col_name cursor local for
		select ColName,count(*) as cn from @TableScript  as Tl
		where tl.PrKey not in (select distinct PrKey from @TableScript where ColName  in(@PrimaryKey))
		group by ColName
	   order by 2 desc
open cursor_col_name
fetch next from cursor_col_name into @ColName,@ColId
	while (@@FETCH_STATUS<>-1)
		begin
			delete @TablCol
			insert @TablCol(ColName,ColId)
			select @ColName,@ColId
			select @sql_query=
				@ActionType+SPACE(1)+@dbname_to+@DSchema+@TableName+ ' set '+[dbo].[GetListColumnsForMerge](@TablCol,@TableName)
			+' from '+@dbname_from+@DSchema+@TableName
				+' as Source_table '+
				'where  checksum('+dbo.GetListColumnsForSelectETL(@TablPrimaries)+ ') in ('
				+dbo.GetIDRRefList(@TableScript,@ActionType,@TablPrimaries, @ColName)
				+') and '+dbo.GetListColumnsForUpdateETL(@TablPrimaries,@TableName)
			exec sp_executesql @sql_query
			fetch next from cursor_col_name into  @ColName,@ColId
		end
close cursor_col_name
deallocate cursor_col_name

	insert into [dbo].[LogSynchonization]
	select * from @TableScript
    select @out_count_row= COUNT(*) from @TableScript
	return @out_count_row
END

