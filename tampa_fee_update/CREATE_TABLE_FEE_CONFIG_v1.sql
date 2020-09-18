USE [SOLANOCO_CONV]
GO

/****** Object:  Table [dbo].[FEE_CONFIG]    Script Date: 9/15/2020 4:50:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FEE_CONFIG](
	[FEE_CALC_PROC] [varchar](30) NOT NULL,
	[FEE_SCHEDULE] [varchar](40) NOT NULL,
	[FEE_CODE] [varchar](15) NOT NULL,
	[SUB_GROUP] [varchar](40) NULL,
	[FEE_DESC] [varchar](100) NULL,
	[SIZE_THRESHOLD] varchar(30) NULL,
	[BASE_FEE] varchar(30) NULL,
	[ADDITIONAL_SQFT_FEE] varchar(30) NULL,
	[VAL1] varchar(30) NULL,
	[MINIMUM_FEE] [numeric](15, 4) NULL,
	[FEE_FORMULA] [varchar](4000) NULL,
	[MULTI_TIER] [varchar](1) NULL
) ON [PRIMARY]
GO

