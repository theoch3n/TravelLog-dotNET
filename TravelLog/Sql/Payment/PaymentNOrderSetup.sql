-- �q�檬�A�� Order_Status
CREATE TABLE Order_Status (
    OS_Id INT IDENTITY(1,1) PRIMARY KEY,  -- �q�檬�A ID (PK)
    OS_OrderStatus NVARCHAR(20) NOT NULL  -- �q�檬�A�W��
);

-- �I�ڪ��A�� Payment_Status
CREATE TABLE Payment_Status (
    PS_Id INT IDENTITY(1,1) PRIMARY KEY,  -- �I�ڪ��A ID (PK)
    payment_Status NVARCHAR(20) NOT NULL  -- �I�ڪ��A�W��
);

-- �q��� Order
CREATE TABLE [Order] (
    order_Id INT IDENTITY(1,1) PRIMARY KEY,  -- �q�� ID (PK)
    merchant_TradeNo VARCHAR(50) UNIQUE NOT NULL,  -- ��ɭq�����s�� (�����ߤ@)
    order_Time DATETIME NOT NULL DEFAULT GETDATE(),  -- �q��إ߮ɶ�
    order_TotalAmount DECIMAL(10,2) NOT NULL,  -- �q���`���B
    delete_at DATETIME NULL,  -- �R���ɶ� (�i�� NULL)
    user_Id INT NOT NULL,  -- �ϥΪ� ID
    order_Status INT NOT NULL,  -- �q�檬�A
    order_PaymentStatus INT NOT NULL,  -- �q��I�ڪ��A
    CONSTRAINT FK_Order_OrderStatus FOREIGN KEY (order_Status) REFERENCES Order_Status(OS_Id),
    CONSTRAINT FK_Order_PaymentStatus FOREIGN KEY (order_PaymentStatus) REFERENCES Payment_Status(PS_Id)
);

-- �I�ڤ覡�� Payment_Method
CREATE TABLE Payment_Method (
    PM_Id INT IDENTITY(1,1) PRIMARY KEY,  -- �I�ڤ覡 ID (PK)
    payment_Method NVARCHAR(20) NOT NULL,  -- �I�ڤ覡�W��
    payment_MethodCode NVARCHAR(50) NOT NULL UNIQUE  -- ��ɥI�ڤ覡�N�X (�ߤ@)
);

-- �I�ڪ� Payment
CREATE TABLE Payment (
    payment_Id INT IDENTITY(1,1) PRIMARY KEY,  -- �I�� ID (PK)
    payment_Time DATETIME NULL,  -- �I�ڦ��\�ɶ� (���\�I�ڤ~����)
    payment_Method INT NOT NULL,  -- �I�ڤ覡
    payment_MethodName INT NOT NULL,  -- ��ɦ^�ǥI�ڤ覡
    order_Id INT NOT NULL,  -- ���p���q�� ID
    paymentStatus_Id INT NOT NULL,  -- �I�ڪ��A
    ECPay_TransactionId NVARCHAR(50) NULL,  -- ��ɥ���s��
    CONSTRAINT FK_Payment_Method FOREIGN KEY (payment_Method) REFERENCES Payment_Method(PM_Id),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_Id) REFERENCES [Order](order_Id),
    CONSTRAINT FK_Payment_Status FOREIGN KEY (paymentStatus_Id) REFERENCES Payment_Status(PS_Id)
);

-- �إ߯���
CREATE INDEX IDX_Order_Status ON [Order](order_Status);
CREATE INDEX IDX_Order_PaymentStatus ON [Order](order_PaymentStatus);
CREATE INDEX IDX_Payment_Method ON Payment(payment_Method);
CREATE INDEX IDX_Payment_Order ON Payment(order_Id);
CREATE INDEX IDX_Payment_Status ON Payment(paymentStatus_Id);

-- �T�O `ECPay_TransactionId` ���\ `NULL`�A���D `NULL` �Ȯɥ����ߤ@
CREATE UNIQUE INDEX UQ_Payment_ECPay ON Payment(ECPay_TransactionId) WHERE ECPay_TransactionId IS NOT NULL;

-- �[�J���Ƶ�
EXEC sp_addextendedproperty 'MS_Description', '�q�檬�A ID', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_Id';
EXEC sp_addextendedproperty 'MS_Description', '�q�檬�A�W�١]�ҡG�ݥI�ڡB�w�I�ڡB�w�����^', 'SCHEMA', 'dbo', 'TABLE', 'Order_Status', 'COLUMN', 'OS_OrderStatus';

EXEC sp_addextendedproperty 'MS_Description', '�q�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '��ɭq�����s��', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'merchant_TradeNo';
EXEC sp_addextendedproperty 'MS_Description', '�q��إ߮ɶ�', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Time';
EXEC sp_addextendedproperty 'MS_Description', '�q���`���B', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_TotalAmount';
EXEC sp_addextendedproperty 'MS_Description', '�R���ɶ��]�i�� NULL�^', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'delete_at';
EXEC sp_addextendedproperty 'MS_Description', '�ϥΪ� ID�]���ӥi�� User ��^', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'user_Id';
EXEC sp_addextendedproperty 'MS_Description', '�q���e���A', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_Status';
EXEC sp_addextendedproperty 'MS_Description', '�q��I�ڪ��A', 'SCHEMA', 'dbo', 'TABLE', 'Order', 'COLUMN', 'order_PaymentStatus';

EXEC sp_addextendedproperty 'MS_Description', '�I�ڪ��A ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'PS_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڪ��A�W�١]�ҡGPending�BPaid�BRefunded�^', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Status', 'COLUMN', 'payment_Status';

EXEC sp_addextendedproperty 'MS_Description', '�I�ڤ覡 ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'PM_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڤ覡�W�١]�ҡG�H�Υd�BATM ��b�^', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '��ɥI�ڤ覡�N�X�]�ҡGCredit�BATM�BCVS�^', 'SCHEMA', 'dbo', 'TABLE', 'Payment_Method', 'COLUMN', 'payment_MethodCode';

EXEC sp_addextendedproperty 'MS_Description', '�I�� ID', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڦ��\�ɶ��]���\�I�ڤ~���ȡ^', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Time';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڤ覡', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_Method';
EXEC sp_addextendedproperty 'MS_Description', '��ɦ^�ǥI�ڤ覡', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'payment_MethodName';
EXEC sp_addextendedproperty 'MS_Description', '���p���q��', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'order_Id';
EXEC sp_addextendedproperty 'MS_Description', '�I�ڪ��A', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'paymentStatus_Id';
EXEC sp_addextendedproperty 'MS_Description', '��ɥ���s��', 'SCHEMA', 'dbo', 'TABLE', 'Payment', 'COLUMN', 'ECPay_TransactionId';
