-- �ץ� UNIQUE KEY ���� ���\ NULL�A���D NULL �ȥ����ߤ@
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_Payment_ECPay')
BEGIN
    DROP INDEX UQ_Payment_ECPay ON Payment;
END

-- ���s�إ� FILTERED UNIQUE INDEX
CREATE UNIQUE INDEX UQ_Payment_ECPay ON Payment(ECPay_TransactionId) WHERE ECPay_TransactionId IS NOT NULL;

-- ���J Order_Status�]�q�檬�A�^
INSERT INTO [Order_Status] (OS_OrderStatus) VALUES
(N'�ݥI��'),
(N'�w�I��'),
(N'�w����'),
(N'�w����');

-- ���J Payment_Status�]�I�ڪ��A�^
INSERT INTO [Payment_Status] (payment_Status) VALUES
(N'�ݥI��'),
(N'�w�I��'),
(N'�I�ڥ���'),
(N'�h�ڤ�'),
(N'�w�h��'),
(N'�w�O��');

-- ���J Payment_Method�]�I�ڤ覡�^
INSERT INTO [Payment_Method] (payment_Method, payment_MethodCode) VALUES
(N'�H�Υd', 'Credit'),
(N'ATM ��b', 'ATM'),
(N'�W�ӥN�X', 'CVS');

-- ���J Order�]�q��^
INSERT INTO [Order] (merchant_TradeNo, order_Time, order_TotalAmount, delete_at, user_Id, order_Status, order_PaymentStatus, product_Id) VALUES
('2024021216375237', DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 30, GETDATE()), 50000, NULL, 5, 1, 1, 3),
('2024010509300040', '2024-01-05 09:30:00', 55000, NULL, 6, 2, 1, 7),
('2023122012000099', '2023-12-20 12:00:00', 200000, NULL, 7, 3, 2, 13),
('2024021015454520', '2024-02-10 15:45:00', 68000, NULL, 8, 1, 3, 8),
('2024020820100995', '2024-02-08 20:10:00', 120000, NULL, 9, 2, 1, 14),
('2024020214003750', DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 30, GETDATE()), 45000, NULL, 10, 4, 2, 11),
('2024012011156499', '2024-01-20 11:15:00', 8000, NULL, 11, 3, 3, 5),
('2024021208451299', '2024-02-12 08:45:00', 25000, NULL, 12, 1, 1, 2),
('2024012814300520', '2024-01-28 14:30:00', 30000, NULL, 13, 2, 1, 1),
('2023123017208750', '2023-12-30 17:20:00', 80000, NULL, 14, 4, 3, 9);


-- ���J Payment�]�I�ڬ����^
INSERT INTO [Payment] (payment_Time, payment_Method, order_Id, paymentStatus_Id, ECPay_TransactionId) VALUES
(NULL, 1, 1, 1, NULL),  -- �q��1�G�|���I��
(DATEADD(DAY, 3, '2024-01-05 09:30:00'), 2, 2, 2, '2501211632090937'), -- �q��2�G�w�I��
(NULL, 3, 3, 3, NULL), -- �q��3�G���I��
(DATEADD(DAY, 5, '2024-02-10 15:45:00'), 1, 4, 2, '2501215383108412'), -- �q��4�G�w�I��
(NULL, 1, 5, 1, NULL), -- �q��5�G���I��
(DATEADD(DAY, 2, '2024-02-02 14:00:37'), 2, 6, 2, '2501211630000973'), -- �q��6�G�w�I��
(NULL, 3, 7, 3, NULL), -- �q��7�G���I��
(DATEADD(DAY, 1, '2024-02-12 08:45:00'), 1, 8, 1, '2501215383108459'), -- �q��8�G�w�I��
(NULL, 1, 9, 1, NULL), -- �q��9�G���I��
(DATEADD(DAY, 3, '2023-12-30 17:20:00'), 2, 10, 2, '2501211632090999'); -- �q��10�G�w�I��

