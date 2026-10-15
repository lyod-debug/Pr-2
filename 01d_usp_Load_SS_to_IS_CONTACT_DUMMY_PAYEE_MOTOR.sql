/* =====================================================================================================
   01d  usp_Load_SS_to_IS_CONTACT_DUMMY_PAYEE_MOTOR Motor payments: dummy payee CONTACTS into the final table IS_CONTACT
   Source : IS_DUMMY_PAYEE_CONTACT_MOTOR (filled by 01b).
   Target : IS_CONTACT, not truncated here (usp_Load_SS_to_IS_CONTACT stays as it is). The claim contact is done by 01e usp_Load_SS_to_IS_CLAIMCONTACT_DUMMY_PAYEE_MOTOR.
   Re-run : first removes only the rows this proc added earlier (PublicID 'mig:motorpayee_...').
   Constants are the SAME as usp_Load_IS_CONTACT_MASTER_MOTOR writes for a Company: GroupPayment_Adm 0, LoadRelatedContacts 0, ObfuscatedInternal 0,
   PendingLinkMessage 0, Preferred 0, Unknown_Adm 0, UnknownFlagVisible 1, Injured_Adm 'No'.
   Text is cut to 60 (IS_CONTACT.Name / NameDenorm are VARCHAR(60)), as the contact master cuts company names.
   Not executed on SQL Server.
   ===================================================================================================== */
CREATE OR ALTER PROCEDURE dbo.usp_Load_SS_to_IS_CONTACT_DUMMY_PAYEE_MOTOR
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM IntermediateStaging_DEV.dbo.IS_CONTACT      WHERE PublicID LIKE 'mig:motorpayee[_]%';

    /* contact: always a Company */
    INSERT INTO IntermediateStaging_DEV.dbo.IS_CONTACT
    (
         PublicID
        ,LUWID
        ,AutoSync
        ,Name
        ,NameDenorm
        ,Notes
        ,PreferredCurrency
        ,PreferRemitChannel_Adm
        ,PrimaryAddressID
        ,Subtype
        ,GroupPayment_Adm
        ,Injured_Adm
        ,LoadRelatedContacts
        ,ObfuscatedInternal
        ,PendingLinkMessage
        ,Preferred
        ,Unknown_Adm
        ,UnknownFlagVisible
    )
    SELECT
         P.PublicID
        ,P.CLAIM_REF AS LUWID
        ,P.AutoSync
        ,NULLIF(LEFT(LTRIM(RTRIM(P.Name)), 60), '') AS Name
        ,NULLIF(LEFT(LTRIM(RTRIM(P.Name)), 60), '') AS NameDenorm
        ,P.Notes
        ,P.PreferredCurrency
        ,P.PreferRemitChannel_Adm
        ,P.PrimaryAddressID
        ,P.Subtype
        ,0    AS GroupPayment_Adm
        ,'No' AS Injured_Adm
        ,0    AS LoadRelatedContacts
        ,0    AS ObfuscatedInternal
        ,0    AS PendingLinkMessage
        ,0    AS Preferred
        ,0    AS Unknown_Adm
        ,1    AS UnknownFlagVisible
    FROM IntermediateStaging_DEV.dbo.IS_DUMMY_PAYEE_CONTACT_MOTOR P;
END;
