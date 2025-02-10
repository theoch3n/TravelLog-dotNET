USE [TravelLog]
GO

/****** Object:  Table [dbo].[Itinerary]    Script Date: 2025/2/10 下午 04:17:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Itinerary](
	[Itinerary_ID] [int] IDENTITY(1,1) NOT NULL,
	[Itinerary_Title] [nvarchar](50) NOT NULL,
	[Itinerary_Image] [varchar](200) NOT NULL,
	[Itinerary_CreateDate] [datetime] NULL,
 CONSTRAINT [PK_Itinerary] PRIMARY KEY CLUSTERED 
(
	[Itinerary_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_Title]  DEFAULT ('') FOR [Itinerary_Title]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_Image]  DEFAULT ('') FOR [Itinerary_Image]
GO

ALTER TABLE [dbo].[Itinerary] ADD  CONSTRAINT [DF_Itinerary_Itinerary_CreateDate]  DEFAULT (getdate()) FOR [Itinerary_CreateDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程圖片' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_Image'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary', @level2type=N'COLUMN',@level2name=N'Itinerary_CreateDate'
GO


