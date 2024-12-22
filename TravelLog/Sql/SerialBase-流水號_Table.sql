USE [TravelLog]
GO

/****** Object:  Table [dbo].[SerialBase]    Script Date: 2024/12/22 下午 04:26:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SerialBase](
	[SB_Serial] [int] IDENTITY(1,1) NOT NULL,
	[SB_SystemCode] [varchar](10) NOT NULL,
	[SB_SystemName] [nvarchar](50) NOT NULL,
	[SB_SerialNumber] [varchar](50) NOT NULL,
	[SB_Count] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SerialBase] PRIMARY KEY CLUSTERED 
(
	[SB_SystemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SerialBase] ADD  CONSTRAINT [DF_SerialBase_SB_SystemCode]  DEFAULT ('') FOR [SB_SystemCode]
GO

ALTER TABLE [dbo].[SerialBase] ADD  CONSTRAINT [DF_SerialBase_SB_SystemName]  DEFAULT ('') FOR [SB_SystemName]
GO

ALTER TABLE [dbo].[SerialBase] ADD  CONSTRAINT [DF_SerialBase_SB_SerialNumber]  DEFAULT ('') FOR [SB_SerialNumber]
GO

ALTER TABLE [dbo].[SerialBase] ADD  CONSTRAINT [DF_SerialBase_SB_Count]  DEFAULT ((0)) FOR [SB_Count]
GO

ALTER TABLE [dbo].[SerialBase] ADD  CONSTRAINT [DF_SerialBase_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'流水號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SerialBase', @level2type=N'COLUMN',@level2name=N'SB_Serial'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'系統代碼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SerialBase', @level2type=N'COLUMN',@level2name=N'SB_SystemCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'代碼名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SerialBase', @level2type=N'COLUMN',@level2name=N'SB_SystemName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'系統編號' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SerialBase', @level2type=N'COLUMN',@level2name=N'SB_SerialNumber'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'取號總數' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SerialBase', @level2type=N'COLUMN',@level2name=N'SB_Count'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SerialBase', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO


