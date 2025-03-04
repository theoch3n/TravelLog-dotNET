USE [TravelLog]
GO

/****** Object:  Table [dbo].[Itinerary_Price]    Script Date: 2025/3/4 ¤U¤È 04:49:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Itinerary_Price](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[itinerary_id] [int] NULL,
	[rating] [int] NULL,
	[price] [decimal](10, 2) NULL,
	[description] [nvarchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Itinerary_Price]  WITH CHECK ADD FOREIGN KEY([itinerary_id])
REFERENCES [dbo].[Itinerary] ([Itinerary_ID])
GO

ALTER TABLE [dbo].[Itinerary_Price]  WITH CHECK ADD CHECK  (([price]<=(200000)))
GO

ALTER TABLE [dbo].[Itinerary_Price]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO


