USE [TravelLog]
GO

-- �ץ� UNIQUE KEY ����A���\ NULL�A���D NULL �ȥ����ߤ@
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_Payment_ECPay')
BEGIN
    DROP INDEX UQ_Payment_ECPay ON [dbo].[Payment];
END
CREATE UNIQUE INDEX UQ_Payment_ECPay ON [dbo].[Payment](ECPay_TransactionId) WHERE ECPay_TransactionId IS NOT NULL;

-- �{�ɪ��x�s����K�X�M������ơA�Ѵ��ըϥ�
DECLARE @UserLoginTemp TABLE (
    User_ID INT,
    User_Name NVARCHAR(20),
    User_Email NVARCHAR(100),
    PlainPassword NVARCHAR(20)
);

-- ���J�w�]��ƨ� User �� (500 ����ơA�إ߮ɶ������b 2024-02-22 �� 2025-02-21)
DECLARE @Surnames TABLE (Surname NVARCHAR(10), Pinyin VARCHAR(20));
INSERT INTO @Surnames (Surname, Pinyin) VALUES 
    (N'��', 'chen'), (N'�L', 'lin'), (N'��', 'huang'), (N'�i', 'zhang'), (N'��', 'li'), 
    (N'��', 'wang'), (N'�d', 'wu'), (N'�B', 'liu'), (N'��', 'cai'), (N'��', 'yang'), 
    (N'�\', 'xu'), (N'�G', 'zheng'), (N'��', 'xie'), (N'��', 'guo'), (N'�x', 'hong'), 
    (N'��', 'qiu'), (N'��', 'zeng'), (N'��', 'liao'), (N'��', 'lai'), (N'�P', 'zhou'), 
    (N'��', 'ye'), (N'Ĭ', 'su'), (N'��', 'zhuang'), (N'�f', 'lu');

DECLARE @GivenNames TABLE (GivenName NVARCHAR(10), Pinyin VARCHAR(20));
INSERT INTO @GivenNames (GivenName, Pinyin) VALUES 
    (N'��', 'wei'), (N'��', 'fang'), (N'�@', 'ting'), (N'��', 'ming'), (N'��', 'hua'), 
    (N'��', 'zhi'), (N'��', 'mei'), (N'��', 'wen'), (N'�j', 'qiang'), (N'�z', 'hui'), 
    (N'�g', 'jun'), (N'��', 'jie'), (N'�Y', 'xin'), (N'��', 'hong'), (N'��', 'yi'), 
    (N'��', 'ren'), (N'��', 'wen'), (N'�p', 'feng'), (N'��', 'ling'), (N'��', 'hao'), 
    (N'��', 'shan'), (N'�t', 'yu'), (N'�X', 'qi'), (N'��', 'xiang'),
    (N'�嶲', 'xiaowen'), (N'�ص�', 'jianhua'), (N'�R��', 'liping'), (N'�ө�', 'zhiming'), 
    (N'���@', 'yating'), (N'�T��', 'junjie'), (N'�Y��', 'xinyi'), (N'����', 'weilun'), 
    (N'����', 'meiling'), (N'�a��', 'jiahao'), (N'�ج�', 'peishan'), (N'�l�X', 'ziqi'), 
    (N'����', 'mingzhe'), (N'�f��', 'huizhen');

DECLARE @Domains TABLE (Domain NVARCHAR(20));
INSERT INTO @Domains (Domain) VALUES 
    ('gmail.com'), ('yahoo.com'), ('hotmail.com'), ('outlook.com'), ('icloud.com');

DECLARE @i INT = 1;
WHILE @i <= 500
BEGIN
    DECLARE @Surname NVARCHAR(10) = (SELECT TOP 1 Surname FROM @Surnames ORDER BY NEWID());
    DECLARE @GivenName NVARCHAR(10) = (SELECT TOP 1 GivenName FROM @GivenNames ORDER BY NEWID());
    DECLARE @FullName NVARCHAR(20) = @Surname + @GivenName; -- �Ҧp�G�����B�L�嶲
    DECLARE @SurnamePinyin VARCHAR(20) = (SELECT Pinyin FROM @Surnames WHERE Surname = @Surname);
    DECLARE @GivenNamePinyin VARCHAR(20) = (SELECT Pinyin FROM @GivenNames WHERE GivenName = @GivenName);
    DECLARE @Domain NVARCHAR(20) = (SELECT TOP 1 Domain FROM @Domains ORDER BY NEWID());
    DECLARE @RandomNum INT = CAST(RAND() * 999 AS INT); -- �T���H���Ʀr
    DECLARE @Email NVARCHAR(100) = LOWER(@SurnamePinyin + @GivenNamePinyin + CAST(@RandomNum AS NVARCHAR(3)) + '@' + @Domain); -- �Ҧp�Gchenwei123@gmail.com
    DECLARE @CreateDate DATETIME = DATEADD(DAY, -CAST(RAND() * 365 AS INT), '2025-02-21'); -- �H�������b�@�~��
    DECLARE @PlainPassword NVARCHAR(20) = 'Pass' + RIGHT('000' + CAST(@i AS NVARCHAR(3)), 3); -- ����K�X�A�Ҧp Pass001
    DECLARE @PasswordHash VARBINARY(32) = HASHBYTES('SHA2_256', @PlainPassword); -- SHA-256 ����

    INSERT INTO [dbo].[User] 
        ([User_Name], [User_Email], [User_Phone], [User_Enabled], [User_CreateDate])
    VALUES 
        (@FullName, 
         @Email, 
         '09' + RIGHT('000000' + CAST(CAST(RAND() * 8999999 + 1000000 AS INT) AS NVARCHAR(7)), 8), 
         1, 
         @CreateDate);

    -- ���J User_PD ����
    INSERT INTO [dbo].[User_PD] 
        ([User_ID], [UserPD_PasswordHash], [UserPD_Token], [UserPD_CreateDate])
    VALUES 
        (@i, -- User_ID �P User �� IDENTITY ����
         CONVERT(VARCHAR(256), @PasswordHash, 2), -- �ର�Q���i��r���x�s
         'token_' + CAST(@i AS NVARCHAR(3)) + '_' + CAST(CAST(RAND() * 999999 AS INT) AS NVARCHAR(6)), -- �����H�� Token
         @CreateDate);

    -- �O������K�X���{�ɪ�A�Ѵ��ըϥ�
    INSERT INTO @UserLoginTemp (User_ID, User_Name, User_Email, PlainPassword)
    VALUES (@i, @FullName, @Email, @PlainPassword);

    SET @i = @i + 1;
END;

-- ��ܥi�Ϊ��n�J��ơ]Email �M����K�X�^
SELECT User_ID, User_Name, User_Email, PlainPassword
FROM @UserLoginTemp
ORDER BY User_ID;

-- ���J�w�]��ƨ� MemberInformation ��
INSERT INTO [dbo].[MemberInformation] 
    ([MI_AccountName], [MI_Email], [MI_PasswordHash], [MI_RegistrationDate], [MI_IsActive], [MiEmailConfirmationToken])
VALUES 
    ('Test', 'Test@gmail.com', '047f91c39524762a871344b62bc607418653f78a2e11fabb1dafb79968a99272', '2025-01-11 17:24:24.650', 1, NULL);

-- ���J�w�]��ƨ� Tickets ��
INSERT INTO [dbo].[Tickets] 
    ([TicketsName], [TicketsType], [Price], [IsAvailable], [Description], [RefundPolicy])
VALUES 
    ('�зǤ�����', '������', 50, 1, '�y��12A�A���Ĵ���2024�~3��', '���h��'),
    ('���ذs���ж�', '�s���w�q', 120, 1, '����301�СA��������', '���e24�p�ɥi�h��'),
    ('�t�۷|����', '���ʪ���', 80, 1, '12��t�۷|�J����', '���h��'),
    ('�D�D�ֶ�J����', '���ʪ���', 35, 1, '�Ҧ��C�ֳ]�I�q����', '���e48�p�ɥi�h��'),
    ('������', '����', 200, 1, '�g�ٿ��y��A���Ĵ���2024�~1��', '���h��');

-- ���J Order_Status�]�q�檬�A�^
INSERT INTO [dbo].[Order_Status] 
    ([OS_OrderStatus])
VALUES
    (N'�ݥI��'),
    (N'�w�I��'),
    (N'�w����'),
    (N'�w����');

-- ���J Payment_Status�]�I�ڪ��A�^
INSERT INTO [dbo].[Payment_Status] 
    ([payment_Status])
VALUES
    (N'�ݥI��'),
    (N'�w�I��'),
    (N'Failed'),
    (N'�h�ڤ�'),
    (N'�w�h��'),
    (N'�w�O��');

-- ���J Payment_Method�]�I�ڤ覡�^
INSERT INTO [dbo].[Payment_Method] 
    ([payment_Method], [payment_MethodCode])
VALUES
    (N'�H�Υd', 'Credit'),
    (N'ATM ��b', 'ATM'),
    (N'�W�ӥN�X', 'CVS');

-- ���J Order�]�q��^ - 100 �����
SET @i = 1;
WHILE @i <= 100
BEGIN
    DECLARE @OrderTime DATETIME = DATEADD(DAY, -CAST(RAND() * 365 AS INT), '2025-02-21'); -- �H�������b�@�~��
    DECLARE @UserId INT = CAST(RAND() * 499 + 1 AS INT); -- �H����� 1-500 �� User_ID
    DECLARE @OrderStatus INT = CAST(RAND() * 4 + 1 AS INT); -- 1-4 �H�����A
    DECLARE @PaymentStatus INT = CASE 
                                    WHEN @OrderStatus = 1 THEN 1 -- �ݥI��
                                    WHEN @OrderStatus = 2 THEN 2 -- �w�I��
                                    WHEN @OrderStatus = 3 THEN 3 -- �w����
                                    WHEN @OrderStatus = 4 THEN 2 -- �w����
                                 END;
    DECLARE @TotalAmount DECIMAL(10,2) = CAST(RAND() * 9900 + 100 AS DECIMAL(10,2)); -- 100-10000 �H�����B
    DECLARE @TradeNo VARCHAR(50) = 'ORD' + FORMAT(@OrderTime, 'yyyyMMddHHmmss') + RIGHT('000' + CAST(@i AS VARCHAR(3)), 3);

    INSERT INTO [dbo].[Order] 
        ([merchant_TradeNo], [order_Time], [order_TotalAmount], [delete_at], [user_Id], [order_Status], [order_PaymentStatus])
    VALUES 
        (@TradeNo, @OrderTime, @TotalAmount, NULL, @UserId, @OrderStatus, @PaymentStatus);

    SET @i = @i + 1;
END;

-- ���J Payment�]�I�ڬ����^ - 100 �����
SET @i = 1;
WHILE @i <= 100
BEGIN
    DECLARE @OrderRowId INT = @i; -- ���� Order �� order_Id
    DECLARE @PaymentMethod INT = CAST(RAND() * 3 + 1 AS INT); -- 1-3 �H���I�ڤ覡
    DECLARE @OrderStatusForPayment INT = (SELECT order_Status FROM [dbo].[Order] WHERE order_Id = @OrderRowId);
    DECLARE @PaymentStatusForPayment INT = (SELECT order_PaymentStatus FROM [dbo].[Order] WHERE order_Id = @OrderRowId);
    DECLARE @PaymentTime DATETIME = CASE 
                                     WHEN @PaymentStatusForPayment = 2 THEN DATEADD(DAY, CAST(RAND() * 5 AS INT), (SELECT order_Time FROM [dbo].[Order] WHERE order_Id = @OrderRowId))
                                     ELSE NULL
                                   END;
    DECLARE @TransactionId NVARCHAR(50) = CASE 
                                            WHEN @PaymentStatusForPayment = 2 THEN 'TX' + FORMAT(GETDATE(), 'yyyyMMddHHmmss') + RIGHT('000' + CAST(@i AS NVARCHAR(3)), 3)
                                            ELSE NULL
                                          END;

    INSERT INTO [dbo].[Payment] 
        ([payment_Time], [payment_Method], [order_Id], [paymentStatus_Id], [ECPay_TransactionId])
    VALUES 
        (@PaymentTime, @PaymentMethod, @OrderRowId, @PaymentStatusForPayment, @TransactionId);

    SET @i = @i + 1;
