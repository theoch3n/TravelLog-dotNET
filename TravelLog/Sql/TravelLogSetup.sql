USE [TravelLog]
GO

-- 如果表已存在，先刪除（按外鍵依賴順序逆向刪除）
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

-- 建立基礎表（無外鍵依賴）
CREATE TABLE [dbo].[User] (
    [User_ID] INT IDENTITY(1,1) PRIMARY KEY,        -- 使用者 ID (PK)
    [User_Name] NVARCHAR(50) NOT NULL,              -- 使用者姓名
    [User_Email] VARCHAR(100) NOT NULL,             -- 信箱
    [User_Phone] VARCHAR(10) NOT NULL,              -- 手機
    [User_Enabled] BIT NOT NULL DEFAULT (0),        -- 啟用狀態
    [User_CreateDate] DATETIME NOT NULL DEFAULT GETDATE() -- 創建時間
);

CREATE TABLE [dbo].[MemberInformation] (
    [MI_MemberID] INT IDENTITY(1,1) PRIMARY KEY,    -- 會員 ID (PK)
    [MI_AccountName] NVARCHAR(50) NOT NULL,         -- 帳戶名稱
    [MI_Email] NVARCHAR(100) NOT NULL,              -- 電子郵件
    [MI_PasswordHash] NVARCHAR(255) NOT NULL,       -- 密碼雜湊
    [MI_RegistrationDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 註冊時間
    [MI_IsActive] BIT NOT NULL DEFAULT (1),         -- 是否啟用
    [MiEmailConfirmationToken] NVARCHAR(255) NULL   -- 電子郵件確認令牌
);

CREATE TABLE [dbo].[Map] (
    [Map_ID] INT IDENTITY(1,1) PRIMARY KEY,         -- 地點 ID (PK)
    [Map_PlaceName] NVARCHAR(50) NOT NULL,          -- 地點名稱
    [Map_Address] NVARCHAR(200) NOT NULL,           -- 地址
    [Map_Longitude] FLOAT NOT NULL,                 -- 經度
    [Map_Latitude] FLOAT NOT NULL,                  -- 緯度
    [Map_CreateDate] DATETIME NOT NULL DEFAULT GETDATE()  -- 創建時間
);

CREATE TABLE [dbo].[Order_Status] (
    [OS_Id] INT IDENTITY(1,1) PRIMARY KEY,          -- 訂單狀態 ID (PK)
    [OS_OrderStatus] NVARCHAR(20) NOT NULL          -- 訂單狀態名稱
);

CREATE TABLE [dbo].[Payment_Status] (
    [PS_Id] INT IDENTITY(1,1) PRIMARY KEY,          -- 付款狀態 ID (PK)
    [payment_Status] NVARCHAR(20) NOT NULL          -- 付款狀態名稱
);

CREATE TABLE [dbo].[Payment_Method] (
    [PM_Id] INT IDENTITY(1,1) PRIMARY KEY,          -- 付款方式 ID (PK)
    [payment_Method] NVARCHAR(20) NOT NULL,         -- 付款方式名稱
    [payment_MethodCode] NVARCHAR(50) NOT NULL UNIQUE -- 綠界付款方式代碼 (唯一)
);

CREATE TABLE [dbo].[Schedule] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,             -- Schedule ID (PK)
    [user_id] INT NOT NULL,                         -- 會員 ID
    [name] NVARCHAR(100) NOT NULL,                  -- 行程名稱
    [destination] NVARCHAR(100) NOT NULL,           -- 目的地
    [start_date] DATE NOT NULL,                     -- 開始日期
    [end_date] DATE NOT NULL                        -- 結束日期
);

CREATE TABLE [dbo].[Tickets] (
    [TicketsId] INT IDENTITY(1,1) PRIMARY KEY,      -- 票務 ID (PK)
    [TicketsName] NVARCHAR(100) NOT NULL,           -- 票務名稱
    [TicketsType] NVARCHAR(20) NOT NULL,            -- 票務種類
    [Price] INT NOT NULL,                           -- 票務價格
    [IsAvailable] BIT NOT NULL DEFAULT (1),         -- 票務狀態
    [Description] NVARCHAR(255) NULL,               -- 票務描述
    [RefundPolicy] NVARCHAR(255) NOT NULL,          -- 票務退款政策
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE() -- 票務創建日期
);

