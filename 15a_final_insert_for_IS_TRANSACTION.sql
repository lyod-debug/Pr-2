/* =====================================================================================================
   15a_final_insert_for_IS_TRANSACTION
   Final insert for the main IS table IS_TRANSACTION (Motor payments and recoveries). Paste at the END of your proc usp_Load_SS_to_IS_TRANSACTION,
   below your existing reserve insert. Reads IS_TRANSACTION_PAY_MOTOR (filled by usp_Load_IS_TRANSACTION_PAY_MOTOR). Not executed on SQL Server.
   [NOT CONFIRMED] the real column list of IS_TRANSACTION: if "invalid column name" appears, run
     SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM IntermediateStaging_DEV.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'IS_TRANSACTION' ORDER BY ORDINAL_POSITION;
   The debug columns of the PAY table (GW_HDR_CASEID, CLAIM_REF, VectusCaseID_Adm, SourceOrigin_Adm, CASE_STATUS) are not copied. LegacyCreateTime_Adm is commented out until the column exists.
   ===================================================================================================== */
/* MOTOR PAYMENTS AND RECOVERIES */
INSERT INTO [IntermediateStaging_DEV].dbo.IS_TRANSACTION
(
      PublicID
    , LUWID
    , BookingDate
    , CreateTime /*, LegacyCreateTime_Adm*/
    , CreateUserID
    , ClaimID
    , CostCategory
    , CostType
    , Currency
    , ExposureID
    , LifeCycleState
    , RecoveryCategory
    , RecoveryCodingID
    , ReserveLineID
    , ReservingCurrency
    , Status
    , Subtype
    , TransactionSetID
    , PaymentType
    , DoesNotErodeReserves
    , CloseExposure
    , CloseClaim
    , CheckID
    , DenormCashMoveNo_Adm
    , ChequeNumber_Adm
    , InternalCCPayRecoCurrency_Adm
    , InternalCCPayRecoCat_Adm
)
SELECT
      PublicID
    , LUWID
    , BookingDate
    , CreateTime /*, LegacyCreateTime_Adm*/
    , CreateUserID
    , ClaimID
    , CostCategory
    , CostType
    , Currency
    , ExposureID
    , LifeCycleState
    , RecoveryCategory
    , RecoveryCodingID
    , ReserveLineID
    , ReservingCurrency
    , Status
    , Subtype
    , TransactionSetID
    , PaymentType
    , DoesNotErodeReserves
    , CloseExposure
    , CloseClaim
    , CheckID
    , DenormCashMoveNo_Adm
    , ChequeNumber_Adm
    , InternalCCPayRecoCurrency_Adm
    , InternalCCPayRecoCat_Adm
FROM [IntermediateStaging_DEV].dbo.IS_TRANSACTION_PAY_MOTOR;
