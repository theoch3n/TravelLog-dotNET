USE TravelLog
-- 插入測試票種數據到 Tickets 表
INSERT INTO Tickets (TicketsName, TicketsType, Price, IsAvailable, Description, RefundPolicy) --, ValidFrom, ValidTo, )
VALUES 
('標準火車票', '火車票', 50, 1, '座位12A，有效期至2024年3月', '不退票'),
('豪華酒店房間', '酒店預訂', 120, 1, '海景301房，視野極佳', '提前24小時可退票'),
('演唱會門票', '活動門票', 80, 1, '12月演唱會入場票', '不退票'),
('主題樂園入場券', '活動門票', 35, 1, '所有遊樂設施通行證', '提前48小時可退票'),
('飛機票', '機票', 200, 1, '經濟艙座位，有效期至2024年1月', '不退票');