CREATE TABLE [dbo].[Tour_Bundles] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,             -- 主鍵
    [eventName] NVARCHAR(40) NOT NULL,              -- 名稱
    [startingPoint] NVARCHAR(40) NOT NULL,          -- 起始地
    [destination] NVARCHAR(40) NOT NULL,            -- 目的地
    [firstDate] DATETIME NOT NULL,                  -- 開始日
    [lastDate] DATETIME NOT NULL,                   -- 結束日
    [duration] INT NOT NULL,                        -- 天數
    [price] INT NOT NULL,                           -- 價格
    [eventDescription] NVARCHAR(500) NOT NULL,      -- 描述
    [ratings] INT NULL,                             -- 評分
    [contactInfo] NVARCHAR(20) NOT NULL             -- 聯絡方式
);

CREATE TABLE [dbo].[SerialBase] (
    [SB_Serial] INT IDENTITY(1,1) NOT NULL,         -- 流水號
    [SB_SystemCode] VARCHAR(10) NOT NULL PRIMARY KEY, -- 系統代碼 (PK)
    [SB_SystemName] NVARCHAR(50) NOT NULL,          -- 代碼名稱
    [SB_SerialNumber] VARCHAR(50) NOT NULL,         -- 系統編號
    [SB_Count] INT NOT NULL,                        -- 取號總數
    [ModifiedDate] DATETIME NOT NULL DEFAULT GETDATE() -- 修改日期
);

