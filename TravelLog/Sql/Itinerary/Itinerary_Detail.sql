USE [TravelLog]
GO

/****** Object:  Table [dbo].[Itinerary_Detail]    Script Date: 2025/2/8 下午 05:48:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Itinerary_Detail](
	[ItineraryDetail_ID] [int] NOT NULL,
	[Itinerary_ID] [int] NOT NULL,
	[ItineraryDetail_Day] [int] NOT NULL,
	[ItineraryDetail_Accommodation] [int] NOT NULL,
	[ItineraryDetail_ProductTypeID] [int] NOT NULL,
	[ItineraryDetail_MapID] [int] NOT NULL,
	[ItineraryDetail_Group] [int] NOT NULL,
	[ItineraryDetail_StartDate] [datetime] NOT NULL,
	[ItineraryDetail_EndDate] [datetime] NOT NULL,
	[ItineraryDetail_Memo] [nvarchar](500) NOT NULL,
	[ItineraryDetail_CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Itinerary_Detail] PRIMARY KEY CLUSTERED 
(
	[ItineraryDetail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_Day]  DEFAULT ((0)) FOR [ItineraryDetail_Day]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_Accommodation]  DEFAULT ((0)) FOR [ItineraryDetail_Accommodation]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_ProductTypeID]  DEFAULT ((0)) FOR [ItineraryDetail_ProductTypeID]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_MapID]  DEFAULT ((0)) FOR [ItineraryDetail_MapID]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_Group]  DEFAULT ((0)) FOR [ItineraryDetail_Group]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_StartDate]  DEFAULT (getdate()) FOR [ItineraryDetail_StartDate]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_EndDate]  DEFAULT (getdate()) FOR [ItineraryDetail_EndDate]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_Memo]  DEFAULT ('') FOR [ItineraryDetail_Memo]
GO

ALTER TABLE [dbo].[Itinerary_Detail] ADD  CONSTRAINT [DF_Itinerary_Detail_ItineraryDetail_CreateDate]  DEFAULT (getdate()) FOR [ItineraryDetail_CreateDate]
GO

ALTER TABLE [dbo].[Itinerary_Detail]  WITH CHECK ADD  CONSTRAINT [FK_Itinerary_ID] FOREIGN KEY([Itinerary_ID])
REFERENCES [dbo].[Itinerary] ([Itinerary_ID])
GO

ALTER TABLE [dbo].[Itinerary_Detail] CHECK CONSTRAINT [FK_Itinerary_ID]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'Itinerary_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'第幾天' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_Day'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'住宿 關聯 ProductType_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_Accommodation'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品類別 關聯 ProductType_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_ProductTypeID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'地點 關聯 Map_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_MapID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'群組' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_Group'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程起始時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_StartDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程結束時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_EndDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程備註' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_Memo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Detail', @level2type=N'COLUMN',@level2name=N'ItineraryDetail_CreateDate'
GO


