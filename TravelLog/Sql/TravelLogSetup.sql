USE [TravelLog]
GO

-- �p�G��w�s�b�A���R���]���~��̿බ�ǰf�V�R���^
DROP TABLE IF EXISTS [dbo].[Bill_details];
DROP TABLE IF EXISTS [dbo].[Bill];
DROP TABLE IF EXISTS [dbo].[Itinerary_Detail];
DROP TABLE IF EXISTS [dbo].[Itinerary_Group];
DROP TABLE IF EXISTS [dbo].[Itinerary];
DROP TABLE IF EXISTS [dbo].[Map];
DROP TABLE IF EXISTS [dbo].[ExternalLogins];
DROP TABLE IF EXISTS [dbo].[MemberInformation];
DROP TABLE IF EXISTS [dbo].[User_PD];
DROP TABLE IF EXISTS [dbo].[User];
DROP TABLE IF EXISTS [dbo].[Payment];
DROP TABLE IF EXISTS [dbo].[Order];
DROP TABLE IF EXISTS [dbo].[Payment_Method];
DROP TABLE IF EXISTS [dbo].[Payment_Status];
DROP TABLE IF EXISTS [dbo].[Order_Status];
DROP TABLE IF EXISTS [dbo].[Location];
DROP TABLE IF EXISTS [dbo].[Place];
DROP TABLE IF EXISTS [dbo].[Schedule];
DROP TABLE IF EXISTS [dbo].[Tickets];
DROP TABLE IF EXISTS [dbo].[Tour_Bundles];
DROP TABLE IF EXISTS [dbo].[SerialBase];

-- �إ߰�¦��]�L�~��̿�^
CREATE TABLE [dbo].[User] (
    [User_ID] INT IDENTITY(1,1) PRIMARY KEY,        -- �ϥΪ� ID (PK)
    [User_Name] NVARCHAR(50) NOT NULL,              -- �ϥΪ̩m�W
    [User_Email] VARCHAR(100) NOT NULL,             -- �H�c
    [User_Phone] VARCHAR(10) NOT NULL,              -- ���
    [User_Enabled] BIT NOT NULL DEFAULT (0),        -- �ҥΪ��A
    [User_CreateDate] DATETIME NOT NULL DEFAULT GETDATE() -- �Ыخɶ�
);

CREATE TABLE [dbo].[MemberInformation] (
    [MI_MemberID] INT IDENTITY(1,1) PRIMARY KEY,    -- �|�� ID (PK)
    [MI_AccountName] NVARCHAR(50) NOT NULL,         -- �b��W��
    [MI_Email] NVARCHAR(100) NOT NULL,              -- �q�l�l��
    [MI_PasswordHash] NVARCHAR(255) NOT NULL,       -- �K�X����
    [MI_RegistrationDate] DATETIME NOT NULL DEFAULT GETDATE(), -- ���U�ɶ�
    [MI_IsActive] BIT NOT NULL DEFAULT (1),         -- �O�_�ҥ�
    [MiEmailConfirmationToken] NVARCHAR(255) NULL   -- �q�l�l��T�{�O�P
);

CREATE TABLE [dbo].[Map] (
    [Map_ID] INT IDENTITY(1,1) PRIMARY KEY,         -- �a�I ID (PK)
    [Map_PlaceName] NVARCHAR(50) NOT NULL,          -- �a�I�W��
    [Map_Address] NVARCHAR(200) NOT NULL,           -- �a�}
    [Map_Longitude] FLOAT NOT NULL,                 -- �g��
    [Map_Latitude] FLOAT NOT NULL,                  -- �n��
    [Map_CreateDate] DATETIME NOT NULL DEFAULT GETDATE()  -- �Ыخɶ�
);

CREATE TABLE [dbo].[Order_Status] (
    [OS_Id] INT IDENTITY(1,1) PRIMARY KEY,          -- �q�檬�A ID (PK)
    [OS_OrderStatus] NVARCHAR(20) NOT NULL          -- �q�檬�A�W��
);

CREATE TABLE [dbo].[Payment_Status] (
    [PS_Id] INT IDENTITY(1,1) PRIMARY KEY,          -- �I�ڪ��A ID (PK)
    [payment_Status] NVARCHAR(20) NOT NULL          -- �I�ڪ��A�W��
);

CREATE TABLE [dbo].[Payment_Method] (
    [PM_Id] INT IDENTITY(1,1) PRIMARY KEY,          -- �I�ڤ覡 ID (PK)
    [payment_Method] NVARCHAR(20) NOT NULL,         -- �I�ڤ覡�W��
    [payment_MethodCode] NVARCHAR(50) NOT NULL UNIQUE -- ��ɥI�ڤ覡�N�X (�ߤ@)
);

CREATE TABLE [dbo].[Schedule] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,             -- Schedule ID (PK)
    [user_id] INT NOT NULL,                         -- �|�� ID
    [name] NVARCHAR(100) NOT NULL,                  -- ��{�W��
    [destination] NVARCHAR(100) NOT NULL,           -- �ت��a
    [start_date] DATE NOT NULL,                     -- �}�l���
    [end_date] DATE NOT NULL                        -- �������
);

CREATE TABLE [dbo].[Tickets] (
    [TicketsId] INT IDENTITY(1,1) PRIMARY KEY,      -- ���� ID (PK)
    [TicketsName] NVARCHAR(100) NOT NULL,           -- ���ȦW��
    [TicketsType] NVARCHAR(20) NOT NULL,            -- ���Ⱥ���
    [Price] INT NOT NULL,                           -- ���Ȼ���
    [IsAvailable] BIT NOT NULL DEFAULT (1),         -- ���Ȫ��A
    [Description] NVARCHAR(255) NULL,               -- ���ȴy�z
    [RefundPolicy] NVARCHAR(255) NOT NULL,          -- ���Ȱh�ڬF��
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE() -- ���ȳЫؤ��
);

CREATE TABLE [dbo].[Tour_Bundles] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,             -- �D��
    [eventName] NVARCHAR(40) NOT NULL,              -- �W��
    [startingPoint] NVARCHAR(40) NOT NULL,          -- �_�l�a
    [destination] NVARCHAR(40) NOT NULL,            -- �ت��a
    [firstDate] DATETIME NOT NULL,                  -- �}�l��
    [lastDate] DATETIME NOT NULL,                   -- ������
    [duration] INT NOT NULL,                        -- �Ѽ�
    [price] INT NOT NULL,                           -- ����
    [eventDescription] NVARCHAR(500) NOT NULL,      -- �y�z
    [ratings] INT NULL,                             -- ����
    [contactInfo] NVARCHAR(20) NOT NULL             -- �p���覡
);

