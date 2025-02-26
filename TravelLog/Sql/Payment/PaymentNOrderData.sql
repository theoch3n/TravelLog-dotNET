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
(N'待付款'),
(N'已付款'),
(N'付款失敗'),
(N'退款中'),
(N'已退款'),
(N'已逾期');

-- 插入 Payment_Method（付款方式）
INSERT INTO [Payment_Method] (payment_Method, payment_MethodCode) VALUES
(N'信用卡', 'Credit'),
(N'ATM 轉帳', 'ATM'),
(N'超商代碼', 'CVS');

-- 插入 Order（訂單）
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


-- 插入 Payment（付款紀錄）
INSERT INTO [Payment] (payment_Time, payment_Method, order_Id, paymentStatus_Id, ECPay_TransactionId) VALUES
(NULL, 1, 1, 1, NULL),  -- 訂單1：尚未付款
(DATEADD(DAY, 3, '2024-01-05 09:30:00'), 2, 2, 2, '2501211632090937'), -- 訂單2：已付款
(NULL, 3, 3, 3, NULL), -- 訂單3：未付款
(DATEADD(DAY, 5, '2024-02-10 15:45:00'), 1, 4, 2, '2501215383108412'), -- 訂單4：已付款
(NULL, 1, 5, 1, NULL), -- 訂單5：未付款
(DATEADD(DAY, 2, '2024-02-02 14:00:37'), 2, 6, 2, '2501211630000973'), -- 訂單6：已付款
(NULL, 3, 7, 3, NULL), -- 訂單7：未付款
(DATEADD(DAY, 1, '2024-02-12 08:45:00'), 1, 8, 1, '2501215383108459'), -- 訂單8：已付款
(NULL, 1, 9, 1, NULL), -- 訂單9：未付款
(DATEADD(DAY, 3, '2023-12-30 17:20:00'), 2, 10, 2, '2501211632090999'); -- 訂單10：已付款

