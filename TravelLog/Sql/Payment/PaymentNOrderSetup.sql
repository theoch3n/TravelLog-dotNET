-- 訂單狀態表 Order_Status
CREATE TABLE Order_Status (
    OS_Id INT IDENTITY(1,1) PRIMARY KEY,  -- 訂單狀態 ID (PK)
    OS_OrderStatus NVARCHAR(20) NOT NULL  -- 訂單狀態名稱
);

-- 付款狀態表 Payment_Status
CREATE TABLE Payment_Status (
    PS_Id INT IDENTITY(1,1) PRIMARY KEY,  -- 付款狀態 ID (PK)
    payment_Status NVARCHAR(20) NOT NULL  -- 付款狀態名稱
);

-- 訂單表 Order
CREATE TABLE [Order] (
    order_Id INT IDENTITY(1,1) PRIMARY KEY,  -- 訂單 ID (PK)
    merchant_TradeNo VARCHAR(50) UNIQUE NOT NULL,  -- 綠界訂單交易編號 (必須唯一)
    order_Time DATETIME NOT NULL DEFAULT GETDATE(),  -- 訂單建立時間
    order_TotalAmount DECIMAL(10,2) NOT NULL,  -- 訂單總金額
    delete_at DATETIME NULL,  -- 刪除時間 (可為 NULL)
    user_Id INT NOT NULL,  -- 使用者 ID
    order_Status INT NOT NULL,  -- 訂單狀態
    order_PaymentStatus INT NOT NULL,  -- 訂單付款狀態
    CONSTRAINT FK_Order_OrderStatus FOREIGN KEY (order_Status) REFERENCES Order_Status(OS_Id),
    CONSTRAINT FK_Order_PaymentStatus FOREIGN KEY (order_PaymentStatus) REFERENCES Payment_Status(PS_Id)
);

-- 付款方式表 Payment_Method
CREATE TABLE Payment_Method (
    PM_Id INT IDENTITY(1,1) PRIMARY KEY,  -- 付款方式 ID (PK)
    payment_Method NVARCHAR(20) NOT NULL,  -- 付款方式名稱
    payment_MethodCode NVARCHAR(50) NOT NULL UNIQUE  -- 綠界付款方式代碼 (唯一)
);

-- 付款表 Payment
CREATE TABLE Payment (
    payment_Id INT IDENTITY(1,1) PRIMARY KEY,  -- 付款 ID (PK)
    payment_Time DATETIME NULL,  -- 付款成功時間 (成功付款才有值)
    payment_Method INT NOT NULL,  -- 付款方式
    payment_MethodName INT NOT NULL,  -- 綠界回傳付款方式
    order_Id INT NOT NULL,  -- 關聯的訂單 ID
    paymentStatus_Id INT NOT NULL,  -- 付款狀態
    ECPay_TransactionId NVARCHAR(50) NULL,  -- 綠界交易編號
    CONSTRAINT FK_Payment_Method FOREIGN KEY (payment_Method) REFERENCES Payment_Method(PM_Id),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_Id) REFERENCES [Order](order_Id),
    CONSTRAINT FK_Payment_Status FOREIGN KEY (paymentStatus_Id) REFERENCES Payment_Status(PS_Id)
);

-- 建立索引
CREATE INDEX IDX_Order_Status ON [Order](order_Status);
CREATE INDEX IDX_Order_PaymentStatus ON [Order](order_PaymentStatus);
CREATE INDEX IDX_Payment_Method ON Payment(payment_Method);
CREATE INDEX IDX_Payment_Order ON Payment(order_Id);
CREATE INDEX IDX_Payment_Status ON Payment(paymentStatus_Id);

-- 確保 `ECPay_TransactionId` 允許 `NULL`，但非 `NULL` 值時必須唯一
CREATE UNIQUE INDEX UQ_Payment_ECPay ON Payment(ECPay_TransactionId) WHERE ECPay_TransactionId IS NOT NULL;

-- 加入欄位備註
EXEC sp_addextendedproperty 'MS_Description', '訂單狀態 ID', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_Id';
EXEC sp_addextendedproperty 'MS_Description', '訂單狀態名稱（例：待付款、已付款、已取消）', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_OrderStatus';

EXEC sp_addextendedproperty 'MS_Description', '訂單 ID', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '綠界訂單交易編號', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'merchant_TradeNo';
EXEC sp_addextendedproperty 'MS_Description', '訂單建立時間', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Time';
EXEC sp_addextendedproperty 'MS_Description', '訂單總金額', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_TotalAmount';
EXEC sp_addextendedproperty 'MS_Description', '刪除時間（可為 NULL）', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'delete_at';
EXEC sp_addextendedproperty 'MS_Description', '使用者 ID（未來可接 User 表）', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'user_Id';
EXEC sp_addextendedproperty 'MS_Description', '訂單當前狀態', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Status';
EXEC sp_addextendedproperty 'MS_Description', '訂單付款狀態', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_PaymentStatus';

EXEC sp_addextendedproperty 'MS_Description', '付款狀態 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'PS_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款狀態名稱（例：Pending、Paid、Refunded）', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'payment_Status';

EXEC sp_addextendedproperty 'MS_Description', '付款方式 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'PM_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款方式名稱（例：信用卡、ATM 轉帳）', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '綠界付款方式代碼（例：Credit、ATM、CVS）', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_MethodCode';

EXEC sp_addextendedproperty 'MS_Description', '付款 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款成功時間（成功付款才有值）', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Time';
EXEC sp_addextendedproperty 'MS_Description', '付款方式', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '綠界回傳付款方式', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_MethodName';
EXEC sp_addextendedproperty 'MS_Description', '關聯的訂單', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '付款狀態', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'paymentStatus_Id';
EXEC sp_addextendedproperty 'MS_Description', '綠界交易編號', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'ECPay_TransactionId';