CREATE TABLE [dbo].[SerialBase] (
    [SB_Serial] INT IDENTITY(1,1) NOT NULL,         -- �y����
    [SB_SystemCode] VARCHAR(10) NOT NULL PRIMARY KEY, -- �t�ΥN�X (PK)
    [SB_SystemName] NVARCHAR(50) NOT NULL,          -- �N�X�W��
    [SB_SerialNumber] VARCHAR(50) NOT NULL,         -- �t�νs��
    [SB_Count] INT NOT NULL,                        -- �����`��
    [ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE() -- �ק���
);

-- �إߦ��~��̿઺��
CREATE TABLE [dbo].[User_PD] (
    [UserPD_ID] INT IDENTITY(1,1) PRIMARY KEY,      -- �ϥΪ̱K�X��� ID (PK)
    [User_ID] INT NOT NULL,                         -- ���p�� User ID
    [UserPD_PasswordHash] VARCHAR(256) NULL,        -- �K�X����
    [UserPD_Token] VARCHAR(MAX) NOT NULL,           -- Token
    [UserPD_CreateDate] DATETIME NOT NULL DEFAULT GETDATE(), -- �Ыخɶ�
    CONSTRAINT FK_UserPD_User FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User]([User_ID])
);

CREATE TABLE [dbo].[ExternalLogins] (
    [ExternalLoginId] INT IDENTITY(1,1) PRIMARY KEY, -- �~���n�J ID (PK)
    [Provider] NVARCHAR(50) NOT NULL,               -- �~���n�J���Ѫ�
    [ProviderUserId] NVARCHAR(100) NOT NULL,        -- �~���ϥΪ̰ߤ@�ѧO�X
    [MI_MemberID] INT NOT NULL,                     -- ���p�� MemberInformation ID
    [DateCreated] DATETIME NOT NULL DEFAULT GETDATE(), -- �Ыخɶ�
    CONSTRAINT FK_ExternalLogins_MemberInformation FOREIGN KEY ([MI_MemberID]) REFERENCES [dbo].[MemberInformation]([MI_MemberID])
);

CREATE TABLE [dbo].[Itinerary] (
    [Itinerary_ID] INT IDENTITY(1,1) PRIMARY KEY,   -- ��{ ID (PK)
    [Itinerary_Title] NVARCHAR(50) NOT NULL,        -- ��{�W��
    [Itinerary_Location] NVARCHAR(50) NOT NULL,     -- ��{�a�I
    [Itinerary_Coordinate] VARCHAR(200) NOT NULL,   -- ��{�y��
    [Itinerary_Image] VARCHAR(MAX) NOT NULL,        -- ��{�Ϥ�
    [Itinerary_StartDate] DATETIME NOT NULL DEFAULT GETDATE(), -- ��{�_�l�ɶ�
    [Itinerary_EndDate] DATETIME NOT NULL,          -- ��{�����ɶ�
    [Itinerary_CreateUser] INT NOT NULL,            -- �ЫبϥΪ�
    [Itinerary_CreateDate] DATETIME NOT NULL DEFAULT GETDATE() -- �Ыخɶ�
);

CREATE TABLE [dbo].[Itinerary_Group] (
    [ItineraryGroup_ID] INT IDENTITY(1,1) PRIMARY KEY,  -- �s�� ID (PK)
    [ItineraryGroup_ItineraryID] INT NOT NULL,          -- ���p����{ ID
    [ItineraryGroup_UserEmail] VARCHAR(100) NOT NULL,   -- �ϥΪ̫H�c
    CONSTRAINT FK_ItineraryGroup_Itinerary FOREIGN KEY ([ItineraryGroup_ItineraryID]) REFERENCES [dbo].[Itinerary]([Itinerary_ID])
);

CREATE TABLE [dbo].[Itinerary_Detail] (
    [ItineraryDetail_ID] INT NOT NULL PRIMARY KEY,      -- ��{���� ID (PK)
    [Itinerary_ID] INT NOT NULL,                        -- ���p����{ ID
    [ItineraryDetail_Day] INT NOT NULL,                 -- �ĴX��
    [ItineraryDetail_Accommodation] INT NOT NULL,       -- ��J (���p ProductType_ID)
    [ItineraryDetail_ProductTypeID] INT NOT NULL,       -- �ӫ~���O (���p ProductType_ID)
    [ItineraryDetail_MapID] INT NOT NULL,               -- �a�I (���p Map_ID)
    [ItineraryDetail_Group] INT NOT NULL,               -- �s��
    [ItineraryDetail_StartDate] DATETIME NOT NULL DEFAULT GETDATE(), -- ��{�_�l�ɶ�
    [ItineraryDetail_EndDate] DATETIME NOT NULL DEFAULT GETDATE(),   -- ��{�����ɶ�
    [ItineraryDetail_Memo] NVARCHAR(500) NOT NULL,      -- ��{�Ƶ�
    [ItineraryDetail_CreateDate] DATETIME NOT NULL DEFAULT GETDATE(), -- �Ыخɶ�
    CONSTRAINT FK_ItineraryDetail_Itinerary FOREIGN KEY ([Itinerary_ID]) REFERENCES [dbo].[Itinerary]([Itinerary_ID]),
    CONSTRAINT FK_ItineraryDetail_Map FOREIGN KEY ([ItineraryDetail_MapID]) REFERENCES [dbo].[Map]([Map_ID])
);

CREATE TABLE [dbo].[Bill] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill ID (PK)
    [Itinerary_Id] INT NOT NULL,                      -- ��{ ID
    [Title] NVARCHAR(50) NOT NULL,                    -- �b����D
    [Total_Amount] DECIMAL(18,2) NOT NULL,            -- �`���B
    [PaidBy] NVARCHAR(50) NOT NULL,                   -- �I�ڤH
    [Created_At] DATETIME NOT NULL DEFAULT GETDATE(), -- �إ߮ɶ�
    CONSTRAINT FK_Bill_Itinerary FOREIGN KEY ([Itinerary_Id]) REFERENCES [dbo].[Itinerary]([Itinerary_ID])
);

