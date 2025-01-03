USE [TravelLog]
GO

/****** Object:  Table [dbo].[Tickets]    Script Date: 2025/1/3 �U�� 09:41:37 ******/
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���� ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'TicketsId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���ȦW��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'TicketsName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���Ⱥ���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'TicketsType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���Ȼ���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���Ȫ��A' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'IsAvailable'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���ȴy�z' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���Ȱh�ڬF��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'RefundPolicy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���ȳЫؤ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tickets', @level2type=N'COLUMN',@level2name=N'CreatedAt'
GO


