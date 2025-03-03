-- 刪除資料但保留表結構
-- 手動重設欄位值
--DELETE FROM Itinerary_Price;
--DBCC CHECKIDENT ('Itinerary_Price', RESEED, 0);
--
--DELETE FROM place_detail;
--DBCC CHECKIDENT ('place_detail', RESEED, 0);
--
--DELETE FROM place;
--DBCC CHECKIDENT ('place', RESEED, 0);
--
--DELETE FROM place_Image;
--DBCC CHECKIDENT ('place_Image', RESEED, 0);
--
----行程表要在最後
--DELETE FROM itinerary;
--DBCC CHECKIDENT ('itinerary', RESEED, 0);


INSERT INTO [dbo].[Itinerary] (Itinerary_Title, Itinerary_Location, Itinerary_Coordinate, Itinerary_Image, Itinerary_StartDate, Itinerary_EndDate, Itinerary_CreateUser, Itinerary_CreateDate)
VALUES
-- 三天兩夜行程
('台北文化之旅', '台北', '25.0330,121.5654', 'https://example.com/image1.jpg', '2025-03-05', '2025-03-07', 1, GETDATE()),
('宜蘭溫泉之旅', '宜蘭', '24.7021,121.7378', 'https://example.com/image2.jpg', '2025-03-10', '2025-03-12', 2, GETDATE()),
('台中美食探險', '台中', '24.1477,120.6736', 'https://example.com/image3.jpg', '2025-03-15', '2025-03-17', 3, GETDATE()),
('南投山林漫遊', '南投', '23.9090,120.6847', 'https://example.com/image4.jpg', '2025-03-20', '2025-03-22', 4, GETDATE()),
('花蓮海岸之旅', '花蓮', '23.9739,121.6113', 'https://example.com/image5.jpg', '2025-03-25', '2025-03-27', 5, GETDATE())



--———————————————————————————————————————————————————————

-- 台北文化之旅 (2025-03-05 至 2025-03-07)
-- 2025-03-05
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-05', 1, '國立故宮博物院', '台北市士林區至善路二段221號', 25.1024, 121.5485, 'https://example.com/place1.jpg', '5'),
('2025-03-05', 1, '陽明山國家公園', '台北市北投區', 25.1665, 121.5523, 'https://example.com/place2.jpg', '4'),
('2025-03-05', 1, '西門町', '台北市萬華區', 25.0421, 121.5086, 'https://example.com/place3.jpg', '4'),
('2025-03-05', 1, '台北101', '台北市信義區信義路五段7號', 25.0330, 121.5654, 'https://example.com/place4.jpg', '5'),
('2025-03-05', 1, '台北喜來登大飯店', '台北市中正區忠孝東路一段12號', 25.0446, 121.5319, 'https://example.com/place5.jpg', '5');

-- 2025-03-06
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-06', 1, '台北車站', '台北市中正區', 25.0478, 121.5170, 'https://example.com/place6.jpg', '4'),
('2025-03-06', 1, '松山文創園區', '台北市信義區', 25.0335, 121.5652, 'https://example.com/place7.jpg', '4'),
('2025-03-06', 1, '士林夜市', '台北市士林區', 25.0875, 121.5239, 'https://example.com/place8.jpg', '4'),
('2025-03-06', 1, '淡水老街', '新北市淡水區', 25.1742, 121.4415, 'https://example.com/place9.jpg', '5'),
('2025-03-06', 1, '台北喜來登大飯店', '台北市中正區忠孝東路一段12號', 25.0446, 121.5319, 'https://example.com/place10.jpg', '5');

-- 2025-03-07
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-07', 1, '台北車站', '台北市中正區', 25.0478, 121.5170, 'https://example.com/place6.jpg', '4'),
('2025-03-07', 1, '松山文創園區', '台北市信義區', 25.0335, 121.5652, 'https://example.com/place7.jpg', '4'),
('2025-03-07', 1, '士林夜市', '台北市士林區', 25.0875, 121.5239, 'https://example.com/place8.jpg', '4'),
('2025-03-07', 1, '淡水老街', '新北市淡水區', 25.1742, 121.4415, 'https://example.com/place9.jpg', '5'),
('2025-03-07', 1, '台北喜來登大飯店', '台北市中正區忠孝東路一段12號', 25.0446, 121.5319, 'https://example.com/place10.jpg', '5');

-- 宜蘭溫泉之旅 (2025-03-10 至 2025-03-12)
-- 2025-03-10
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-10', 2, '宜蘭傳藝中心', '宜蘭縣冬山鄉', 24.6887, 121.7469, 'https://example.com/place11.jpg', '5'),
('2025-03-10', 2, '礁溪溫泉', '宜蘭縣礁溪鄉', 24.9536, 121.7815, 'https://example.com/place12.jpg', '4'),
('2025-03-10', 2, '宜蘭夜市', '宜蘭市', 24.7511, 121.7447, 'https://example.com/place13.jpg', '4'),
('2025-03-10', 2, '羅東林業文化園區', '宜蘭縣羅東鎮', 24.6819, 121.7844, 'https://example.com/place14.jpg', '5'),
('2025-03-10', 2, '礁溪老爺酒店', '宜蘭縣礁溪鄉', 24.9389, 121.7758, 'https://example.com/place15.jpg', '5');

-- 2025-03-11
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-11', 2, '宜蘭傳藝中心', '宜蘭縣冬山鄉', 24.6887, 121.7469, 'https://example.com/place11.jpg', '5'),
('2025-03-11', 2, '礁溪溫泉', '宜蘭縣礁溪鄉', 24.9536, 121.7815, 'https://example.com/place12.jpg', '4'),
('2025-03-11', 2, '宜蘭夜市', '宜蘭市', 24.7511, 121.7447, 'https://example.com/place13.jpg', '4'),
('2025-03-11', 2, '羅東林業文化園區', '宜蘭縣羅東鎮', 24.6819, 121.7844, 'https://example.com/place14.jpg', '5'),
('2025-03-11', 2, '礁溪老爺酒店', '宜蘭縣礁溪鄉', 24.9389, 121.7758, 'https://example.com/place15.jpg', '5');

-- 2025-03-12
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-12', 2, '宜蘭傳藝中心', '宜蘭縣冬山鄉', 24.6887, 121.7469, 'https://example.com/place11.jpg', '5'),
('2025-03-12', 2, '礁溪溫泉', '宜蘭縣礁溪鄉', 24.9536, 121.7815, 'https://example.com/place12.jpg', '4'),
('2025-03-12', 2, '宜蘭夜市', '宜蘭市', 24.7511, 121.7447, 'https://example.com/place13.jpg', '4'),
('2025-03-12', 2, '羅東林業文化園區', '宜蘭縣羅東鎮', 24.6819, 121.7844, 'https://example.com/place14.jpg', '5'),
('2025-03-12', 2, '礁溪老爺酒店', '宜蘭縣礁溪鄉', 24.9389, 121.7758, 'https://example.com/place15.jpg', '5');

-- 台中美食探險 (2025-03-15 至 2025-03-17)
-- 2025-03-15
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-15', 3, '逢甲夜市', '台中市西屯區', 24.1828, 120.6426, 'https://example.com/place16.jpg', '5'),
('2025-03-15', 3, '台中公園', '台中市南區', 24.1465, 120.6735, 'https://example.com/place17.jpg', '4'),
('2025-03-15', 3, '草悟道', '台中市西區', 24.1462, 120.6753, 'https://example.com/place18.jpg', '5'),
('2025-03-15', 3, '國立自然科學博物館', '台中市南區', 24.1471, 120.6830, 'https://example.com/place19.jpg', '5'),
('2025-03-15', 3, '台中火車站', '台中市中區', 24.1381, 120.6869, 'https://example.com/place20.jpg', '4');

-- 2025-03-16
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-16', 3, '逢甲夜市', '台中市西屯區', 24.1828, 120.6426, 'https://example.com/place16.jpg', '5'),
('2025-03-16', 3, '台中公園', '台中市南區', 24.1465, 120.6735, 'https://example.com/place17.jpg', '4'),
('2025-03-16', 3, '草悟道', '台中市西區', 24.1462, 120.6753, 'https://example.com/place18.jpg', '5'),
('2025-03-16', 3, '國立自然科學博物館', '台中市南區', 24.1471, 120.6830, 'https://example.com/place19.jpg', '5'),
('2025-03-16', 3, '台中火車站', '台中市中區', 24.1381, 120.6869, 'https://example.com/place20.jpg', '4');

-- 2025-03-17
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-17', 3, '逢甲夜市', '台中市西屯區', 24.1828, 120.6426, 'https://example.com/place16.jpg', '5'),
('2025-03-17', 3, '台中公園', '台中市南區', 24.1465, 120.6735, 'https://example.com/place17.jpg', '4'),
('2025-03-17', 3, '草悟道', '台中市西區', 24.1462, 120.6753, 'https://example.com/place18.jpg', '5'),
('2025-03-17', 3, '國立自然科學博物館', '台中市南區', 24.1471, 120.6830, 'https://example.com/place19.jpg', '5'),
('2025-03-17', 3, '台中火車站', '台中市中區', 24.1381, 120.6869, 'https://example.com/place20.jpg', '4');



--南投山林漫遊（2025-03-20 至 2025-03-22）
-- 2025-03-20
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-20', 4, '日月潭', '南投縣魚池鄉日月潭', 23.8551, 120.9283, 'https://example.com/place1.jpg', '5'),
('2025-03-20', 4, '溪頭自然教育園區', '南投縣鹿谷鄉', 23.7811, 120.8456, 'https://example.com/place2.jpg', '4'),
('2025-03-20', 4, '集集車站', '南投縣集集鎮', 23.8691, 120.7915, 'https://example.com/place3.jpg', '4'),
('2025-03-20', 4, '南投森林遊樂區', '南投縣仁愛鄉', 23.5421, 120.9247, 'https://example.com/place4.jpg', '5'),
('2025-03-20', 4, '武嶺飯店', '南投縣仁愛鄉', 23.5418, 120.9385, 'https://example.com/place5.jpg', '5');

-- 2025-03-21
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-21', 4, '日月潭纜車', '南投縣魚池鄉日月潭', 23.8530, 120.9301, 'https://example.com/place6.jpg', '4'),
('2025-03-21', 4, '松瀧瀑布', '南投縣魚池鄉', 23.8515, 120.9154, 'https://example.com/place7.jpg', '4'),
('2025-03-21', 4, '清境農場', '南投縣仁愛鄉', 24.0174, 121.1556, 'https://example.com/place8.jpg', '5'),
('2025-03-21', 4, '合歡山', '南投縣仁愛鄉', 24.1122, 121.2674, 'https://example.com/place9.jpg', '5'),
('2025-03-21', 4, '清境維納斯酒店', '南投縣仁愛鄉', 24.0185, 121.1564, 'https://example.com/place10.jpg', '4');

-- 2025-03-22
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-22', 4, '達觀山', '南投縣仁愛鄉', 23.9736, 120.8751, 'https://example.com/place11.jpg', '5'),
('2025-03-22', 4, '內湖國小步道', '南投縣草屯鎮', 23.9602, 120.7061, 'https://example.com/place12.jpg', '4'),
('2025-03-22', 4, '台大草地', '南投縣南投市', 23.9765, 120.6883, 'https://example.com/place13.jpg', '4'),
('2025-03-22', 4, '原住民文化村', '南投縣魚池鄉', 23.8714, 120.9279, 'https://example.com/place14.jpg', '4'),
('2025-03-22', 4, '日月潭大飯店', '南投縣魚池鄉', 23.8600, 120.9305, 'https://example.com/place15.jpg', '5');



--花蓮海岸之旅（2025-03-25 至 2025-03-27）
-- 2025-03-25
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-25', 5, '花蓮海洋公園', '花蓮縣壽豐鄉', 23.9881, 121.5994, 'https://example.com/place16.jpg', '5'),
('2025-03-25', 5, '七星潭', '花蓮縣花蓮市', 23.9750, 121.6112, 'https://example.com/place17.jpg', '5'),
('2025-03-25', 5, '東大門夜市', '花蓮縣花蓮市', 23.9804, 121.6040, 'https://example.com/place18.jpg', '4'),
('2025-03-25', 5, '花蓮文化創意產業園區', '花蓮縣花蓮市', 23.9775, 121.6073, 'https://example.com/place19.jpg', '5'),
('2025-03-25', 5, '花蓮夢想家旅店', '花蓮縣花蓮市', 23.9762, 121.6125, 'https://example.com/place20.jpg', '4');

