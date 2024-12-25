USE [TravelLog]
GO

/****** Object:  Table [dbo].[Payment_Method]    Script Date: 2024/12/25 22:33:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Payment_Method](
	[PM_Id] [int] IDENTITY(1,1) NOT NULL,
	[payment_Method] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PM_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'付款方式 ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment_Method', @level2type=N'COLUMN',@level2name=N'PM_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'付款方式' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment_Method', @level2type=N'COLUMN',@level2name=N'payment_Method'
GO