CREATE TABLE [dbo].[Bill_details] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill_details ID (PK)
    [Bill_Id] INT NOT NULL,                           -- ���p�� Bill ID
    [Member_Name] NVARCHAR(20) NOT NULL,              -- �����W��
    [Amount] DECIMAL(18,2) NOT NULL,                  -- ������B
    [Paid] BIT NOT NULL DEFAULT (0),                  -- �O�_�w�I��
    CONSTRAINT FK_BillDetails_Bill FOREIGN KEY ([Bill_Id]) REFERENCES [dbo].[Bill]([Id])
);

CREATE TABLE [dbo].[Order] (
    [order_Id] INT IDENTITY(1,1) PRIMARY KEY,       -- �q�� ID (PK)
    [merchant_TradeNo] VARCHAR(50) UNIQUE NOT NULL, -- ��ɭq�����s�� (�����ߤ@)
    [order_Time] DATETIME NOT NULL DEFAULT GETDATE(), -- �q��إ߮ɶ�
    [order_TotalAmount] DECIMAL(10,2) NOT NULL,     -- �q���`���B
    [delete_at] DATETIME NULL,                      -- �R���ɶ� (�i�� NULL)
    [user_Id] INT NOT NULL,                         -- �ϥΪ� ID
    [order_Status] INT NOT NULL,                    -- �q�檬�A
    [order_PaymentStatus] INT NOT NULL,             -- �q��I�ڪ��A
    CONSTRAINT FK_Order_User FOREIGN KEY ([user_Id]) REFERENCES [dbo].[User]([User_ID]),
    CONSTRAINT FK_Order_OrderStatus FOREIGN KEY ([order_Status]) REFERENCES [dbo].[Order_Status]([OS_Id]),
    CONSTRAINT FK_Order_PaymentStatus FOREIGN KEY ([order_PaymentStatus]) REFERENCES [dbo].[Payment_Status]([PS_Id])
);

CREATE TABLE [dbo].[Payment] (
    [payment_Id] INT IDENTITY(1,1) PRIMARY KEY,     -- �I�� ID (PK)
    [payment_Time] DATETIME NULL,                   -- �I�ڦ��\�ɶ� (���\�I�ڤ~����)
    [payment_Method] INT NOT NULL,                  -- �I�ڤ覡
    [payment_MethodName] INT NULL,                  -- ��ɦ^�ǥI�ڤ覡
    [order_Id] INT NOT NULL,                        -- ���p���q�� ID
    [paymentStatus_Id] INT NOT NULL,                -- �I�ڪ��A
    [ECPay_TransactionId] NVARCHAR(50) NULL,        -- ��ɥ���s��
    CONSTRAINT FK_Payment_Method FOREIGN KEY ([payment_Method]) REFERENCES [dbo].[Payment_Method]([PM_Id]),
    CONSTRAINT FK_Payment_Order FOREIGN KEY ([order_Id]) REFERENCES [dbo].[Order]([order_Id]),
    CONSTRAINT FK_Payment_Status FOREIGN KEY ([paymentStatus_Id]) REFERENCES [dbo].[Payment_Status]([PS_Id])
);

CREATE TABLE [dbo].[Location] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,             -- �a�I ID (PK)
    [user_id] INT NOT NULL,                         -- �|�� ID
    [schedule_id] INT NOT NULL,                     -- ���p����{ ID
    [attraction] NVARCHAR(100) NOT NULL,            -- ���I
    [date] DATE NOT NULL,                           -- ���
    CONSTRAINT FK_Location_Schedule FOREIGN KEY ([schedule_id]) REFERENCES [dbo].[Schedule]([id]),
    CONSTRAINT FK_Location_User FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([User_ID])
);

CREATE TABLE [dbo].[Place] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,             -- �a�I ID (PK)
    [date] DATETIME2(7) NOT NULL,                   -- ����ɶ�
    [scheduleId] INT NOT NULL,                      -- ���p����{ ID
    [Name] NVARCHAR(255) NOT NULL,                  -- �W��
    [Address] NVARCHAR(255) NOT NULL,               -- �a�}
    [Latitude] FLOAT NOT NULL,                      -- �n��
    [Longitude] FLOAT NOT NULL,                     -- �g��
    [img] NVARCHAR(MAX) NOT NULL,                   -- �Ϥ�
    [rating] NVARCHAR(10) NOT NULL,                 -- ����
    CONSTRAINT FK_Place_Schedule FOREIGN KEY ([scheduleId]) REFERENCES [dbo].[Schedule]([id])
);

-- �[�J�w�]��
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Name DEFAULT ('') FOR [User_Name];
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Email DEFAULT ('') FOR [User_Email];
ALTER TABLE [dbo].[User] ADD CONSTRAINT DF_User_Phone DEFAULT ('') FOR [User_Phone];

ALTER TABLE [dbo].[User_PD] ADD CONSTRAINT DF_UserPD_PasswordHash DEFAULT ('') FOR [UserPD_PasswordHash];
ALTER TABLE [dbo].[User_PD] ADD CONSTRAINT DF_UserPD_Token DEFAULT ('') FOR [UserPD_Token];

ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_PlaceName DEFAULT ('') FOR [Map_PlaceName];
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_Address DEFAULT ('') FOR [Map_Address];
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_Longitude DEFAULT (0) FOR [Map_Longitude];
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_Latitude DEFAULT (0) FOR [Map_Latitude];

ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Title DEFAULT ('') FOR [Itinerary_Title];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Location DEFAULT ('') FOR [Itinerary_Location];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Coordinate DEFAULT ('') FOR [Itinerary_Coordinate];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Image DEFAULT ('') FOR [Itinerary_Image];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_CreateUser DEFAULT (0) FOR [Itinerary_CreateUser];

ALTER TABLE [dbo].[Itinerary_Group] ADD CONSTRAINT DF_ItineraryGroup_ItineraryID DEFAULT (0) FOR [ItineraryGroup_ItineraryID];
ALTER TABLE [dbo].[Itinerary_Group] ADD CONSTRAINT DF_ItineraryGroup_UserEmail DEFAULT ('') FOR [ItineraryGroup_UserEmail];

ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Day DEFAULT (0) FOR [ItineraryDetail_Day];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Accommodation DEFAULT (0) FOR [ItineraryDetail_Accommodation];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_ProductTypeID DEFAULT (0) FOR [ItineraryDetail_ProductTypeID];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_MapID DEFAULT (0) FOR [ItineraryDetail_MapID];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Group DEFAULT (0) FOR [ItineraryDetail_Group];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Memo DEFAULT ('') FOR [ItineraryDetail_Memo];

ALTER TABLE [dbo].[SerialBase] ADD CONSTRAINT DF_SerialBase_SystemCode DEFAULT ('') FOR [SB_SystemCode];
ALTER TABLE [dbo].[SerialBase] ADD CONSTRAINT DF_SerialBase_SystemName DEFAULT ('') FOR [SB_SystemName];
ALTER TABLE [dbo].[SerialBase] ADD CONSTRAINT DF_SerialBase_SerialNumber DEFAULT ('') FOR [SB_SerialNumber];
ALTER TABLE [dbo].[SerialBase] ADD CONSTRAINT DF_SerialBase_Count DEFAULT (0) FOR [SB_Count];

-- �[�J�ˬd����
ALTER TABLE [dbo].[User] 
    WITH CHECK ADD CHECK ((LEN([User_Phone]) = 10));

ALTER TABLE [dbo].[Bill] 
    WITH CHECK ADD CHECK (([Total_Amount] >= 0));

ALTER TABLE [dbo].[Bill_details] 
    WITH CHECK ADD CHECK (([Amount] >= 0));

ALTER TABLE [dbo].[Itinerary] 
    WITH CHECK ADD CHECK (([Itinerary_StartDate] <= [Itinerary_EndDate]));

ALTER TABLE [dbo].[Itinerary_Detail] 
    WITH CHECK ADD CHECK (([ItineraryDetail_Day] >= 0));
ALTER TABLE [dbo].[Itinerary_Detail] 
    WITH CHECK ADD CHECK (([ItineraryDetail_StartDate] <= [ItineraryDetail_EndDate]));

ALTER TABLE [dbo].[Order] 
    WITH CHECK ADD CHECK (([order_TotalAmount] >= 0));

ALTER TABLE [dbo].[Schedule] 
    WITH CHECK ADD CHECK (([start_date] <= [end_date]));

ALTER TABLE [dbo].[Tickets] 
    WITH CHECK ADD CHECK (([Price] >= 0));

ALTER TABLE [dbo].[Tour_Bundles] 
    WITH CHECK ADD CHECK (([firstDate] <= [lastDate]));
ALTER TABLE [dbo].[Tour_Bundles] 
    WITH CHECK ADD CHECK (([duration] > 0));
ALTER TABLE [dbo].[Tour_Bundles] 
    WITH CHECK ADD CHECK (([price] >= 0));

ALTER TABLE [dbo].[SerialBase] 
    WITH CHECK ADD CHECK (([SB_Count] >= 0));

-- �إ߯���
CREATE INDEX IDX_Bill_Itinerary ON [dbo].[Bill]([Itinerary_Id]);
CREATE INDEX IDX_BillDetails_Bill ON [dbo].[Bill_details]([Bill_Id]);
CREATE INDEX IDX_Itinerary_CreateUser ON [dbo].[Itinerary]([Itinerary_CreateUser]);
CREATE INDEX IDX_ItineraryGroup_Itinerary ON [dbo].[Itinerary_Group]([ItineraryGroup_ItineraryID]);
CREATE INDEX IDX_ItineraryDetail_Itinerary ON [dbo].[Itinerary_Detail]([Itinerary_ID]);
CREATE INDEX IDX_ItineraryDetail_Map ON [dbo].[Itinerary_Detail]([ItineraryDetail_MapID]);
CREATE UNIQUE NONCLUSTERED INDEX UQ_MemberInformation_Email ON [dbo].[MemberInformation]([MI_Email]) WHERE [MI_Email] IS NOT NULL;
CREATE UNIQUE INDEX IX_ExternalLogins_Provider_ProviderUserId ON [dbo].[ExternalLogins]([Provider], [ProviderUserId]);
CREATE INDEX IDX_UserPD_User ON [dbo].[User_PD]([User_ID]);
CREATE INDEX IDX_ExternalLogins_Member ON [dbo].[ExternalLogins]([MI_MemberID]);
CREATE INDEX IDX_Order_Status ON [dbo].[Order]([order_Status]);
CREATE INDEX IDX_Order_PaymentStatus ON [dbo].[Order]([order_PaymentStatus]);
CREATE INDEX IDX_Payment_Method ON [dbo].[Payment]([payment_Method]);
CREATE INDEX IDX_Payment_Order ON [dbo].[Payment]([order_Id]);
CREATE INDEX IDX_Payment_Status ON [dbo].[Payment]([paymentStatus_Id]);
CREATE UNIQUE INDEX UQ_Payment_ECPay ON [dbo].[Payment]([ECPay_TransactionId]) WHERE [ECPay_TransactionId] IS NOT NULL;
CREATE INDEX IDX_Schedule_User ON [dbo].[Schedule]([user_id]);
CREATE INDEX IDX_Location_Schedule ON [dbo].[Location]([schedule_id]);
CREATE INDEX IDX_Location_User ON [dbo].[Location]([user_id]);
CREATE INDEX IDX_Place_Schedule ON [dbo].[Place]([scheduleId]);
CREATE INDEX IDX_Tickets_Type ON [dbo].[Tickets]([TicketsType]);

-- �[�J���Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�b�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '��{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Itinerary_Id';
EXEC sp_addextendedproperty 'MS_Description', '�b����D', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Title';
EXEC sp_addextendedproperty 'MS_Description', '�`���B', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Total_Amount';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڤH', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'PaidBy';
EXEC sp_addextendedproperty 'MS_Description', '�b��إ߮ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Created_At';

EXEC sp_addextendedproperty 'MS_Description', '�b����� ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '���p���b�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Bill_Id';
EXEC sp_addextendedproperty 'MS_Description', '�����W��', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Member_Name';
EXEC sp_addextendedproperty 'MS_Description', '������B', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Amount';
EXEC sp_addextendedproperty 'MS_Description', '�O�_�w�I�ڡ]0 = ���I�ڡA1 = �w�I�ڡ^', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Paid';

EXEC sp_addextendedproperty 'MS_Description', '�a�I ID', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_ID';
EXEC sp_addextendedproperty 'MS_Description', '�a�I�W��', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_PlaceName';
EXEC sp_addextendedproperty 'MS_Description', '�a�}', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Address';
EXEC sp_addextendedproperty 'MS_Description', '�g��', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Longitude';
EXEC sp_addextendedproperty 'MS_Description', '�n��', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Latitude';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '��{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_ID';
EXEC sp_addextendedproperty 'MS_Description', '��{�W��', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Title';
EXEC sp_addextendedproperty 'MS_Description', '��{�a�I', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Location';
EXEC sp_addextendedproperty 'MS_Description', '��{�y��', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Coordinate';
EXEC sp_addextendedproperty 'MS_Description', '��{�Ϥ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Image';
EXEC sp_addextendedproperty 'MS_Description', '��{�_�l�ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_StartDate';
EXEC sp_addextendedproperty 'MS_Description', '��{�����ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_EndDate';
EXEC sp_addextendedproperty 'MS_Description', '�ЫبϥΪ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateUser';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '�s�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ID';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ItineraryID';
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ̫H�c', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_UserEmail';

EXEC sp_addextendedproperty 'MS_Description', '��{���� ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_ID';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'Itinerary_ID';
EXEC sp_addextendedproperty 'MS_Description', '�ĴX��', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Day';
EXEC sp_addextendedproperty 'MS_Description', '��J (���p ProductType_ID)', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Accommodation';
EXEC sp_addextendedproperty 'MS_Description', '�ӫ~���O (���p ProductType_ID)', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_ProductTypeID';
EXEC sp_addextendedproperty 'MS_Description', '�a�I (���p Map_ID)', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_MapID';
EXEC sp_addextendedproperty 'MS_Description', '�s��', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Group';
EXEC sp_addextendedproperty 'MS_Description', '��{�_�l�ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_StartDate';
EXEC sp_addextendedproperty 'MS_Description', '��{�����ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_EndDate';
EXEC sp_addextendedproperty 'MS_Description', '��{�Ƶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Memo';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ� ID', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ̩m�W', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Name';
EXEC sp_addextendedproperty 'MS_Description', '�H�c', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Email';
EXEC sp_addextendedproperty 'MS_Description', '���', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Phone';
EXEC sp_addextendedproperty 'MS_Description', '�ҥΪ��A (0 = ���ҥ�, 1 = �ҥ�)', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Enabled';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '�|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '�b��W��', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_AccountName';
EXEC sp_addextendedproperty 'MS_Description', '�q�l�l��', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_Email';
EXEC sp_addextendedproperty 'MS_Description', '�K�X����', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', '���U�ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_RegistrationDate';
EXEC sp_addextendedproperty 'MS_Description', '�O�_�ҥ� (0 = ���ҥ�, 1 = �ҥ�)', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_IsActive';
EXEC sp_addextendedproperty 'MS_Description', '�q�l�l��T�{�O�P', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MiEmailConfirmationToken';

EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ̱K�X��� ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_ID';
EXEC sp_addextendedproperty 'MS_Description', '���p�� User ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '�K�X����', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', 'Token', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_Token';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '�~���n�J ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ExternalLoginId';
EXEC sp_addextendedproperty 'MS_Description', '�~���n�J���Ѫ� (�p Google)', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'Provider';
EXEC sp_addextendedproperty 'MS_Description', '�~���ϥΪ̰ߤ@�ѧO�X', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ProviderUserId';
EXEC sp_addextendedproperty 'MS_Description', '���p���|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'DateCreated';

EXEC sp_addextendedproperty 'MS_Description', '�q�檬�A ID', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_Id';
EXEC sp_addextendedproperty 'MS_Description', '�q�檬�A�W�١]�ҡG�ݥI�ڡB�w�I�ڡB�w�����^', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_OrderStatus';

EXEC sp_addextendedproperty 'MS_Description', '�q�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '��ɭq�����s��', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'merchant_TradeNo';
EXEC sp_addextendedproperty 'MS_Description', '�q��إ߮ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Time';
EXEC sp_addextendedproperty 'MS_Description', '�q���`���B', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_TotalAmount';
EXEC sp_addextendedproperty 'MS_Description', '�R���ɶ��]�i�� NULL�^', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'delete_at';
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ� ID', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'user_Id';
EXEC sp_addextendedproperty 'MS_Description', '�q���e���A', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Status';
EXEC sp_addextendedproperty 'MS_Description', '�q��I�ڪ��A', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_PaymentStatus';

EXEC sp_addextendedproperty 'MS_Description', '�I�ڪ��A ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'PS_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڪ��A�W�١]�ҡGPending�BPaid�BRefunded�^', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'payment_Status';

EXEC sp_addextendedproperty 'MS_Description', '�I�ڤ覡 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'PM_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڤ覡�W�١]�ҡG�H�Υd�BATM ��b�^', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '��ɥI�ڤ覡�N�X�]�ҡGCredit�BATM�BCVS�^', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_MethodCode';

