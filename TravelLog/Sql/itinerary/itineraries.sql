


CREATE TABLE itineraries (
    id INT IDENTITY(1,1) PRIMARY KEY, -- �D��A�۰ʻ��W
    name VARCHAR(255) NOT NULL,       -- ��{�W��
    address TEXT NOT NULL,            -- ��{�a�}
    latitude FLOAT NOT NULL,          -- �n��
    longitude FLOAT NOT NULL,         -- �g��
    created_at DATETIME DEFAULT GETDATE() -- �إ߮ɶ��A�w�]����e�ɶ�
);