-- 建立有外鍵依賴的表
CREATE TABLE [dbo].[User_PD] (
    [UserPD_ID] INT IDENTITY(1,1) PRIMARY KEY,      -- 使用者密碼資料 ID (PK)
    [User_ID] INT NOT NULL,                         -- 關聯的 User ID
    [UserPD_PasswordHash] VARCHAR(256) NULL,        -- 密碼雜湊
    [UserPD_Token] VARCHAR(MAX) NOT NULL,           -- Token
    [UserPD_CreateDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 創建時間
    CONSTRAINT FK_UserPD_User FOREIGN KEY ([User_ID]) REFERENCES [dbo].[User]([User_ID])
);

CREATE TABLE [dbo].[ExternalLogins] (
    [ExternalLoginId] INT IDENTITY(1,1) PRIMARY KEY, -- 外部登入 ID (PK)
    [Provider] NVARCHAR(50) NOT NULL,               -- 外部登入提供者
    [ProviderUserId] NVARCHAR(100) NOT NULL,        -- 外部使用者唯一識別碼
    [MI_MemberID] INT NOT NULL,                     -- 關聯的 MemberInformation ID
    [DateCreated] DATETIME NOT NULL DEFAULT GETDATE(), -- 創建時間
    CONSTRAINT FK_ExternalLogins_MemberInformation FOREIGN KEY ([MI_MemberID]) REFERENCES [dbo].[MemberInformation]([MI_MemberID])
);

CREATE TABLE [dbo].[Itinerary] (
    [Itinerary_ID] INT IDENTITY(1,1) PRIMARY KEY,   -- 行程 ID (PK)
    [Itinerary_Title] NVARCHAR(50) NOT NULL,        -- 行程名稱
    [Itinerary_Location] NVARCHAR(50) NOT NULL,     -- 行程地點
    [Itinerary_Coordinate] VARCHAR(200) NOT NULL,   -- 行程座標
    [Itinerary_Image] VARCHAR(MAX) NOT NULL,        -- 行程圖片
    [Itinerary_StartDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 行程起始時間
    [Itinerary_EndDate] DATETIME NOT NULL,          -- 行程結束時間
    [Itinerary_CreateUser] INT NOT NULL,            -- 創建使用者
    [Itinerary_CreateDate] DATETIME NOT NULL DEFAULT GETDATE() -- 創建時間
);

CREATE TABLE [dbo].[Itinerary_Group] (
    [ItineraryGroup_ID] INT IDENTITY(1,1) PRIMARY KEY,  -- 群組 ID (PK)
    [ItineraryGroup_ItineraryID] INT NOT NULL,          -- 關聯的行程 ID
    [ItineraryGroup_UserEmail] VARCHAR(100) NOT NULL,   -- 使用者信箱
    CONSTRAINT FK_ItineraryGroup_Itinerary FOREIGN KEY ([ItineraryGroup_ItineraryID]) REFERENCES [dbo].[Itinerary]([Itinerary_ID])
);

CREATE TABLE [dbo].[Itinerary_Detail] (
    [ItineraryDetail_ID] INT NOT NULL PRIMARY KEY,      -- 行程明細 ID (PK)
    [Itinerary_ID] INT NOT NULL,                        -- 關聯的行程 ID
    [ItineraryDetail_Day] INT NOT NULL,                 -- 第幾天
    [ItineraryDetail_Accommodation] INT NOT NULL,       -- 住宿 (關聯 ProductType_ID)
    [ItineraryDetail_ProductTypeID] INT NOT NULL,       -- 商品類別 (關聯 ProductType_ID)
    [ItineraryDetail_MapID] INT NOT NULL,               -- 地點 (關聯 Map_ID)
    [ItineraryDetail_Group] INT NOT NULL,               -- 群組
    [ItineraryDetail_StartDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 行程起始時間
    [ItineraryDetail_EndDate] DATETIME NOT NULL DEFAULT GETDATE(),   -- 行程結束時間
    [ItineraryDetail_Memo] NVARCHAR(500) NOT NULL,      -- 行程備註
    [ItineraryDetail_CreateDate] DATETIME NOT NULL DEFAULT GETDATE(), -- 創建時間
    CONSTRAINT FK_ItineraryDetail_Itinerary FOREIGN KEY ([Itinerary_ID]) REFERENCES [dbo].[Itinerary]([Itinerary_ID]),
    CONSTRAINT FK_ItineraryDetail_Map FOREIGN KEY ([ItineraryDetail_MapID]) REFERENCES [dbo].[Map]([Map_ID])
);

CREATE TABLE [dbo].[Bill] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill ID (PK)
    [Itinerary_Id] INT NOT NULL,                      -- 行程 ID
    [Title] NVARCHAR(50) NOT NULL,                    -- 帳單標題
    [Total_Amount] DECIMAL(18,2) NOT NULL,            -- 總金額
    [PaidBy] NVARCHAR(50) NOT NULL,                   -- 付款人
    [Created_At] DATETIME NOT NULL DEFAULT GETDATE(), -- 建立時間
    CONSTRAINT FK_Bill_Itinerary FOREIGN KEY ([Itinerary_Id]) REFERENCES [dbo].[Itinerary]([Itinerary_ID])
);

CREATE TABLE [dbo].[Bill_details] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill_details ID (PK)
    [Bill_Id] INT NOT NULL,                           -- 關聯的 Bill ID
    [Member_Name] NVARCHAR(20) NOT NULL,              -- 成員名稱
    [Amount] DECIMAL(18,2) NOT NULL,                  -- 分擔金額
    [Paid] BIT NOT NULL DEFAULT (0),                  -- 是否已付款
    CONSTRAINT FK_BillDetails_Bill FOREIGN KEY ([Bill_Id]) REFERENCES [dbo].[Bill]([Id])
);

CREATE TABLE [dbo].[Order] (
    [order_Id] INT IDENTITY(1,1) PRIMARY KEY,       -- 訂單 ID (PK)
    [merchant_TradeNo] VARCHAR(50) UNIQUE NOT NULL, -- 綠界訂單交易編號 (必須唯一)
    [order_Time] DATETIME NOT NULL DEFAULT GETDATE(), -- 訂單建立時間
    [order_TotalAmount] DECIMAL(10,2) NOT NULL,     -- 訂單總金額
    [delete_at] DATETIME NULL,                      -- 刪除時間 (可為 NULL)
    [user_Id] INT NOT NULL,                         -- 使用者 ID
    [order_Status] INT NOT NULL,                    -- 訂單狀態
    [order_PaymentStatus] INT NOT NULL,             -- 訂單付款狀態
    CONSTRAINT FK_Order_User FOREIGN KEY ([user_Id]) REFERENCES [dbo].[User]([User_ID]),
    CONSTRAINT FK_Order_OrderStatus FOREIGN KEY ([order_Status]) REFERENCES [dbo].[Order_Status]([OS_Id]),
    CONSTRAINT FK_Order_PaymentStatus FOREIGN KEY ([order_PaymentStatus]) REFERENCES [dbo].[Payment_Status]([PS_Id])
);

CREATE TABLE [dbo].[Payment] (
    [payment_Id] INT IDENTITY(1,1) PRIMARY KEY,     -- 付款 ID (PK)
    [payment_Time] DATETIME NULL,                   -- 付款成功時間 (成功付款才有值)
    [payment_Method] INT NOT NULL,                  -- 付款方式
    [payment_MethodName] INT NULL,                  -- 綠界回傳付款方式
    [order_Id] INT NOT NULL,                        -- 關聯的訂單 ID
    [paymentStatus_Id] INT NOT NULL,                -- 付款狀態
    [ECPay_TransactionId] NVARCHAR(50) NULL,        -- 綠界交易編號
    CONSTRAINT FK_Payment_Method FOREIGN KEY ([payment_Method]) REFERENCES [dbo].[Payment_Method]([PM_Id]),
    CONSTRAINT FK_Payment_Order FOREIGN KEY ([order_Id]) REFERENCES [dbo].[Order]([order_Id]),
    CONSTRAINT FK_Payment_Status FOREIGN KEY ([paymentStatus_Id]) REFERENCES [dbo].[Payment_Status]([PS_Id])
);

CREATE TABLE [dbo].[Location] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,             -- 地點 ID (PK)
    [user_id] INT NOT NULL,                         -- 會員 ID
    [schedule_id] INT NOT NULL,                     -- 關聯的行程 ID
    [attraction] NVARCHAR(100) NOT NULL,            -- 景點
    [date] DATE NOT NULL,                           -- 日期
    CONSTRAINT FK_Location_Schedule FOREIGN KEY ([schedule_id]) REFERENCES [dbo].[Schedule]([id]),
    CONSTRAINT FK_Location_User FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([User_ID])
);

