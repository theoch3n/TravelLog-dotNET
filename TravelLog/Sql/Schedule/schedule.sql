USE [TravelLog]
GO

/****** Object:  Table [dbo].[Schedule]    Script Date: 2025/1/12 下午 05:44:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Schedule](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[destination] [nvarchar](100) NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ScheduleID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Schedule', @level2type=N'COLUMN',@level2name=N'id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'會員 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Schedule', @level2type=N'COLUMN',@level2name=N'user_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Schedule', @level2type=N'COLUMN',@level2name=N'name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'目的地' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Schedule', @level2type=N'COLUMN',@level2name=N'destination'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'開始日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Schedule', @level2type=N'COLUMN',@level2name=N'start_date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'結束日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Schedule', @level2type=N'COLUMN',@level2name=N'end_date'
GO


