USE [TravelLog]
GO

/****** Object:  Table [dbo].[Place_Detail]    Script Date: 2025/3/4 ¤U¤È 04:49:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Place_Detail](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[itinerary_id] [int] NULL,
	[place_id] [int] NULL,
	[detail] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Place_Detail]  WITH CHECK ADD FOREIGN KEY([itinerary_id])
REFERENCES [dbo].[Itinerary] ([Itinerary_ID])
GO

ALTER TABLE [dbo].[Place_Detail]  WITH CHECK ADD FOREIGN KEY([place_id])
REFERENCES [dbo].[Place] ([Id])
GO


