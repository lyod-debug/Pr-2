/* =====================================================================================================
   15c_final_insert_for_IS_TRANSACTIONLINEITEM
   Final insert for the main IS table IS_TRANSACTIONLINEITEM (Motor payments and recoveries). Paste at the END of your proc usp_Load_SS_to_IS_TRANSACTIONLINEITEM,
   below your existing reserve insert. Reads IS_TRANSACTIONLINEITEM_PAY_MOTOR (filled by usp_Load_IS_TRANSACTIONLINEITEM_PAY_MOTOR). Not executed on SQL Server.
   [NOT CONFIRMED] the real column list of IS_TRANSACTIONLINEITEM: if "invalid column name" appears, run
     SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM IntermediateStaging_DEV.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'IS_TRANSACTIONLINEITEM' ORDER BY ORDINAL_POSITION;
   The debug columns of the PAY table (GW_HDR_CASEID, CLAIM_REF, VectusCaseID_Adm, SourceOrigin_Adm, CASE_STATUS) are not copied. LegacyCreateTime_Adm is commented out until the column exists.
   ===================================================================================================== */
/* MOTOR PAYMENTS AND RECOVERIES. Not copied (not in IS_TRANSACTIONLINEITEM): ReservingForExAmount, ReportingForExAmount, ClaimForExAmount */
INSERT INTO [IntermediateStaging_DEV].dbo.IS_TRANSACTIONLINEITEM
(
      PublicID
    , LUWID
    , CreateTime /*, LegacyCreateTime_Adm*/
    , CreateUserID
    , TransactionAmount
    , ReportingAmount
    , ClaimAmount
    , ReservingAmount
    , LineCategory
    , TransactionID
)
SELECT
      PublicID
    , LUWID
    , CreateTime /*, LegacyCreateTime_Adm*/
    , CreateUserID
    , TransactionAmount
    , ReportingAmount
    , ClaimAmount
    , ReservingAmount
    , LineCategory
    , TransactionID
FROM [IntermediateStaging_DEV].dbo.IS_TRANSACTIONLINEITEM_PAY_MOTOR;