END;

-- ���J Tour_Bundles�]�M�˦�{�^
INSERT INTO [dbo].[Tour_Bundles] 
    ([eventName], [startingPoint], [destination], [firstDate], [lastDate], [duration], [price], [eventDescription], [ratings], [contactInfo])
VALUES 
    ('���q�_�J����', '�x�_', '�ڨ��q', '2025-02-01', '2025-02-07', 7, 30000, '����ڨ��q�������P�F�y�A�ɨ���o�������O�ֻP��a��ƭ����C', 5, '0912345678'),
    ('��ƿ򲣱���', '����', '�ʳ�', '2025-03-10', '2025-03-15', 6, 25000, '�����饻�ʳ����j�Ѥ�ƻP�ǲΡA���[�@�ɿ򲣲M���x�B���զx�����I�C', 4, '0922334455'),
    ('���褽������', '�����F', '�ª��s', '2025-04-01', '2025-04-10', 10, 50000, '�u�ۥ[�{�@�������r���A�ɨ����R�����������P�h�˪������y�O�C', 5, '0933445566'),
    ('�_�ڷ������I', '���w������', 'ù�˯I��', '2025-12-01', '2025-12-07', 7, 70000, '�l�M�������_�����A����B���@�ɪ��y�O�A���[�Ħ̤�Ƨ��P���a�ʪ���C', 5, '0944556677'),
    ('�j�۵M���I��', '�x��', '�Ὤ', '2025-05-15', '2025-05-17', 3, 8000, '�����Ӿ|�հ�a���骺���R�l���P�����s���A�ɨ����������P��ơC', 4, '0955667788'),
    ('�k���������', '�ھ�', '����', '2025-06-01', '2025-06-08', 8, 60000, '�C���k��g�崺�I�A�ɨ��a�����u���������P�����C', 5, '0966778899'),
    ('�����q�j�Q����', 'ù��', '��ù�۴�', '2025-07-01', '2025-07-07', 7, 55000, '�`�J�q�j�Q�������P���N��ơA���[�g�崺�I�pù���v�޳��P���ı׶�C', 4, '0977889900'),
    ('�D�w�ͺA���I', '����', '�j���G', '2025-08-10', '2025-08-17', 8, 68000, '�����j���G�����R�����@�ɡA����D�w�S�����۵M�P���Ͱʪ��C', 5, '0988990011'),
    ('���������s�Ƴ�����', '�餺��', '�������S', '2025-12-20', '2025-12-27', 8, 80000, '�b���������s�ɱ��Ƴ��A�ɨ��ŷx����λP��a�S���\���C', 5, '0999001122'),
    ('���F�F�z����', '����', '�����F��', '2025-11-01', '2025-11-05', 5, 40000, '����F�z�V���B�M�d�m�P���ԧB��ƪ������P���ءC', 4, '0900112233'),
    ('�F�ڥj����§', '���Ԯ�', '���F�ش�', '2025-09-01', '2025-09-10', 10, 45000, '�C���F�ڥj�������v�P�ؿv���ǡA�~����a���S������C', 5, '0911223344'),
    ('�L�H����', '����', '����', '2025-10-01', '2025-10-07', 7, 32000, '�`�J���ê������P���R�A���[���F�Ԯc�P�]�p�Ժ��p�C', 4, '0922334455'),
    ('�n�����I', '���y�մ���Q��', '�n���b�q', '2025-12-15', '2026-01-01', 18, 200000, '�����a�y�̫n�ݪ����a�����A���ҫn�����º�P�����C', 5, '0933445566'),
    ('�[�Ǥ�����ضl��', '�ڪ��K', '���R�[', '2025-07-01', '2025-07-10', 10, 120000, '�f�����ضl���C���[�Ǥ���A�ɨ��U�خT�ֳ]�I�P��o�����C', 5, '0944556677'),
    ('��������ʪ�����', '�x�_', '����', '2025-06-15', '2025-06-18', 4, 15000, '������������P�ɩ|�ʪ��A�����������I�p���}�P���j�C', 4, '0955667788');
GO