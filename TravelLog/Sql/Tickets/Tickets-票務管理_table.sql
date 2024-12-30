USE [TravelLog]
GO

/****** Object:  Table [dbo].[Tickets]    Script Date: 2024/12/30 ¤W¤È 10:12:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Tickets](
	[TicketsId] [int] IDENTITY(1,1) NOT NULL,
	[TicketsName] [nvarchar](100) NOT NULL,
	[TicketsType] [nvarchar](20) NOT NULL,
	[Price] [int] NOT NULL,
	[IsAvailable] [bit] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[RefundPolicy] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TicketsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tickets] ADD  DEFAULT ((1)) FOR [IsAvailable]
GO

ALTER TABLE [dbo].[Tickets] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO


