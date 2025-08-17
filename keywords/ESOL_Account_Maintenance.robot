*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem
Library           DateTime
Library           json
Library           JSONLibrary

Resource          General_Keywords.robot

*** Keywords ***
Update Account Maintenance Information Consent
    #put case action=Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}
    
    Account Maintenance Information
    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Put_Consent_Open_Account.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}    ${False}
    ${data}=    Convert String to JSON    ${json_text_replaced}
    Set To Dictionary   ${data}[customerInfo][personalInfos][0][cardInfo]    cardType=Citizen ID
    # ${json_text}=    Get File   ${CURDIR}/../resources/data/${env}/Account_Maintenance.json
    # ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_data}=    Evaluate    json.loads($json_text_replaced)
    
    # ${upper}=    Convert To Upper Case    ${Overide}
    # IF    '${upper}' == 'Y'
    #     ${cifForm}    Set Variable    {"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"47e63b21-195d-4744-8975-b10d92d1624b"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}","engTitle":"${MOCK_EngTitle}","engName":"${MOCK_EngFirstName} ${MOCK_EengLastName}","dateOfBirth":"19930424","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"สำนักงานเขตคลองเตย","cardIssueDate":"20200212","cardExpiryDate":"20280816","legalAddr1":"30","legalAddr2":"หมู่ 1 สามัคคี28","legalAddr3":"ถ.สามัคคี","legalSubDistrict":"0500","legalDistrict":"1","legalStateProv":"12","legalPostalCd":"11000","legalCountry":"TH","mailingAddr1":"51/70","mailingAddr2":"","mailingAddr3":"ถ.พัฒนาชนบท 3","mailingSubDistrict":"0200","mailingDistrict":"11","mailingStateProv":"10","mailingPostalCd":"10520","mailingCountry":"TH","occupationCd":"1257","subOccupationCd":"08","officeName":"BLUE","officeAddr1":"51/70","officeAddr2":"","officeAddr3":"ถ.พัฒนาชนบท 3","officeSubDistrict":"0200","officeDistrict":"11","officeStateProv":"10","officePostalCd":"10520","officeCountry":"TH","homePhone":"","mobilePhone":"${OTP_Tel}","officePhone":"0788885856","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"5","maritalStat":"S","sex":"M","accountOpenDt":"20241106","kycStatus":"1","thaiFirstName":"ชนัดดา","thaiMiddleName":"","thaiLastName":"พฤฒาการย์","engFirstName":"CHANADDA","engMiddleName":"","engLastName":"PHRUETTHAKAN","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"01","personIDDocumentDetail":"","locationIDDocument":"01","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"200000","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"ตำบลท่าทราย","legalDistrictDesc":"อำเภอเมืองนนทบุรี","legalStateProvDesc":"นนทบุรี","mailingSubDistrictDesc":"แขวงคลองสองต้นนุ่น","mailingDistrictDesc":"เขตลาดกระบัง","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงคลองสองต้นนุ่น","officeDistrictDesc":"เขตลาดกระบัง","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"30,001-40,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"0","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"4","ktbUserID":"","legalAddr4":"ตำบลท่าทราย","mailingAddr4":"แขวงคลองสองต้นนุ่น","officeAddr4":"แขวงคลองสองต้นนุ่น","occupationSector":"07","smsSaleCode":"","kycLastReviewDt":"20250327","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"0","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"${MOCK_CardNumber}","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"","amdUnit":"","citizenID":"${MOCK_CardNumber}","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200000,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"TH","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@gmail.com","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตคลองเตย","citizenIssueDate":"20200212","citizenExpiryDate":"20280816","passportNo":"","passportCountry":"","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":true},"customerConsent":{"referenceId":"${CUSTOMER_CIF}","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]}]},"facialConsent":"N","cbsInfoChanges":[{"field":"emailAddr","newValue":"${Email}","oldValue":"${Old_EmailAddr}"},{"field":"mobilePhone","newValue":"${OTP_Tel}","oldValue":"${Old_Tel}"}],"fatcaInfo":{"q1Flag":"0","q2Flag":"0","q3Flag":"0","q4Flag":"0","q5Flag":"0","q6Flag":"0","q8Flag":null,"q7Flag":"0","lastUIDFATCA":"${User_ID}"}}
    #     ${cifForm}    Replace Variables    ${cifForm}  
    #     # ${cifForm}    Clean string for load json    ${cifForm}
    #     ${cifForm} =   Evaluate    json.loads('${cifForm}')
    #     Set To Dictionary   ${json_data}[customerInfo][personalInfos][0]    cifForm=${cifForm} 
    # END

    log    ${json_data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200
    #Should Be Equal    ${response.content}    ${None}
    Sleep    2s


Account Maintenance Information
    #Consent body
    #${Document_Beneficiary_Id} =    Set Variable If    '${Beneficiary_Id}' == '${EMPTY}'        ""        "${Beneficiary_Id}"
    #${Document_Beneficiary_Nickname} =    Set Variable If    '${Beneficiary_Nickname}' == '${EMPTY}'        None        "${Beneficiary_Nickname}"
    ${Document_BulkFlag} =    Set Variable If    '${BulkFlag}' == '${EMPTY}'        false        ${BulkFlag}
    ${Document_SubAccountFlag} =    Set Variable If    '${SubAccountFlag}' == '${EMPTY}'        false        ${SubAccountFlag}
    ${Document_EditAcName} =    Set Variable If    '${EditAcName}' == '${EMPTY}'        false        ${EditAcName}
    ${Document_EditAcStatus} =    Set Variable If    '${EditAcStatus}' == '${EMPTY}'        false        ${EditAcStatus}
    ${Document_EditAcRestriction} =    Set Variable If    '${EditAcRestriction}' == '${EMPTY}'        false        ${EditAcRestriction}
    ${Document_RegisterAcEduFlag} =    Set Variable If    '${RegisterAcEduFlag}' == '${EMPTY}'        false        ${RegisterAcEduFlag}
    ${Document_EditAcStandingPaymentOrder} =    Set Variable If    '${EditAcStandingPaymentOrder}' == '${EMPTY}'        false        ${EditAcStandingPaymentOrder}
    ${Document_EditCurrentStandingPaymentOrder} =    Set Variable If    '${EditCurrentStandingPaymentOrder}' == '${EMPTY}'        false        ${EditCurrentStandingPaymentOrder}
    ${Document_EditAcOverDraftLinkage} =    Set Variable If    '${EditAcOverDraftLinkage}' == '${EMPTY}'        false        ${EditAcOverDraftLinkage}
    ${Document_EditAffiliateAccount} =    Set Variable If    '${EditAffiliateAccount}' == '${EMPTY}'        false        ${EditAffiliateAccount}
    ${Document_InterestRateAdjust} =    Set Variable If    '${InterestRateAdjust}' == '${EMPTY}'        false        ${InterestRateAdjust}
    ${Document_EditAcAddress} =    Set Variable If    '${EditAcAddress}' == '${EMPTY}'        false        ${EditAcAddress}
    ${Document_RemoveAcEduFlag} =    Set Variable If    '${RemoveAcEduFlag}' == '${EMPTY}'        false        ${RemoveAcEduFlag}

    IF    '${Document_EditAcStatus}' == 'true'
        ${EditAcStatus_AccountStatus} =    Convert To Integer    ${EditAcStatus_AccountStatus}
        
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcPayCondition":false,"acStatus":${EditAcStatus_AccountStatus},"acStatusDesc":"${EditAcStatus_AccountStatus_Desc}","needOverride":false,"oldAcStatus":"0","editAcStatus":${Document_EditAcStatus},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_EditAcName}' == 'true'
        ${Document_acNameTh} =    Set Variable If    '${EditAcName_acNameTh}' == '${EMPTY}'        null        "${EditAcName_acNameTh}"
        ${Document_acNameEn} =    Set Variable If    '${EditAcName_acNameEn}' == '${EMPTY}'        null        "${EditAcName_acNameEn}"
        
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"acNameTh":${Document_acNameTh},"acNameEn":${Document_acNameEn},"editAcPayCondition":false,"needOverride":false,"editAcStatus":${Document_EditAcStatus},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_EditAcAddress}' == 'true'
        ${Document_acAddress_addr1} =    Set Variable If    '${EditAcAddress_acAddress_addr1}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_addr1}"
        ${Document_acAddress_addr2} =    Set Variable If    '${EditAcAddress_acAddress_addr2}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_addr2}"
        ${Document_acAddress_addr3} =    Set Variable If    '${EditAcAddress_acAddress_addr3}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_addr3}"
        ${Document_acAddress_district} =    Set Variable If    '${EditAcAddress_acAddress_district}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_district}"
        ${Document_acAddress_districtDesc} =    Set Variable If    '${EditAcAddress_acAddress_districtDesc}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_districtDesc}"
        ${Document_acAddress_homeType} =    Set Variable If    '${EditAcAddress_acAddress_homeType}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_homeType}"
        ${Document_acAddress_stateProv} =    Set Variable If    '${EditAcAddress_acAddress_stateProv}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_stateProv}"
        ${Document_acAddress_stateProvDesc} =    Set Variable If    '${EditAcAddress_acAddress_stateProvDesc}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_stateProvDesc}"
        ${Document_acAddress_subDistrict} =    Set Variable If    '${EditAcAddress_acAddress_subDistrict}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_subDistrict}"
        ${Document_acAddress_subDistrictDesc} =    Set Variable If    '${EditAcAddress_acAddress_subDistrictDesc}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_subDistrictDesc}"
        ${Document_acAddress_country} =    Set Variable If    '${EditAcAddress_acAddress_country}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_country}"
        ${Document_acAddress_countryDesc} =    Set Variable If    '${EditAcAddress_acAddress_countryDesc}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_countryDesc}"
        ${Document_acAddress_postalCd} =    Set Variable If    '${EditAcAddress_acAddress_postalCd}' == '${EMPTY}'        ""        "${EditAcAddress_acAddress_postalCd}"
        
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcAddress":${Document_EditAcAddress},"acAddress":{"addr1":${Document_acAddress_addr1},"addr2":${Document_acAddress_addr2},"addr3":${Document_acAddress_addr3},"district":${Document_acAddress_district},"districtDesc":${Document_acAddress_districtDesc},"homeType":${Document_acAddress_homeType},"stateProv":${Document_acAddress_stateProv},"stateProvDesc":${Document_acAddress_stateProvDesc},"subDistrict":${Document_acAddress_subDistrict},"subDistrictDesc":${Document_acAddress_subDistrictDesc},"country":${Document_acAddress_country},"countryDesc":${Document_acAddress_countryDesc},"postalCd":${Document_acAddress_postalCd}},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
    ELSE IF    '${Document_EditAcRestriction}' == 'true'
        
        ${Document_EditAcRestriction_restrictionAction} =    Set Variable If    '${EditAcRestriction_restrictionAction}' == '${EMPTY}'        ""        "${EditAcRestriction_restrictionAction}"
        ${Document_EditAcRestriction_key} =    Set Variable If    '${EditAcRestriction_key}' == '${EMPTY}'        ""        "${EditAcRestriction_key}"
        ${Document_EditAcRestriction_restrictionCode} =    Set Variable If    '${EditAcRestriction_restrictionCode}' == '${EMPTY}'        ""        "${EditAcRestriction_restrictionCode}"
        ${Document_EditAcRestriction_restrictionName} =    Set Variable If    '${EditAcRestriction_restrictionName}' == '${EMPTY}'        ""        "${EditAcRestriction_restrictionName}"
        
        IF    '${EditAcRestriction_restrictionStartDate}' != '${EMPTY}'
            ${StartDate}=        Convert Format Date At YYYY-MM-DD        ${EditAcRestriction_restrictionStartDate}
            Set Suite Variable    ${Document_EditAcRestriction_restrictionStartDate}     "${StartDate}"
        ELSE
            Set Suite Variable    ${Document_EditAcRestriction_restrictionStartDate}     ""
        END
        
        IF    '${EditAcRestriction_restrictionExpiredDate}' != '${EMPTY}'
            ${ExpiredDate}=        Convert Format Date At YYYY-MM-DD        ${EditAcRestriction_restrictionExpiredDate}
            Set Suite Variable    ${Document_EditAcRestriction_restrictionExpiredDate}     "${ExpiredDate}"
        ELSE
            Set Suite Variable    ${Document_EditAcRestriction_restrictionExpiredDate}     ""
        END
        
        ${Document_EditAcRestriction_restrictionCreateBy} =    Set Variable If    '${EditAcRestriction_restrictionCreateBy}' == '${EMPTY}'        ""        "${EditAcRestriction_restrictionCreateBy}"
        ${Document_EditAcRestriction_restrictionCommentCode} =    Set Variable If    '${EditAcRestriction_restrictionCommentCode}' == '${EMPTY}'        ""        "${EditAcRestriction_restrictionCommentCode}"
        ${Document_EditAcRestriction_restrictionComment} =    Set Variable If    '${EditAcRestriction_restrictionComment}' == '${EMPTY}'        ""        "${EditAcRestriction_restrictionComment}"
        
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":[{"key":${Document_EditAcRestriction_key},"restrictionCode":${Document_EditAcRestriction_restrictionCode},"restrictionName":${Document_EditAcRestriction_restrictionName},"restrictionStartDate":${Document_EditAcRestriction_restrictionStartDate},"restrictionExpiredDate":${Document_EditAcRestriction_restrictionExpiredDate},"restrictionCreateBy":${Document_EditAcRestriction_restrictionCreateBy},"restrictionCommentCode":${Document_EditAcRestriction_restrictionCommentCode},"restrictionComment":${Document_EditAcRestriction_restrictionComment},"restrictionAction":${Document_EditAcRestriction_restrictionAction}}],"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_RegisterAcEduFlag}' == 'true'
        ${Document_RegisterAcEduFlag_acEduNote} =    Set Variable If    '${RegisterAcEduFlag_acEduNote}' == '${EMPTY}'        ""        "${RegisterAcEduFlag_acEduNote}"

        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"acEduNote":${Document_RegisterAcEduFlag_acEduNote},"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"editAcPayCondition":false,"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_RemoveAcEduFlag}' == 'true'
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"removeAcEduFlag":${Document_RemoveAcEduFlag},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_EditAcOverDraftLinkage}' == 'true' and '${Document_EditCurrentStandingPaymentOrder}' == 'true'
        
        IF    '${SavingsAccount}' == 'true'
            Get Account Savings Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE IF    '${KrungthaiNEXTSavings}' == 'true'
            Get Account KrungthaiNEXTSavings Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE
            Set Suite Variable    ${Document_AccountNumber}     ""
            Set Suite Variable    ${Document_AccountType}       ""
        END
        
        ${Document_PaymentOrderAction} =    Set Variable If    '${PaymentOrderAction}' == '${EMPTY}'        ""        "${PaymentOrderAction}"
        ${Document_PaymentAccountName} =    Set Variable If    '${PaymentAccountName}' == '${EMPTY}'        ""        "${PaymentAccountName}"
        ${Document_PaymentAmount} =    Set Variable If    '${PaymentAmount}' == '${EMPTY}'        0        ${PaymentAmount}
        
        IF    '${PaymentStartDate}' != '${EMPTY}'
            ${StartDate}=        Convert Format Date At YYYY-MM-DD        ${PaymentStartDate}
            Set Suite Variable    ${Document_PaymentStartDate}     "${StartDate}"
        ELSE
            Set Suite Variable    ${Document_PaymentStartDate}     ""
        END
        
        ${Document_PaymentCandT} =    Set Variable If    '${PaymentCandT}' == '${EMPTY}'        ""        "${PaymentCandT}"
        ${Document_OverDraftLinkageAction} =    Set Variable If    '${OverDraftLinkageAction}' == '${EMPTY}'        ""        "${OverDraftLinkageAction}"
        ${Document_OdPri} =    Set Variable If    '${OdPri}' == '${EMPTY}'        0        ${OdPri}

        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"acNameTh":null,"acNameEn":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","currentStandingPaymentOrder":{"standingPaymentAccountNumber":${Document_AccountNumber},"standingPaymentOrderAction":${Document_PaymentOrderAction},"standingPaymentAccountName":${Document_PaymentAccountName},"standingPaymentAmount":${Document_PaymentAmount},"standingPaymentStartDate":${Document_PaymentStartDate},"standingPaymentCandT":${Document_PaymentCandT}},"editAcMinBalance":true,"minBalance":${Document_PaymentAmount},"overDraftLinkages":[{"odPri":${Document_OdPri},"overDraftLinkageAction":${Document_OverDraftLinkageAction},"odAcct":${Document_AccountNumber},"type":${Document_AccountType}}],"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_EditCurrentStandingPaymentOrder}' == 'true'
        
        IF    '${SavingsAccount}' == 'true'
            Get Account Savings Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE IF    '${KrungthaiNEXTSavings}' == 'true'
            Get Account KrungthaiNEXTSavings Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE
            Set Suite Variable    ${Document_AccountNumber}     ""
            Set Suite Variable    ${Document_AccountType}       ""
        END
        
        ${Document_PaymentOrderAction} =    Set Variable If    '${PaymentOrderAction}' == '${EMPTY}'        ""        "${PaymentOrderAction}"
        ${Document_PaymentAccountName} =    Set Variable If    '${PaymentAccountName}' == '${EMPTY}'        ""        "${PaymentAccountName}"
        ${Document_PaymentAmount} =    Set Variable If    '${PaymentAmount}' == '${EMPTY}'        0        ${PaymentAmount}
        
        IF    '${PaymentStartDate}' != '${EMPTY}'
            ${StartDate}=        Convert Format Date At YYYY-MM-DD        ${PaymentStartDate}
            Set Suite Variable    ${Document_PaymentStartDate}     "${StartDate}"
        ELSE
            Set Suite Variable    ${Document_PaymentStartDate}     ""
        END
        ${Document_PaymentCandT} =    Set Variable If    '${PaymentCandT}' == '${EMPTY}'        ""        "${PaymentCandT}"
        
        ${status}=    Run Keyword And Return Status    Variable Should Exist    ${RESP_OD_PRI}
        IF   ${status}
            Set Suite Variable    ${Document_OdPri}     ${RESP_OD_PRI}
        ELSE
            ${Document_OdPri} =    Set Variable If    '${OdPri}' == '${EMPTY}'        0        ${OdPri}
        END
        
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"acNameTh":null,"acNameEn":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","currentStandingPaymentOrder":{"standingPaymentAccountNumber":${Document_AccountNumber},"standingPaymentOrderAction":${Document_PaymentOrderAction},"standingPaymentAccountName":${Document_PaymentAccountName},"standingPaymentAmount":${Document_PaymentAmount},"standingPaymentStartDate":${Document_PaymentStartDate},"standingPaymentCandT":${Document_PaymentCandT},"seqNumber":${Document_OdPri}},"editAcMinBalance":true,"minBalance":${Document_PaymentAmount},"appId":"${APP_ID}"}
    
    ELSE IF    '${Document_EditAcOverDraftLinkage}' == 'true'
        
        IF    '${SavingsAccount}' == 'true'
            Get Account Savings Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE IF    '${KrungthaiNEXTSavings}' == 'true'
            Get Account KrungthaiNEXTSavings Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE
            Set Suite Variable    ${Document_AccountNumber}     ""
            Set Suite Variable    ${Document_AccountType}     ""
        END
        
        ${Document_OverDraftLinkageAction} =    Set Variable If    '${OverDraftLinkageAction}' == '${EMPTY}'        ""        "${OverDraftLinkageAction}"
        
        ${status}=    Run Keyword And Return Status    Variable Should Exist    ${RESP_OD_PRI}
        IF   ${status}
            Set Suite Variable    ${Document_OdPri}               ${RESP_OD_PRI}
            Set Suite Variable    ${Document_AccountType}         ${RESP_OD_TYPE}
            Set Suite Variable    ${Document_AccountNumber}       "${RESP_OD_ACCT}"
        ELSE
            ${Document_OdPri} =    Set Variable If    '${OdPri}' == '${EMPTY}'        0        ${OdPri}
        END

        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"acNameTh":null,"acNameEn":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"overDraftLinkages":[{"odPri":${Document_OdPri},"odAcct":${Document_AccountNumber},"type":${Document_AccountType}}],"appId":"${APP_ID}"}
        #${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[],"editAcName":${Document_EditAcName},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"acNameTh":null,"acNameEn":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"overDraftLinkages":[{"odPri":${Document_OdPri},"odAcct":"0003350193","type":${Document_AccountType}}],"appId":"${APP_ID}"}
    ELSE IF    '${Document_EditAcStandingPaymentOrder}' == 'true'
        
        IF    '${ZeroTaxAccountNo}' == 'true'
            Get Account ZeroTax Linkage Link
            Set Suite Variable    ${Document_AccountNumber}     "${ACCOUNT_LINKAGE_LINK}"
            Set Suite Variable    ${Document_AccountType}     ${ACCOUNT_TYPE_LINKAGE_LINK}
        
        ELSE
            Set Suite Variable    ${Document_AccountNumber}     ""
            Set Suite Variable    ${Document_AccountType}       ""
        END
        
        Get standingPaymentEndDate
        Get standingPaymentStartDate
        ${Document_PaymentOrderAction} =    Set Variable If    '${PaymentOrderAction}' == '${EMPTY}'        ""        "${PaymentOrderAction}"
        ${Document_PaymentAccountName} =    Set Variable If    '${PaymentAccountName}' == '${EMPTY}'        ""        "${PaymentAccountName}"
        ${Document_PaymentDate} =    Set Variable If    '${PaymentDate}' == '${EMPTY}'        ""        "${PaymentDate}"
        ${Document_PaymentEndOfMonth} =    Set Variable If    '${PaymentEndOfMonth}' == '${EMPTY}'        false        ${PaymentEndOfMonth}
        
        ${status}=    Run Keyword And Return Status    Variable Should Exist    ${RESP_SPO_SEQ_NUMBER}
        IF   ${status}
            Set Suite Variable    ${Document_SeqNumber}               ${RESP_SPO_SEQ_NUMBER}
            Set Suite Variable    ${Document_PaymentAmount}           ${RESP_SPO_AMOUNT}
            Set Suite Variable    ${Document_PaymentStartDate}       "${RESP_SPO_STARTDATE}"
            Set Suite Variable    ${Document_AccountNumber}          "${RESP_SPO_TOACCOUNT_PADDED}"
            Set Suite Variable    ${Document_PaymentEndDate}         "${RESP_SPO_ENDDATE}"
        ELSE
            ${Document_PaymentAmount} =    Set Variable If    '${PaymentAmount}' == '${EMPTY}'        0        ${PaymentAmount}
            Set Suite Variable    ${Document_PaymentStartDate}     "${standingPaymentStartDate}"
            Set Suite Variable    ${Document_PaymentEndDate}       "${standingPaymentEndDate}"
            ${Document_SeqNumber} =    Set Variable If    '${seqNumber}' == '${EMPTY}'        null        ${seqNumber}
        END

        #IF    '${PaymentOrderAction}' == ''
        #    ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[{"standingPaymentAccountNumber":${Document_AccountNumber},"standingPaymentEndOfMonth":${Document_PaymentEndOfMonth},"standingPaymentOrderAction":${Document_PaymentOrderAction},"standingPaymentDate":${Document_PaymentDate},"standingPaymentAccountName":${Document_PaymentAccountName},"standingPaymentAmount":${Document_PaymentAmount},"standingPaymentStartDate":${Document_PaymentStartDate},"seqNumber":${Document_SeqNumber},"standingPaymentEndDate":${Document_PaymentEndDate}}],"editAcName":${Document_EditAcName},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null}
        #ELSE
        #    ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[{"standingPaymentAccountNumber":${Document_AccountNumber},"standingPaymentDate":${Document_PaymentDate},"standingPaymentEndOfMonth":${Document_PaymentEndOfMonth},"standingPaymentOrderAction":${Document_PaymentOrderAction},"standingPaymentAccountName":${Document_PaymentAccountName},"standingPaymentAmount":${Document_PaymentAmount},"seqNumber":${Document_SeqNumber},"standingPaymentStartDate":${Document_PaymentStartDate},"standingPaymentEndDate":${Document_PaymentEndDate}}],"editAcName":${Document_EditAcName},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
        #END
        ${Consent_body}=    Set variable    {"accountNumber":"${ACCOUNT_NO}","productName":"${ACCOUNT_PRODUCT_NAME}","productCode":"${ACCOUNT_PRODUCT_TYPE}","bulkFlag":${Document_BulkFlag},"subAccountFlag":${Document_SubAccountFlag},"mainAccountNumber":null,"acStandingPaymentOrders":[{"standingPaymentAccountNumber":${Document_AccountNumber},"standingPaymentDate":${Document_PaymentDate},"standingPaymentEndOfMonth":${Document_PaymentEndOfMonth},"standingPaymentOrderAction":${Document_PaymentOrderAction},"standingPaymentAccountName":${Document_PaymentAccountName},"standingPaymentAmount":${Document_PaymentAmount},"seqNumber":${Document_SeqNumber},"standingPaymentStartDate":${Document_PaymentStartDate},"standingPaymentEndDate":${Document_PaymentEndDate}}],"editAcName":${Document_EditAcName},"editAcStandingPaymentOrder":${Document_EditAcStandingPaymentOrder},"editAcRestriction":${Document_EditAcRestriction},"acRestrictions":null,"editAcPayCondition":false,"registerAcEduFlag":${Document_RegisterAcEduFlag},"editCurrentStandingPaymentOrder":${Document_EditCurrentStandingPaymentOrder},"editAcOverDraftLinkage":${Document_EditAcOverDraftLinkage},"editAffiliateAccount":${Document_EditAffiliateAccount},"interestRateAdjust":${Document_InterestRateAdjust},"productTypeBusinessCode":"${ACCOUNT_PRODUCT_GROUP}","editAcMinBalance":false,"minBalance":null,"currentStandingPaymentOrder":null,"appId":"${APP_ID}"}
        
    END
    Set Suite Variable    ${ACCOUNT_MAINTENANCE_BODY}    ${Consent_body}
    log    ${ACCOUNT_MAINTENANCE_BODY}

