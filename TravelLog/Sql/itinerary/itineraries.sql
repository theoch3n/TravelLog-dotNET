


CREATE TABLE itineraries (
    id INT IDENTITY(1,1) PRIMARY KEY, -- 主鍵，自動遞增
    name VARCHAR(255) NOT NULL,       -- 行程名稱
    address TEXT NOT NULL,            -- 行程地址
    latitude FLOAT NOT NULL,          -- 緯度
    longitude FLOAT NOT NULL,         -- 經度
    created_at DATETIME DEFAULT GETDATE() -- 建立時間，預設為當前時間
);