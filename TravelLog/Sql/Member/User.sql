USE [TravelLog]
GO

/****** Object:  Table [dbo].[User]    Script Date: 2025/2/4 下午 04:27:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[User](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_Name] [nvarchar](50) NOT NULL,
	[User_Email] [varchar](100) NOT NULL,
	[User_Phone] [varchar](10) NOT NULL,
	[User_Enabled] [bit] NOT NULL,
	[User_CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_User_Name]  DEFAULT ('') FOR [User_Name]
GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_User_Email]  DEFAULT ('') FOR [User_Email]
GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_User_Phone]  DEFAULT ('') FOR [User_Phone]
GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_User_Enabled]  DEFAULT ((0)) FOR [User_Enabled]
GO

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_User_CreateDate]  DEFAULT (getdate()) FOR [User_CreateDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'User_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'使用者姓名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'User_Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'信箱' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'User_Email'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'手機' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'User_Phone'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'啟用狀態  0 = 啟用, 1 = 關閉 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'User_Enabled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User', @level2type=N'COLUMN',@level2name=N'User_CreateDate'
GO


