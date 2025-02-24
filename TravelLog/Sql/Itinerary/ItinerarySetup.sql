USE [TravelLog]
GO

-- 如果表已存在，先刪除
DROP TABLE IF EXISTS [dbo].[Itinerary_Detail];
DROP TABLE IF EXISTS [dbo].[Itinerary_Group];
DROP TABLE IF EXISTS [dbo].[Itinerary];
DROP TABLE IF EXISTS [dbo].[Map];

-- 建立 Map 表
CREATE TABLE [dbo].[Map] (
    [Map_ID] INT IDENTITY(1,1) PRIMARY KEY,         -- 地點 ID (PK)
    [Map_PlaceName] NVARCHAR(50) NOT NULL,          -- 地點名稱
    [Map_Address] NVARCHAR(200) NOT NULL,           -- 地址
    [Map_Longitude] FLOAT NOT NULL,                 -- 經度
    [Map_Latitude] FLOAT NOT NULL,                  -- 緯度
    [Map_CreateDate] DATETIME NOT NULL DEFAULT GETDATE()  -- 創建時間
);

-- 建立 Itinerary 表
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

-- 建立 Itinerary_Group 表
CREATE TABLE [dbo].[Itinerary_Group] (
    [ItineraryGroup_ID] INT IDENTITY(1,1) PRIMARY KEY,  -- 群組 ID (PK)
    [ItineraryGroup_ItineraryID] INT NOT NULL,          -- 關聯的行程 ID
    [ItineraryGroup_UserEmail] VARCHAR(100) NOT NULL,   -- 使用者信箱
    CONSTRAINT FK_ItineraryGroup_Itinerary FOREIGN KEY ([ItineraryGroup_ItineraryID]) REFERENCES [dbo].[Itinerary]([Itinerary_ID])
);

-- 建立 Itinerary_Detail 表
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

-- 加入預設值
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_PlaceName DEFAULT ('') FOR [Map_PlaceName];
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_Address DEFAULT ('') FOR [Map_Address];
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_Longitude DEFAULT ((0)) FOR [Map_Longitude];
ALTER TABLE [dbo].[Map] ADD CONSTRAINT DF_Map_Latitude DEFAULT ((0)) FOR [Map_Latitude];

ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Title DEFAULT ('') FOR [Itinerary_Title];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Location DEFAULT ('') FOR [Itinerary_Location];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Coordinate DEFAULT ('') FOR [Itinerary_Coordinate];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_Image DEFAULT ('') FOR [Itinerary_Image];
ALTER TABLE [dbo].[Itinerary] ADD CONSTRAINT DF_Itinerary_CreateUser DEFAULT ((0)) FOR [Itinerary_CreateUser];

ALTER TABLE [dbo].[Itinerary_Group] ADD CONSTRAINT DF_ItineraryGroup_ItineraryID DEFAULT ((0)) FOR [ItineraryGroup_ItineraryID];
ALTER TABLE [dbo].[Itinerary_Group] ADD CONSTRAINT DF_ItineraryGroup_UserEmail DEFAULT ('') FOR [ItineraryGroup_UserEmail];

ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Day DEFAULT ((0)) FOR [ItineraryDetail_Day];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Accommodation DEFAULT ((0)) FOR [ItineraryDetail_Accommodation];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_ProductTypeID DEFAULT ((0)) FOR [ItineraryDetail_ProductTypeID];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_MapID DEFAULT ((0)) FOR [ItineraryDetail_MapID];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Group DEFAULT ((0)) FOR [ItineraryDetail_Group];
ALTER TABLE [dbo].[Itinerary_Detail] ADD CONSTRAINT DF_ItineraryDetail_Memo DEFAULT ('') FOR [ItineraryDetail_Memo];

-- 加入檢查條件
ALTER TABLE [dbo].[Itinerary] 
    WITH CHECK ADD CHECK (([Itinerary_StartDate] <= [Itinerary_EndDate]));

ALTER TABLE [dbo].[Itinerary_Detail] 
    WITH CHECK ADD CHECK (([ItineraryDetail_Day] >= 0));
ALTER TABLE [dbo].[Itinerary_Detail] 
    WITH CHECK ADD CHECK (([ItineraryDetail_StartDate] <= [ItineraryDetail_EndDate]));

-- 建立索引
CREATE INDEX IDX_Itinerary_CreateUser ON [dbo].[Itinerary]([Itinerary_CreateUser]);
CREATE INDEX IDX_ItineraryGroup_Itinerary ON [dbo].[Itinerary_Group]([ItineraryGroup_ItineraryID]);
CREATE INDEX IDX_ItineraryDetail_Itinerary ON [dbo].[Itinerary_Detail]([Itinerary_ID]);
CREATE INDEX IDX_ItineraryDetail_Map ON [dbo].[Itinerary_Detail]([ItineraryDetail_MapID]);

-- 加入欄位備註
-- Map 表備註
EXEC sp_addextendedproperty 'MS_Description', '地點 ID', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_ID';
EXEC sp_addextendedproperty 'MS_Description', '地點名稱', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_PlaceName';
EXEC sp_addextendedproperty 'MS_Description', '地址', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Address';
EXEC sp_addextendedproperty 'MS_Description', '經度', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Longitude';
EXEC sp_addextendedproperty 'MS_Description', '緯度', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Latitude';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_CreateDate';

-- Itinerary 表備註
EXEC sp_addextendedproperty 'MS_Description', '行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_ID';
EXEC sp_addextendedproperty 'MS_Description', '行程名稱', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Title';
EXEC sp_addextendedproperty 'MS_Description', '行程地點', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Location';
EXEC sp_addextendedproperty 'MS_Description', '行程座標', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Coordinate';
EXEC sp_addextendedproperty 'MS_Description', '行程圖片', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Image';
EXEC sp_addextendedproperty 'MS_Description', '行程起始時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_StartDate';
EXEC sp_addextendedproperty 'MS_Description', '行程結束時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_EndDate';
EXEC sp_addextendedproperty 'MS_Description', '創建使用者', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateUser';
EXEC sp_addextendedproperty 'MS_Description', '創建時間', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateDate';

-- Itinerary_Group 表備註
EXEC sp_addextendedproperty 'MS_Description', '群組 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ID';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ItineraryID';
EXEC sp_addextendedproperty 'MS_Description', '使用者信箱', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_UserEmail';

-- Itinerary_Detail 表備註
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
GO