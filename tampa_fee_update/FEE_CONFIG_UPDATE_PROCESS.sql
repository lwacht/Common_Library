USE [accela8]
GO

/****** Object:  StoredProcedure [dbo].[FEE_CONFIG_UPDATE_PROCESS]    Script Date: 8/30/2018 2:01:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FEE_CONFIG_UPDATE_PROCESS]
@P_FEE_INCREASE_PERCENTAGE VARCHAR (30)
AS
BEGIN
    PRINT ('FEE_CONFIG_UPDATE_PROCESS begin.')
    SET  NOCOUNT ON
	
	PRINT ('Increase fee by : ' + @P_FEE_INCREASE_PERCENTAGE + '%');

	UPDATE [dbo].[fee_config]
	SET [base_fee] = [base_fee] + ([base_fee] * @P_FEE_INCREASE_PERCENTAGE)/100,
		[additional_sqft_fee] = [additional_sqft_fee] + ([additional_sqft_fee] * @P_FEE_INCREASE_PERCENTAGE)/100;

END
GO