CREATE TABLE [dbo].[Place] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,             -- 地點 ID (PK)
    [date] DATETIME2(7) NOT NULL,                   -- 日期時間
    [scheduleId] INT NOT NULL,                      -- 關聯的行程 ID
    [Name] NVARCHAR(255) NOT NULL,                  -- 名稱
    [Address] NVARCHAR(255) NOT NULL,               -- 地址
    [Latitude] FLOAT NOT NULL,                      -- 緯度
    [Longitude] FLOAT NOT NULL,                     -- 經度
    [img] NVARCHAR(MAX) NOT NULL,                   -- 圖片
    [rating] NVARCHAR(10) NOT NULL,                 -- 評分
    CONSTRAINT FK_Place_Schedule FOREIGN KEY ([scheduleId]) REFERENCES [dbo].[Schedule]([id])
);

-- 加入預設值
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

-- 加入檢查條件
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

-- 建立索引
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

-- 加入欄位備註
EXEC sp_addextendedproperty 'MS_Description', '帳單 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Itinerary_Id';
EXEC sp_addextendedproperty 'MS_Description', '帳單標題', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Title';
EXEC sp_addextendedproperty 'MS_Description', '總金額', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Total_Amount';
EXEC sp_addextendedproperty 'MS_Description', '付款人', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'PaidBy';
EXEC sp_addextendedproperty 'MS_Description', '帳單建立時間', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Created_At';

EXEC sp_addextendedproperty 'MS_Description', '帳單明細 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '關聯的帳單 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Bill_Id';
EXEC sp_addextendedproperty 'MS_Description', '成員名稱', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Member_Name';
EXEC sp_addextendedproperty 'MS_Description', '分擔金額', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Amount';
EXEC sp_addextendedproperty 'MS_Description', '是否已付款（0 = 未付款，1 = 已付款）', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Paid';

EXEC sp_addextendedproperty 'MS_Description', '地點 ID', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_ID';
EXEC sp_addextendedproperty 'MS_Description', '地點名稱', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_PlaceName';
EXEC sp_addextendedproperty 'MS_Description', '地址', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Address';
EXEC sp_addextendedproperty 'MS_Description', '經度', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Longitude';
EXEC sp_addextendedproperty 'MS_Description', '緯度', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Latitude';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_ID';
EXEC sp_addextendedproperty 'MS_Description', '行程名稱', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Title';
EXEC sp_addextendedproperty 'MS_Description', '行程地點', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Location';
EXEC sp_addextendedproperty 'MS_Description', '行程座標', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Coordinate';
EXEC sp_addextendedproperty 'MS_Description', '行程圖片', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Image';
EXEC sp_addextendedproperty 'MS_Description', '行程起始時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_StartDate';
EXEC sp_addextendedproperty 'MS_Description', '行程結束時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_EndDate';
EXEC sp_addextendedproperty 'MS_Description', '創建使用者', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateUser';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '群組 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ID';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ItineraryID';
EXEC sp_addextendedproperty 'MS_Description', '使用者信箱', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_UserEmail';

