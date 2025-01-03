USE [TravelLog]
GO

/****** Object:  Table [dbo].[Tickets]    Script Date: 2025/1/3 下午 09:41:37 ******/
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'TicketsId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'TicketsName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務種類' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'TicketsType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務價格' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務狀態' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'IsAvailable'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務退款政策' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'RefundPolicy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票務創建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'CreatedAt'
GO


