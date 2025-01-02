USE [TravelLog]
GO

/****** Object:  Table [dbo].[MemberInformation]    Script Date: 2024/12/30 ¤W¤È 09:10:33 ******/
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


