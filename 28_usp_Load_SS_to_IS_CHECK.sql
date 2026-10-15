/* =====================================================================================
   usp_Load_SS_to_IS_CHECK
   Motor payments: main IS table IS_CHECK (one check per loadable payment).
   Reads IS_CHECK_MOTOR (filled by usp_Load_IS_CHECK_MOTOR) and loads the main IS table IS_CHECK.
   Full reload on every run: TRUNCATE, then one INSERT. Run it AFTER the payment procs (and after the append procs of the dummy payees).
   [NOT CONFIRMED] the real column list of IS_CHECK: the list below is the same columns as IS_CHECK_MOTOR.
   Check with:  SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM IntermediateStaging_DEV.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'IS_CHECK' ORDER BY ORDINAL_POSITION;
   If your IS_CHECK does not have a column, delete that line in BOTH lists (the INSERT list and the SELECT list).
   LegacyCreateTime_Adm is commented out until the column exists in ClaimCenter, as in the other payment procs.
   ===================================================================================== */
USE [IntermediateStaging_DEV]
GO

/* Run once, only if IS_CHECK does not exist yet (it is created with the same columns as IS_CHECK_MOTOR) */
IF OBJECT_ID('IntermediateStaging_DEV.dbo.IS_CHECK', 'U') IS NULL
CREATE TABLE dbo.IS_CHECK
(
    GW_HDR_CASEID                  BIGINT         NULL,
    CLAIM_REF                      VARCHAR(50)    NULL,
    VectusCaseID_Adm               VARCHAR(64)    NULL,
    SourceOrigin_Adm               VARCHAR(50)    NULL,
    CASE_STATUS                    VARCHAR(50)    NULL,
    LUWID                          VARCHAR(64)    NULL,
    PublicID                       VARCHAR(64)    NOT NULL,
    Retired                        BIGINT         NOT NULL DEFAULT 0,
    AccountName                    VARCHAR(255)   NULL,
    BankAccountNumber              VARCHAR(100)   NULL,
    BankSortCodeStr_Adm            VARCHAR(50)    NULL,
    CheckBatching                  VARCHAR(50)    NULL,
    CheckNumber                    VARCHAR(255)   NULL,
    CheckSetID                     VARCHAR(64)    NULL,
    CheckType                      VARCHAR(50)    NULL,
    ChequeNumber_Adm               VARCHAR(100)   NULL,
    ChequePresentedDate_Adm        DATETIME2(7)   NULL,
    ChequeStopReason_Adm           VARCHAR(50)    NULL,
    ClaimContactID                 VARCHAR(64)    NULL,
    ClaimID                        VARCHAR(64)    NULL,
    DenormCashMoveNo_Adm           BIGINT         NULL,
    DenormPostalCode_Adm           VARCHAR(100)   NULL,
    EnteredTime                    DATETIME2(7)   NULL,
    InCareOf_Adm                   VARCHAR(64)    NULL,
    InternalCCPayClaimNumber_Adm   VARCHAR(255)   NULL,
    IssueDate                      DATETIME2(7)   NULL,
    MailingAddressID               VARCHAR(64)    NULL,
    MailTo                         VARCHAR(255)   NULL,
    PaymentMethod                  VARCHAR(50)    NULL,
    PayTo                          VARCHAR(255)   NULL,
    PayToDenorm                    VARCHAR(255)   NULL,
    Status                         VARCHAR(50)    NULL,
    CreateTime                     DATETIME2(7)   NULL,
    LegacyCreateTime_Adm           DATETIME2(7)   NULL,
    CreateUserID                   VARCHAR(64)    NULL,
    VoidStopUserID                 VARCHAR(64)    NULL
);
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.usp_Load_SS_to_IS_CHECK
AS
BEGIN
    SET NOCOUNT ON;
    TRUNCATE TABLE IntermediateStaging_DEV.dbo.IS_CHECK;

    INSERT INTO IntermediateStaging_DEV.dbo.IS_CHECK
    (
          LUWID
        , PublicID
        , Retired
        , AccountName
        , BankAccountNumber
        , BankSortCodeStr_Adm
        , CheckBatching
        , CheckNumber
        , CheckSetID
        , CheckType
        , ChequeNumber_Adm
        , ChequePresentedDate_Adm
        , ChequeStopReason_Adm
        , ClaimContactID
        , ClaimID
        , DenormCashMoveNo_Adm
        , DenormPostalCode_Adm
        , EnteredTime
        , InCareOf_Adm
        , InternalCCPayClaimNumber_Adm
        , IssueDate
        , MailingAddressID
        , MailTo
        , PaymentMethod
        , PayTo
        , PayToDenorm
        , Status
        , CreateTime /*, LegacyCreateTime_Adm*/
        , CreateUserID
        , VoidStopUserID
        /* debug columns: delete these 5 lines (GW_HDR_CASEID to CASE_STATUS), in BOTH lists, if your IS_CHECK has no such columns */
        , GW_HDR_CASEID
        , CLAIM_REF
        , VectusCaseID_Adm
        , SourceOrigin_Adm
        , CASE_STATUS
    )
    SELECT
          LUWID
        , PublicID
        , Retired
        , AccountName
        , BankAccountNumber
        , BankSortCodeStr_Adm
        , CheckBatching
        , CheckNumber
        , CheckSetID
        , CheckType
        , ChequeNumber_Adm
        , ChequePresentedDate_Adm
        , ChequeStopReason_Adm
        , ClaimContactID
        , ClaimID
        , DenormCashMoveNo_Adm
        , DenormPostalCode_Adm
        , EnteredTime
        , InCareOf_Adm
        , InternalCCPayClaimNumber_Adm
        , IssueDate
        , MailingAddressID
        , MailTo
        , PaymentMethod
        , PayTo
        , PayToDenorm
        , Status
        , CreateTime /*, LegacyCreateTime_Adm*/
        , CreateUserID
        , VoidStopUserID
        /* debug columns: delete these 5 lines (GW_HDR_CASEID to CASE_STATUS), in BOTH lists, if your IS_CHECK has no such columns */
        , GW_HDR_CASEID
        , CLAIM_REF
        , VectusCaseID_Adm
        , SourceOrigin_Adm
        , CASE_STATUS
    FROM IntermediateStaging_DEV.dbo.IS_CHECK_MOTOR;
END;
GO
