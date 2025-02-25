USE [TravelLog]
GO

/****** Object:  Table [dbo].[User_PD]    Script Date: 2025/2/25 下午 02:00:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[User_PD](
	[UserPD_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NOT NULL,
	[UserPD_PasswordHash] [varchar](256) NULL,
	[UserPD_Token] [varchar](max) NOT NULL,
	[UserPD_CreateDate] [datetime] NOT NULL,
	[TokenCreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_User_PD] PRIMARY KEY CLUSTERED 
(
	[UserPD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[User_PD] ADD  CONSTRAINT [DF_User_PD_UserPD_PasswordHash]  DEFAULT ('') FOR [UserPD_PasswordHash]
GO

ALTER TABLE [dbo].[User_PD] ADD  CONSTRAINT [DF_User_PD_UserPD_Token]  DEFAULT ('') FOR [UserPD_Token]
GO

ALTER TABLE [dbo].[User_PD] ADD  CONSTRAINT [DF_User_PD_UserPD_CreateDate]  DEFAULT (getdate()) FOR [UserPD_CreateDate]
GO

ALTER TABLE [dbo].[User_PD] ADD  CONSTRAINT [DF_User_PD_TokenCreateDate]  DEFAULT (getdate()) FOR [TokenCreateDate]
GO

ALTER TABLE [dbo].[User_PD]  WITH CHECK ADD  CONSTRAINT [FK__User_ID] FOREIGN KEY([User_ID])
REFERENCES [dbo].[User] ([User_ID])
GO

ALTER TABLE [dbo].[User_PD] CHECK CONSTRAINT [FK__User_ID]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_PD', @level2type=N'COLUMN',@level2name=N'UserPD_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'外鍵' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_PD', @level2type=N'COLUMN',@level2name=N'User_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密碼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_PD', @level2type=N'COLUMN',@level2name=N'UserPD_PasswordHash'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Token' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_PD', @level2type=N'COLUMN',@level2name=N'UserPD_Token'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'創建時間' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User_PD', @level2type=N'COLUMN',@level2name=N'UserPD_CreateDate'
GO


