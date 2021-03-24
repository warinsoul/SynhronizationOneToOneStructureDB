USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[FormatDate]    Script Date: 06.03.21 16:21:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FormatDate]
(
-- Add the parameters for the function here
@Date   DATETIME,
@Format NVARCHAR(50)
)
RETURNS NVARCHAR(50)
AS
 BEGIN

   DECLARE @ResultVar nvarchar(50) = UPPER(@Format);


   DECLARE @d nvarchar(20) = CONVERT(nvarchar(20), DATEPART(day, @Date));
   DECLARE @dd nvarchar(20) = case when DATEPART(day, @Date)<10 then +'0'+CONVERT(nvarchar(20), DATEPART(day, @Date)) else CONVERT(nvarchar(20), DATEPART(day, @Date)) end;
   DECLARE @day nvarchar(20) = DATENAME(weekday, @Date);
   DECLARE @ddd nvarchar(20) = DATENAME(weekday, @Date)+' '+CONVERT(nvarchar(5), DATEPART(day, @Date));


   DECLARE @m nvarchar(20) = CONVERT(nvarchar, DATEPART(month, @Date));
   DECLARE @mm nvarchar(20) = case when DATEPART(month, @Date)<10 then '0'+CONVERT(nvarchar, DATEPART(month, @Date))else CONVERT(nvarchar, DATEPART(month, @Date)) end;
   DECLARE @mmm nvarchar(20) = CONVERT(VARCHAR(3), DATENAME(month, @Date), 100);
   DECLARE @month nvarchar(20) = DATENAME(month, @Date);

   DECLARE @y nvarchar(20) = CONVERT(nvarchar, DATEPART(year, @Date));
   DECLARE @yy nvarchar(20) = RIGHT(CONVERT(nvarchar, DATEPART(year, GETDATE())),2);
   DECLARE @yyy nvarchar(20) = CONVERT(nvarchar, DATEPART(year, @Date));
   DECLARE @yyyy nvarchar(20) = CONVERT(nvarchar, DATEPART(year, @Date));
   DECLARE @year nvarchar(20) = CONVERT(nvarchar, DATEPART(year, @Date));

   SELECT @ResultVar = CASE WHEN CHARINDEX('DAY',@ResultVar) > 0 THEN  REPLACE(@ResultVar collate Latin1_General_CS_AS ,'DAY' collate Latin1_General_CS_AS ,@day)
                        WHEN CHARINDEX('DDD',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS ,'DDD' collate Latin1_General_CS_AS ,@ddd)
                       WHEN CHARINDEX('DD',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS ,'DD' collate Latin1_General_CS_AS ,@dd)
                       WHEN CHARINDEX('D',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS,'D' collate Latin1_General_CS_AS ,@d) END;

   SELECT @ResultVar = REPLACE(@ResultVar collate Latin1_General_CS_AS,'Monday' collate Latin1_General_CS_AS ,'monday')

   SELECT @ResultVar = CASE WHEN CHARINDEX('MONTH',@ResultVar) > 0 THEN  REPLACE(@ResultVar collate Latin1_General_CS_AS,'MONTH' collate Latin1_General_CS_AS,@month)
                       WHEN CHARINDEX('MMM',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS ,'MMM' collate Latin1_General_CS_AS,@mmm)
                       WHEN CHARINDEX('MM',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS,'MM' collate Latin1_General_CS_AS,@mm)
                       WHEN CHARINDEX('M',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS,'M' collate Latin1_General_CS_AS,@m) END;


   SELECT @ResultVar = CASE WHEN CHARINDEX('YEAR',@ResultVar) > 0 THEN  REPLACE(@ResultVar collate Latin1_General_CS_AS,'YEAR' collate Latin1_General_CS_AS ,@year)
                       WHEN CHARINDEX('YYYY',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS,'YYYY' collate Latin1_General_CS_AS ,@yyyy)
                       WHEN CHARINDEX('YYY',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS ,'YYY' collate Latin1_General_CS_AS ,@yyy)
                       WHEN CHARINDEX('YY',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS ,'YY' collate Latin1_General_CS_AS ,@yy)
                       WHEN CHARINDEX('Y',@ResultVar) > 0 THEN REPLACE(@ResultVar collate Latin1_General_CS_AS,'Y' collate Latin1_General_CS_AS ,@y) END;

   SELECT @ResultVar = REPLACE(@ResultVar collate Latin1_General_CS_AS,'monday' collate Latin1_General_CS_AS ,'Monday')

   RETURN @ResultVar

 END;