EXEC sp_addextendedproperty 'MS_Description', '�I�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڦ��\�ɶ��]���\�I�ڤ~���ȡ^', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Time';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڤ覡', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '��ɦ^�ǥI�ڤ覡', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_MethodName';
EXEC sp_addextendedproperty 'MS_Description', '���p���q��', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڪ��A', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'paymentStatus_Id';
EXEC sp_addextendedproperty 'MS_Description', '��ɥ���s��', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'ECPay_TransactionId';

EXEC sp_addextendedproperty 'MS_Description', '��{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '�|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '��{�W��', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'name';
EXEC sp_addextendedproperty 'MS_Description', '�ت��a', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'destination';
EXEC sp_addextendedproperty 'MS_Description', '�}�l���', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'start_date';
EXEC sp_addextendedproperty 'MS_Description', '�������', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'end_date';

EXEC sp_addextendedproperty 'MS_Description', '�a�I ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '�|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'schedule_id';
EXEC sp_addextendedproperty 'MS_Description', '���I', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'attraction';
EXEC sp_addextendedproperty 'MS_Description', '���', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'date';

EXEC sp_addextendedproperty 'MS_Description', '�a�I ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '����ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'date';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'scheduleId';
EXEC sp_addextendedproperty 'MS_Description', '�W��', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', '�a�}', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Address';
EXEC sp_addextendedproperty 'MS_Description', '�n��', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Latitude';
EXEC sp_addextendedproperty 'MS_Description', '�g��', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Longitude';
EXEC sp_addextendedproperty 'MS_Description', '�Ϥ�', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'img';
EXEC sp_addextendedproperty 'MS_Description', '����', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'rating';

