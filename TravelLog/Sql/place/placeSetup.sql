USE [TravelLog]
GO

-- �p�G��w�s�b�A���R��
DROP TABLE IF EXISTS [dbo].[Location];
DROP TABLE IF EXISTS [dbo].[Place];
DROP TABLE IF EXISTS [dbo].[Schedule];

-- �إ� Schedule ��
CREATE TABLE [dbo].[Schedule] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,         -- Schedule ID (PK)
    [user_id] INT NOT NULL,                     -- �|�� ID
    [name] NVARCHAR(100) NOT NULL,              -- ��{�W��
    [destination] NVARCHAR(100) NOT NULL,       -- �ت��a
    [start_date] DATE NOT NULL,                 -- �}�l���
    [end_date] DATE NOT NULL                    -- �������
);

-- �إ� Location ��
CREATE TABLE [dbo].[Location] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,         -- �a�I ID (PK)
    [user_id] INT NOT NULL,                     -- �|�� ID
    [schedule_id] INT NOT NULL,                 -- ���p����{ ID
    [attraction] NVARCHAR(100) NOT NULL,        -- ���I
    [date] DATE NOT NULL,                       -- ���
    CONSTRAINT FK_Location_Schedule FOREIGN KEY ([schedule_id]) REFERENCES [dbo].[Schedule]([id])
);

-- �إ� Place ��
CREATE TABLE [dbo].[Place] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,         -- �a�I ID (PK)
    [date] DATETIME2(7) NOT NULL,               -- ����ɶ�
    [scheduleId] INT NOT NULL,                  -- ���p����{ ID
    [Name] NVARCHAR(255) NOT NULL,              -- �W��
    [Address] NVARCHAR(255) NOT NULL,           -- �a�}
    [Latitude] FLOAT NOT NULL,                  -- �n��
    [Longitude] FLOAT NOT NULL,                 -- �g��
    [img] NVARCHAR(MAX) NOT NULL,               -- �Ϥ�
    [rating] NVARCHAR(10) NOT NULL,             -- ����
    CONSTRAINT FK_Place_Schedule FOREIGN KEY ([scheduleId]) REFERENCES [dbo].[Schedule]([id])
);

-- �[�J�ˬd����
ALTER TABLE [dbo].[Schedule] 
    WITH CHECK ADD CHECK (([start_date] <= [end_date]));

-- �إ߯���
CREATE INDEX IDX_Schedule_User ON [dbo].[Schedule]([user_id]);
CREATE INDEX IDX_Location_Schedule ON [dbo].[Location]([schedule_id]);
CREATE INDEX IDX_Location_User ON [dbo].[Location]([user_id]);
CREATE INDEX IDX_Place_Schedule ON [dbo].[Place]([scheduleId]);

-- �[�J���Ƶ�
-- Schedule ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '��{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '�|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '��{�W��', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'name';
EXEC sp_addextendedproperty 'MS_Description', '�ت��a', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'destination';
EXEC sp_addextendedproperty 'MS_Description', '�}�l���', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'start_date';
EXEC sp_addextendedproperty 'MS_Description', '�������', 'SCHEMA', 'dbo', 'TABLE', 'Schedule', 'COLUMN', 'end_date';

-- Location ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�a�I ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'id';
EXEC sp_addextendedproperty 'MS_Description', '�|�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'user_id';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'schedule_id';
EXEC sp_addextendedproperty 'MS_Description', '���I', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'attraction';
EXEC sp_addextendedproperty 'MS_Description', '���', 'SCHEMA', 'dbo', 'TABLE', 'Location', 'COLUMN', 'date';

-- Place ��Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�a�I ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '����ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'date';
EXEC sp_addextendedproperty 'MS_Description', '���p����{ ID', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'scheduleId';
EXEC sp_addextendedproperty 'MS_Description', '�W��', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', '�a�}', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Address';
EXEC sp_addextendedproperty 'MS_Description', '�n��', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Latitude';
EXEC sp_addextendedproperty 'MS_Description', '�g��', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'Longitude';
EXEC sp_addextendedproperty 'MS_Description', '�Ϥ�', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'img';
EXEC sp_addextendedproperty 'MS_Description', '����', 'SCHEMA', 'dbo', 'TABLE', 'Place', 'COLUMN', 'rating';
GO