-- 2025-03-26
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-26', 5, '太魯閣國家公園', '花蓮縣秀林鄉', 24.1558, 121.6184, 'https://example.com/place21.jpg', '5'),
('2025-03-26', 5, '長春祠', '花蓮縣秀林鄉', 24.1634, 121.6073, 'https://example.com/place22.jpg', '5'),
('2025-03-26', 5, '砂卡礑步道', '花蓮縣秀林鄉', 24.1550, 121.6160, 'https://example.com/place23.jpg', '4'),
('2025-03-26', 5, '花蓮火車站', '花蓮縣花蓮市', 23.9730, 121.6070, 'https://example.com/place24.jpg', '4'),
('2025-03-26', 5, '花蓮金針花園', '花蓮縣光復鄉', 23.9450, 121.6067, 'https://example.com/place25.jpg', '5');

-- 2025-03-27
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-03-27', 5, '海洋公園', '花蓮縣壽豐鄉', 23.9881, 121.5994, 'https://example.com/place26.jpg', '5'),
('2025-03-27', 5, '瑞穗牧場', '花蓮縣瑞穗鄉', 23.4503, 121.5521, 'https://example.com/place27.jpg', '4'),
('2025-03-27', 5, '富里櫻花步道', '花蓮縣富里鄉', 23.5117, 121.3555, 'https://example.com/place28.jpg', '4'),
('2025-03-27', 5, '花蓮廟口夜市', '花蓮縣花蓮市', 23.9810, 121.6100, 'https://example.com/place29.jpg', '4'),
('2025-03-27', 5, '華東飯店', '花蓮縣花蓮市', 23.9762, 121.6105, 'https://example.com/place30.jpg', '5');



-------以上是三天兩夜








-- 國外行程 (日本、韓國、美國)
INSERT INTO [dbo].[Itinerary] (Itinerary_Title, Itinerary_Location, Itinerary_Coordinate, Itinerary_Image, Itinerary_StartDate, Itinerary_EndDate, Itinerary_CreateUser, Itinerary_CreateDate)
VALUES
('東京文化探索', '東京', '35.682839,139.759455', 'https://example.com/image21.jpg', '2025-07-01', '2025-07-05', 21, GETDATE()),
('大阪美食之旅', '大阪', '34.6937,135.5023', 'https://example.com/image22.jpg', '2025-07-10', '2025-07-14', 22, GETDATE()),
('京都傳統文化遊', '京都', '35.0116,135.7681', 'https://example.com/image23.jpg', '2025-07-15', '2025-07-19', 23, GETDATE()),
('首爾購物與美食', '首爾', '37.5665,126.9780', 'https://example.com/image24.jpg', '2025-08-01', '2025-08-05', 24, GETDATE()),
('釜山海岸假期', '釜山', '35.1796,129.0756', 'https://example.com/image25.jpg', '2025-08-10', '2025-08-14', 25, GETDATE()),
('洛杉磯陽光之旅', '洛杉磯', '34.0522,-118.2437', 'https://example.com/image26.jpg', '2025-09-01', '2025-09-06', 26, GETDATE()),
('紐約城市探索', '紐約', '40.7128,-74.0060', 'https://example.com/image27.jpg', '2025-09-10', '2025-09-15', 27, GETDATE()),
('舊金山灣區巡禮', '舊金山', '37.7749,-122.4194', 'https://example.com/image28.jpg', '2025-09-20', '2025-09-25', 28, GETDATE());


--——————————————————————————————————————————————————————

--東京文化探索（2025-07-01 至 2025-07-05）
-- 2025-07-01 東京文化探索
-- Place
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-01', 6, '淺草寺', '台東區淺草2-3-1', 35.7148, 139.7967, 'https://example.com/place1.jpg', '5'),
('2025-07-01', 6, '東京塔', '港區芝公園4-2-8', 35.6586, 139.7454, 'https://example.com/place2.jpg', '5'),
('2025-07-01', 6, '秋葉原電器街', '千代田區外神田1丁目', 35.7023, 139.7745, 'https://example.com/place3.jpg', '4'),
('2025-07-01', 6, '新宿歌舞伎町', '新宿區歌舞伎町1丁目', 35.6954, 139.7004, 'https://example.com/place4.jpg', '4'),
('2025-07-01', 6, '東京站周邊', '千代田區丸之內', 35.6812, 139.7671, 'https://example.com/place5.jpg', '5');

-- 2025-07-02 東京文化探索
-- Place
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-02', 6, '上野恩賜公園', '台東區上野公園', 35.7138, 139.7770, 'https://example.com/place6.jpg', '5'),
('2025-07-02', 6, '東京迪士尼樂園', '浦安市舞浜1-1', 35.6329, 139.8804, 'https://example.com/place7.jpg', '5'),
('2025-07-02', 6, '原宿竹下通', '渋谷區神宮前1-6-1', 35.6703, 139.7020, 'https://example.com/place8.jpg', '4'),
('2025-07-02', 6, '明治神宮', '渋谷區代代木神園町1-1', 35.6764, 139.6993, 'https://example.com/place9.jpg', '5'),
('2025-07-02', 6, '帝國酒店', '千代田區内幸町1-1-1', 35.6767, 139.7592, 'https://example.com/place10.jpg', '5');

-- 2025-07-03 東京文化探索
-- Place
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-03', 6, '築地市場', '中央區築地5-2-1', 35.6653, 139.7705, 'https://example.com/place11.jpg', '4'),
('2025-07-03', 6, '六本木新城', '港區六本木6-10-1', 35.6580, 139.7305, 'https://example.com/place12.jpg', '5'),
('2025-07-03', 6, '東京國立博物館', '台東區上野公園13-9', 35.7187, 139.7730, 'https://example.com/place13.jpg', '4'),
('2025-07-03', 6, '淺草雷門', '台東區淺草2-3-1', 35.7148, 139.7967, 'https://example.com/place14.jpg', '5'),
('2025-07-03', 6, '麗思卡爾頓東京', '港區赤坂9-7-1', 35.6605, 139.7310, 'https://example.com/place15.jpg', '5');

-- 2025-07-04 東京文化探索
-- Place
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-04', 6, '銀座', '中央區銀座', 35.6733, 139.7632, 'https://example.com/place16.jpg', '5'),
('2025-07-04', 6, '代代木公園', '渋谷區代代木神園町', 35.6744, 139.6981, 'https://example.com/place17.jpg', '4'),
('2025-07-04', 6, '新宿御苑', '新宿區內藤町11', 35.6842, 139.7100, 'https://example.com/place18.jpg', '5'),
('2025-07-04', 6, '表參道', '渋谷區神宮前', 35.6642, 139.7119, 'https://example.com/place19.jpg', '4'),
('2025-07-04', 6, '東京神樂坂', '新宿區神樂坂', 35.7016, 139.7325, 'https://example.com/place20.jpg', '5');

-- 2025-07-05 東京文化探索 (結尾日期)
-- Place
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-05', 6, '東京迪士尼海洋', '浦安市舞浜1-13', 35.6273, 139.8804, 'https://example.com/place21.jpg', '5'),
('2025-07-05', 6, '羽田機場', '東京市大田區羽田空港3-3-2', 35.5494, 139.7798, 'https://example.com/place22.jpg', '4'),
('2025-07-05', 6, '東京國際論壇', '千代田區丸之內3-5-1', 35.6703, 139.7598, 'https://example.com/place23.jpg', '4'),
('2025-07-05', 6, '新橋', '港區新橋', 35.6653, 139.7597, 'https://example.com/place24.jpg', '5'),
('2025-07-05', 6, '東京新宿王子飯店', '新宿區歌舞伎町1-1-1', 35.6905, 139.7037, 'https://example.com/place25.jpg', '5');


--大阪美食之旅（2025-07-10 至 2025-07-14）
-- 2025-07-01
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-01', 7, '淺草寺', '台東區淺草2-3-1', 35.7148, 139.7967, 'https://example.com/place1.jpg', '5'),
('2025-07-01', 7, '東京塔', '港區芝公園4-2-8', 35.6586, 139.7454, 'https://example.com/place2.jpg', '5'),
('2025-07-01', 7, '秋葉原電器街', '千代田區外神田1丁目', 35.7023, 139.7745, 'https://example.com/place3.jpg', '4'),
('2025-07-01', 7, '新宿歌舞伎町', '新宿區歌舞伎町1丁目', 35.6954, 139.7004, 'https://example.com/place4.jpg', '4'),
('2025-07-01', 7, '東京站周邊', '千代田區丸之內', 35.6812, 139.7671, 'https://example.com/place5.jpg', '5');

-- 2025-07-02
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-02', 7, '上野恩賜公園', '台東區上野公園', 35.7138, 139.7770, 'https://example.com/place6.jpg', '5'),
('2025-07-02', 7, '東京迪士尼樂園', '浦安市舞浜1-1', 35.6329, 139.8804, 'https://example.com/place7.jpg', '5'),
('2025-07-02', 7, '原宿竹下通', '渋谷區神宮前1-6-1', 35.6703, 139.7020, 'https://example.com/place8.jpg', '4'),
('2025-07-02', 7, '明治神宮', '渋谷區代代木神園町1-1', 35.6764, 139.6993, 'https://example.com/place9.jpg', '5'),
('2025-07-02', 7, '帝國酒店', '千代田區内幸町1-1-1', 35.6767, 139.7592, 'https://example.com/place10.jpg', '5');

-- 2025-07-03
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-03', 7, '築地市場', '中央區築地5-2-1', 35.6653, 139.7705, 'https://example.com/place11.jpg', '4'),
('2025-07-03', 7, '六本木新城', '港區六本木6-10-1', 35.6580, 139.7305, 'https://example.com/place12.jpg', '5'),
('2025-07-03', 7, '東京國立博物館', '台東區上野公園13-9', 35.7187, 139.7730, 'https://example.com/place13.jpg', '4'),
('2025-07-03', 7, '淺草雷門', '台東區淺草2-3-1', 35.7148, 139.7967, 'https://example.com/place14.jpg', '5'),
('2025-07-03', 7, '麗思卡爾頓東京', '港區赤坂9-7-1', 35.6605, 139.7310, 'https://example.com/place15.jpg', '5');

-- 2025-07-04
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-04', 7, '銀座', '中央區銀座', 35.6733, 139.7632, 'https://example.com/place16.jpg', '5'),
('2025-07-04', 7, '代代木公園', '渋谷區代代木神園町', 35.6744, 139.6981, 'https://example.com/place17.jpg', '4'),
('2025-07-04', 7, '新宿御苑', '新宿區內藤町11', 35.6842, 139.7100, 'https://example.com/place18.jpg', '5'),
('2025-07-04', 7, '表參道', '渋谷區神宮前', 35.6642, 139.7119, 'https://example.com/place19.jpg', '4'),
('2025-07-04', 7, '東京神樂坂', '新宿區神樂坂', 35.7016, 139.7325, 'https://example.com/place20.jpg', '5');

-- 2025-07-05 (結尾日期)
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-05', 7, '東京迪士尼海洋', '浦安市舞浜1-13', 35.6273, 139.8804, 'https://example.com/place21.jpg', '5'),
('2025-07-05', 7, '羽田機場', '東京市大田區羽田空港3-3-2', 35.5494, 139.7798, 'https://example.com/place22.jpg', '4'),
('2025-07-05', 7, '東京國際論壇', '千代田區丸之內3-5-1', 35.6703, 139.7598, 'https://example.com/place23.jpg', '4'),
('2025-07-05', 7, '新橋', '港區新橋', 35.6653, 139.7597, 'https://example.com/place24.jpg', '5'),
('2025-07-05', 7, '東京新宿王子飯店', '新宿區歌舞伎町1-1-1', 35.6905, 139.7037, 'https://example.com/place25.jpg', '5');







--京都傳統文化遊（2025-07-15 至 2025-07-19）

-- 2025-07-15
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-15', 8, '金閣寺', '京都市北區金閣寺町1', 35.0394, 135.7292, 'https://example.com/place1.jpg', '5'),
('2025-07-15', 8, '清水寺', '京都市東山區清水1-294', 35.0056, 135.7850, 'https://example.com/place2.jpg', '5'),
('2025-07-15', 8, '伏見稻荷大社', '京都市伏見區深草薭町68', 35.0248, 135.7483, 'https://example.com/place3.jpg', '5'),
('2025-07-15', 8, '嵐山', '京都市右京區嵐山', 35.0133, 135.6773, 'https://example.com/place4.jpg', '5'),
('2025-07-15', 8, '祇園', '京都市東山區祇園町', 35.0036, 135.7782, 'https://example.com/place5.jpg', '5');

