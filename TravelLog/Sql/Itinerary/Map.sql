USE [TravelLog]
GO

/****** Object:  Table [dbo].[Map]    Script Date: 2025/2/8 下午 05:44:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Map](
	[Map_ID] [int] IDENTITY(1,1) NOT NULL,
	[Map_PlaceName] [nvarchar](50) NOT NULL,
	[Map_Address] [nvarchar](200) NOT NULL,
	[Map_Longitude] [float] NOT NULL,
	[Map_Latitude] [float] NOT NULL,
	[Map_CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Map] PRIMARY KEY CLUSTERED 
(
	[Map_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Map] ADD  CONSTRAINT [DF_Map_Map_PlaceName]  DEFAULT ('') FOR [Map_PlaceName]
GO

ALTER TABLE [dbo].[Map] ADD  CONSTRAINT [DF_Map_Map_Address]  DEFAULT ('') FOR [Map_Address]
GO

ALTER TABLE [dbo].[Map] ADD  CONSTRAINT [DF_Map_Map_Longitude]  DEFAULT ((0)) FOR [Map_Longitude]
GO

ALTER TABLE [dbo].[Map] ADD  CONSTRAINT [DF_Map_Map_Latitude]  DEFAULT ((0)) FOR [Map_Latitude]
GO

ALTER TABLE [dbo].[Map] ADD  CONSTRAINT [DF_Map_Map_CreateDate]  DEFAULT (getdate()) FOR [Map_CreateDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Map', @level2type=N'COLUMN',@level2name=N'Map_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'地點名稱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Map', @level2type=N'COLUMN',@level2name=N'Map_PlaceName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Map', @level2type=N'COLUMN',@level2name=N'Map_Address'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'經度' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Map', @level2type=N'COLUMN',@level2name=N'Map_Longitude'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'緯度' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Map', @level2type=N'COLUMN',@level2name=N'Map_Latitude'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Map', @level2type=N'COLUMN',@level2name=N'Map_CreateDate'
GO


