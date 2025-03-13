# TravelLog - 旅遊管理系統

## 📌 目錄
- [📖 簡介](#-簡介)
- [💼 後台管理系統](#-後台管理系統)
- [🚀 TravelLog API](#-travellog-api)
- [🛠 技術棧](#-技術棧)
- [📂 專案結構](#-專案結構)
- [📥 安裝與運行](#-安裝與運行)
- [🌐 API 端點](#-api-端點)
- [📜 環境變數設置](#-環境變數設置)
- [🔬 測試 API](#-測試-api)
- [🎯 測試用戶帳號](#-測試用戶帳號)
- [🖼 專案預覽](#-專案預覽)
- [📖 開發資源](#-開發資源)

---

## 📖 簡介
TravelLog 是一個完整的旅遊管理解決方案，提供 **行程管理、訂單管理、用戶管理、地點資訊、金流整合** 等功能，並包含：
- **TravelLog 後台管理系統**（ASP.NET Core MVC）
- **TravelLog API**（ASP.NET Core 8.0 RESTful API）

## 💼 後台管理系統
### 📊 主要功能
- **用戶管理**（帳號管理、權限控制、數據統計）
- **訂單管理**（狀態追蹤、付款記錄、數據統計）
- **即時客服**（線上客服、訊息記錄管理、客服分配）
- **行程管理**（套裝行程管理、價格設定）
- **景點管理**（資訊維護、圖片管理、分類管理）
- **數據分析**（銷售統計、用戶分析）
- **系統設定**（參數配置、郵件範本、金流設定）

## 🚀 TravelLog API
### 🔐 主要功能
- **JWT 身份驗證**（用戶登入、電子郵件驗證）
- **行程管理**（搜索、創建、推薦行程）
- **地點管理**（景點查詢、圖片管理）
- **金流管理**（綠界支付、訂單管理、交易紀錄）

## 🛠 技術棧
- **後端框架**：ASP.NET Core 8.0
- **數據庫**：SQL Server 2019
- **ORM**：Entity Framework Core
- **身份驗證**：JWT
- **郵件服務**：Gmail API
- **金流**：綠界金流
- **即時通訊**：SignalR

## 📂 專案結構
```plaintext
TravelLog-dotNET/
├── TravelLog/             # 後台管理系統 (ASP.NET Core MVC)
│   ├── Controllers/       # MVC 控制器
│   ├── Doc/               # 專案文檔
│   ├── images/            # 圖片資源
│   ├── Models/            # 數據模型
│   ├── Sql/               # SQL 腳本
│   ├── ViewModels/        # 視圖模型
│   ├── Views/             # Razor 視圖
│   ├── wwwroot/           # 靜態資源 (CSS, JS, 圖片等)
│   ├── appsettings.json   # 配置文件
│   ├── Program.cs         # 應用入口
│   ├── TravelLog.csproj   # MVC 專案文件
│   └── TravelLog.sln      # 解決方案文件
│
├── TravelLogAPI/          # 後端 API 專案 (ASP.NET Core Web API)
│   ├── Controllers/       # API 控制器
│   ├── Credentials/       # 憑證存放
│   ├── DTO/               # 數據傳輸對象
│   ├── Hubs/              # SignalR 即時通訊
│   ├── Models/            # 數據模型
│   ├── Services/          # 業務邏輯層
│   ├── ViewModels/        # 視圖模型
│   ├── appsettings.json   # 配置文件
│   ├── Program.cs         # 應用入口
│   ├── Startup.cs         # 服務與中介軟體配置
│   ├── TravelLogAPI.csproj # API 專案文件
```

## 📥 安裝與運行
```bash
git clone https://github.com/theoch3n/TravelLog-dotNET.git
cd TravelLog-dotNET
dotnet restore
dotnet ef database update
dotnet run
```

## 🌐 API 端點
### 🔐 用戶 API
| 方法 | 端點 | 說明 |
|------|------|------|
| `POST` | `/api/User/register` | 註冊用戶 |
| `POST` | `/api/User/login` | 用戶登入 |
| `GET` | `/api/Profile` | 取得個人資料 |
| `PUT` | `/api/Profile` | 更新個人資料 |

### 📖 行程 API
| 方法 | 端點 | 說明 |
|------|------|------|
| `GET` | `/api/TravelPackage` | 獲取所有行程 |
| `POST` | `/api/TravelPackage` | 創建新行程 |
| `GET` | `/api/TourBundles` | 獲取推薦行程 |
| `POST` | `/api/TourBundles/GetTourBundlesByKeyword` | 搜索行程 |

## 📜 環境變數設置
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your_server;Database=your_db;User Id=your_user;Password=your_password;"
  },
  "GmailSettings": {
    "ClientId": "your_client_id",
    "ClientSecret": "your_client_secret",
    "ApiKey": "your_gmail_api_key"
  },
  "Ecpay": {
    "MerchantID": "your_merchant_id",
    "HashKey": "your_hash_key",
    "HashIV": "your_hash_iv"
  }
}
```

## 🔬 測試 API
```bash
curl -X POST "https://yourdomain.com/api/User/login" \
     -H "Content-Type: application/json" \
     -d '{ "email": "test@example.com", "password": "123456" }'
```

## 🎯 測試用戶帳號
| 用戶名 | Email | 密碼 |
|------|------|------|
| admin | `admin@travellog.com` | `Admin@123` |
| user | `user@travellog.com` | `User@123` |

## 🖼 專案預覽
### 🎛 後台管理系統
![Dashboard 頁面](https://yourimageurl.com/dashboard.png)

### 📱 API 回應範例
```json
{
  "status": "success",
  "data": {
    "userId": 123,
    "email": "test@example.com",
    "token": "eyJhbGciOiJIUz..."
  }
}
```

## 📖 開發資源
- [ASP.NET Core 官方文檔](https://learn.microsoft.com/aspnet/core/)
- [Entity Framework Core 官方文檔](https://learn.microsoft.com/ef/core/)
- [JWT 身份驗證指南](https://jwt.io/)
- [Gmail API 文檔](https://developers.google.com/gmail/api)
- [綠界金流 API 技術文件](https://developers.ecpay.com.tw/)