-- 2025-07-16
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-16', 8, '二年坂三年坂', '京都市東山區', 35.0033, 135.7802, 'https://example.com/place6.jpg', '4'),
('2025-07-16', 8, '銀閣寺', '京都市左京區銀閣寺町2', 35.0260, 135.7803, 'https://example.com/place7.jpg', '5'),
('2025-07-16', 8, '京都塔', '京都市下京區烏丸通七條下る東塩小路町', 35.0035, 135.7588, 'https://example.com/place8.jpg', '4'),
('2025-07-16', 8, '京都御苑', '京都市上京區京都御苑', 35.0276, 135.7710, 'https://example.com/place9.jpg', '5'),
('2025-07-16', 8, '三十三間堂', '京都市東山區三十三間堂廻廊', 35.0113, 135.7677, 'https://example.com/place10.jpg', '5');

-- 2025-07-17
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-17', 8, '京都金山寺', '京都市伏見區深草谷口町8-1', 35.0055, 135.7567, 'https://example.com/place11.jpg', '4'),
('2025-07-17', 8, '東福寺', '京都市東山區東福寺', 35.0169, 135.7856, 'https://example.com/place12.jpg', '5'),
('2025-07-17', 8, '八坂神社', '京都市東山區八坂鳥居前東入', 35.0031, 135.7774, 'https://example.com/place13.jpg', '4'),
('2025-07-17', 8, '西本願寺', '京都市下京區堀川通五条下る', 35.0124, 135.7465, 'https://example.com/place14.jpg', '5'),
('2025-07-17', 8, '京都市動物園', '京都市左京區岡崎法勝寺町', 35.0081, 135.7861, 'https://example.com/place15.jpg', '4');

-- 2025-07-18
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-18', 8, '京都博物館', '京都市東山區茶屋町2', 35.0225, 135.7775, 'https://example.com/place16.jpg', '5'),
('2025-07-18', 8, '南禪寺', '京都市左京區南禪寺町', 35.0030, 135.7811, 'https://example.com/place17.jpg', '5'),
('2025-07-18', 8, '東大路', '京都市東山區東大路', 35.0000, 135.7732, 'https://example.com/place18.jpg', '4'),
('2025-07-18', 8, '平安神宮', '京都市左京區平安神宮', 35.0283, 135.7807, 'https://example.com/place19.jpg', '5'),
('2025-07-18', 8, '金閣寺前飯店', '京都市北區金閣寺町1', 35.0394, 135.7292, 'https://example.com/place20.jpg', '5');

-- 2025-07-19 (結尾日期)
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-07-19', 8, '大德寺', '京都市北區大徳寺町1', 35.0398, 135.7681, 'https://example.com/place21.jpg', '5'),
('2025-07-19', 8, '北野天滿宮', '京都市上京區馬喰町', 35.0279, 135.7432, 'https://example.com/place22.jpg', '5'),
('2025-07-19', 8, '京都市美術館', '京都市左京區岡崎公園', 35.0161, 135.7802, 'https://example.com/place23.jpg', '5'),
('2025-07-19', 8, '京都站', '京都市南區東九條下殿田町', 35.0116, 135.7681, 'https://example.com/place24.jpg', '5'),
('2025-07-19', 8, '京都餐廳', '京都市中京區', 35.0116, 135.7681, 'https://example.com/place25.jpg', '5');



--首爾購物與美食（2025-08-01 至 2025-08-05）
-- 2025-08-01
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-01', 9, '明洞', '首爾中區明洞', 37.5665, 126.9780, 'https://example.com/place1.jpg', '5'),
('2025-08-01', 9, '南山塔', '首爾中區南山公園', 37.5512, 126.9882, 'https://example.com/place2.jpg', '5'),
('2025-08-01', 9, '東大門', '首爾中區東大門', 37.5710, 127.0074, 'https://example.com/place3.jpg', '4'),
('2025-08-01', 9, '景福宮', '首爾鍾路區世宗路1-1', 37.5779, 126.9768, 'https://example.com/place4.jpg', '5'),
('2025-08-01', 9, '弘大', '首爾麻浦區弘大', 37.5497, 126.9213, 'https://example.com/place5.jpg', '5');

-- 2025-08-02
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-02', 9, '韓國戰爭紀念館', '首爾龍山區三一大路2', 37.5374, 126.9819, 'https://example.com/place6.jpg', '5'),
('2025-08-02', 9, '梨花女子大學', '首爾西大門區梨花女子大學', 37.5537, 126.9354, 'https://example.com/place7.jpg', '4'),
('2025-08-02', 9, '樂天世界塔', '首爾松坡區高聳路40', 37.5123, 127.1021, 'https://example.com/place8.jpg', '5'),
('2025-08-02', 9, '鐘閣', '首爾鐘路區鐘閣', 37.5651, 126.9779, 'https://example.com/place9.jpg', '4'),
('2025-08-02', 9, '光化門', '首爾鍾路區', 37.5759, 126.9767, 'https://example.com/place10.jpg', '5');

-- 2025-08-03
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-03', 9, '新沙洞', '首爾江南區新沙洞', 37.5162, 127.0200, 'https://example.com/place11.jpg', '5'),
('2025-08-03', 9, '首爾塔', '首爾中區南山公園', 37.5512, 126.9882, 'https://example.com/place12.jpg', '5'),
('2025-08-03', 9, 'COEX商場', '首爾江南區三成洞', 37.5114, 127.0580, 'https://example.com/place13.jpg', '4'),
('2025-08-03', 9, '東大門設計廣場', '首爾東大門區東大門路', 37.5664, 127.0108, 'https://example.com/place14.jpg', '5'),
('2025-08-03', 9, '明洞街頭美食', '首爾中區明洞', 37.5665, 126.9780, 'https://example.com/place15.jpg', '5');

-- 2025-08-04
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-04', 9, '北村韓屋村', '首爾鍾路區北村', 37.5822, 126.9868, 'https://example.com/place16.jpg', '5'),
('2025-08-04', 9, '仁寺洞', '首爾鐘路區仁寺洞', 37.5720, 126.9800, 'https://example.com/place17.jpg', '5'),
('2025-08-04', 9, '昌德宮', '首爾鍾路區昌德宮', 37.5795, 126.9910, 'https://example.com/place18.jpg', '4'),
('2025-08-04', 9, '東大門歷史文化公園', '首爾東大門區', 37.5695, 127.0091, 'https://example.com/place19.jpg', '5'),
('2025-08-04', 9, 'Namsan公園', '首爾中區南山公園', 37.5512, 126.9882, 'https://example.com/place20.jpg', '4');

-- 2025-08-05 (結尾日期)
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-05', 9, '南大門市場', '首爾中區南大門路', 37.5593, 126.9779, 'https://example.com/place21.jpg', '5'),
('2025-08-05', 9, '樂天世界', '首爾松坡區', 37.5123, 127.1021, 'https://example.com/place22.jpg', '5'),
('2025-08-05', 9, '韓國國立博物館', '首爾龍山區', 37.5325, 126.9800, 'https://example.com/place23.jpg', '5'),
('2025-08-05', 9, '韓國首爾塔', '首爾中區', 37.5512, 126.9882, 'https://example.com/place24.jpg', '5'),
('2025-08-05', 9, '明洞購物街', '首爾中區明洞', 37.5665, 126.9780, 'https://example.com/place25.jpg', '5');



--釜山海岸假期（2025-08-10 至 2025-08-14）

-- 2025-08-10
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-10', 10, '海雲台', '釜山海雲台區', 35.1580, 129.1600, 'https://example.com/place1.jpg', '5'),
('2025-08-10', 10, '釜山塔', '釜山市中區', 35.1028, 129.0392, 'https://example.com/place2.jpg', '5'),
('2025-08-10', 10, '甘川文化村', '釜山釜山鎮區', 35.1287, 129.0275, 'https://example.com/place3.jpg', '4'),
('2025-08-10', 10, '釜山水族館', '釜山市海雲台區', 35.1595, 129.1588, 'https://example.com/place4.jpg', '4'),
('2025-08-10', 10, '東萊溫泉', '釜山東萊區', 35.2328, 129.0877, 'https://example.com/place5.jpg', '5');

-- 2025-08-11
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-11', 10, '光復洞', '釜山光復洞', 35.1063, 129.0400, 'https://example.com/place6.jpg', '4'),
('2025-08-11', 10, '西面', '釜山市中區西面', 35.1588, 129.0606, 'https://example.com/place7.jpg', '5'),
('2025-08-11', 10, '釜山博物館', '釜山西區', 35.1475, 129.0392, 'https://example.com/place8.jpg', '5'),
('2025-08-11', 10, '金海海岸', '釜山金海市', 35.1798, 128.8714, 'https://example.com/place9.jpg', '4'),
('2025-08-11', 10, '釜山港', '釜山港', 35.1024, 129.0392, 'https://example.com/place10.jpg', '5');

-- 2025-08-12
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-12', 10, '南浦洞', '釜山市中區南浦洞', 35.0987, 129.0311, 'https://example.com/place11.jpg', '5'),
('2025-08-12', 10, '蓮池公園', '釜山釜山鎮區', 35.1151, 129.0783, 'https://example.com/place12.jpg', '4'),
('2025-08-12', 10, '金剛山', '釜山金剛山', 35.2237, 129.1305, 'https://example.com/place13.jpg', '5'),
('2025-08-12', 10, '廣安大橋', '釜山廣安區', 35.1562, 129.1203, 'https://example.com/place14.jpg', '5'),
('2025-08-12', 10, '釜山美術館', '釜山市海雲台區', 35.1642, 129.1550, 'https://example.com/place15.jpg', '5');

-- 2025-08-13
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-13', 10, '蛇島', '釜山金海市', 35.1460, 128.8767, 'https://example.com/place16.jpg', '5'),
('2025-08-13', 10, '釜山影像博物館', '釜山影像博物館', 35.1790, 129.0700, 'https://example.com/place17.jpg', '4'),
('2025-08-13', 10, '海洋博物館', '釜山市海雲台區', 35.1602, 129.1599, 'https://example.com/place18.jpg', '5'),
('2025-08-13', 10, '釜山大學', '釜山金井區', 35.2285, 129.0777, 'https://example.com/place19.jpg', '4'),
('2025-08-13', 10, '新世界百貨', '釜山釜山鎮區', 35.1300, 129.0402, 'https://example.com/place20.jpg', '5');

-- 2025-08-14 (結尾日期)
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-08-14', 10, '釜山水族館', '釜山市海雲台區', 35.1595, 129.1588, 'https://example.com/place21.jpg', '5'),
('2025-08-14', 10, '釜山大橋', '釜山東區', 35.1043, 129.0571, 'https://example.com/place22.jpg', '5'),
('2025-08-14', 10, '九龍山', '釜山市西區', 35.1228, 129.0410, 'https://example.com/place23.jpg', '4'),
('2025-08-14', 10, '濟州島', '釜山濟州', 33.5097, 126.5213, 'https://example.com/place24.jpg', '5'),
('2025-08-14', 10, '中華文化博物館', '釜山市', 35.1560, 129.0891, 'https://example.com/place25.jpg', '5');



--洛杉磯陽光之旅（2025-09-01 至 2025-09-06）
-- 2025-09-01
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-01', 11, '好萊塢星光大道', '洛杉磯好萊塢', 34.0928, -118.3287, 'https://example.com/place1.jpg', '5'),
('2025-09-01', 11, '聖塔莫尼卡海灘', '洛杉磯聖塔莫尼卡', 34.0226, -118.4957, 'https://example.com/place2.jpg', '5'),
('2025-09-01', 11, '洛杉磯縣藝術博物館', '洛杉磯', 34.0635, -118.3577, 'https://example.com/place3.jpg', '5'),
('2025-09-01', 11, '格里菲斯天文台', '洛杉磯格里菲斯公園', 34.1184, -118.3004, 'https://example.com/place4.jpg', '5'),
('2025-09-01', 11, '洛杉磯市中心', '洛杉磯市中心', 34.0522, -118.2437, 'https://example.com/place5.jpg', '5');

