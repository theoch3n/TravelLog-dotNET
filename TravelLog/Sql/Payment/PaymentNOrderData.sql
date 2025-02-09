-- 修正 UNIQUE KEY 限制 允許 NULL，但非 NULL 值必須唯一
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_Payment_ECPay')
BEGIN
    DROP INDEX UQ_Payment_ECPay ON Payment;
END

-- 重新建立 FILTERED UNIQUE INDEX
CREATE UNIQUE INDEX UQ_Payment_ECPay ON Payment(ECPay_TransactionId) WHERE ECPay_TransactionId IS NOT NULL;

-- 插入 Order_Status（訂單狀態）
INSERT INTO [Order_Status] (OS_OrderStatus) VALUES
(N'待付款'),
(N'已付款'),
(N'已取消'),
(N'已完成');

-- 插入 Payment_Status（付款狀態）
INSERT INTO [Payment_Status] (payment_Status) VALUES
(N'Pending'),
(N'Paid'),
(N'Failed'),
(N'Refunding'),
(N'Refunded'),
(N'Expired');

-- 插入 Payment_Method（付款方式）
INSERT INTO [Payment_Method] (payment_Method, payment_MethodCode) VALUES
(N'信用卡', 'Credit'),
(N'ATM 轉帳', 'ATM'),
(N'超商代碼', 'CVS');

-- 插入 Order（訂單）
INSERT INTO [Order] (order_Time, order_TotalAmount, delete_at, user_Id, order_Status, order_PaymentStatus) VALUES
(DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 7, GETDATE()), 1500.00, NULL, 1, 1, 1),  
('2023-06-15 10:45:00', 3200.50, NULL, 2, 2, 2),  
('2024-03-22 14:30:00', 499.99, NULL, 3, 3, 3),   
('2024-12-10 18:15:00', 7899.00, NULL, 4, 4, 2);  

-- 插入 Payment（付款紀錄）
INSERT INTO [Payment] (payment_Time, payment_Method, order_Id, paymentStatus_Id, ECPay_TransactionId) VALUES
(NULL, 1, 1, 1, NULL),  
(DATEADD(DAY, 3, '2023-06-15 10:45:00'), 2, 2, 2, 'EC1234567890'),  
(NULL, 3, 3, 3, NULL),  
(DATEADD(DAY, 5, '2024-12-10 18:15:00'), 1, 4, 2, 'EC9876543210');  
