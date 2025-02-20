USE [TravelLog]
GO

/****** Object:  Table [dbo].[Itinerary]    Script Date: 2025/2/20 下午 01:43:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Itinerary](
	[Itinerary_ID] [int] IDENTITY(1,1) NOT NULL,
	[Itinerary_Title] [nvarchar](50) NOT NULL,
	[Itinerary_Location] [nvarchar](50) NOT NULL,
	[Itinerary_Coordinate] [varchar](200) NOT NULL,
	[Itinerary_Image] [varchar](max) NOT NULL,
	[Itinerary_StartDate] [datetime] NOT NULL,
	[Itinerary_EndDate] [datetime] NOT NULL,
	[Itinerary_CreateUser] [int] NOT NULL,
	[Itinerary_CreateDate] [datetime] NULL,
 CONSTRAINT [PK_Itinerary] PRIMARY KEY CLUSTERED 
(
	[Itinerary_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_Title]  DEFAULT ('') FOR [Itinerary_Title]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_Location]  DEFAULT ('') FOR [Itinerary_Location]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_Coordinate]  DEFAULT ('') FOR [Itinerary_Coordinate]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_Image]  DEFAULT ('') FOR [Itinerary_Image]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_StartDate]  DEFAULT (getdate()) FOR [Itinerary_StartDate]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_CreateUser]  DEFAULT ((0)) FOR [Itinerary_CreateUser]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_CreateDate]  DEFAULT (getdate()) FOR [Itinerary_CreateDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程地點' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_Location'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程座標' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_Coordinate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程圖片' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_Image'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程起始時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_StartDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程結束時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_EndDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建使用者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_CreateUser'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_CreateDate'
GO