-- 2025-09-02
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-02', 11, '比佛利山莊', '洛杉磯比佛利山莊', 34.0696, -118.4053, 'https://example.com/place6.jpg', '5'),
('2025-09-02', 11, '洛杉磯博物館', '洛杉磯', 34.0696, -118.4053, 'https://example.com/place7.jpg', '5'),
('2025-09-02', 11, '格蘭維爾天使劇院', '洛杉磯', 34.0500, -118.2500, 'https://example.com/place8.jpg', '4'),
('2025-09-02', 11, '洛杉磯動物園', '洛杉磯格里菲斯公園', 34.1341, -118.2874, 'https://example.com/place9.jpg', '4'),
('2025-09-02', 11, '羅賓遜購物中心', '洛杉磯', 34.0800, -118.5000, 'https://example.com/place10.jpg', '5');

-- 2025-09-03
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-03', 11, '拉布雷亞沥青坑', '洛杉磯', 34.0736, -118.3285, 'https://example.com/place11.jpg', '5'),
('2025-09-03', 11, '洛杉磯植物園', '洛杉磯', 34.1397, -118.1517, 'https://example.com/place12.jpg', '4'),
('2025-09-03', 11, '洛杉磯歌劇院', '洛杉磯', 34.0540, -118.2500, 'https://example.com/place13.jpg', '5'),
('2025-09-03', 11, '威尼斯海灘', '洛杉磯', 33.9850, -118.4695, 'https://example.com/place14.jpg', '5'),
('2025-09-03', 11, '洛杉磯科學中心', '洛杉磯', 34.0526, -118.2884, 'https://example.com/place15.jpg', '4');

-- 2025-09-04
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-04', 11, '洛杉磯自然歷史博物館', '洛杉磯', 34.0206, -118.2891, 'https://example.com/place16.jpg', '5'),
('2025-09-04', 11, '西好萊塢', '洛杉磯', 34.0900, -118.3800, 'https://example.com/place17.jpg', '5'),
('2025-09-04', 11, '華特迪士尼音樂廳', '洛杉磯', 34.0575, -118.2500, 'https://example.com/place18.jpg', '5'),
('2025-09-04', 11, '洛杉磯火車站', '洛杉磯', 34.0564, -118.2387, 'https://example.com/place19.jpg', '4'),
('2025-09-04', 11, '洛杉磯國際機場', '洛杉磯', 33.9416, -118.4085, 'https://example.com/place20.jpg', '5');

-- 2025-09-05
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-05', 11, '洛杉磯海洋世界', '洛杉磯', 33.8837, -118.2207, 'https://example.com/place21.jpg', '5'),
('2025-09-05', 11, '格里菲斯公園', '洛杉磯', 34.1367, -118.2953, 'https://example.com/place22.jpg', '5'),
('2025-09-05', 11, '棕櫚泉', '洛杉磯', 33.8225, -116.5405, 'https://example.com/place23.jpg', '4'),
('2025-09-05', 11, '聖佩德羅海灘', '洛杉磯', 33.7398, -118.2910, 'https://example.com/place24.jpg', '5'),
('2025-09-05', 11, '洛杉磯港', '洛杉磯', 33.7360, -118.2743, 'https://example.com/place25.jpg', '5');

-- 2025-09-06（結尾日期）
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-06', 11, '迪士尼樂園', '安那罕', 33.8121, -117.9190, 'https://example.com/place26.jpg', '5'),
('2025-09-06', 11, '安納海姆博物館', '安那罕', 33.8393, -117.9145, 'https://example.com/place27.jpg', '4'),
('2025-09-06', 11, '洛杉磯國際馬術大會', '洛杉磯', 33.9735, -118.2427, 'https://example.com/place28.jpg', '5'),
('2025-09-06', 11, '梅爾羅斯大道', '洛杉磯', 34.0815, -118.2851, 'https://example.com/place29.jpg', '4'),
('2025-09-06', 11, '加州科學中心', '洛杉磯', 34.0162, -118.2850, 'https://example.com/place30.jpg', '5');



-- 紐約城市探索（2025-09-10 至 2025-09-15）
-- 2025-09-10
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-10', 12, '自由女神像', '紐約', 40.6892, -74.0445, 'https://example.com/place1.jpg', '5'),
('2025-09-10', 12, '中央公園', '紐約', 40.7851, -73.9683, 'https://example.com/place2.jpg', '5'),
('2025-09-10', 12, '時代廣場', '紐約', 40.7580, -73.9855, 'https://example.com/place3.jpg', '5'),
('2025-09-10', 12, '帝國大廈', '紐約', 40.748817, -73.985428, 'https://example.com/place4.jpg', '5'),
('2025-09-10', 12, '紐約大都會博物館', '紐約', 40.7792, -73.9634, 'https://example.com/place5.jpg', '5');

-- 2025-09-11
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-11', 12, '洛克菲勒中心', '紐約', 40.7587, -73.9787, 'https://example.com/place6.jpg', '5'),
('2025-09-11', 12, '百老匯劇院', '紐約', 40.7590, -73.9845, 'https://example.com/place7.jpg', '5'),
('2025-09-11', 12, '布魯克林大橋', '紐約', 40.7061, -73.9969, 'https://example.com/place8.jpg', '5'),
('2025-09-11', 12, '第五大道', '紐約', 40.7831, -73.9712, 'https://example.com/place9.jpg', '5'),
('2025-09-11', 12, '大中央車站', '紐約', 40.7527, -73.9772, 'https://example.com/place10.jpg', '5');

-- 2025-09-12
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-12', 12, '世界貿易中心', '紐約', 40.7127, -74.0134, 'https://example.com/place11.jpg', '5'),
('2025-09-12', 12, '紐約公共圖書館', '紐約', 40.7532, -73.9822, 'https://example.com/place12.jpg', '5'),
('2025-09-12', 12, '華爾街', '紐約', 40.7074, -74.0113, 'https://example.com/place13.jpg', '5'),
('2025-09-12', 12, '洛克菲勒廣場', '紐約', 40.7587, -73.9787, 'https://example.com/place14.jpg', '5'),
('2025-09-12', 12, '紐約海濱公園', '紐約', 40.7060, -73.9970, 'https://example.com/place15.jpg', '4');

-- 2025-09-13
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-13', 12, '紐約現代藝術博物館', '紐約', 40.7614, -73.9776, 'https://example.com/place16.jpg', '5'),
('2025-09-13', 12, '蘇荷區', '紐約', 40.7240, -73.9987, 'https://example.com/place17.jpg', '5'),
('2025-09-13', 12, '哈德遜廣場', '紐約', 40.7410, -74.0075, 'https://example.com/place18.jpg', '4'),
('2025-09-13', 12, '新世貿大樓', '紐約', 40.7115, -74.0134, 'https://example.com/place19.jpg', '5'),
('2025-09-13', 12, '華盛頓廣場公園', '紐約', 40.7309, -73.9973, 'https://example.com/place20.jpg', '5');

-- 2025-09-14
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-14', 12, '中央車站', '紐約', 40.7527, -73.9772, 'https://example.com/place21.jpg', '5'),
('2025-09-14', 12, '艾姆斯大廈', '紐約', 40.7480, -73.9848, 'https://example.com/place22.jpg', '5'),
('2025-09-14', 12, '聖約翰大教堂', '紐約', 40.8075, -73.9614, 'https://example.com/place23.jpg', '4'),
('2025-09-14', 12, '帝國大廈觀景台', '紐約', 40.748817, -73.985428, 'https://example.com/place24.jpg', '5'),
('2025-09-14', 12, '格林威治村', '紐約', 40.7323, -73.9973, 'https://example.com/place25.jpg', '5');

-- 2025-09-15（結尾日期）
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-15', 12, '博物館區', '紐約', 40.7792, -73.9634, 'https://example.com/place26.jpg', '5'),
('2025-09-15', 12, '華爾街金融區', '紐約', 40.7074, -74.0113, 'https://example.com/place27.jpg', '5'),
('2025-09-15', 12, '大中央車站', '紐約', 40.7527, -73.9772, 'https://example.com/place28.jpg', '5'),
('2025-09-15', 12, '新世貿大樓', '紐約', 40.7115, -74.0134, 'https://example.com/place29.jpg', '5'),
('2025-09-15', 12, '海港大橋', '紐約', 40.7282, -74.0046, 'https://example.com/place30.jpg', '5');





-- 舊金山灣區巡禮（2025-09-20 至 2025-09-25）
-- 2025-09-20
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-20', 13, '金門大橋', '舊金山', 37.8199, -122.4783, 'https://example.com/place1.jpg', '5'),
('2025-09-20', 13, '漁人碼頭', '舊金山', 37.8080, -122.4177, 'https://example.com/place2.jpg', '5'),
('2025-09-20', 13, '九曲花街', '舊金山', 37.8021, -122.4187, 'https://example.com/place3.jpg', '5'),
('2025-09-20', 13, '舊金山大學', '舊金山', 37.7749, -122.4194, 'https://example.com/place4.jpg', '5'),
('2025-09-20', 13, '金門公園', '舊金山', 37.7694, -122.4862, 'https://example.com/place5.jpg', '5');

-- 2025-09-21
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-21', 13, '加州科學院', '舊金山', 37.7699, -122.4660, 'https://example.com/place6.jpg', '5'),
('2025-09-21', 13, '舊金山藝術宮', '舊金山', 37.7715, -122.4683, 'https://example.com/place7.jpg', '5'),
('2025-09-21', 13, '金門大橋觀景台', '舊金山', 37.8270, -122.4784, 'https://example.com/place8.jpg', '5'),
('2025-09-21', 13, '唐人街', '舊金山', 37.7941, -122.4078, 'https://example.com/place9.jpg', '5'),
('2025-09-21', 13, '舊金山博物館', '舊金山', 37.8044, -122.2711, 'https://example.com/place10.jpg', '5');

-- 2025-09-22
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-22', 13, '斯坦福大學', '舊金山', 37.4275, -122.1697, 'https://example.com/place11.jpg', '5'),
('2025-09-22', 13, '聯合廣場', '舊金山', 37.7879, -122.4074, 'https://example.com/place12.jpg', '5'),
('2025-09-22', 13, '舊金山天際線', '舊金山', 37.7749, -122.4194, 'https://example.com/place13.jpg', '5'),
('2025-09-22', 13, '瑪琳縣', '舊金山', 37.9063, -122.5619, 'https://example.com/place14.jpg', '4'),
('2025-09-22', 13, '萬麗酒店', '舊金山', 37.7833, -122.4167, 'https://example.com/place15.jpg', '5');

-- 2025-09-23
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-23', 13, '舊金山藍鯨博物館', '舊金山', 37.7580, -122.4230, 'https://example.com/place16.jpg', '5'),
('2025-09-23', 13, '舊金山現代藝術博物館', '舊金山', 37.7857, -122.4011, 'https://example.com/place17.jpg', '5'),
('2025-09-23', 13, '舊金山聖瑪麗大教堂', '舊金山', 37.7894, -122.4167, 'https://example.com/place18.jpg', '4'),
('2025-09-23', 13, '馬薩諸塞灣', '舊金山', 37.7749, -122.4194, 'https://example.com/place19.jpg', '5'),
('2025-09-23', 13, '環球影城', '舊金山', 37.7849, -122.4133, 'https://example.com/place20.jpg', '4');

-- 2025-09-24
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-24', 13, '舊金山金門大橋公園', '舊金山', 37.8078, -122.4750, 'https://example.com/place21.jpg', '5'),
('2025-09-24', 13, '貝克海灘', '舊金山', 37.7801, -122.4867, 'https://example.com/place22.jpg', '4'),
('2025-09-24', 13, '金門大橋博物館', '舊金山', 37.8112, -122.4762, 'https://example.com/place23.jpg', '5'),
('2025-09-24', 13, '舊金山城市花園', '舊金山', 37.7661, -122.4232, 'https://example.com/place24.jpg', '5'),
('2025-09-24', 13, '舊金山藝術中心', '舊金山', 37.7722, -122.4190, 'https://example.com/place25.jpg', '4');

-- 2025-09-25（結尾日期）
INSERT INTO [dbo].[Place] (date, scheduleId, Name, Address, Latitude, Longitude, img, rating)
VALUES
('2025-09-25', 13, '聖塔克拉拉大學', '舊金山', 37.3430, -122.0375, 'https://example.com/place26.jpg', '5'),
('2025-09-25', 13, '舊金山灣區鐵路', '舊金山', 37.7707, -122.4664, 'https://example.com/place27.jpg', '5'),
('2025-09-25', 13, '舊金山公共圖書館', '舊金山', 37.7762, -122.4242, 'https://example.com/place28.jpg', '5'),
('2025-09-25', 13, '舊金山音樂劇院', '舊金山', 37.7799, -122.4194, 'https://example.com/place29.jpg', '5'),
('2025-09-25', 13, '舊金山動物園', '舊金山', 37.7338, -122.5050, 'https://example.com/place30.jpg', '4');


