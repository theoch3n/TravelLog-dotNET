USE [TravelLog]
GO

-- �p�G��w�s�b�A���R��
DROP TABLE IF EXISTS [dbo].[Itinerary_Detail];
DROP TABLE IF EXISTS [dbo].[Itinerary_Group];
DROP TABLE IF EXISTS [dbo].[Itinerary];
DROP TABLE IF EXISTS [dbo].[Map];

-- �إ� Map ��
CREATE TABLE [dbo].[Map] (
    [Map_ID] INT IDENTITY(1,1) PRIMARY KEY,         -- �a�I ID (PK)
    [Map_PlaceName] NVARCHAR(50) NOT NULL,          -- �a�I�W��
    [Map_Address] NVARCHAR(200) NOT NULL,           -- �a�}
    [Map_Longitude] FLOAT NOT NULL,                 -- �g��
    [Map_Latitude] FLOAT NOT NULL,                  -- �n��
    [Map_CreateDate] DATETIME NOT NULL DEFAULT GETDATE()  -- �Ыخɶ�
);

-- �إ� Itinerary ��
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

-- �إ� Itinerary_Group ��
CREATE TABLE [dbo].[Itinerary_Group] (
    [ItineraryGroup_ID] INT IDENTITY(1,1) PRIMARY KEY,  -- �s�� ID (PK)
    [ItineraryGroup_ItineraryID] INT NOT NULL,          -- ���p����{ ID
    [ItineraryGroup_UserEmail] VARCHAR(100) NOT NULL,   -- �ϥΪ̫H�c
    CONSTRAINT FK_ItineraryGroup_Itinerary FOREIGN KEY ([ItineraryGroup_ItineraryID]) REFERENCES [dbo].[Itinerary]([Itinerary_ID])
);

-- �إ� Itinerary_Detail ��
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

-- �[�J�w�]��
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

-- �[�J�ˬd����
ALTER TABLE [dbo].[Itinerary] 
    WITH CHECK ADD CHECK (([Itinerary_StartDate] <= [Itinerary_EndDate]));

ALTER TABLE [dbo].[Itinerary_Detail] 
    WITH CHECK ADD CHECK (([ItineraryDetail_Day] >= 0));
ALTER TABLE [dbo].[Itinerary_Detail] 
    WITH CHECK ADD CHECK (([ItineraryDetail_StartDate] <= [ItineraryDetail_EndDate]));

-- �إ߯���
CREATE INDEX IDX_Itinerary_CreateUser ON [dbo].[Itinerary]([Itinerary_CreateUser]);
CREATE INDEX IDX_ItineraryGroup_Itinerary ON [dbo].[Itinerary_Group]([ItineraryGroup_ItineraryID]);
CREATE INDEX IDX_ItineraryDetail_Itinerary ON [dbo].[Itinerary_Detail]([Itinerary_ID]);
CREATE INDEX IDX_ItineraryDetail_Map ON [dbo].[Itinerary_Detail]([ItineraryDetail_MapID]);

-- �[�J���Ƶ�
-- Map ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�a�I ID', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_ID';
EXEC sp_addextendedproperty 'MS_Description', '�a�I�W��', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_PlaceName';
EXEC sp_addextendedproperty 'MS_Description', '�a�}', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Address';
EXEC sp_addextendedproperty 'MS_Description', '�g��', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Longitude';
EXEC sp_addextendedproperty 'MS_Description', '�n��', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_Latitude';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Map', 'COLUMN', 'Map_CreateDate';

-- Itinerary ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '��{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_ID';
EXEC sp_addextendedproperty 'MS_Description', '��{�W��', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Title';
EXEC sp_addextendedproperty 'MS_Description', '��{�a�I', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Location';
EXEC sp_addextendedproperty 'MS_Description', '��{�y��', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Coordinate';
EXEC sp_addextendedproperty 'MS_Description', '��{�Ϥ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_Image';
EXEC sp_addextendedproperty 'MS_Description', '��{�_�l�ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_StartDate';
EXEC sp_addextendedproperty 'MS_Description', '��{�����ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_EndDate';
EXEC sp_addextendedproperty 'MS_Description', '�ЫبϥΪ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateUser';
EXEC sp_addextendedproperty 'MS_Description', '�Ыخɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary', 'COLUMN', 'Itinerary_CreateDate';

-- Itinerary_Group ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�s�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ID';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_ItineraryID';
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ̫H�c', 'SCHEMA', 'dbo', 'TABLE', 'Itinerary_Group', 'COLUMN', 'ItineraryGroup_UserEmail';

-- Itinerary_Detail ��Ƶ�
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
GO