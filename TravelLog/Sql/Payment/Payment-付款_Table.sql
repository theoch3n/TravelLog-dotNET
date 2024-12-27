USE [TravelLog]
GO

/****** Object:  Table [dbo].[Payment]    Script Date: 2024/12/25 22:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Payment](
	[payment_Id] [int] IDENTITY(1,1) NOT NULL,
	[payment_Deadline] [datetime] NOT NULL,
	[payment_Time] [datetime] NULL,
	[payment_Method] [int] NULL,
	[order_id] [int] NULL,
	[paymentStatus_Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[payment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Payment]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[Order] ([order_Id])
GO

ALTER TABLE [dbo].[Payment]  WITH CHECK ADD FOREIGN KEY([payment_Method])
REFERENCES [dbo].[Payment_Method] ([PM_Id])
GO

ALTER TABLE [dbo].[Payment]  WITH CHECK ADD FOREIGN KEY([paymentStatus_Id])
REFERENCES [dbo].[Payment_Status] ([PS_Id])
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�I�� ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'payment_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�I�ڴ���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'payment_Deadline'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�I�ڮɶ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'payment_Time'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�s���I�ڤ覡 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'payment_Method'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�s���q�� ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'order_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�s���I�ڪ��A ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment', @level2type=N'COLUMN',@level2name=N'paymentStatus_Id'
GO