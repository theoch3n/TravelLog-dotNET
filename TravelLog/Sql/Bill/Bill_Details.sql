USE [TravelLog]
GO

/****** Object:  Table [dbo].[Bill_details]    Script Date: 2025/2/21 ¤W¤È 09:06:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Bill_details](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Bill_Id] [int] NOT NULL,
	[Member_Name] [nvarchar](20) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Paid] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Bill_details] ADD  DEFAULT ((0)) FOR [Paid]
GO

ALTER TABLE [dbo].[Bill_details]  WITH CHECK ADD FOREIGN KEY([Bill_Id])
REFERENCES [dbo].[Bill] ([Id])
GO

ALTER TABLE [dbo].[Bill_details]  WITH CHECK ADD CHECK  (([Amount]>=(0)))
GO


