USE [TravelLog]
GO

-- 修正 UNIQUE KEY 限制，允許 NULL，但非 NULL 值必須唯一
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_Payment_ECPay')
BEGIN
    DROP INDEX UQ_Payment_ECPay ON [dbo].[Payment];
END
CREATE UNIQUE INDEX UQ_Payment_ECPay ON [dbo].[Payment](ECPay_TransactionId) WHERE ECPay_TransactionId IS NOT NULL;

-- 臨時表儲存明文密碼和對應資料，供測試使用
DECLARE @UserLoginTemp TABLE (
    User_ID INT,
    User_Name NVARCHAR(20),
    User_Email NVARCHAR(100),
    PlainPassword NVARCHAR(20)
);

-- 插入預設資料到 User 表 (500 筆資料，建立時間分散在 2024-02-22 至 2025-02-21)
DECLARE @Surnames TABLE (Surname NVARCHAR(10), Pinyin VARCHAR(20));
INSERT INTO @Surnames (Surname, Pinyin) VALUES 
    (N'陳', 'chen'), (N'林', 'lin'), (N'黃', 'huang'), (N'張', 'zhang'), (N'李', 'li'), 
    (N'王', 'wang'), (N'吳', 'wu'), (N'劉', 'liu'), (N'蔡', 'cai'), (N'楊', 'yang'), 
    (N'許', 'xu'), (N'鄭', 'zheng'), (N'謝', 'xie'), (N'郭', 'guo'), (N'洪', 'hong'), 
    (N'邱', 'qiu'), (N'曾', 'zeng'), (N'廖', 'liao'), (N'賴', 'lai'), (N'周', 'zhou'), 
    (N'葉', 'ye'), (N'蘇', 'su'), (N'莊', 'zhuang'), (N'呂', 'lu');

DECLARE @GivenNames TABLE (GivenName NVARCHAR(10), Pinyin VARCHAR(20));
INSERT INTO @GivenNames (GivenName, Pinyin) VALUES 
    (N'偉', 'wei'), (N'芳', 'fang'), (N'婷', 'ting'), (N'明', 'ming'), (N'華', 'hua'), 
    (N'志', 'zhi'), (N'美', 'mei'), (N'文', 'wen'), (N'強', 'qiang'), (N'慧', 'hui'), 
    (N'君', 'jun'), (N'傑', 'jie'), (N'欣', 'xin'), (N'宏', 'hong'), (N'怡', 'yi'), 
    (N'仁', 'ren'), (N'雯', 'wen'), (N'峰', 'feng'), (N'玲', 'ling'), (N'豪', 'hao'), 
    (N'珊', 'shan'), (N'宇', 'yu'), (N'琪', 'qi'), (N'翔', 'xiang'),
    (N'曉雯', 'xiaowen'), (N'建華', 'jianhua'), (N'麗萍', 'liping'), (N'志明', 'zhiming'), 
    (N'雅婷', 'yating'), (N'俊傑', 'junjie'), (N'欣怡', 'xinyi'), (N'偉倫', 'weilun'), 
    (N'美玲', 'meiling'), (N'家豪', 'jiahao'), (N'佩珊', 'peishan'), (N'子琪', 'ziqi'), 
    (N'明哲', 'mingzhe'), (N'惠珍', 'huizhen');

DECLARE @Domains TABLE (Domain NVARCHAR(20));
INSERT INTO @Domains (Domain) VALUES 
    ('gmail.com'), ('yahoo.com'), ('hotmail.com'), ('outlook.com'), ('icloud.com');

