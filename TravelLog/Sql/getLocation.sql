USE [TravelLog]
GO

/****** Object:  StoredProcedure [dbo].[getLocation]    Script Date: 2025/2/13 下午 12:13:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		JEC
-- Create date: 2025.02.13
-- Description:	取得景點
-- =============================================
CREATE PROCEDURE [dbo].[getLocation]  
	@Itinerary_ID INT
AS
BEGIN
	 
	 --DECLARE @Itinerary_ID INT = 1

	 
	 SELECT A.[Itinerary_ID],[Itinerary_Title],[Itinerary_Location],[Itinerary_Image],[Itinerary_StartDate],[Itinerary_EndDate], [ItineraryDetail_ID],[ItineraryDetail_Day],[ItineraryDetail_MapID],[ItineraryDetail_StartDate],
      [ItineraryDetail_EndDate],[ItineraryDetail_Memo],[Id],[date],[scheduleId],[Name],[Address],[Latitude],[Longitude],[img],[rating]
	 FROM [TravelLog].[dbo].[Itinerary] A
	 LEFT JOIN [TravelLog].[dbo].[Itinerary_Detail] B WITH(NOLOCK) ON A.[Itinerary_ID] = B.[Itinerary_ID]
	 LEFT JOIN [TravelLog].[dbo].[Place] C WITH(NOLOCK) ON B.[ItineraryDetail_MapID] = C.[ID]
	 WHERE A.[Itinerary_ID] = @Itinerary_ID
END
GO


