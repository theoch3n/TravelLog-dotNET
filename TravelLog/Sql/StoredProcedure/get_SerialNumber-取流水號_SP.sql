USE [TravelLog]
GO

/****** Object:  StoredProcedure [dbo].[get_SerialNumber]    Script Date: 2024/12/22 下午 04:29:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		JEC
-- Create date: 2024.11.09
-- Description:	自動取號
-- =============================================
CREATE PROCEDURE [dbo].[get_SerialNumber]
	@SystemCode VARCHAR(10),
	@AddDay INT --可以增加幾天 提前取編號 預設給0
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		--可以增加幾天 提前取編號 預設給0
		--DECLARE @AddDay INT = 0
		--SET @AddDay = 0
	
		DECLARE @Year INT = YEAR(DATEADD(DAY,@AddDay,GETDATE()))
		DECLARE @Month INT = MONTH(DATEADD(DAY,@AddDay,GETDATE()))
		DECLARE @Day INT = DAY(GETDATE() + @AddDay)

		--每日重置流水號並從1開始
		DECLARE @SeqNo INT = (SELECT ISNULL(MAX(CAST(RIGHT([SB_SerialNumber], 6) AS INT)), 0) + 1 
							  FROM [TravelLog].[dbo].[SerialBase]
							  WHERE [SB_SystemCode] = @SystemCode AND CAST(SUBSTRING([SB_SerialNumber], 4, 8) AS INT) = @Year * 10000 + @Month * 100 + @Day)

		DECLARE @SerialNumber VARCHAR(20) = CONCAT(@SystemCode + '-', 
													@Year, 
													RIGHT('00' + CAST(@Month AS VARCHAR), 2), 
													RIGHT('00' + CAST(@Day AS VARCHAR), 2), 
													'-', 
													RIGHT('000000' + CAST(@SeqNo AS VARCHAR), 6))
		UPDATE [TravelLog].[dbo].[SerialBase]
		SET [SB_SerialNumber] = @SerialNumber,[SB_Count] = ([SB_Count] + 1),[ModifiedDate] = DATEADD(DAY,@AddDay,GETDATE())
		WHERE [SB_SystemCode] = @SystemCode

		SELECT * 
		FROM [TravelLog].[dbo].[SerialBase]
		WHERE [SB_SystemCode] = @SystemCode

	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION
		DECLARE @ErrorMessage VARCHAR(MAX) = ERROR_MESSAGE(), @ErrorSeverity INT = ERROR_SEVERITY(), @ErrorState INT = ERROR_STATE()
		RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState)
		
		SELECT 'NG' Result, '取號失敗' [Message]
		

	END CATCH

END
GO


