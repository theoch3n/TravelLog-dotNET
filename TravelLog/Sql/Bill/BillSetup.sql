USE [TravelLog]
GO

-- 如果表已存在，先刪除
DROP TABLE IF EXISTS [dbo].[Bill_details];
DROP TABLE IF EXISTS [dbo].[Bill];

-- 建立 Bill 表
CREATE TABLE [dbo].[Bill] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill ID (PK)
    [Itinerary_Id] INT NOT NULL,                      -- 行程 ID
    [Title] NVARCHAR(50) NOT NULL,                    -- 帳單標題
    [Total_Amount] DECIMAL(18,2) NOT NULL,            -- 總金額
    [PaidBy] NVARCHAR(50) NOT NULL,                   -- 付款人
    [Created_At] DATETIME NOT NULL DEFAULT GETDATE()  -- 建立時間
);

-- 建立 Bill_details 表
CREATE TABLE [dbo].[Bill_details] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill_details ID (PK)
    [Bill_Id] INT NOT NULL,                           -- 關聯的 Bill ID
    [Member_Name] NVARCHAR(20) NOT NULL,              -- 成員名稱
    [Amount] DECIMAL(18,2) NOT NULL,                  -- 分擔金額
    [Paid] BIT NOT NULL DEFAULT (0),                  -- 是否已付款
    CONSTRAINT FK_BillDetails_Bill FOREIGN KEY ([Bill_Id]) REFERENCES [dbo].[Bill]([Id])
);

-- 加入檢查條件
ALTER TABLE [dbo].[Bill] 
    WITH CHECK ADD CHECK (([Total_Amount] >= (0)));

ALTER TABLE [dbo].[Bill_details] 
    WITH CHECK ADD CHECK (([Amount] >= (0)));

-- 建立索引
CREATE INDEX IDX_Bill_Itinerary ON [dbo].[Bill]([Itinerary_Id]);
CREATE INDEX IDX_BillDetails_Bill ON [dbo].[Bill_details]([Bill_Id]);

-- 加入欄位備註
EXEC sp_addextendedproperty 'MS_Description', '帳單 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '行程 ID（未來可接 Itinerary 表）', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Itinerary_Id';
EXEC sp_addextendedproperty 'MS_Description', '帳單標題', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Title';
EXEC sp_addextendedproperty 'MS_Description', '總金額', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Total_Amount';
EXEC sp_addextendedproperty 'MS_Description', '付款人', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'PaidBy';
EXEC sp_addextendedproperty 'MS_Description', '帳單建立時間', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Created_At';

EXEC sp_addextendedproperty 'MS_Description', '帳單明細 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '關聯的帳單 ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Bill_Id';
EXEC sp_addextendedproperty 'MS_Description', '成員名稱', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Member_Name';
EXEC sp_addextendedproperty 'MS_Description', '分擔金額', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Amount';
EXEC sp_addextendedproperty 'MS_Description', '是否已付款（0 = 未付款，1 = 已付款）', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Paid';
GO