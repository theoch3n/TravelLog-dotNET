USE [TravelLog]
GO

-- �p�G��w�s�b�A���R��
DROP TABLE IF EXISTS [dbo].[Bill_details];
DROP TABLE IF EXISTS [dbo].[Bill];

-- �إ� Bill ��
CREATE TABLE [dbo].[Bill] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill ID (PK)
    [Itinerary_Id] INT NOT NULL,                      -- ��{ ID
    [Title] NVARCHAR(50) NOT NULL,                    -- �b����D
    [Total_Amount] DECIMAL(18,2) NOT NULL,            -- �`���B
    [PaidBy] NVARCHAR(50) NOT NULL,                   -- �I�ڤH
    [Created_At] DATETIME NOT NULL DEFAULT GETDATE()  -- �إ߮ɶ�
);

-- �إ� Bill_details ��
CREATE TABLE [dbo].[Bill_details] (
    [Id] INT IDENTITY(1,1) PRIMARY KEY,               -- Bill_details ID (PK)
    [Bill_Id] INT NOT NULL,                           -- ���p�� Bill ID
    [Member_Name] NVARCHAR(20) NOT NULL,              -- �����W��
    [Amount] DECIMAL(18,2) NOT NULL,                  -- ������B
    [Paid] BIT NOT NULL DEFAULT (0),                  -- �O�_�w�I��
    CONSTRAINT FK_BillDetails_Bill FOREIGN KEY ([Bill_Id]) REFERENCES [dbo].[Bill]([Id])
);

-- �[�J�ˬd����
ALTER TABLE [dbo].[Bill] 
    WITH CHECK ADD CHECK (([Total_Amount] >= (0)));

ALTER TABLE [dbo].[Bill_details] 
    WITH CHECK ADD CHECK (([Amount] >= (0)));

-- �إ߯���
CREATE INDEX IDX_Bill_Itinerary ON [dbo].[Bill]([Itinerary_Id]);
CREATE INDEX IDX_BillDetails_Bill ON [dbo].[Bill_details]([Bill_Id]);

-- �[�J���Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�b�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '��{ ID�]���ӥi�� Itinerary ��^', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Itinerary_Id';
EXEC sp_addextendedproperty 'MS_Description', '�b����D', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Title';
EXEC sp_addextendedproperty 'MS_Description', '�`���B', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Total_Amount';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڤH', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'PaidBy';
EXEC sp_addextendedproperty 'MS_Description', '�b��إ߮ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Bill', 'COLUMN', 'Created_At';

EXEC sp_addextendedproperty 'MS_Description', '�b����� ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Id';
EXEC sp_addextendedproperty 'MS_Description', '���p���b�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Bill_Id';
EXEC sp_addextendedproperty 'MS_Description', '�����W��', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Member_Name';
EXEC sp_addextendedproperty 'MS_Description', '������B', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Amount';
EXEC sp_addextendedproperty 'MS_Description', '�O�_�w�I�ڡ]0 = ���I�ڡA1 = �w�I�ڡ^', 'SCHEMA', 'dbo', 'TABLE', 'Bill_details', 'COLUMN', 'Paid';
GO