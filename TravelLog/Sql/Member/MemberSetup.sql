USE [TravelLog]
GO

-- 如果表已存在，先刪除
DROP TABLE IF EXISTS [dbo].[ExternalLogins];
DROP TABLE IF EXISTS [dbo].[MemberInformation];
DROP TABLE IF EXISTS [dbo].[User_PD];
DROP TABLE IF EXISTS [dbo].[User];

-- 建立 User 表
CREATE TABLE [dbo].[User] (
    [User_ID] INT IDENTITY(1,1) PRIMARY KEY,        -- 使用者 ID (PK)
    [User_Name] NVARCHAR(50) NOT NULL,              -- 使用者姓名
    [User_Email] VARCHAR(100) NOT NULL,             -- 信箱
    [User_Phone] VARCHAR(10) NOT NULL,              -- 手機
    [User_Enabled] BIT NOT NULL DEFAULT (0),        -- 啟用狀態
    [User_CreateDate] DATETIME NOT NULL DEFAULT GETDATE() -- 創建時間
);

-- 建立 MemberInformation 表
CREATE TABLE [dbo].[MemberInformation] (
    [MI_MemberID] INT IDENTITY(1,1) PRIMARY KEY,    -- 會員 ID (PK)
    [MI_AccountName] NVARCHAR(50) NOT NULL,         -- 帳戶名稱
    [MI_Email] NVARCHAR(100) NOT NULL,              -- 電子郵件
    [MI_PasswordHash] NVARCHAR(255) NOT NULL,       -- 密碼雜湊
    [MI_RegistrationDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 註冊時間
    [MI_IsActive] BIT NOT NULL DEFAULT (1),         -- 是否啟用
    [MiEmailConfirmationToken] NVARCHAR(255) NULL   -- 電子郵件確認令牌
);

-- 建立 User_PD 表
CREATE TABLE [dbo].[User_PD] (
    [UserPD_ID] INT IDENTITY(1,1) PRIMARY KEY,      -- 使用者密碼資料 ID (PK)
    [User_ID] INT NOT NULL,                         -- 關聯的 User ID
    [UserPD_PasswordHash] VARCHAR(256) NULL,        -- 密碼雜湊
    [UserPD_Token] VARCHAR(MAX) NOT NULL,           -- Token
    [UserPD_CreateDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 創建時間
    CONSTRAINT FK_UserPD_User FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User]([User_ID])
);

-- 建立 ExternalLogins 表
CREATE TABLE [dbo].[ExternalLogins] (
    [ExternalLoginId] INT IDENTITY(1,1) PRIMARY KEY, -- 外部登入 ID (PK)
    [Provider] NVARCHAR(50) NOT NULL,               -- 外部登入提供者
    [ProviderUserId] NVARCHAR(100) NOT NULL,        -- 外部使用者唯一識別碼
    [MI_MemberID] INT NOT NULL,                     -- 關聯的 MemberInformation ID
    [DateCreated] DATETIME NOT NULL DEFAULT GETDATE(), -- 創建時間
    CONSTRAINT FK_ExternalLogins_MemberInformation FOREIGN KEY ([MI_MemberID]) REFERENCES [dbo].[MemberInformation]([MI_MemberID])
);

-- 加入預設值
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Name DEFAULT ('') FOR [User_Name];
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Email DEFAULT ('') FOR [User_Email];
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Phone DEFAULT ('') FOR [User_Phone];

ALTER TABLE [dbo].[User_PD] ADD CONSTRAINT DF_UserPD_PasswordHash DEFAULT ('') FOR [UserPD_PasswordHash];
ALTER TABLE [dbo].[User_PD] ADD CONSTRAINT DF_UserPD_Token DEFAULT ('') FOR [UserPD_Token];

-- 加入檢查條件
ALTER TABLE [dbo].[User] 
    WITH CHECK ADD CHECK ((LEN([User_Phone]) = 10)); -- 手機號碼長度必須為 10

-- 建立索引
CREATE UNIQUE NONCLUSTERED INDEX UQ_MemberInformation_Email 
    ON [dbo].[MemberInformation]([MI_Email]) 
    WHERE [MI_Email] IS NOT NULL;

CREATE UNIQUE INDEX IX_ExternalLogins_Provider_ProviderUserId 
    ON [dbo].[ExternalLogins]([Provider], [ProviderUserId]);

CREATE INDEX IDX_UserPD_User ON [dbo].[User_PD]([User_ID]);
CREATE INDEX IDX_ExternalLogins_Member ON [dbo].[ExternalLogins]([MI_MemberID]);

-- 插入預設資料
INSERT INTO [dbo].[MemberInformation] 
    ([MI_AccountName], [MI_Email], [MI_PasswordHash], [MI_RegistrationDate], [MI_IsActive], [MiEmailConfirmationToken])
VALUES 
    ('Test', 'Test@gmail.com', '047f91c39524762a871344b62bc607418653f78a2e11fabb1dafb79968a99272', '2025-01-11 17:24:24.650', 1, NULL);

-- 加入欄位備註
-- User 表備註
EXEC sp_addextendedproperty 'MS_Description', '使用者 ID', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '使用者姓名', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Name';
EXEC sp_addextendedproperty 'MS_Description', '信箱', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Email';
EXEC sp_addextendedproperty 'MS_Description', '手機', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Phone';
EXEC sp_addextendedproperty 'MS_Description', '啟用狀態 (0 = 未啟用, 1 = 啟用)', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Enabled';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_CreateDate';

-- MemberInformation 表備註
EXEC sp_addextendedproperty 'MS_Description', '會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '帳戶名稱', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_AccountName';
EXEC sp_addextendedproperty 'MS_Description', '電子郵件', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_Email';
EXEC sp_addextendedproperty 'MS_Description', '密碼雜湊', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', '註冊時間', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_RegistrationDate';
EXEC sp_addextendedproperty 'MS_Description', '是否啟用 (0 = 未啟用, 1 = 啟用)', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_IsActive';
EXEC sp_addextendedproperty 'MS_Description', '電子郵件確認令牌', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MiEmailConfirmationToken';

-- User_PD 表備註
EXEC sp_addextendedproperty 'MS_Description', '使用者密碼資料 ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_ID';
EXEC sp_addextendedproperty 'MS_Description', '關聯的 User ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '密碼雜湊', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', 'Token', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_Token';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_CreateDate';

-- ExternalLogins 表備註
EXEC sp_addextendedproperty 'MS_Description', '外部登入 ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ExternalLoginId';
EXEC sp_addextendedproperty 'MS_Description', '外部登入提供者 (如 Google)', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'Provider';
EXEC sp_addextendedproperty 'MS_Description', '外部使用者唯一識別碼', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ProviderUserId';
EXEC sp_addextendedproperty 'MS_Description', '關聯的會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'DateCreated';
GO