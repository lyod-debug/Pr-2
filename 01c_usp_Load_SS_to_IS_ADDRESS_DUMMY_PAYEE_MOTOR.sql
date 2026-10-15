/* =====================================================================================================
   01c  usp_Load_SS_to_IS_ADDRESS_DUMMY_PAYEE_MOTOR Motor payments: dummy payee ADDRESSES into the final table IS_ADDRESS
   Source : IS_DUMMY_PAYEE_ADDRESS_MOTOR (filled by usp_Load_IS_DUMMY_PAYEE_MOTOR, 01b).
   Target : IS_ADDRESS. IS_ADDRESS is NOT truncated here (your usp_Load_SS_to_IS_ADDRESS stays as it is and runs earlier).
   Re-run : first removes only the rows this proc added earlier (PublicID 'mig:motorpayeeadr_...'), then inserts them again.
   Text is cut to the IS_ADDRESS sizes (address lines 60, postcode 60) the way usp_Load_IS_ADDRESS_CONTACT cuts.
   BatchGeocode 0 and ObfuscatedInternal 0 are the constants usp_Load_IS_ADDRESS_CONTACT writes (both NOT NULL in IS_ADDRESS).
   Not executed on SQL Server.
   ===================================================================================================== */
CREATE OR ALTER PROCEDURE dbo.usp_Load_SS_to_IS_ADDRESS_DUMMY_PAYEE_MOTOR
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM IntermediateStaging_DEV.dbo.IS_ADDRESS
    WHERE PublicID LIKE 'mig:motorpayeeadr[_]%';

    INSERT INTO IntermediateStaging_DEV.dbo.IS_ADDRESS
    (
         PublicID
        ,LUWID
        ,AddressLine1
        ,AddressLine2
        ,AddressLine3
        ,PostalCode
        ,State
        ,Subtype
        ,BatchGeocode
        ,ObfuscatedInternal
    )
    SELECT
         A.PublicID
        ,A.CLAIM_REF AS LUWID
        ,NULLIF(LEFT(LTRIM(RTRIM(A.AddressLine1)), 60), '')
        ,NULLIF(LEFT(LTRIM(RTRIM(A.AddressLine2)), 60), '')
        ,NULLIF(LEFT(LTRIM(RTRIM(A.AddressLine3)), 60), '')
        ,NULLIF(LEFT(LTRIM(RTRIM(A.PostalCode)), 60), '')
        ,A.State
        ,A.Subtype
        ,0 AS BatchGeocode
        ,0 AS ObfuscatedInternal
    FROM IntermediateStaging_DEV.dbo.IS_DUMMY_PAYEE_ADDRESS_MOTOR A;
END;