EXEC sp_addextendedproperty 'MS_Description', '行程明細 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_ID';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'Itinerary_ID';
EXEC sp_addextendedproperty 'MS_Description', '第幾天', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Day';
EXEC sp_addextendedproperty 'MS_Description', '住宿 (關聯 ProductType_ID)', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Accommodation';
EXEC sp_addextendedproperty 'MS_Description', '商品類別 (關聯 ProductType_ID)', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_ProductTypeID';
EXEC sp_addextendedproperty 'MS_Description', '地點 (關聯 Map_ID)', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_MapID';
EXEC sp_addextendedproperty 'MS_Description', '群組', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Group';
EXEC sp_addextendedproperty 'MS_Description', '行程起始時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_StartDate';
EXEC sp_addextendedproperty 'MS_Description', '行程結束時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_EndDate';
EXEC sp_addextendedproperty 'MS_Description', '行程備註', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_Memo';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Detail', 'COLUMN', 'ItineraryDetail_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '使用者 ID', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '使用者姓名', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Name';
EXEC sp_addextendedproperty 'MS_Description', '信箱', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Email';
EXEC sp_addextendedproperty 'MS_Description', '手機', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Phone';
EXEC sp_addextendedproperty 'MS_Description', '啟用狀態 (0 = 未啟用, 1 = 啟用)', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_Enabled';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'User', 'COLUMN', 'User_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '帳戶名稱', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_AccountName';
EXEC sp_addextendedproperty 'MS_Description', '電子郵件', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_Email';
EXEC sp_addextendedproperty 'MS_Description', '密碼雜湊', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', '註冊時間', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_RegistrationDate';
EXEC sp_addextendedproperty 'MS_Description', '是否啟用 (0 = 未啟用, 1 = 啟用)', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MI_IsActive';
EXEC sp_addextendedproperty 'MS_Description', '電子郵件確認令牌', 'SCHEMA', 'dbo', 'TABLE', 'MemberInformation', 'COLUMN', 'MiEmailConfirmationToken';

EXEC sp_addextendedproperty 'MS_Description', '使用者密碼資料 ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_ID';
EXEC sp_addextendedproperty 'MS_Description', '關聯的 User ID', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'User_ID';
EXEC sp_addextendedproperty 'MS_Description', '密碼雜湊', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_PasswordHash';
EXEC sp_addextendedproperty 'MS_Description', 'Token', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_Token';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'User_PD', 'COLUMN', 'UserPD_CreateDate';

EXEC sp_addextendedproperty 'MS_Description', '外部登入 ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ExternalLoginId';
EXEC sp_addextendedproperty 'MS_Description', '外部登入提供者 (如 Google)', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'Provider';
EXEC sp_addextendedproperty 'MS_Description', '外部使用者唯一識別碼', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'ProviderUserId';
EXEC sp_addextendedproperty 'MS_Description', '關聯的會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'MI_MemberID';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'ExternalLogins', 'COLUMN', 'DateCreated';

EXEC sp_addextendedproperty 'MS_Description', '訂單狀態 ID', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_Id';
EXEC sp_addextendedproperty 'MS_Description', '訂單狀態名稱（例：待付款、已付款、已取消）', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_OrderStatus';

EXEC sp_addextendedproperty 'MS_Description', '訂單 ID', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '綠界訂單交易編號', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'merchant_TradeNo';
EXEC sp_addextendedproperty 'MS_Description', '訂單建立時間', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Time';
EXEC sp_addextendedproperty 'MS_Description', '訂單總金額', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_TotalAmount';
EXEC sp_addextendedproperty 'MS_Description', '刪除時間（可為 NULL）', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'delete_at';
EXEC sp_addextendedproperty 'MS_Description', '使用者 ID', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'user_Id';
EXEC sp_addextendedproperty 'MS_Description', '訂單當前狀態', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Status';
EXEC sp_addextendedproperty 'MS_Description', '訂單付款狀態', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_PaymentStatus';

EXEC sp_addextendedproperty 'MS_Description', '付款狀態 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'PS_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款狀態名稱（例：Pending、Paid、Refunded）', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'payment_Status';

