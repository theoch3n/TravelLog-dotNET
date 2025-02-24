USE [TravelLog]
GO

/****** Object:  Table [dbo].[MemberInformation]    Script Date: 2025/1/9 上午 09:23:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MemberInformation](
	[MI_MemberID] [int] IDENTITY(1,1) NOT NULL,
	[MI_AccountName] [nvarchar](50) NOT NULL,
	[MI_Email] [nvarchar](100) NOT NULL,
	[MI_PasswordHash] [nvarchar](255) NOT NULL,
	[MI_RegistrationDate] [datetime] NULL,
	[MI_IsActive] [bit] NULL,
	[MiEmailConfirmationToken] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED
(
	[MI_MemberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
	[MI_Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MemberInformation] ADD  DEFAULT (getdate()) FOR [MI_RegistrationDate]
GO

ALTER TABLE [dbo].[MemberInformation] ADD  DEFAULT ((1)) FOR [MI_IsActive]
GO



-- 插入預設資料
INSERT INTO [dbo].[MemberInformation]
(MI_AccountName, MI_Email, MI_PasswordHash, MI_RegistrationDate, MI_IsActive, MIEmailConfirmationToken)
VALUES
('Test', 'Test@gmail.com', '047f91c39524762a871344b62bc607418653f78a2e11fabb1dafb79968a99272',
 '2025-01-11 17:24:24.650', 1, NULL);