Get Restriction
    #Restriction
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/account/${ACCOUNT_NO}/restriction
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    Get_Restriction    ${url}
    ${response}=    GET On Session    Get_Restriction    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${json}=    Convert String to JSON    ${response.content}
    log    ${response.content}

    Dictionary Should Contain Key     ${json}    inquiryAccountRestrictionRespHeader
    ${inquiryAccountRestrictionRespHeader}=    Set Variable    ${json["inquiryAccountRestrictionRespHeader"]}
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespHeader}    responseCode
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespHeader}    responseDesc
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespHeader}    wsRefId
    Dictionary Should Contain Key     ${json}    inquiryAccountRestrictionRespRecs
    ${inquiryAccountRestrictionRespRecs}=    Set Variable    ${json["inquiryAccountRestrictionRespRecs"]}
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespRecs}    inquiryAccountRestrictionRespRec
    ${inquiryAccountRestrictionRespRec_detail}=    Set Variable    ${json["inquiryAccountRestrictionRespRecs"]["inquiryAccountRestrictionRespRec"][0]}
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespRec_detail}    comment
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespRec_detail}    expiryDate
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespRec_detail}    restriction
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespRec_detail}    startDate
    Dictionary Should Contain Key     ${inquiryAccountRestrictionRespRec_detail}    userID
    Dictionary Should Contain Key     ${json}    lastRflg
    Dictionary Should Contain Key     ${json}    moreFlg
    Dictionary Should Contain Key     ${json}    totalRec

    Set Suite Variable    ${RESTRICTION_CODE}    ${inquiryAccountRestrictionRespRec_detail}[restriction]
    Set Suite Variable    ${RESTRICTION_USERID}    ${inquiryAccountRestrictionRespRec_detail}[userID]
    Set Suite Variable    ${RESTRICTION_COMMENT}    ${inquiryAccountRestrictionRespRec_detail}[comment]
    Set Suite Variable    ${RESTRICTION_STARTDATE}    ${inquiryAccountRestrictionRespRec_detail}[startDate]
    Set Suite Variable    ${RESTRICTION_EXPIRYDATE}    ${inquiryAccountRestrictionRespRec_detail}[expiryDate]