--——————————————————建立Place_Detail 表格結構———————————————————



--CREATE TABLE [dbo].[Place_Detail] (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    itinerary_id INT,
--    place_id INT,
--    detail VARCHAR(1000),
--    FOREIGN KEY (itinerary_id) REFERENCES [dbo].[Itinerary](Itinerary_ID),
--    FOREIGN KEY (place_id) REFERENCES [dbo].[Place](id)
--);
-- 插入資料到 Place_Detail 表
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
-- 2025-03-05
(1, 1, '國立故宮博物院，收藏著豐富的中國古代藝術品，是世界四大博物館之一，擁有極高的歷史與文化價值。'),
(1, 2, '陽明山國家公園，擁有美麗的自然景觀及溫泉，是台灣著名的休閒旅遊景點。'),
(1, 3, '西門町，台北的購物與娛樂中心，擁有眾多的商店、餐廳與夜市。'),
(1, 4, '台北101，台灣的地標之一，是世界上最早的超高摩天大樓之一，提供壯觀的城市景觀。'),
(1, 5, '台北喜來登大飯店，位於台北市的中心地帶，提供高端的住宿服務，並擁有多間餐廳與設施。'),

-- 2025-03-06
(1, 6, '台北車站，是台北市最重要的交通樞紐，聯通台灣各大城市，是繁忙的交通中心。'),
(1, 7, '松山文創園區，這裡是藝術、設計和創意的集散地，有許多的藝術展覽和創意市集。'),
(1, 8, '士林夜市，台北最大的夜市之一，是品嘗當地小吃與購物的好地方。'),
(1, 9, '淡水老街，這是台北近郊的歷史街區，擁有美麗的古老建築與多元的台灣小吃。'),
(1, 10, '台北喜來登大飯店，台北的高端酒店之一，提供舒適的住宿與多樣的餐飲選擇。'),

-- 2025-03-07
(1, 11, '台北車站，是台北市最重要的交通樞紐，聯通台灣各大城市，是繁忙的交通中心。'),
(1, 12, '松山文創園區，這裡是藝術、設計和創意的集散地，有許多的藝術展覽和創意市集。'),
(1, 13, '士林夜市，台北最大的夜市之一，是品嘗當地小吃與購物的好地方。'),
(1, 14, '淡水老街，這是台北近郊的歷史街區，擁有美麗的古老建築與多元的台灣小吃。'),
(1, 15, '台北喜來登大飯店，台北的高端酒店之一，提供舒適的住宿與多樣的餐飲選擇。');



--————————————————————————————————————————————————
-- 插入資料到 Place_Detail 表
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
-- 2025-03-10 (宜蘭溫泉之旅)
(2, 16, '宜蘭傳藝中心，是台灣重要的傳統藝術展示場所，讓遊客了解並體驗台灣的民間藝術與文化。'),
(2, 17, '礁溪溫泉，位於宜蘭縣，這裡的溫泉水質清澈、舒適，是放鬆心情、享受自然景觀的理想場所。'),
(2, 18, '宜蘭夜市，是當地的熱鬧聚集地，提供各式各樣的台灣小吃與手工藝品，是宜蘭的特色景點之一。'),
(2, 19, '羅東林業文化園區，是一個融合自然與歷史的景點，展現台灣林業發展的歷史與文化特色。'),
(2, 20, '礁溪老爺酒店，提供高品質的溫泉和住宿服務，是宜蘭地區一個受歡迎的休閒度假場所。'),

-- 2025-03-11 (宜蘭溫泉之旅)
(2, 21, '宜蘭傳藝中心，是台灣重要的傳統藝術展示場所，讓遊客了解並體驗台灣的民間藝術與文化。'),
(2, 22, '礁溪溫泉，位於宜蘭縣，這裡的溫泉水質清澈、舒適，是放鬆心情、享受自然景觀的理想場所。'),
(2, 23, '宜蘭夜市，是當地的熱鬧聚集地，提供各式各樣的台灣小吃與手工藝品，是宜蘭的特色景點之一。'),
(2, 24, '羅東林業文化園區，是一個融合自然與歷史的景點，展現台灣林業發展的歷史與文化特色。'),
(2, 25, '礁溪老爺酒店，提供高品質的溫泉和住宿服務，是宜蘭地區一個受歡迎的休閒度假場所。'),

-- 2025-03-12 (宜蘭溫泉之旅)
(2, 26, '宜蘭傳藝中心，是台灣重要的傳統藝術展示場所，讓遊客了解並體驗台灣的民間藝術與文化。'),
(2, 27, '礁溪溫泉，位於宜蘭縣，這裡的溫泉水質清澈、舒適，是放鬆心情、享受自然景觀的理想場所。'),
(2, 28, '宜蘭夜市，是當地的熱鬧聚集地，提供各式各樣的台灣小吃與手工藝品，是宜蘭的特色景點之一。'),
(2, 29, '羅東林業文化園區，是一個融合自然與歷史的景點，展現台灣林業發展的歷史與文化特色。'),
(2, 30, '礁溪老爺酒店，提供高品質的溫泉和住宿服務，是宜蘭地區一個受歡迎的休閒度假場所。');

--————————————————————————————————————————————


-- 2025-03-15 台中美食探險
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(3, 31, '逢甲夜市，台中著名的夜市之一，擁有各式小吃和購物攤位，是年輕人最愛的聚集地。'),
(3, 32, '台中公園，是市民放鬆的好場所，擁有美麗的湖泊和綠意盎然的步道，非常適合散步和晨跑。'),
(3, 33, '草悟道，融合自然景觀與現代藝術，適合步行和騎行，周圍有許多藝術展覽。'),
(3, 34, '國立自然科學博物館，提供多種科學展示和互動體驗，適合家庭和學生參觀。'),
(3, 35, '台中火車站，台中的主要交通樞紐，擁有歷史建築與現代化設施，方便旅客出入。');

-- 2025-03-16 台中美食探險
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(3, 36, '逢甲夜市，台中著名的夜市之一，擁有各式小吃和購物攤位，是年輕人最愛的聚集地。'),
(3, 37, '台中公園，是市民放鬆的好場所，擁有美麗的湖泊和綠意盎然的步道，非常適合散步和晨跑。'),
(3, 38, '草悟道，融合自然景觀與現代藝術，適合步行和騎行，周圍有許多藝術展覽。'),
(3, 39, '國立自然科學博物館，提供多種科學展示和互動體驗，適合家庭和學生參觀。'),
(3, 40, '台中火車站，台中的主要交通樞紐，擁有歷史建築與現代化設施，方便旅客出入。');

-- 2025-03-17 台中美食探險
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(3, 41, '逢甲夜市，台中著名的夜市之一，擁有各式小吃和購物攤位，是年輕人最愛的聚集地。'),
(3, 42, '台中公園，是市民放鬆的好場所，擁有美麗的湖泊和綠意盎然的步道，非常適合散步和晨跑。'),
(3, 43, '草悟道，融合自然景觀與現代藝術，適合步行和騎行，周圍有許多藝術展覽。'),
(3, 44, '國立自然科學博物館，提供多種科學展示和互動體驗，適合家庭和學生參觀。'),
(3, 45, '台中火車站，台中的主要交通樞紐，擁有歷史建築與現代化設施，方便旅客出入。');

--————————————————————————————————————————————



-- 2025-03-20 南投山林漫遊
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(4, 46, '日月潭，位於南投縣的著名景點，擁有美麗的湖泊和豐富的文化背景，適合乘船遊覽。'),
(4, 47, '溪頭自然教育園區，是一個結合自然生態與教育的園區，適合愛好大自然的人。'),
(4, 48, '集集車站，是台灣重要的鐵道歷史景點之一，提供懷舊的鐵道體驗。'),
(4, 49, '南投森林遊樂區，擁有豐富的自然景觀，是遊客放鬆身心的好地方。'),
(4, 50, '武嶺飯店，位於南投的高山上，提供舒適的住宿和壯麗的山景。');

-- 2025-03-21 南投山林漫遊
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(4, 51, '日月潭纜車，提供壯觀的空中視角，遊客可以俯瞰整個日月潭的美景。'),
(4, 52, '松瀧瀑布，位於日月潭附近，是一道迷人的自然景觀，適合攝影愛好者。'),
(4, 53, '清境農場，擁有美麗的草原和羊群，是親子遊和攝影的好地方。'),
(4, 54, '合歡山，是南投縣著名的登山健行景點之一，提供壯麗的高山風光。'),
(4, 55, '清境維納斯酒店，提供高品質的住宿與舒適的環境，讓遊客享受山中的寧靜。');

-- 2025-03-22 南投山林漫遊
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(4, 56, '達觀山，位於南投仁愛鄉，是登山健行愛好者的好去處，提供壯麗的山景。'),
(4, 57, '內湖國小步道，是一條位於南投草屯鎮的輕鬆步道，適合家庭與老年人。'),
(4, 58, '台大草地，是南投市的放鬆場所，提供舒適的綠地和清新的空氣。'),
(4, 59, '原住民文化村，讓遊客體驗台灣原住民的文化與生活方式，適合全家一起參觀。'),
(4, 60, '日月潭大飯店，擁有美麗的湖景和豪華設施，是享受休閒假期的理想場所。');
--————————————————————————————————————————————



-- 2025-03-25 花蓮海岸之旅
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(5, 61, '花蓮海洋公園，提供豐富的海洋生物展示和各種海洋主題的活動，適合全家遊玩。'),
(5, 62, '七星潭，擁有美麗的海岸線，是放鬆身心、散步和拍照的好地方。'),
(5, 63, '東大門夜市，是花蓮市最著名的夜市之一，提供各式台灣小吃和購物選擇。'),
(5, 64, '花蓮文化創意產業園區，融合藝術與文化創意，定期舉辦展覽和手作市集。'),
(5, 65, '花蓮夢想家旅店，是一個風格獨特的旅館，提供舒適的住宿環境。');

-- 2025-03-26 花蓮海岸之旅
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(5, 66, '太魯閣國家公園，是台灣最著名的國家公園之一，擁有壯麗的山脈與溪谷景觀。'),
(5, 67, '長春祠，是為紀念在建設中央山脈的過程中犧牲的工人而建立的紀念碑，擁有美麗的山景。'),
(5, 68, '砂卡礑步道，擁有迷人的自然景觀，是輕鬆健行的好地方，適合所有年齡層。'),
(5, 69, '花蓮火車站，是花蓮市的重要交通樞紐，外觀古樸，適合拍照和探索周邊的街區。'),
(5, 70, '花蓮金針花園，擁有美麗的金針花田，特別在每年的金針花季節非常受遊客歡迎。');

-- 2025-03-27 花蓮海岸之旅
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(5, 71, '海洋公園，提供豐富的海洋生物體驗，適合親子旅遊。'),
(5, 72, '瑞穗牧場，擁有寬廣的草原和豐富的牧場活動，遊客可以親近動物並享受農村生活。'),
(5, 73, '富里櫻花步道，春天時可以欣賞到美麗的櫻花，是登山健行的好地方。'),
(5, 74, '花蓮廟口夜市，擁有各式各樣的台灣小吃，是體驗當地美食文化的好地方。'),
(5, 75, '華東飯店，提供舒適的住宿環境和優質的服務，是遊客的理想住宿選擇。');

--————————————————————————————————————————————


-- 2025-07-01 東京文化探索
-- Place_Detail
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(6, 76, '淺草寺是東京最著名的寺廟之一，擁有古老的建築和獨特的文化氛圍。'),
(6, 77, '東京塔是東京的地標之一，可以俯瞰整個城市的美麗景色。'),
(6, 78, '秋葉原電器街是電子產品愛好者的天堂，擁有各種電子商品和動漫商品。'),
(6, 79, '新宿歌舞伎町是東京最熱鬧的娛樂區之一，擁有各式餐廳和夜生活場所。'),
(6, 80, '東京站周邊是東京的交通中心，周圍有許多購物和飲食場所，交通十分便利。');