EXEC sp_addextendedproperty 'MS_Description', '���� ID', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'TicketsId';
EXEC sp_addextendedproperty 'MS_Description', '���ȦW��', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'TicketsName';
EXEC sp_addextendedproperty 'MS_Description', '���Ⱥ���', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'TicketsType';
EXEC sp_addextendedproperty 'MS_Description', '���Ȼ���', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'Price';
EXEC sp_addextendedproperty 'MS_Description', '���Ȫ��A (0 = ���i��, 1 = �i��)', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'IsAvailable';
EXEC sp_addextendedproperty 'MS_Description', '���ȴy�z', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'Description';
EXEC sp_addextendedproperty 'MS_Description', '���Ȱh�ڬF��', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'RefundPolicy';
EXEC sp_addextendedproperty 'MS_Description', '���ȳЫؤ��', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'CreatedAt';

EXEC sp_addextendedproperty 'MS_Description', '�M�˦�{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '���ʦW��', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'eventName';
EXEC sp_addextendedproperty 'MS_Description', '�_�l�a', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'startingPoint';
EXEC sp_addextendedproperty 'MS_Description', '�ت��a', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'destination';
EXEC sp_addextendedproperty 'MS_Description', '�}�l���', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'firstDate';
EXEC sp_addextendedproperty 'MS_Description', '�������', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'lastDate';
EXEC sp_addextendedproperty 'MS_Description', '�Ѽ�', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'duration';
EXEC sp_addextendedproperty 'MS_Description', '����', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'price';
EXEC sp_addextendedproperty 'MS_Description', '�y�z', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'eventDescription';
EXEC sp_addextendedproperty 'MS_Description', '����', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'ratings';
EXEC sp_addextendedproperty 'MS_Description', '�p���覡', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'contactInfo';

EXEC sp_addextendedproperty 'MS_Description', '�y����', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_Serial';
EXEC sp_addextendedproperty 'MS_Description', '�t�ΥN�X', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_SystemCode';
EXEC sp_addextendedproperty 'MS_Description', '�N�X�W��', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_SystemName';
EXEC sp_addextendedproperty 'MS_Description', '�t�νs��', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_SerialNumber';
EXEC sp_addextendedproperty 'MS_Description', '�����`��', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_Count';
EXEC sp_addextendedproperty 'MS_Description', '�ק���', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'ModifiedDate';
GO