Upload Document Education
    #EDU_DOC
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_DOC}
    Log    url = ${url}${uri}
    
    ${file_path}    Set Variable    ${CURDIR}/../uploads/${EDU_DOC}
    
    ${req}    Set Variable    {"caseId":"${CASE_ID}","documentId":"EDU_DOC","appId":"${APP_ID}","cardNumber":"${MOCK_CardNumber}","dateOfBirth":"${MOCK_DateOfBirth}","overrideContentType":"application/pdf"}
    
    ${file_data}=    Evaluate
    ...    {"file": open(r'${file_path}', 'rb'),"request": ('request', '${req}', 'application/json')}
    
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    
    Create Session    upload_Signature    ${url}
    ${response}    POST On Session  upload_Signature  ${uri}  headers=${headers}  files=${file_data}  expected_status=any    

    Log    ${response.status_code}
    Log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    uploadSessionId

    Set Suite Variable    ${DOCUMENT EDUCATION_UPLOAD_SESSION_ID}    ${json["uploadSessionId"]}

Get Portfolio Overdraft
    #portfolio_overdraft
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/portfolio/type/overdraft/${ACCOUNT_NO}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    portfolio_overdraft    ${url}
    ${response}=    GET On Session    portfolio_overdraft    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${json}=    Convert String to JSON    ${response.content}
    log    ${response.content}

    Dictionary Should Contain Key     ${json[0]}    odAcct
    Dictionary Should Contain Key     ${json[0]}    odPri
    Dictionary Should Contain Key     ${json[0]}    type

    Set Test Variable    ${RESP_OD_ACCT}    ${json[0]["odAcct"]}
    Set Test Variable    ${RESP_OD_PRI}     ${json[0]["odPri"]}
    Set Test Variable    ${RESP_OD_TYPE}    ${json[0]["type"]}

