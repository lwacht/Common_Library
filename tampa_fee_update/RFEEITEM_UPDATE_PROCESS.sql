USE [accela8]
GO

/****** Object:  StoredProcedure [dbo].[RFEEITEM_UPDATE_PROCESS]    Script Date: 8/30/2018 2:02:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RFEEITEM_UPDATE_PROCESS]
AS
BEGIN
	DECLARE @FEE_SCHEDULE NVARCHAR(255);
	DECLARE @FEE_CODE NVARCHAR(255);
	DECLARE @FEE_CODE_CHECK NVARCHAR(255);
	DECLARE @sub_group NVARCHAR(255);
	DECLARE @size_threshold INT;
	DECLARE @base_fee DECIMAL(15,4);
	DECLARE @additional_sqft_fee DECIMAL(15,4);
	DECLARE @calc_base_fee DECIMAL(15,4);
	DECLARE @calc_additional_sqft_fee DECIMAL(15,4);
	DECLARE @minimum_fee DECIMAL(15,2);
	DECLARE @formula NVARCHAR(MAX);
	DECLARE @counter int;

	SET @counter = 0;
	SET @formula = '';
	SET @minimum_fee = 0.00;
	SET @FEE_CODE_CHECK = '';
	DECLARE feeConfig_csr CURSOR
	FOR
		SELECT [fee_schedule],
			   [fee_code],
			   [sub_group],
			   [size_threshold],
			   [base_fee],
			   [additional_sqft_fee]
		FROM [dbo].[fee_config]
		ORDER BY [fee_schedule],[fee_code];
	OPEN feeConfig_csr;
	FETCH NEXT FROM feeConfig_csr INTO @FEE_SCHEDULE, @FEE_CODE, @sub_group, @size_threshold, @base_fee, @additional_sqft_fee;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FEE_CODE_CHECK <> @FEE_CODE AND @sub_group = 'STANDARD'
		BEGIN
			SET @calc_additional_sqft_fee = @additional_sqft_fee/100;
			SET @calc_base_fee = @base_fee-50-@calc_additional_sqft_fee;
			SET @formula = '0,0,0,0'+','+CONVERT(varchar,(@size_threshold-1))+','+CONVERT(varchar,@calc_additional_sqft_fee)+','+
			CONVERT(varchar,@calc_base_fee)+',0'+',999999999';
			SET @minimum_fee = (@base_fee-50);
		END
		ELSE
		IF @FEE_CODE_CHECK = @FEE_CODE AND @sub_group = 'STANDARD'
		BEGIN
			SET @calc_additional_sqft_fee = @additional_sqft_fee/100;
			SET @calc_base_fee = @base_fee-50-@calc_additional_sqft_fee;
			SET @formula = @formula+','+CONVERT(varchar,(@size_threshold - 1))+','+CONVERT(varchar,@calc_additional_sqft_fee)+','+
			CONVERT(varchar,@calc_base_fee)+',0'+',999999999';
			--SET @minimum_fee = (@base_fee-50);
		END
		ELSE
		IF @FEE_CODE_CHECK <> @FEE_CODE AND @sub_group = 'STANDARD2'
		BEGIN
			SET @calc_additional_sqft_fee = @additional_sqft_fee/100;
			SET @calc_base_fee = @base_fee-@calc_additional_sqft_fee;
			SET @formula = '0,0,0,0'+','+CONVERT(varchar,(@size_threshold-1))+','+CONVERT(varchar,@calc_additional_sqft_fee)+','+
			CONVERT(varchar,@calc_base_fee)+',0'+',999999999';
			SET @minimum_fee = (@base_fee);
		END
		ELSE
		IF @FEE_CODE_CHECK = @FEE_CODE AND @sub_group = 'STANDARD2'
		BEGIN
			SET @calc_additional_sqft_fee = @additional_sqft_fee/100;
			SET @calc_base_fee = @base_fee-@calc_additional_sqft_fee;
			SET @formula = @formula+','+CONVERT(varchar,(@size_threshold - 1))+','+CONVERT(varchar,@calc_additional_sqft_fee)+','+
			CONVERT(varchar,@calc_base_fee)+',0'+',999999999';
			--SET @minimum_fee = (@base_fee);
		END
		SET @counter = @counter + 1;
		PRINT (CONVERT(nvarchar,@counter) + ':: ' + @FEE_SCHEDULE + ' -- ' + @FEE_CODE + ' -- ' + @FEE_CODE_CHECK + ' -- ' + @sub_group + ' -- ' + @formula + ' -- ' + CONVERT(nvarchar,@minimum_fee));
		UPDATE accela.dbo.RFEEITEM
		SET R1_GF_MIN_FEE = @minimum_fee,
			R1_GF_FORMULA = @formula
		WHERE R1_GF_COD = @FEE_CODE
		AND R1_FEE_CODE = @FEE_SCHEDULE;
		SET @FEE_CODE_CHECK = @FEE_CODE;
		FETCH NEXT FROM feeConfig_csr INTO @FEE_SCHEDULE, @FEE_CODE, @sub_group, @size_threshold, @base_fee, @additional_sqft_fee;
	END;
	IF @@FETCH_STATUS <> 0
		--PRINT @formula;
		--PRINT @FEE_CODE + '--' + CONVERT(nvarchar,@minimum_fee);
		--return;
	CLOSE feeConfig_csr;
	DEALLOCATE feeConfig_csr;
END
GO

