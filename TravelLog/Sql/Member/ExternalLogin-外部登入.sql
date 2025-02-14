USE [TravelLog]
GO

-- 建立外部登入映射資料表
CREATE TABLE [dbo].[ExternalLogins](
    [ExternalLoginId] [int] IDENTITY(1,1) NOT NULL,
    [Provider] [nvarchar](50) NOT NULL,            -- 外部登入提供者，例如 'Google'
    [ProviderUserId] [nvarchar](100) NOT NULL,       -- 外部使用者唯一識別碼，由 Google 回傳
    [MI_MemberID] [int] NOT NULL,                    -- 與 MemberInformation 的對應外鍵
    [DateCreated] [datetime] NOT NULL CONSTRAINT DF_ExternalLogins_DateCreated DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
    [ExternalLoginId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- 建立外鍵約束，連結到 MemberInformation 資料表
ALTER TABLE [dbo].[ExternalLogins] WITH CHECK ADD CONSTRAINT [FK_ExternalLogins_MemberInformation] FOREIGN KEY([MI_MemberID])
REFERENCES [dbo].[MemberInformation] ([MI_MemberID])
GO

ALTER TABLE [dbo].[ExternalLogins] CHECK CONSTRAINT [FK_ExternalLogins_MemberInformation]
GO

-- 建立唯一索引，避免同一個 Provider 的 ProviderUserId 重複對應不同的會員
CREATE UNIQUE INDEX [IX_ExternalLogins_Provider_ProviderUserId] ON [dbo].[ExternalLogins]
(
	[Provider] ASC,
	[ProviderUserId] ASC
) ON [PRIMARY]
GO