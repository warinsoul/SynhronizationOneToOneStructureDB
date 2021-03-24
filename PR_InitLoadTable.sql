USE [obmen_rn]
GO
/****** Object:  StoredProcedure [dbo].[InitLoadTable]    Script Date: 06.03.21 15:57:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		warinsoul
-- Create date: 29.07.2020
-- Description:	Ïðîöåäóðà çàïóñêà ñèíõðîíèçàöèè
-- =============================================
CREATE PROCEDURE [dbo].[InitLoadTable] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
declare @db_name_from sysname
declare @TableName sysname
declare @db_name_to sysname
declare @PrimaryKeys sysname
declare @id_event int
declare @count_row int
declare @acc_count_row int=0


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	delete from loadEvents
	where dateTimeEvent<=DATEADD(day,-7,CURRENT_TIMESTAMP)

	insert into dbo.LoadEvents(DateTimeEvent,Flag)
		values(CURRENT_TIMESTAMP,0)
		SET @id_event=SCOPE_IDENTITY()

    -- Insert statements for procedure here
	declare curs cursor local for select db_name_from,TableName,db_name_to,PrimaryKeys from dbo.LoadParametrs
	open curs
	fetch next from  curs  into @db_name_from,  @TableName,@db_name_to,@PrimaryKeys
	while @@FETCH_STATUS<>-1
	begin
		execute @count_row= dbo.SynchronizationUppCopyUpp @db_name_from,@TableName,@db_name_to,@PrimaryKeys
		set @acc_count_row=@acc_count_row+@count_row
		fetch next from curs  into @db_name_from,  @TableName,@db_name_to,@PrimaryKeys
	end

	update dbo.LoadEvents
	set Flag=1,
	CountRow=@acc_count_row
	where id=@id_event
END

