use TravelLog

create table Tour_Bundles(
	id int identity not null primary key, --主鍵
	eventName nvarchar(40) not null,	  --名稱
	startingPoint nvarchar(40) not null,  --起始地
	destination nvarchar(40) not null,	  --目的地
	firstDate datetime not null,		  --開始日
	lastDate datetime not null,			  --結束日
	duration int not null,				  --天數
	price int not null,					  --價格
	eventDescription nvarchar(500) not null, --描述
	ratings int	,						  --評分
	contactInfo nvarchar(20) not null	  --聯絡方式
)
