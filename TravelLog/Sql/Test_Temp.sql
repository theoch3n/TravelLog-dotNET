USE [TravelLog]
GO

/****** Object:  Table [dbo].[Temp]    Script Date: 2024/12/20 ¤W¤È 11:36:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp](
	[CO1] [char](10) NOT NULL,
	[CO2] [varchar](10) NOT NULL,
	[Delete_at] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Temp] ADD  CONSTRAINT [DF_Temp_CO1]  DEFAULT ('') FOR [CO1]
GO

ALTER TABLE [dbo].[Temp] ADD  CONSTRAINT [DF_Temp_CO2]  DEFAULT ('') FOR [CO2]
GO