DECLARE @i INT = 1;
WHILE @i <= 500
BEGIN
    DECLARE @Surname NVARCHAR(10) = (SELECT TOP 1 Surname FROM @Surnames ORDER BY NEWID());
    DECLARE @GivenName NVARCHAR(10) = (SELECT TOP 1 GivenName FROM @GivenNames ORDER BY NEWID());
    DECLARE @FullName NVARCHAR(20) = @Surname + @GivenName; -- 例如：陳偉、林曉雯
    DECLARE @SurnamePinyin VARCHAR(20) = (SELECT Pinyin FROM @Surnames WHERE Surname = @Surname);
    DECLARE @GivenNamePinyin VARCHAR(20) = (SELECT Pinyin FROM @GivenNames WHERE GivenName = @GivenName);
    DECLARE @Domain NVARCHAR(20) = (SELECT TOP 1 Domain FROM @Domains ORDER BY NEWID());
    DECLARE @RandomNum INT = CAST(RAND() * 999 AS INT); -- 三位隨機數字
    DECLARE @Email NVARCHAR(100) = LOWER(@SurnamePinyin + @GivenNamePinyin + CAST(@RandomNum AS NVARCHAR(3)) + '@' + @Domain); -- 例如：chenwei123@gmail.com
    DECLARE @CreateDate DATETIME = DATEADD(DAY, -CAST(RAND() * 365 AS INT), '2025-02-21'); -- 隨機分散在一年內
    DECLARE @PlainPassword NVARCHAR(20) = 'Pass' + RIGHT('000' + CAST(@i AS NVARCHAR(3)), 3); -- 明文密碼，例如 Pass001
    DECLARE @PasswordHash VARBINARY(32) = HASHBYTES('SHA2_256', @PlainPassword); -- SHA-256 雜湊

    INSERT INTO [dbo].[User] 
        ([User_Name], [User_Email], [User_Phone], [User_Enabled], [User_CreateDate])
    VALUES 
        (@FullName, 
         @Email, 
         '09' + RIGHT('000000' + CAST(CAST(RAND() * 8999999 + 1000000 AS INT) AS NVARCHAR(7)), 8), 
         1, 
         @CreateDate);

    -- 插入 User_PD 表資料
    INSERT INTO [dbo].[User_PD] 
        ([User_ID], [UserPD_PasswordHash], [UserPD_Token], [UserPD_CreateDate])
    VALUES 
        (@i, -- User_ID 與 User 表的 IDENTITY 對應
         CONVERT(VARCHAR(256), @PasswordHash, 2), -- 轉為十六進位字串儲存
         'token_' + CAST(@i AS NVARCHAR(3)) + '_' + CAST(CAST(RAND() * 999999 AS INT) AS NVARCHAR(6)), -- 模擬隨機 Token
         @CreateDate);

    -- 記錄明文密碼到臨時表，供測試使用
    INSERT INTO @UserLoginTemp (User_ID, User_Name, User_Email, PlainPassword)
    VALUES (@i, @FullName, @Email, @PlainPassword);

    SET @i = @i + 1;
END;

-- 顯示可用的登入資料（Email 和明文密碼）
SELECT User_ID, User_Name, User_Email, PlainPassword
FROM @UserLoginTemp
ORDER BY User_ID;

-- 插入預設資料到 MemberInformation 表
INSERT INTO [dbo].[MemberInformation] 
    ([MI_AccountName], [MI_Email], [MI_PasswordHash], [MI_RegistrationDate], [MI_IsActive], [MiEmailConfirmationToken])
VALUES 
    ('Test', 'Test@gmail.com', '047f91c39524762a871344b62bc607418653f78a2e11fabb1dafb79968a99272', '2025-01-11 17:24:24.650', 1, NULL);

-- 插入預設資料到 Tickets 表
INSERT INTO [dbo].[Tickets] 
    ([TicketsName], [TicketsType], [Price], [IsAvailable], [Description], [RefundPolicy])
VALUES 
    ('標準火車票', '火車票', 50, 1, '座位12A，有效期至2024年3月', '不退票'),
    ('豪華酒店房間', '酒店預訂', 120, 1, '海景301房，視野極佳', '提前24小時可退票'),
    ('演唱會門票', '活動門票', 80, 1, '12月演唱會入場票', '不退票'),
    ('主題樂園入場券', '活動門票', 35, 1, '所有遊樂設施通行證', '提前48小時可退票'),
    ('飛機票', '機票', 200, 1, '經濟艙座位，有效期至2024年1月', '不退票');

-- 插入 Order_Status（訂單狀態）
INSERT INTO [dbo].[Order_Status] 
    ([OS_OrderStatus])
VALUES
    (N'待付款'),
    (N'已付款'),
    (N'已取消'),
    (N'已完成');

-- 插入 Payment_Status（付款狀態）
INSERT INTO [dbo].[Payment_Status] 
    ([payment_Status])
VALUES
    (N'待付款'),
    (N'已付款'),
    (N'Failed'),
    (N'退款中'),
    (N'已退款'),
    (N'已逾期');

-- 插入 Payment_Method（付款方式）
INSERT INTO [dbo].[Payment_Method] 
    ([payment_Method], [payment_MethodCode])
VALUES
    (N'信用卡', 'Credit'),
    (N'ATM 轉帳', 'ATM'),
    (N'超商代碼', 'CVS');

-- 插入 Order（訂單） - 100 筆資料
SET @i = 1;
WHILE @i <= 100
BEGIN
    DECLARE @OrderTime DATETIME = DATEADD(DAY, -CAST(RAND() * 365 AS INT), '2025-02-21'); -- 隨機分散在一年內
    DECLARE @UserId INT = CAST(RAND() * 499 + 1 AS INT); -- 隨機選擇 1-500 的 User_ID
    DECLARE @OrderStatus INT = CAST(RAND() * 4 + 1 AS INT); -- 1-4 隨機狀態
    DECLARE @PaymentStatus INT = CASE 
                                    WHEN @OrderStatus = 1 THEN 1 -- 待付款
                                    WHEN @OrderStatus = 2 THEN 2 -- 已付款
                                    WHEN @OrderStatus = 3 THEN 3 -- 已取消
                                    WHEN @OrderStatus = 4 THEN 2 -- 已完成
                                 END;
    DECLARE @TotalAmount DECIMAL(10,2) = CAST(RAND() * 9900 + 100 AS DECIMAL(10,2)); -- 100-10000 隨機金額
    DECLARE @TradeNo VARCHAR(50) = 'ORD' + FORMAT(@OrderTime, 'yyyyMMddHHmmss') + RIGHT('000' + CAST(@i AS VARCHAR(3)), 3);

    INSERT INTO [dbo].[Order] 
        ([merchant_TradeNo], [order_Time], [order_TotalAmount], [delete_at], [user_Id], [order_Status], [order_PaymentStatus])
    VALUES 
        (@TradeNo, @OrderTime, @TotalAmount, NULL, @UserId, @OrderStatus, @PaymentStatus);

    SET @i = @i + 1;