Get SPO Account
    #spoAccount
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/portfolio/type/spoAccount/${ACCOUNT_NO}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    get_spoAccount    ${url}
    ${response}=    GET On Session    get_spoAccount    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${json}=    Convert String to JSON    ${response.content}
    log    ${response.content}

    Dictionary Should Contain Key     ${json[0]}    seqNumber
    Dictionary Should Contain Key     ${json[0]}    amount
    Dictionary Should Contain Key     ${json[0]}    startDate
    Dictionary Should Contain Key     ${json[0]}    toAccount
    Dictionary Should Contain Key     ${json[0]}    endDate
    Dictionary Should Contain Key     ${json[0]}    frequency
    Dictionary Should Contain Key     ${json[0]}    status

    ${startDate} =    Set variable    ${json[0]["startDate"]}
    ${year}=    Set Variable    ${startDate}[0:4]
    ${month}=    Set Variable    ${startDate}[4:6]
    ${day}=    Set Variable    ${startDate}[6:8]
    ${formattedDate}=    Set Variable    ${year}-${month}-${PaymentDate}
    
    IF    '${json[0]["endDate"]}' != '${EMPTY}'
        ${endDate} =    Set variable    ${json[0]["endDate"]}
        ${year}=    Set Variable    ${endDate}[0:4]
        ${month}=    Set Variable    ${endDate}[4:6]
        ${day}=    Set Variable    ${endDate}[6:8]
        ${formattedEndDate}=    Set Variable    ${year}-${month}-${day}
    ELSE
        Set Test Variable    ${term}    24
        ${today}=    Get Current Date    result_format=%Y-%m-%d
        ${year}=    Evaluate    int(${today.split('-')[0]}) + (${term} // 12)
        ${month}=    Evaluate    int('${today.split("-")[1]}'.lstrip("0"))
        Run Keyword If    ${month} == 1    Set Variable    ${year}=    ${year - 1}
        Run Keyword If    ${month} == 1    Set Variable    ${month}=    12
        Run Keyword If    ${month} != 1    Set Variable    ${month}=    ${month - 1}
        ${month}=    Evaluate    "{:02d}".format(${month})
        ${year}=    Convert To String    ${year}

        #${standingPaymentEndDate}=    Set Variable    ${year}-${month}-31
        ${formattedEndDate}=    Set Variable    ${year}-${month}-30
    END
    
    ${toAccount} =    Set variable    ${json[0]["toAccount"]}
    ${paddedAccount}=    Evaluate    str(${toAccount}).zfill(10)

    Set Test Variable    ${RESP_SPO_SEQ_NUMBER}          ${json[0]["seqNumber"]}
    Set Test Variable    ${RESP_SPO_AMOUNT}              ${json[0]["amount"]}
    Set Test Variable    ${RESP_SPO_STARTDATE}           ${formattedDate}
    Set Test Variable    ${RESP_SPO_TOACCOUNT_PADDED}    ${paddedAccount}
    Set Test Variable    ${RESP_SPO_ENDDATE}             ${formattedEndDate}
    Set Test Variable    ${RESP_SPO_FREQUENCY}           ${json[0]["frequency"]}
    Set Test Variable    ${RESP_SPO_STATUS}              ${json[0]["status"]}