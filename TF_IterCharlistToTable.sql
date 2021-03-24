USE [obmen_rn]
GO
/****** Object:  UserDefinedFunction [dbo].[IterCharlistToTable]    Script Date: 06.03.21 16:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
       CREATE FUNCTION [dbo].[IterCharlistToTable]
                    (@list      sysname,
                     @delimiter nchar(1) = N',')
         RETURNS @tbl TABLE ([ColName] nvarchar(256),[ColId] int IDENTITY(1, 1) NOT NULL,ColType nvarchar(256)) AS

   BEGIN
      DECLARE @pos      int,
              @textpos  int,
              @chunklen smallint,
              @tmpstr   nvarchar(4000),
              @leftover nvarchar(4000),
              @tmpval   nvarchar(4000)

      SET @textpos = 1
      SET @leftover = ''
      WHILE @textpos <= datalength(@list) / 2
      BEGIN
         SET @chunklen = 4000 - datalength(@leftover) / 2
         SET @tmpstr = @leftover + substring(@list, @textpos, @chunklen)
         SET @textpos = @textpos + @chunklen

         SET @pos = charindex(@delimiter, @tmpstr)

         WHILE @pos > 0
         BEGIN
            SET @tmpval = ltrim(rtrim(left(@tmpstr, charindex(@delimiter, @tmpstr) - 1)))
            INSERT @tbl ([ColName]) VALUES(@tmpval)
            SET @tmpstr = substring(@tmpstr, @pos + 1, len(@tmpstr))
            SET @pos = charindex(@delimiter, @tmpstr)
         END

         SET @leftover = @tmpstr
      END

      INSERT @tbl([ColName]) VALUES (ltrim(rtrim(@leftover)))
   RETURN
   END
