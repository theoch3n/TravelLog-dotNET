USE [TravelLog]
GO

/****** Object:  Table [dbo].[Payment_Status]    Script Date: 2024/12/25 22:22:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Payment_Status](
	[PS_Id] [int] IDENTITY(1,1) NOT NULL,
	[payment_Status] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PS_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'¥I´Úª¬ºA ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment_Status', @level2type=N'COLUMN',@level2name=N'PS_Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'¥I´Úª¬ºA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment_Status', @level2type=N'COLUMN',@level2name=N'payment_Status'
GO