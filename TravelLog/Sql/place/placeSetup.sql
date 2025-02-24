USE [TravelLog]
GO

-- 如果表已存在，先刪除
DROP TABLE IF EXISTS [dbo].[Location];
DROP TABLE IF EXISTS [dbo].[Place];
DROP TABLE IF EXISTS [dbo].[Schedule];

-- 建立 Schedule 表
CREATE TABLE [dbo].[Schedule] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,         -- Schedule ID (PK)
    [user_id] INT NOT NULL,                     -- 會員 ID
    [name] NVARCHAR(100) NOT NULL,              -- 行程名稱
    [destination] NVARCHAR(100) NOT NULL,       -- 目的地
    [start_date] DATE NOT NULL,                 -- 開始日期
    [end_date] DATE NOT NULL                    -- 結束日期
);

-- 建立 Location 表
CREATE TABLE [dbo].[Location] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,         -- 地點 ID (PK)
    [user_id] INT NOT NULL,                     -- 會員 ID
    [schedule_id] INT NOT NULL,                 -- 關聯的行程 ID
    [attraction] NVARCHAR(100) NOT NULL,        -- 景點
    [date] DATE NOT NULL,                       -- 日期
    CONSTRAINT FK_Location_Schedule FOREIGN KEY ([schedule_id]) REFERENCES [dbo].[Schedule]([id])
);

-- 建立 Place 表
CREATE TABLE [dbo].[Place] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,         -- 地點 ID (PK)
    [date] DATETIME2(7) NOT NULL,               -- 日期時間
    [scheduleId] INT NOT NULL,                  -- 關聯的行程 ID
    [Name] NVARCHAR(255) NOT NULL,              -- 名稱
    [Address] NVARCHAR(255) NOT NULL,           -- 地址
    [Latitude] FLOAT NOT NULL,                  -- 緯度
    [Longitude] FLOAT NOT NULL,                 -- 經度
    [img] NVARCHAR(MAX) NOT NULL,               -- 圖片
    [rating] NVARCHAR(10) NOT NULL,             -- 評分
    CONSTRAINT FK_Place_Schedule FOREIGN KEY ([scheduleId]) REFERENCES [dbo].[Schedule]([id])
);

-- 加入檢查條件
ALTER TABLE [dbo].[Schedule] 
    WITH CHECK ADD CHECK (([start_date] <= [end_date]));

-- 建立索引
CREATE INDEX IDX_Schedule_User ON [dbo].[Schedule]([user_id]);
CREATE INDEX IDX_Location_Schedule ON [dbo].[Location]([schedule_id]);
CREATE INDEX IDX_Location_User ON [dbo].[Location]([user_id]);
CREATE INDEX IDX_Place_Schedule ON [dbo].[Place]([scheduleId]);

-- 加入欄位備註
-- Schedule 表備註
EXEC sp_addextendedproperty 'MS_Description', '行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '行程名稱', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'name';
EXEC sp_addextendedproperty 'MS_Description', '目的地', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'destination';
EXEC sp_addextendedproperty 'MS_Description', '開始日期', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'start_date';
EXEC sp_addextendedproperty 'MS_Description', '結束日期', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'end_date';

-- Location 表備註
EXEC sp_addextendedproperty 'MS_Description', '地點 ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '會員 ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'schedule_id';
EXEC sp_addextendedproperty 'MS_Description', '景點', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'attraction';
EXEC sp_addextendedproperty 'MS_Description', '日期', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'date';

-- Place 表備註
EXEC sp_addextendedproperty 'MS_Description', '地點 ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '日期時間', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'date';
EXEC sp_addextendedproperty 'MS_Description', '關聯的行程 ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'scheduleId';
EXEC sp_addextendedproperty 'MS_Description', '名稱', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', '地址', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Address';
EXEC sp_addextendedproperty 'MS_Description', '緯度', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Latitude';
EXEC sp_addextendedproperty 'MS_Description', '經度', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Longitude';
EXEC sp_addextendedproperty 'MS_Description', '圖片', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'img';
EXEC sp_addextendedproperty 'MS_Description', '評分', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'rating';
GO