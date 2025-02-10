USE [TravelLog]
GO

-- �إߥ~���n�J�M�g��ƪ�
CREATE TABLE [dbo].[ExternalLogins](
    [ExternalLoginId] [int] IDENTITY(1,1) NOT NULL,
    [Provider] [nvarchar](50) NOT NULL,            -- �~���n�J���Ѫ̡A�Ҧp 'Google'
    [ProviderUserId] [nvarchar](100) NOT NULL,       -- �~���ϥΪ̰ߤ@�ѧO�X�A�� Google �^��
    [MI_MemberID] [int] NOT NULL,                    -- �P MemberInformation �������~��
    [DateCreated] [datetime] NOT NULL CONSTRAINT DF_ExternalLogins_DateCreated DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
    [ExternalLoginId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- �إߥ~������A�s���� MemberInformation ��ƪ�
ALTER TABLE [dbo].[ExternalLogins] WITH CHECK ADD CONSTRAINT [FK_ExternalLogins_MemberInformation] FOREIGN KEY([MI_MemberID])
REFERENCES [dbo].[MemberInformation] ([MI_MemberID])
GO

ALTER TABLE [dbo].[ExternalLogins] CHECK CONSTRAINT [FK_ExternalLogins_MemberInformation]
GO

-- �إ߰ߤ@���ޡA�קK�P�@�� Provider �� ProviderUserId ���ƹ������P���|��
CREATE UNIQUE INDEX [IX_ExternalLogins_Provider_ProviderUserId] ON [dbo].[ExternalLogins]
(
	[Provider] ASC,
	[ProviderUserId] ASC
) ON [PRIMARY]
GO