-- 2025-07-02 東京文化探索
-- Place_Detail
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(6, 81, '上野恩賜公園是東京最大的公園之一，擁有美麗的自然景觀和動物園。'),
(6, 82, '東京迪士尼樂園是亞洲最受歡迎的主題樂園之一，擁有各式各樣的遊樂設施。'),
(6, 83, '原宿竹下通是一條擁有眾多流行時尚店和特色餐廳的繁華街道。'),
(6, 84, '明治神宮是一個擁有悠久歷史和文化的神社，是日本文化的象徵之一。'),
(6, 85, '帝國酒店是東京最豪華的五星級酒店之一，擁有優雅的設施和高端的服務。');

-- 2025-07-03 東京文化探索
-- Place_Detail
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(6, 86, '築地市場是世界上最著名的魚市場之一，提供新鮮的海鮮和壽司。'),
(6, 87, '六本木新城是一個集購物、餐飲、娛樂於一體的綜合設施，適合家庭出遊。'),
(6, 88, '東京國立博物館是日本最重要的博物館之一，擁有大量的歷史和文化藏品。'),
(6, 89, '淺草雷門是淺草寺的主要入口，是東京最具代表性的景點之一。'),
(6, 90, '麗思卡爾頓東京是一家奢華的酒店，提供無與倫比的服務和壯觀的城市景色。');

-- 2025-07-04 東京文化探索
-- Place_Detail
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(6, 91, '銀座是東京的高端購物區，擁有許多國際品牌和精品店。'),
(6, 92, '代代木公園是東京最大的公園之一，是人們放鬆和運動的好地方。'),
(6, 93, '新宿御苑是一個廣闊的公園，擁有美麗的花園和自然景觀，適合散步。'),
(6, 94, '表參道是東京的時尚大道，擁有許多流行的品牌店和餐廳。'),
(6, 95, '東京神樂坂是一個擁有日本傳統文化氛圍的區域，並且有許多迷人的小巷。');

-- 2025-07-05 東京文化探索 (結尾日期)
-- Place_Detail
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(6, 96, '東京迪士尼海洋是一個海洋主題的遊樂園，擁有多個精緻的遊樂設施。'),
(6, 97, '羽田機場是東京的主要國際機場之一，擁有先進的設施和無數的商店。'),
(6, 98, '東京國際論壇是一個現代化的會議和展覽中心，擁有先進的設施和開放的空間。'),
(6, 99, '新橋是一個繁忙的商業區，擁有多樣化的餐廳和酒吧，適合下班後放鬆。'),
(6, 100, '東京新宿王子飯店是一家豪華的酒店，提供一流的設施和服務，適合商務或休閒旅行。');


--————————————————————————————————————————————



-- 大阪美食之旅（2025-07-10 至 2025-07-14）

-- 2025-07-01
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(7, 101, '這是一個具有歷史意義的寺廟，是淺草區最著名的旅遊景點之一。'),
(7, 102, '東京塔是一座標誌性的建築，提供壯麗的城市全景。'),
(7, 103, '秋葉原電器街是日本的電子產品和動漫文化中心。'),
(7, 104, '新宿歌舞伎町以夜生活和娛樂場所聞名，是東京的娛樂中心之一。'),
(7, 105, '東京站周邊是東京的交通中心，擁有多座歷史建築與商業區。');

-- 2025-07-02
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(7, 106, '上野恩賜公園是一個擁有大面積綠地與湖泊的公園，適合放鬆與散步。'),
(7, 107, '東京迪士尼樂園是一個家庭友好的主題公園，適合所有年齡層的人。'),
(7, 108, '原宿竹下通是一條以時尚和潮流服飾聞名的購物街。'),
(7, 109, '明治神宮是東京最大的神社之一，充滿了歷史和自然的美麗景觀。'),
(7, 110, '帝國酒店是東京著名的豪華酒店，以其優質服務和設施著稱。');

-- 2025-07-03
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(7, 111, '築地市場是世界著名的海鮮市場，以新鮮的魚類和壽司聞名。'),
(7, 112, '六本木新城是東京的商業與文化中心之一，擁有許多高級餐廳與藝術畫廊。'),
(7, 113, '東京國立博物館展示了日本豐富的歷史和文化遺產。'),
(7, 114, '淺草雷門是淺草寺的入口，擁有巨大的紅色燈籠，是東京的標誌之一。'),
(7, 115, '麗思卡爾頓東京是一家高端酒店，以其奢華的設施和服務吸引了無數遊客。');

-- 2025-07-04
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(7, 116, '銀座是東京最著名的購物和娛樂區之一，擁有世界頂級品牌。'),
(7, 117, '代代木公園是東京的綠洲之一，常常舉辦音樂節和戶外活動。'),
(7, 118, '新宿御苑是一個美麗的公園，擁有大面積的自然景觀與日本傳統的庭園設計。'),
(7, 119, '表參道是東京最具設計感的街道之一，以高端品牌和時尚店鋪為特色。'),
(7, 120, '東京神樂坂是一個具有法國風情的小區，以餐廳和咖啡館聞名。');

-- 2025-07-05
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(7, 121, '東京迪士尼海洋是一個以海洋為主題的奇妙樂園，適合所有年齡層。'),
(7, 122, '羽田機場是東京主要的國際機場，提供便捷的國內外航班連接。'),
(7, 123, '東京國際論壇是一個著名的會議和活動中心，擁有獨特的建築設計。'),
(7, 124, '新橋是東京的一個商業區，周圍擁有許多餐廳和酒吧。'),
(7, 125, '東京新宿王子飯店是一家豪華的酒店，提供優質的住宿和服務。');

--————————————————————————————————————————————




--京都傳統文化遊（2025-07-15 至 2025-07-19）

-- 2025-07-15
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(8, 106, '金閣寺是京都的著名景點之一，以其金色外觀著稱，是日本最具代表性的寺廟之一。'),
(8, 107, '清水寺是京都的世界文化遺產之一，擁有美麗的木造建築和廣闊的景觀。'),
(8, 108, '伏見稻荷大社以成千上萬的紅色鳥居而著名，是日本最具象徵性的神社之一。'),
(8, 109, '嵐山是京都的自然景點，擁有美麗的竹林和著名的天龍寺。'),
(8, 110, '祇園是京都的傳統文化區，擁有許多茶屋和傳統的和服文化。');

-- 2025-07-16
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(8, 111, '二年坂三年坂是京都的古老街道，以其傳統建築和手工藝品商店而著名。'),
(8, 112, '銀閣寺是一座精美的禪宗寺廟，擁有優美的庭園和建築，與金閣寺相比較為樸實。'),
(8, 113, '京都塔是京都市的地標之一，提供壯觀的市景，並且是觀光的好去處。'),
(8, 114, '京都御苑是一個歷史悠久的皇家庭園，擁有許多古老的樹木和優美的景觀。'),
(8, 115, '三十三間堂是著名的佛教寺廟，以其一千零一尊佛像而聞名。');

-- 2025-07-17
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(8, 116, '京都金山寺位於京都的伏見區，以其古老的歷史和文化價值而聞名。'),
(8, 117, '東福寺是日本最大的禪宗寺廟之一，擁有壯麗的建築和美麗的庭園。'),
(8, 118, '八坂神社是京都最重要的神社之一，每年吸引大量的信徒與遊客。'),
(8, 119, '西本願寺是日本最大的佛教寺廟之一，擁有壯觀的建築和深厚的宗教意義。'),
(8, 120, '京都市動物園是日本最古老的動物園之一，擁有各種各樣的動物和豐富的自然景觀。');

-- 2025-07-18
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(8, 121, '京都博物館是京都的重要文化機構，收藏了豐富的歷史文物和藝術品。'),
(8, 122, '南禪寺是一座典型的禪宗寺廟，擁有著名的水道橋和靜謐的氛圍。'),
(8, 123, '東大路是京都的主要街道之一，沿途有許多著名的景點和商店。'),
(8, 124, '平安神宮是一座重要的神社，以其宏偉的建築和寧靜的環境著稱。'),
(8, 125, '金閣寺前飯店位於金閣寺附近，是提供遊客住宿的熱門地點。');

-- 2025-07-19 (結尾日期)
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(8, 126, '大德寺是一座歷史悠久的禪宗寺廟，以其古老的建築和美麗的庭園而著名。'),
(8, 127, '北野天滿宮是京都的著名神社之一，以供奉學問之神而著名。'),
(8, 128, '京都市美術館擁有豐富的藝術作品，並定期舉辦各種展覽和活動。'),
(8, 129, '京都站是京都的交通樞紐，也是購物和餐飲的熱門場所。'),
(8, 130, '京都餐廳是京都市的美食集中區，提供各種地道的日本料理。');

--————————————————————————————————————————————

--首爾購物與美食（2025-08-01 至 2025-08-05）

-- 2025-08-01
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(9, 131, '明洞是首爾的著名購物區之一，擁有許多國際品牌和當地特色商店。'),
(9, 132, '南山塔是首爾的地標之一，提供壯觀的城市景觀，並且是情侶約會的熱點。'),
(9, 133, '東大門是首爾的購物天堂，有許多大型購物中心和批發市場。'),
(9, 134, '景福宮是韓國歷史悠久的王宮之一，擁有雄偉的建築和廣闊的庭園。'),
(9, 135, '弘大區以其年輕人文化、街頭表演和藝術展覽而聞名，是首爾的潮流聚集地。');

-- 2025-08-02
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(9, 136, '韓國戰爭紀念館是了解韓國戰爭歷史的重要場所，內部收藏大量的戰爭文物。'),
(9, 137, '梨花女子大學是一所著名的女子大學，其校園內有許多美麗的建築和自然景觀。'),
(9, 138, '樂天世界塔是首爾的摩天大樓，擁有商場、餐廳和觀光台。'),
(9, 139, '鐘閣是首爾的交通樞紐之一，周圍有許多餐廳和商店。'),
(9, 140, '光化門是首爾的歷史門之一，是通往景福宮的主要入口。');

-- 2025-08-03
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(9, 141, '新沙洞是首爾的時尚購物區，擁有許多精品店和設計師店鋪。'),
(9, 142, '首爾塔是眾多觀光景點中的一個，從塔頂可以俯瞰首爾市區。'),
(9, 143, 'COEX商場是首爾最大的地下購物中心之一，擁有各種品牌商店和餐廳。'),
(9, 144, '東大門設計廣場是一個結合設計、文化和藝術的綜合性建築，常舉辦展覽和活動。'),
(9, 145, '明洞街頭美食是首爾最具代表性的街頭小吃場所之一，提供各種地道的韓國美食。');

-- 2025-08-04
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(9, 146, '北村韓屋村是保留傳統韓屋的區域，可以體驗到韓國的傳統文化。'),
(9, 147, '仁寺洞是充滿傳統氛圍的街區，擁有許多古董店、茶館和手工藝品店。'),
(9, 148, '昌德宮是朝鮮時代的王宮之一，擁有美麗的庭園和古老的建築。'),
(9, 149, '東大門歷史文化公園是結合歷史和現代建築的綜合性公園，擁有豐富的文化活動。'),
(9, 150, 'Namsan公園是首爾市中心的一個綠意盎然的公園，是休閒和散步的好地方。');

-- 2025-08-05 (結尾日期)
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(9, 151, '南大門市場是首爾最古老的市場之一，提供各種當地商品和美食。'),
(9, 152, '樂天世界是一個大型的娛樂和購物複合設施，擁有各種遊樂設施和購物商場。'),
(9, 153, '韓國國立博物館是了解韓國歷史和文化的重要場所，擁有大量的文物展示。'),
(9, 154, '韓國首爾塔是另一個著名的地標，提供觀景台和周邊的餐飲設施。'),
(9, 155, '明洞購物街是首爾最具活力的購物區之一，擁有眾多國際品牌和本地商店。');

--————————————————————————————————————————————

-- 2025-08-10
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(10, 156, '這是海雲台，一個著名的海灘，擁有美麗的海景和熱門的度假地點。'),
(10, 157, '釜山塔提供壯觀的市區全景，是觀光客的必遊景點。'),
(10, 158, '甘川文化村以其多彩的街道和獨特的藝術氛圍而著名，吸引了不少藝術家和遊客。'),
(10, 159, '釜山水族館是探索海洋生物的好地方，展示了各種海洋生物。'),
(10, 160, '東萊溫泉是一個歷史悠久的溫泉地點，以其療效著名，吸引著很多當地人和遊客。');

