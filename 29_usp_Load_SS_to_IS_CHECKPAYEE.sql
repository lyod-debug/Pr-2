/* =====================================================================================
   usp_Load_SS_to_IS_CHECKPAYEE
   Motor payments: main IS table IS_CHECKPAYEE (exactly one check payee per check).
   Reads IS_CHECKPAYEE_MOTOR (filled by usp_Load_IS_CHECKPAYEE_MOTOR) and loads the main IS table IS_CHECKPAYEE.
   Full reload on every run: TRUNCATE, then one INSERT. Run it AFTER the payment procs (and after the append procs of the dummy payees).
   [NOT CONFIRMED] the real column list of IS_CHECKPAYEE: the list below is the list of IS_CHECKPAYEE_MOTOR without the Motor working column IsDummyPayee (not a ClaimCenter column).
   Check with:  SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM IntermediateStaging_DEV.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'IS_CHECKPAYEE' ORDER BY ORDINAL_POSITION;
   If your IS_CHECKPAYEE does not have a column, delete that line in BOTH lists (the INSERT list and the SELECT list).
   LegacyCreateTime_Adm is commented out until the column exists in ClaimCenter, as in the other payment procs.
   ===================================================================================== */
USE [IntermediateStaging_DEV]
GO

/* Run once, only if IS_CHECKPAYEE does not exist yet (it is created with the same columns as IS_CHECKPAYEE_MOTOR) */
IF OBJECT_ID('IntermediateStaging_DEV.dbo.IS_CHECKPAYEE', 'U') IS NULL
CREATE TABLE dbo.IS_CHECKPAYEE
(
    GW_HDR_CASEID                  BIGINT         NULL,
    CLAIM_REF                      VARCHAR(50)    NULL,
    VectusCaseID_Adm               VARCHAR(64)    NULL,
    SourceOrigin_Adm               VARCHAR(50)    NULL,
    CASE_STATUS                    VARCHAR(50)    NULL,
    LUWID                          VARCHAR(64)    NULL,
    PublicID                       VARCHAR(64)    NOT NULL,
    CheckID                        VARCHAR(64)    NULL,
    ClaimContactID                 VARCHAR(64)    NULL,
    PayeeType                      VARCHAR(50)    NULL
);
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.usp_Load_SS_to_IS_CHECKPAYEE
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE IntermediateStaging_DEV.dbo.IS_CHECKPAYEE;

    INSERT INTO IntermediateStaging_DEV.dbo.IS_CHECKPAYEE
    (
          LUWID
        , PublicID
        , CheckID
        , ClaimContactID
        , PayeeType
        /* debug columns: delete these 5 lines (GW_HDR_CASEID to CASE_STATUS), in BOTH lists, if your IS_CHECKPAYEE has no such columns */
        , GW_HDR_CASEID
        , CLAIM_REF
        , VectusCaseID_Adm
        , SourceOrigin_Adm
        , CASE_STATUS
    )
    SELECT
          LUWID
        , PublicID
        , CheckID
        , ClaimContactID
        , PayeeType
        /* debug columns: delete these 5 lines (GW_HDR_CASEID to CASE_STATUS), in BOTH lists, if your IS_CHECKPAYEE has no such columns */
        , GW_HDR_CASEID
        , CLAIM_REF
        , VectusCaseID_Adm
        , SourceOrigin_Adm
        , CASE_STATUS
    FROM IntermediateStaging_DEV.dbo.IS_CHECKPAYEE_MOTOR;
END;
GO
