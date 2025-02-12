USE [TravelLog]
GO

/****** Object:  Table [dbo].[Bill]    Script Date: 2025/2/12 ¤U¤È 11:05:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Bill](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Total_Amount] [decimal](18, 0) NOT NULL,
	[PaidBy] [nvarchar](50) NOT NULL,
	[Created_At] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Bill] ADD  DEFAULT (getdate()) FOR [Created_At]
GO

ALTER TABLE [dbo].[Bill]  WITH CHECK ADD CHECK  (([Total_Amount]>=(0)))
GO


