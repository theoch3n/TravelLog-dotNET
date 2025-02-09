USE TravelLog;

-- 訂單狀態
INSERT INTO [Order_Status](OS_OrderStatus)
VALUES
	('確認中'),
	('確認完成'),
	('完成'),
	('取消');
GO

-- 訂單
INSERT INTO [Order] (order_Time, order_TotalAmount, user_Id, order_Status)
VALUES
	('2024-07-11', 936, 1, 3),
	('2024-08-24', 2130, 2, 2);
GO

-- 商品與票券中繼表
INSERT INTO[Product_Ticket](order_Id, ticket_Id, product_Id)
VALUES
	(1, 1, 1),
	(2, 0, 3);
GO

-- 付款狀態
INSERT INTO [Payment_Status] (payment_Status)
VALUES
	('尚未付款'),
	('付款完成'),
	('尚未退款'),
	('退款完成');
GO

-- 付款方式
INSERT INTO [Payment_Method](payment_Method)
VALUES
	('超商繳費'),
	('銀行轉帳'),
	('信用卡付款');
GO

-- 付款
INSERT INTO [Payment](payment_Deadline, payment_Time, payment_Method, order_id, paymentStatus_Id)
VALUES
	('2024-07-18', '2024-07-14', 3, 1, 2),
	('2024-08-31', null, 1, 2, 1);
GO

SELECT * FROM [Order];