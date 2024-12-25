USE [TravelLog]
GO

/****** Object:  Table [dbo].[Order]    Script Date: 2024/12/25 22:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order](
	[order_Id] [int] IDENTITY(1,1) NOT NULL,
	[order_Time] [datetime] NOT NULL,
	[order_TotalAmount] [decimal](18, 0) NOT NULL,
	[delete_at] [datetime] NULL,
	[user_Id] [int] NOT NULL,
	[order_Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[order_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([order_Status])
REFERENCES [dbo].[Order_Status] ([OS_Id])
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�q�� ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'order_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�U�q�ɶ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'order_Time'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�q���`���B' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'order_TotalAmount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����q��ɶ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'delete_at'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�s���Τ� ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'user_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�s���q�檬�A ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'order_Status'
GO