END;

-- 插入 Payment（付款紀錄） - 100 筆資料
SET @i = 1;
WHILE @i <= 100
BEGIN
    DECLARE @OrderRowId INT = @i; -- 對應 Order 的 order_Id
    DECLARE @PaymentMethod INT = CAST(RAND() * 3 + 1 AS INT); -- 1-3 隨機付款方式
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

-- 插入 Tour_Bundles（套裝行程）
INSERT INTO [dbo].[Tour_Bundles] 
    ([eventName], [startingPoint], [destination], [firstDate], [lastDate], [duration], [price], [eventDescription], [ratings], [contactInfo])
VALUES 
    ('海島奇遇之旅', '台北', '巴里島', '2025-02-01', '2025-02-07', 7, 30000, '體驗巴里島的陽光與沙灘，享受精緻的海景別墅與當地文化風情。', 5, '0912345678'),
    ('文化遺產探索', '高雄', '京都', '2025-03-10', '2025-03-15', 6, 25000, '探索日本京都的古老文化與傳統，參觀世界遺產清水寺、金閣寺等景點。', 4, '0922334455'),
    ('美西公路之旅', '洛杉磯', '舊金山', '2025-04-01', '2025-04-10', 10, 50000, '沿著加州一號公路駕車，享受壯麗的海岸風光與多樣的城市魅力。', 5, '0933445566'),
    ('北歐極光探險', '斯德哥爾摩', '羅瓦涅米', '2025-12-01', '2025-12-07', 7, 70000, '追尋神秘的北極光，體驗冰雪世界的魅力，參觀薩米文化村與極地動物園。', 5, '0944556677'),
    ('大自然的呼喚', '台中', '花蓮', '2025-05-15', '2025-05-17', 3, 8000, '探索太魯閣國家公園的壯麗峽谷與絕美山景，享受原住民美食與文化。', 4, '0955667788'),
    ('法國浪漫假期', '巴黎', '尼斯', '2025-06-01', '2025-06-08', 8, 60000, '遊覽法國經典景點，享受地中海沿岸的陽光與美食。', 5, '0966778899'),
    ('美味義大利之旅', '羅馬', '佛羅倫斯', '2025-07-01', '2025-07-07', 7, 55000, '深入義大利的美食與藝術文化，參觀經典景點如羅馬競技場與比薩斜塔。', 4, '0977889900'),
    ('澳洲生態探險', '雪梨', '大堡礁', '2025-08-10', '2025-08-17', 8, 68000, '探索大堡礁的美麗海底世界，體驗澳洲特有的自然與野生動物。', 5, '0988990011'),
    ('阿爾卑斯山滑雪假期', '日內瓦', '采爾馬特', '2025-12-20', '2025-12-27', 8, 80000, '在阿爾卑斯山盡情滑雪，享受溫暖的木屋與當地特色餐飲。', 5, '0999001122'),
    ('中東沙漠探秘', '杜拜', '阿布達比', '2025-11-01', '2025-11-05', 5, 40000, '體驗沙漠越野、騎駱駝與阿拉伯文化的熱情與奢華。', 4, '0900112233'),
    ('東歐古城巡禮', '布拉格', '布達佩斯', '2025-09-01', '2025-09-10', 10, 45000, '遊覽東歐古城的歷史與建築美學，品味當地的特色美食。', 5, '0911223344'),
    ('印象西藏', '成都', '拉薩', '2025-10-01', '2025-10-07', 7, 32000, '深入西藏的神秘與壯麗，參觀布達拉宮與珠穆朗瑪峰。', 4, '0922334455'),
    ('南極探險', '布宜諾斯艾利斯', '南極半島', '2025-12-15', '2026-01-01', 18, 200000, '探索地球最南端的極地風光，見證南極的純粹與壯美。', 5, '0933445566'),
    ('加勒比海豪華郵輪', '邁阿密', '牙買加', '2025-07-01', '2025-07-10', 10, 120000, '搭乘豪華郵輪遊覽加勒比海，享受各種娛樂設施與精緻美食。', 5, '0944556677'),
    ('韓國美妝購物之旅', '台北', '首爾', '2025-06-15', '2025-06-18', 4, 15000, '體驗韓國美妝與時尚購物，探索熱門景點如明洞與弘大。', 4, '0955667788');
GO