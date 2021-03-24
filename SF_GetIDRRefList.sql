USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[GetIDRRefList]    Script Date: 06.03.21 16:18:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		warinsoul
-- Create date: 28.07.2020
-- Description:	Ôóíêöèÿ ñîáèðàþùàÿ ñïèñîê _IDRRef
-- =============================================
CREATE FUNCTION [dbo].[GetIDRRefList] 
(
	-- Add the parameters for the function here
	@TableScript TableScript readonly,
	@ActionType NVarchar(25),
	@PrimaryKey ColNames readonly,
	@ColName NVarchar(256)=null	
)
RETURNS Varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ListIdRRef Varchar(max)=''

	if lower(@ActionType)='update'
		SELECT @ListIdRRef = STUFF(CAST((
				SELECT [text()] = ', ' +  CONVERT(varchar(max),[PrKey],1)
			from @TableScript  as Tl
							where tl.PrKey not in (select distinct PrKey from @TableScript where ColName  in(select ColName from @PrimaryKey)) and  ColName=@ColName
				FOR XML PATH(''), TYPE
				) AS VARCHAR(max)), 1, 2, '')

	if lower(@ActionType)='insert'
		SELECT @ListIdRRef = STUFF(CAST((
				SELECT distinct  [text()] = ', ' +  CONVERT(varchar(max),[PrKey],1)
			from @TableScript  as Tl
							where tl.PrKey  in (select distinct PrKey from @TableScript where ColName  in(select ColName from @PrimaryKey)) 
				FOR XML PATH(''), TYPE
				) AS VARCHAR(max)), 1, 2, '')

	RETURN @ListIdRRef
	-- Return the result of the function
	

END