-- 2025-08-11
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(10, 161, '光復洞是釜山的一個文化區，以各種餐廳和商店而聞名，是本地人和遊客的熱門地點。'),
(10, 162, '西面是釜山的繁華區，擁有許多商店、餐廳和購物中心，是購物和娛樂的熱點。'),
(10, 163, '釜山博物館展示了釜山的歷史和文化，是了解當地文化的好地方。'),
(10, 164, '金海海岸是一個美麗的海灘，擁有寧靜的景色和舒適的環境。'),
(10, 165, '釜山港是釜山的主要港口，也是韓國重要的貿易和航運中心。');

-- 2025-08-12
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(10, 166, '南浦洞是一個熱鬧的市區，有許多市場和餐廳，非常適合散步和購物。'),
(10, 167, '蓮池公園是一個美麗的公園，擁有寧靜的湖泊和自然景觀，非常適合放鬆和散步。'),
(10, 168, '金剛山擁有壯麗的山景和許多遠足路徑，是登山健行愛好者的理想場所。'),
(10, 169, '廣安大橋連接釜山市的廣安區和其他地區，是釜山著名的地標之一。'),
(10, 170, '釜山美術館是一個展示當代藝術和韓國藝術作品的博物館，是藝術愛好者的必訪地點。');

-- 2025-08-13
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(10, 171, '蛇島是一個有著豐富自然景觀的島嶼，擁有許多野生動植物，是生態愛好者的天堂。'),
(10, 172, '釜山影像博物館是一個專門展示電影和影像藝術的博物館，吸引了大量影迷和藝術愛好者。'),
(10, 173, '海洋博物館是釜山的一個主要博物館，展示了各種海洋生物和海洋生態知識。'),
(10, 174, '釜山大學是釜山的頂尖大學之一，擁有壯麗的校園和優秀的學術聲譽。'),
(10, 175, '新世界百貨是釜山的主要購物中心之一，提供各種商品和品牌，吸引大量顧客。');

-- 2025-08-14
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(10, 176, '釜山水族館展示了各種海洋生物，是一個家庭友善的旅遊景點。'),
(10, 177, '釜山大橋連接了釜山的東區和其他地區，提供壯觀的城市景色。'),
(10, 178, '九龍山是釜山市區的一個山脈，擁有許多遠足路徑和自然景觀。'),
(10, 179, '濟州島是一個著名的度假島嶼，以其獨特的自然景觀和豐富的文化而著稱。'),
(10, 180, '中華文化博物館展示了中國的歷史和文化，是了解中國文化的好地方。');

--————————————————————————————————————————————
-- 2025-09-01
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(11, 181, '好萊塭星光大道是好萊塭著名的景點，擁有超過2600個明星手印。這裡常常是遊客來洛杉磯必訪的地方。'),
(11, 182, '聖塔莫尼卡海灘是洛杉磯的著名沙灘，擁有美麗的海岸線和悠閒的氣氛，適合放鬆和各種水上活動。'),
(11, 183, '洛杉磯縣藝術博物館擁有世界一流的藝術收藏品，展出各種不同風格和時期的藝術作品，是文化愛好者的必訪之地。'),
(11, 184, '格里菲斯天文台提供壯觀的洛杉磯市景和夜空觀賞，是科學與天文愛好者的理想場所。'),
(11, 185, '洛杉磯市中心是洛杉磯的心臟，擁有多樣化的餐廳、商店和文化活動，代表了這座城市的現代化與活力。');

-- 2025-09-02
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(11, 186, '比佛利山莊是世界著名的奢華住宅區，擁有高檔購物商場和無數的明星豪宅。'),
(11, 187, '洛杉磯博物館擁有許多文化和歷史的展品，展示了洛杉磯的發展與歷史變遷。'),
(11, 188, '格蘭維爾天使劇院是洛杉磯的文化地標之一，經常上演各種戲劇和音樂演出。'),
(11, 189, '洛杉磯動物園是格里菲斯公園中的一個大型動物園，擁有來自世界各地的動物，適合家庭旅遊。'),
(11, 190, '羅賓遜購物中心是洛杉磯著名的購物中心之一，擁有各大品牌店鋪，適合購物與娛樂。');

-- 2025-09-03
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(11, 191, '拉布雷亞沥青坑是洛杉磯的自然奇觀，這些沥青坑吸引了大量的考古學家與自然愛好者。'),
(11, 192, '洛杉磯植物園是一個美麗的綠地，擁有各式各樣的植物，適合散步和觀察自然。'),
(11, 193, '洛杉磯歌劇院是洛杉磯的音樂和表演藝術中心之一，擁有世界級的演出和演唱會。'),
(11, 194, '威尼斯海灘以其獨特的沙灘文化和藝術氛圍聞名，是洛杉磯的一個重要地標。'),
(11, 195, '洛杉磯科學中心提供豐富的科學展覽與互動體驗，特別適合家庭和孩子們參觀。');

-- 2025-09-04
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(11, 196, '洛杉磯自然歷史博物館擁有超過3500萬件收藏品，展示了洛杉磯和地球的自然歷史。'),
(11, 197, '西好萊塢是一個充滿活力的社區，擁有許多餐廳、商店和夜生活場所。'),
(11, 198, '華特迪士尼音樂廳以其獨特的建築設計和卓越的音響效果而著稱，是音樂愛好者的聖地。'),
(11, 199, '洛杉磯火車站是一個具有歷史意義的建築，是洛杉磯重要的交通樞紐之一。'),
(11, 200, '洛杉磯國際機場是世界上最繁忙的機場之一，連接世界各地的航班。');

-- 2025-09-05
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(11, 201, '洛杉磯海洋世界是一個提供各種水上表演和海洋生物展示的主題公園，非常適合全家人來遊玩。'),
(11, 202, '格里菲斯公園是洛杉磯最大的公園之一，提供多種活動，包括遠足、野餐和天文觀察。'),
(11, 203, '棕櫚泉是洛杉磯近郊的一個度假小鎮，擁有溫暖的氣候和奢華的度假設施。'),
(11, 204, '聖佩德羅海灘是洛杉磯的另一個受歡迎的海灘，擁有美麗的海岸線和放鬆的氣氛。'),
(11, 205, '洛杉磯港是洛杉磯的主要港口之一，許多貨船與遊輪都經過這裡。');

-- 2025-09-06（結尾日期）
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(11, 206, '迪士尼樂園是世界上最著名的主題公園之一，擁有眾多的遊樂設施和卡通人物。'),
(11, 207, '安納海姆博物館展示了該地區的歷史和文化，具有豐富的教育意義。'),
(11, 208, '洛杉磯國際馬術大會是一個頂級的馬術比賽活動，吸引了全球的馬術愛好者。'),
(11, 209, '梅爾羅斯大道是洛杉磯著名的購物街之一，擁有各大時尚品牌和藝術畫廊。'),
(11, 210, '加州科學中心是一個充滿互動的科學博物館，展覽涵蓋了太空探索、科技與環境等領域。');

--————————————————————————————————————————————

-- 紐約城市探索（2025-09-10 至 2025-09-15）
-- 2025-09-10
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(12, 211, '自由女神像是紐約市最具代表性的地標之一，是紀念美國獨立百年而贈送給美國的禮物。'),
(12, 212, '中央公園是紐約市最大的城市公園，擁有美麗的自然景觀和多樣的休閒設施。'),
(12, 213, '時代廣場是紐約市最著名的地標之一，以其五光十色的電子廣告牌和繁華的街景聞名。'),
(12, 214, '帝國大廈曾經是世界上最高的建築，是紐約市的重要象徵。'),
(12, 215, '紐約大都會博物館擁有世界上最豐富的藝術收藏之一，涵蓋多個時代和地區。');

-- 2025-09-11
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(12, 216, '洛克菲勒中心是紐約市著名的綜合商業建築群，擁有世界著名的聖誕樹和溜冰場。'),
(12, 217, '百老匯劇院是紐約市戲劇藝術的心臟地帶，擁有世界一流的音樂劇和演出。'),
(12, 218, '布魯克林大橋是紐約市最具歷史意義的橋樑之一，將曼哈頓與布魯克林相連。'),
(12, 219, '第五大道是世界著名的購物街之一，擁有高端品牌和歷史建築。'),
(12, 220, '大中央車站是紐約市的交通樞紐，以其宏偉的建築和裝飾聞名。');

-- 2025-09-12
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(12, 221, '世界貿易中心原址上的新世貿大樓是紐約市的象徵之一，並擁有觀景台。'),
(12, 222, '紐約公共圖書館是世界著名的圖書館之一，以其宏偉的建築和豐富的藏書而聞名。'),
(12, 223, '華爾街是世界金融中心的心臟，擁有許多重要的金融機構。'),
(12, 224, '洛克菲勒廣場是洛克菲勒中心的核心區域，擁有著名的冰上溜冰場和聖誕樹。'),
(12, 225, '紐約海濱公園是曼哈頓的沿海公園，擁有美麗的海景和多樣的戶外活動。');

-- 2025-09-13
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(12, 226, '紐約現代藝術博物館擁有世界級的現代藝術作品，是全球最重要的藝術機構之一。'),
(12, 227, '蘇荷區是紐約市的藝術和時尚中心，擁有許多畫廊、精品店和餐廳。'),
(12, 228, '哈德遜廣場是紐約市的一個熱門地點，提供壯觀的天際線和美麗的河岸景觀。'),
(12, 229, '新世貿大樓位於世界貿易中心原址，是一座現代化的超高層建築，擁有觀景平台。'),
(12, 230, '華盛頓廣場公園是一個著名的城市公園，位於格林威治村，以其拱門和周圍的文化氛圍而聞名。');

-- 2025-09-14
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(12, 231, '中央車站是紐約市的主要火車站之一，以其壯麗的建築和悠久的歷史而聞名。'),
(12, 232, '艾姆斯大廈是一個著名的古典建築，以其精美的裝飾和文化價值而著稱。'),
(12, 233, '聖約翰大教堂是紐約市的歷史性教堂之一，擁有壯麗的哥德式建築。'),
(12, 234, '帝國大廈觀景台提供壯觀的城市景觀，是游客最受歡迎的觀光地點之一。'),
(12, 235, '格林威治村是一個充滿藝術氛圍的社區，擁有許多歷史建築和文化場所。');

-- 2025-09-15（結尾日期）
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(12, 236, '博物館區是紐約市最重要的文化區域之一，擁有許多世界著名的博物館。'),
(12, 237, '華爾街金融區是紐約市的金融核心，擁有眾多著名的銀行和證券交易所。'),
(12, 238, '大中央車站再次被提及，是紐約市的交通樞紐，並且是著名的旅遊景點。'),
(12, 239, '新世貿大樓再次提及，代表著紐約市的重建和未來。'),
(12, 240, '海港大橋是紐約市的標誌性建築之一，為曼哈頓和布魯克林之間的連接橋樑。');

--————————————————————————————————————————————




-- 舊金山灣區巡禮（2025-09-20 至 2025-09-25）
-- 2025-09-20
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(13, 241, '金門大橋是一個著名的吊橋，橫跨舊金山灣，連接舊金山市和馬林縣。'),
(13, 242, '漁人碼頭是舊金山的一個著名旅遊景點，以海鮮餐廳和遊客活動聞名。'),
(13, 243, '九曲花街是舊金山著名的曲折街道，風景如畫，吸引許多遊客。'),
(13, 244, '舊金山大學是一所歷史悠久的學術機構，位於舊金山的市中心。'),
(13, 245, '金門公園是一個大型城市公園，提供各種休閒活動，擁有美麗的景觀。');

-- 2025-09-21
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(13, 246, '加州科學院是世界知名的博物館，擁有多個展覽和生態展示。'),
(13, 247, '舊金山藝術宮是舊金山的文化地標，展示大量藝術品。'),
(13, 248, '金門大橋觀景台提供壯觀的金門大橋全景，是觀賞的最佳地點。'),
(13, 249, '唐人街是舊金山的一個多元文化區，擁有許多商店和餐廳。'),
(13, 250, '舊金山博物館是集科學、藝術和歷史於一身的博物館，提供多樣化的展覽。');

-- 2025-09-22
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(13, 251, '斯坦福大學位於舊金山灣區，是美國最頂尖的私立大學之一。'),
(13, 252, '聯合廣場是舊金山的主要購物區，擁有許多高端商店和餐廳。'),
(13, 253, '舊金山天際線是舊金山市區的獨特景觀，包含了許多高樓大廈。'),
(13, 254, '瑪琳縣是舊金山灣區的一個郊區，擁有美麗的自然景觀。'),
(13, 255, '萬麗酒店是一家奢華的酒店，提供優質的服務和壯麗的景觀。');

