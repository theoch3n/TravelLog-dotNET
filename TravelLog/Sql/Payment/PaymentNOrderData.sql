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
(N'Pending'),
(N'Paid'),
(N'Failed'),
(N'Refunding'),
(N'Refunded'),
(N'Expired');

-- ���J Payment_Method�]�I�ڤ覡�^
INSERT INTO [Payment_Method] (payment_Method, payment_MethodCode) VALUES
(N'�H�Υd', 'Credit'),
(N'ATM ��b', 'ATM'),
(N'�W�ӥN�X', 'CVS');

-- ���J Order�]�q��^
INSERT INTO [Order] (order_Time, order_TotalAmount, delete_at, user_Id, order_Status, order_PaymentStatus) VALUES
(DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 7, GETDATE()), 1500.00, NULL, 1, 1, 1),  
('2023-06-15 10:45:00', 3200.50, NULL, 2, 2, 2),  
('2024-03-22 14:30:00', 499.99, NULL, 3, 3, 3),   
('2024-12-10 18:15:00', 7899.00, NULL, 4, 4, 2);  

-- ���J Payment�]�I�ڬ����^
INSERT INTO [Payment] (payment_Time, payment_Method, order_Id, paymentStatus_Id, ECPay_TransactionId) VALUES
(NULL, 1, 1, 1, NULL),  
(DATEADD(DAY, 3, '2023-06-15 10:45:00'), 2, 2, 2, 'EC1234567890'),  
(NULL, 3, 3, 3, NULL),  
(DATEADD(DAY, 5, '2024-12-10 18:15:00'), 1, 4, 2, 'EC9876543210');  
