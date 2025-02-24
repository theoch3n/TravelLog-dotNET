USE [TravelLog]
GO

-- �p�G��w�s�b�A���R��
DROP TABLE IF EXISTS [dbo].[ExternalLogins];
DROP TABLE IF EXISTS [dbo].[MemberInformation];
DROP TABLE IF EXISTS [dbo].[User_PD];
DROP TABLE IF EXISTS [dbo].[User];

-- �إ� User ��
CREATE TABLE [dbo].[User] (
    [User_ID] INT IDENTITY(1,1) PRIMARY KEY,        -- �ϥΪ� ID (PK)
    [User_Name] NVARCHAR(50) NOT NULL,              -- �ϥΪ̩m�W
    [User_Email] VARCHAR(100) NOT NULL,             -- �H�c
    [User_Phone] VARCHAR(10) NOT NULL,              -- ���
    [User_Enabled] BIT NOT NULL DEFAULT (0),        -- �ҥΪ��A
    [User_CreateDate] DATETIME NOT NULL DEFAULT GETDATE() -- �Ыخɶ�
);

-- �إ� MemberInformation ��
CREATE TABLE [dbo].[MemberInformation] (
    [MI_MemberID] INT IDENTITY(1,1) PRIMARY KEY,    -- �|�� ID (PK)
    [MI_AccountName] NVARCHAR(50) NOT NULL,         -- �b��W��
    [MI_Email] NVARCHAR(100) NOT NULL,              -- �q�l�l��
    [MI_PasswordHash] NVARCHAR(255) NOT NULL,       -- �K�X����
    [MI_RegistrationDate] DATETIME NOT NULL DEFAULT GETDATE(), -- ���U�ɶ�
    [MI_IsActive] BIT NOT NULL DEFAULT (1),         -- �O�_�ҥ�
    [MiEmailConfirmationToken] NVARCHAR(255) NULL   -- �q�l�l��T�{�O�P
);

-- �إ� User_PD ��
CREATE TABLE [dbo].[User_PD] (
    [UserPD_ID] INT IDENTITY(1,1) PRIMARY KEY,      -- �ϥΪ̱K�X��� ID (PK)
    [User_ID] INT NOT NULL,                         -- ���p�� User ID
    [UserPD_PasswordHash] VARCHAR(256) NULL,        -- �K�X����
    [UserPD_Token] VARCHAR(MAX) NOT NULL,           -- Token
    [UserPD_CreateDate] DATETIME NOT NULL DEFAULT GETDATE(), -- �Ыخɶ�
    CONSTRAINT FK_UserPD_User FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User]([User_ID])
);

-- �إ� ExternalLogins ��
CREATE TABLE [dbo].[ExternalLogins] (
    [ExternalLoginId] INT IDENTITY(1,1) PRIMARY KEY, -- �~���n�J ID (PK)
    [Provider] NVARCHAR(50) NOT NULL,               -- �~���n�J���Ѫ�
    [ProviderUserId] NVARCHAR(100) NOT NULL,        -- �~���ϥΪ̰ߤ@�ѧO�X
    [MI_MemberID] INT NOT NULL,                     -- ���p�� MemberInformation ID
    [DateCreated] DATETIME NOT NULL DEFAULT GETDATE(), -- �Ыخɶ�
    CONSTRAINT FK_ExternalLogins_MemberInformation FOREIGN KEY ([MI_MemberID]) REFERENCES [dbo].[MemberInformation]([MI_MemberID])
);

-- �[�J�w�]��
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Name DEFAULT ('') FOR [User_Name];
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Email DEFAULT ('') FOR [User_Email];
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Phone DEFAULT ('') FOR [User_Phone];

ALTER TABLE [dbo].[User_PD] ADD CONSTRAINT DF_UserPD_PasswordHash DEFAULT ('') FOR [UserPD_PasswordHash];
ALTER TABLE [dbo].[User_PD] ADD CONSTRAINT DF_UserPD_Token DEFAULT ('') FOR [UserPD_Token];

-- �[�J�ˬd����
ALTER TABLE [dbo].[User] 
    WITH CHECK ADD CHECK ((LEN([User_Phone]) = 10)); -- ������X���ץ����� 10

-- �إ߯���
CREATE UNIQUE NONCLUSTERED INDEX UQ_MemberInformation_Email 
    ON [dbo].[MemberInformation]([MI_Email]) 
    WHERE [MI_Email] IS NOT NULL;

CREATE UNIQUE INDEX IX_ExternalLogins_Provider_ProviderUserId 
    ON [dbo].[ExternalLogins]([Provider], [ProviderUserId]);

CREATE INDEX IDX_UserPD_User ON [dbo].[User_PD]([User_ID]);
CREATE INDEX IDX_ExternalLogins_Member ON [dbo].[ExternalLogins]([MI_MemberID]);

-- ���J�w�]���
INSERT INTO [dbo].[MemberInformation] 
    ([MI_AccountName], [MI_Email], [MI_PasswordHash], [MI_RegistrationDate], [MI_IsActive], [MiEmailConfirmationToken])
VALUES 
    ('Test', 'Test@gmail.com', '047f91c39524762a871344b62bc607418653f78a2e11fabb1dafb79968a99272', '2025-01-11 17:24:24.650', 1, NULL);

-- �[�J���Ƶ�
-- User ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ� ID', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ̩m�W', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Name';
EXEC sp_addextendedproperty 'MS_Description', '�H�c', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Email';
EXEC sp_addextendedproperty 'MS_Description', '���', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Phone';
EXEC sp_addextendedproperty 'MS_Description', '�ҥΪ��A (0 = ���ҥ�, 1 = �ҥ�)', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Enabled';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_CreateDate';

-- MemberInformation ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '�b��W��', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_AccountName';
EXEC sp_addextendedproperty 'MS_Description', '�q�l�l��', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_Email';
EXEC sp_addextendedproperty 'MS_Description', '�K�X����', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', '���U�ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_RegistrationDate';
EXEC sp_addextendedproperty 'MS_Description', '�O�_�ҥ� (0 = ���ҥ�, 1 = �ҥ�)', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_IsActive';
EXEC sp_addextendedproperty 'MS_Description', '�q�l�l��T�{�O�P', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MiEmailConfirmationToken';

-- User_PD ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ̱K�X��� ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_ID';
EXEC sp_addextendedproperty 'MS_Description', '���p�� User ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '�K�X����', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', 'Token', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_Token';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_CreateDate';

-- ExternalLogins ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�~���n�J ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ExternalLoginId';
EXEC sp_addextendedproperty 'MS_Description', '�~���n�J���Ѫ� (�p Google)', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'Provider';
EXEC sp_addextendedproperty 'MS_Description', '�~���ϥΪ̰ߤ@�ѧO�X', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ProviderUserId';
EXEC sp_addextendedproperty 'MS_Description', '���p���|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'DateCreated';
GO