-- 2025-09-23
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(13, 256, '舊金山藍鯨博物館是專注於海洋生物的博物館，特別是藍鯨。'),
(13, 257, '舊金山現代藝術博物館是一個以現代藝術為主題的博物館，展示許多重要作品。'),
(13, 258, '舊金山聖瑪麗大教堂是一座宏偉的哥德式教堂，是舊金山的重要地標。'),
(13, 259, '馬薩諸塞灣是位於舊金山的一個美麗灣區，擁有迷人的海景。'),
(13, 260, '環球影城是知名的娛樂公司，擁有多樣的電影和遊樂設施。');

-- 2025-09-24
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(13, 261, '舊金山金門大橋公園是一個靠近金門大橋的公園，提供優美的觀景點。'),
(13, 262, '貝克海灘是一個著名的海灘，擁有美麗的海岸線和迷人的景色。'),
(13, 263, '金門大橋博物館介紹了金門大橋的歷史和建設過程。'),
(13, 264, '舊金山城市花園是一個優美的城市公園，擁有各種花卉和植物。'),
(13, 265, '舊金山藝術中心展示各種視覺藝術和表演藝術的展覽和演出。');

-- 2025-09-25（結尾日期）
INSERT INTO [dbo].[Place_Detail] (itinerary_id, place_id, detail)
VALUES
(13, 266, '聖塔克拉拉大學是一所頂尖的天主教大學，擁有悠久的歷史和優秀的學術背景。'),
(13, 267, '舊金山灣區鐵路是舊金山灣區的主要交通系統，方便遊客和居民出行。'),
(13, 268, '舊金山公共圖書館是一個提供豐富書籍和資源的公共圖書館。'),
(13, 269, '舊金山音樂劇院提供各種音樂和舞台劇演出，吸引許多觀眾。'),
(13, 270, '舊金山動物園擁有多種動物和自然景觀，適合全家人參觀。');
--——————————————————建立 Itinerary_Price——————————————————————
--CREATE TABLE [dbo].[Itinerary_Price] (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    itinerary_id INT,
--    rating INT CHECK (rating BETWEEN 1 AND 5),
--    price DECIMAL(10, 2) CHECK (price <= 200000),
--    description NVARCHAR(2000),
--    FOREIGN KEY (itinerary_id) REFERENCES [dbo].[Itinerary](Itinerary_ID)
--);

-- 插入資料到 Itinerary_Price 表，包含詳細簡介
INSERT INTO [dbo].[Itinerary_Price] (itinerary_id, rating, price, description)
VALUES
(1, 4, 150000, '體驗台北的歷史文化之旅，從故宮博物院的千年珍藏到大稻埕老街的懷舊氛圍，感受台北城市變遷的歷史軌跡。這趟行程將帶您走訪龍山寺、總統府與中正紀念堂，並在夜晚品味士林夜市的多樣美食，適合喜愛文化探索的旅客。'),
(2, 5, 180000, '宜蘭溫泉之旅讓您在大自然環抱中放鬆身心，入住頂級溫泉飯店，享受蘇澳冷泉與礁溪溫泉的療癒效果。搭配農場採果體驗與傳統手作米香DIY，讓旅程更加豐富，並探索龜山島海域與冬山河風光。'),
(3, 4, 120000, '台中美食探險從逢甲夜市的創意小吃開始，品味大腸包小腸、珍珠奶茶等在地美味。參觀宮原眼科，感受文青風格的冰淇淋店，並安排前往草悟道與高美濕地，讓旅程結合美食與自然景觀。'),
(4, 3, 100000, '南投山林漫遊適合喜愛大自然的旅客，安排清境農場綿羊秀與日月潭遊船體驗。夜宿山林民宿，品味在地特色料理，並造訪埔里酒廠與武嶺觀景台，讓旅程充滿靜謐與療癒氛圍。'),
(5, 5, 170000, '花蓮海岸之旅帶您探索東部自然奇景，從太魯閣峽谷的壯麗景觀到七星潭的藍色海灣。安排賞鯨之旅與原住民文化體驗，入住海景民宿，感受花蓮獨特的慢活步調與溫暖人情味。'),
(6, 4, 150000, '東京文化探索將帶您參觀淺草寺與明治神宮，並深入銀座與新宿的購物街區。搭乘隅田川遊船欣賞城市夜景，並安排和服租借體驗，讓您感受日本傳統文化與現代都市交融的魅力。'),
(7, 5, 180000, '大阪美食之旅專為美食愛好者設計，從章魚燒、串燒到黑門市場的新鮮海產，每一道料理都讓人垂涎欲滴。遊覽大阪城與梅田藍天大廈，夜晚沉浸於道頓堀的霓虹燈光與活力氛圍中。'),
(8, 4, 170000, '京都傳統文化遊將帶您走訪世界遺產清水寺與金閣寺，並安排抹茶體驗與和服租借。造訪祇園花見小路，感受藝妓文化，並漫步於嵐山竹林，讓旅程充滿日式古典浪漫。'),
(9, 5, 200000, '首爾購物與美食行程涵蓋明洞商圈的時尚購物體驗，並安排品嚐韓國烤肉與部隊鍋等特色料理。參觀景福宮與北村韓屋村，感受韓國傳統文化，讓旅程結合現代與古典風情。'),
(10, 3, 130000, '釜山海岸假期帶您漫遊海雲台沙灘，品嚐新鮮海產料理，並安排甘川文化村的彩繪巷弄之旅。搭乘空中纜車俯瞰釜山港美景，讓旅程結合文化探索與悠閒度假氛圍。'),
(11, 4, 160000, '洛杉磯陽光之旅從好萊塢星光大道開始，遊覽比佛利山莊與聖塔莫尼卡海灘。安排環球影城遊覽，並體驗洛杉磯多元文化與美食，適合熱愛陽光與冒險的旅客。'),
(12, 5, 190000, '紐約城市探索將帶您參觀自由女神像、帝國大廈與中央公園。安排百老匯音樂劇欣賞，並於時代廣場感受城市的繁華魅力，讓旅程充滿文化藝術與都市活力。'),
(13, 4, 175000, '舊金山灣區巡禮將帶您參觀金門大橋、九曲花街與漁人碼頭。搭乘電纜車穿越城市，並安排納帕酒鄉品酒體驗，讓旅程結合都市風光與自然美景。');

--底下是舊的
-- 建立 Itinerary_Price 表
--CREATE TABLE [dbo].[Itinerary_Price] (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    itinerary_id INT,
--    rating INT CHECK (rating BETWEEN 1 AND 5),
--    price DECIMAL(10, 2) CHECK (price < 200000),
--    FOREIGN KEY (itinerary_id) REFERENCES [dbo].[Itinerary](Itinerary_ID)
--);

-- 插入資料到 Itinerary_Price 表
--INSERT INTO [dbo].[Itinerary_Price] (itinerary_id, rating, price)
--VALUES
--(1, 4, 150000),  -- 台北文化之旅
--(2, 5, 180000),  -- 宜蘭溫泉之旅
--(3, 4, 120000),  -- 台中美食探險
--(4, 3, 100000),  -- 南投山林漫遊
--(5, 5, 170000),  -- 花蓮海岸之旅
--(6, 4, 150000),  -- 東京文化探索
--(7, 5, 180000),  -- 大阪美食之旅
--(8, 4, 170000),  -- 京都傳統文化遊
--(9, 5, 199999),  -- 首爾購物與美食
--(10, 3, 130000),  -- 釜山海岸假期
--(11, 4, 160000),  -- 洛杉磯陽光之旅
--(12, 5, 190000),  -- 紐約城市探索
--(13, 4, 175000);  -- 舊金山灣區巡禮

-- 建立 Place_Image 表，存放圖片資訊
--CREATE TABLE [dbo].[Place_Image] (
--    id INT IDENTITY(1,1) PRIMARY KEY,
--    place_id INT,
--    image_url NVARCHAR(MAX),
--    FOREIGN KEY (place_id) REFERENCES [dbo].[place](id)
--);



-- 插入資料到 Place_Image 表
INSERT INTO [dbo].[Place_Image] (place_id, image_url)
VALUES
(1, 'https://funintw.com/wp-content/uploads/2020/03/82156375_664830191000640_1409436719926957657_n-e1585192741571.jpg'),
(1, 'https://funintw.com/wp-content/uploads/2020/03/36021817_2088149464591610_6336446297821675520_n.jpg'),
(1, 'https://funintw.com/wp-content/uploads/2020/03/83167758_1363216283871923_2060935397394805991_n.jpg'),
(2, 'https://th.bing.com/th/id/OIP.H1RVNTpDjC9MbZZuluV-fAHaE8?w=366&h=200&c=7&r=0&o=5&dpr=2&pid=1.7'),
(2, 'https://th.bing.com/th/id/OIP.Cp9l2bK2wNLOZawLEVUOqwHaE8?w=285&h=191&c=7&r=0&o=5&dpr=2&pid=1.7'),
(2, 'https://th.bing.com/th/id/OIP.ox2bq8DxvfZyC_zx3w-0fQHaE8?w=237&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(3, 'https://th.bing.com/th/id/OIP.niqBGcEpSEo2fOv5RnhfBAHaFj?w=235&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(3, 'https://th.bing.com/th/id/OIP.2sAccnth_4sTJF8ERZKzCAHaFj?w=245&h=183&c=7&r=0&o=5&dpr=2&pid=1.7'),
(3, 'https://th.bing.com/th/id/OIP.LpxwexF-QR4wGRD1idkYFAHaE7?w=262&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(4, 'https://th.bing.com/th/id/OIP.dWQusOf5l-JG93UxFU7xPwHaE8?w=253&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(4, 'https://th.bing.com/th/id/OIP.e1185BF0dFV9ONQhcw1ZVwHaE7?w=266&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(4, 'https://th.bing.com/th/id/OIP.MMhOj0btKD1uGgQGnCl7vQHaFj?w=205&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(5, 'https://th.bing.com/th/id/OIP.k1A0VnP31jwfyVf8JDGSXAHaD4?w=321&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(5, 'https://th.bing.com/th/id/OIP.nIy7dqKZdpWrGIkCaSv1XAHaEc?w=254&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(5, 'https://th.bing.com/th/id/OIP.9byxJDPzBiXvNio-vvA1rgHaE8?w=238&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(6, 'https://th.bing.com/th/id/OIP.6torsWsKO2p3DHiF2ZzLgwHaE7?w=231&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(6, 'https://th.bing.com/th/id/OIP.up36CfF6oV4un_osFwTF8AHaEK?w=324&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(6, 'https://th.bing.com/th/id/OIP.DPRNRn0QTllpSyNLtD0-hwHaE8?w=271&h=181&c=7&r=0&o=5&dpr=2&pid=1.7'),
(7, 'https://th.bing.com/th/id/OIP.j2xurLgJtvgWBthDoCBRGQHaE7?w=299&h=199&c=7&r=0&o=5&dpr=2&pid=1.7'),
(7, 'https://th.bing.com/th/id/OIP.inIx98-LwNlXR8CeS5hU3wHaE8?w=299&h=199&c=7&r=0&o=5&dpr=2&pid=1.7'),
(7, 'https://th.bing.com/th/id/OIP.azTLJmdAZDthl5GTizNx7gHaEv?w=207&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(8, 'https://th.bing.com/th/id/OIP.WXJM9NIkKlpnA3zoWaRpJwHaE8?w=349&h=190&c=7&r=0&o=5&dpr=2&pid=1.7'),
(8, 'https://th.bing.com/th/id/OIP.m96rtW6Tsp0KU4eutS0UuQHaE7?w=302&h=201&c=7&r=0&o=5&dpr=2&pid=1.7'),
(8, 'https://th.bing.com/th/id/OIP.Cr-uqeF_EIzGAFoNDMWL4gHaE7?w=252&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(9, 'https://th.bing.com/th/id/OIP._Q1vvDlpYQ4VOaGtAVI7pgHaEN?w=299&h=180&c=7&r=0&o=5&dpr=2&pid=1.7'),
(9, 'https://th.bing.com/th/id/OIP.jVdJiwJ7IcHsmvq911hnowHaE7?w=348&h=190&c=7&r=0&o=5&dpr=2&pid=1.7'),
(9, 'https://th.bing.com/th/id/OIP.prqIpYl4S3e8rQWLpY75cAHaE8?w=285&h=190&c=7&r=0&o=5&dpr=2&pid=1.7');