EXEC sp_addextendedproperty 'MS_Description', '付款方式 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'PM_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款方式名稱（例：信用卡、ATM 轉帳）', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '綠界付款方式代碼（例：Credit、ATM、CVS）', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_MethodCode';

EXEC sp_addextendedproperty 'MS_Description', '付款 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款成功時間（成功付款才有值）', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Time';
EXEC sp_addextendedproperty 'MS_Description', '付款方式', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '綠界回傳付款方式', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_MethodName';
EXEC sp_addextendedproperty 'MS_Description', '關聯的訂單', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款狀態', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'paymentStatus_Id';
EXEC sp_addextendedproperty 'MS_Description', '綠界交易編號', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'ECPay_TransactionId';

EXEC sp_addextendedproperty 'MS_Description', '行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '行程名稱', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'name';
EXEC sp_addextendedproperty 'MS_Description', '目的地', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'destination';
EXEC sp_addextendedproperty 'MS_Description', '開始日期', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'start_date';
EXEC sp_addextendedproperty 'MS_Description', '結束日期', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'end_date';

EXEC sp_addextendedproperty 'MS_Description', '地點 ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'schedule_id';
EXEC sp_addextendedproperty 'MS_Description', '景點', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'attraction';
EXEC sp_addextendedproperty 'MS_Description', '日期', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'date';

EXEC sp_addextendedproperty 'MS_Description', '地點 ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '日期時間', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'date';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'scheduleId';
EXEC sp_addextendedproperty 'MS_Description', '名稱', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', '地址', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Address';
EXEC sp_addextendedproperty 'MS_Description', '緯度', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Latitude';
EXEC sp_addextendedproperty 'MS_Description', '經度', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Longitude';
EXEC sp_addextendedproperty 'MS_Description', '圖片', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'img';
EXEC sp_addextendedproperty 'MS_Description', '評分', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'rating';

EXEC sp_addextendedproperty 'MS_Description', '票務 ID', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'TicketsId';
EXEC sp_addextendedproperty 'MS_Description', '票務名稱', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'TicketsName';
EXEC sp_addextendedproperty 'MS_Description', '票務種類', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'TicketsType';
EXEC sp_addextendedproperty 'MS_Description', '票務價格', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'Price';
EXEC sp_addextendedproperty 'MS_Description', '票務狀態 (0 = 不可用, 1 = 可用)', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'IsAvailable';
EXEC sp_addextendedproperty 'MS_Description', '票務描述', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'Description';
EXEC sp_addextendedproperty 'MS_Description', '票務退款政策', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'RefundPolicy';
EXEC sp_addextendedproperty 'MS_Description', '票務創建日期', 'SCHEMA', 'dbo', 'TABLE', 'Tickets', 'COLUMN', 'CreatedAt';

EXEC sp_addextendedproperty 'MS_Description', '套裝行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '活動名稱', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'eventName';
EXEC sp_addextendedproperty 'MS_Description', '起始地', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'startingPoint';
EXEC sp_addextendedproperty 'MS_Description', '目的地', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'destination';
EXEC sp_addextendedproperty 'MS_Description', '開始日期', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'firstDate';
EXEC sp_addextendedproperty 'MS_Description', '結束日期', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'lastDate';
EXEC sp_addextendedproperty 'MS_Description', '天數', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'duration';
EXEC sp_addextendedproperty 'MS_Description', '價格', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'price';
EXEC sp_addextendedproperty 'MS_Description', '描述', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'eventDescription';
EXEC sp_addextendedproperty 'MS_Description', '評分', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'ratings';
EXEC sp_addextendedproperty 'MS_Description', '聯絡方式', 'SCHEMA', 'dbo', 'TABLE', 'Tour_Bundles', 'COLUMN', 'contactInfo';

EXEC sp_addextendedproperty 'MS_Description', '流水號', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_Serial';
EXEC sp_addextendedproperty 'MS_Description', '系統代碼', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_SystemCode';
EXEC sp_addextendedproperty 'MS_Description', '代碼名稱', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_SystemName';
EXEC sp_addextendedproperty 'MS_Description', '系統編號', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_SerialNumber';
EXEC sp_addextendedproperty 'MS_Description', '取號總數', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'SB_Count';
EXEC sp_addextendedproperty 'MS_Description', '修改日期', 'SCHEMA', 'dbo', 'TABLE', 'SerialBase', 'COLUMN', 'ModifiedDate';
GO