/* =====================================================================================================
   01e  usp_Load_SS_to_IS_CLAIMCONTACT_DUMMY_PAYEE_MOTOR Motor payments: dummy payee CLAIM CONTACTS into the final table IS_CLAIMCONTACT
   Source : IS_DUMMY_PAYEE_CLAIMCONTACT_MOTOR (filled by 01b).
   Target : IS_CLAIMCONTACT, not truncated here (usp_Load_IS_CLAIMCONTACT stays as it is and runs earlier).
   Re-run : first removes only the rows this proc added earlier (PublicID 'mig:motorpayeecc_...').
   Person fields (first name, last name, date of birth) stay NULL: a dummy payee is a Company.
   ContactProhibited 0 as in usp_Load_IS_CLAIMCONTACT. ContactNameDenorm is cut to 60 (IS_CLAIMCONTACT column size).
   Run AFTER usp_Load_SS_to_IS_CONTACT_DUMMY_PAYEE_MOTOR (ContactID points to the dummy IS_CONTACT row).
   Not executed on SQL Server.
   ===================================================================================================== */
CREATE OR ALTER PROCEDURE dbo.usp_Load_SS_to_IS_CLAIMCONTACT_DUMMY_PAYEE_MOTOR
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM IntermediateStaging_DEV.dbo.IS_CLAIMCONTACT
    WHERE PublicID LIKE 'mig:motorpayeecc[_]%';

    INSERT INTO IntermediateStaging_DEV.dbo.IS_CLAIMCONTACT
    (
         PublicID
        ,LUWID
        ,ClaimID
        ,ContactID
        ,ContactNameDenorm
        ,ContactProhibited
    )
    SELECT
         C.PublicID
        ,C.CLAIM_REF AS LUWID
        ,C.ClaimID
        ,C.ContactID
        ,NULLIF(LEFT(LTRIM(RTRIM(C.ContactNameDenorm)), 60), '')
        ,0 AS ContactProhibited
    FROM IntermediateStaging_DEV.dbo.IS_DUMMY_PAYEE_CLAIMCONTACT_MOTOR C;
END;
