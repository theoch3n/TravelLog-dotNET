USE [TravelLog]
GO

/****** Object:  Table [dbo].[Itinerary_Group]    Script Date: 2025/2/20 下午 04:46:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Itinerary_Group](
	[ItineraryGroup_ID] [int] IDENTITY(1,1) NOT NULL,
	[ItineraryGroup_ItineraryID] [int] NOT NULL,
	[ItineraryGroup_UserEmail] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Itinerary_Group] PRIMARY KEY CLUSTERED 
(
	[ItineraryGroup_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Itinerary_Group] ADD  CONSTRAINT [DF_ItineraryGroup_ItineraryGroup_ItineraryID]  DEFAULT ((0)) FOR [ItineraryGroup_ItineraryID]
GO

ALTER TABLE [dbo].[Itinerary_Group] ADD  CONSTRAINT [DF_ItineraryGroup_ItineraryGroup_UserEmail]  DEFAULT ('') FOR [ItineraryGroup_UserEmail]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Group', @level2type=N'COLUMN',@level2name=N'ItineraryGroup_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'行程ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Group', @level2type=N'COLUMN',@level2name=N'ItineraryGroup_ItineraryID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'使用者信箱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Itinerary_Group', @level2type=N'COLUMN',@level2name=N'ItineraryGroup_UserEmail'
GO


