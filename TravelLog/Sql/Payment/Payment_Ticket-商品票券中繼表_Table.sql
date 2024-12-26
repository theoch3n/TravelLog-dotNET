USE [TravelLog]
GO

/****** Object:  Table [dbo].[Product_Ticket]    Script Date: 2024/12/25 22:34:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Product_Ticket](
	[order_Id] [int] NULL,
	[ticket_Id] [int] NULL,
	[product_Id] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Product_Ticket]  WITH CHECK ADD FOREIGN KEY([order_Id])
REFERENCES [dbo].[Order] ([order_Id])
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'訂單 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Product_Ticket', @level2type=N'COLUMN',@level2name=N'order_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'票券 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Product_Ticket', @level2type=N'COLUMN',@level2name=N'ticket_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'商品 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Product_Ticket', @level2type=N'COLUMN',@level2name=N'product_Id'
GO
