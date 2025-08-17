*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem
Library           DateTime
Library           json
Library           JSONLibrary
#Library			  RPA.Excel.Files

Resource          General_Keywords.robot
Resource          ESOL_Open_Account_Keywords.robot

*** Keywords ***
Generate App ID Next
    #generate_appid_next
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/app-id/SV/generate?count=1
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    generate_appid_next    ${url}
    ${response}    POST On Session  generate_appid_next  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    appIds

    Set Suite Variable    ${APP_ID_NEXT}    ${json["appIds"][0]}
    Set Suite Variable    ${IS_NEW_NEXT}    ${TRUE}

MC Tool Product Information
    #mcToolProductInfos
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_MC_TOOL}
    Log    url = ${url}${uri}

    ${data}=    Set variable    {"event":"PROD_SELECT","refNo":"${MC_TOOL_REFNO}","mainFlowEventTime": null,"mcToolProductInfos":[{"productTypeId":"${Product_TypeId}","productId":"${Product_ID}"}],"caseId":"${CASE_ID}"}
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    MC_Tool_Product    ${url}
    ${response}=    POST On Session    MC_Tool_Product    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    refNo
    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    event
    Dictionary Should Contain Key     ${json}    eventDateTime
    Dictionary Should Contain Key     ${json}    mcToolProductInfos
    ${mcToolProductInfos}=    Set Variable    ${json["mcToolProductInfos"][0]}
    Dictionary Should Contain item    ${mcToolProductInfos}    productId        ${Product_ID}
    Dictionary Should Contain item    ${mcToolProductInfos}    productTypeId    ${Product_TypeId}

    Set Suite Variable    ${MC_Tool_PRODUCT_REFNO}    ${json["refNo"]}

Update Card Information Consent
    #put case action=Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    IF    '${Label_serviceType}' == 'DebitCards'
        ${data}=    Evaluate    {"caseId":"${CASE_ID}","selectedLanguage":"th","customerInfo":{"personalInfos":[{"cardInfo":{"engTitle":"${MOCK_EngTitle}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","thaiTitle":"${MOCK_ThaiTitle}","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","address":{"homeNo":"${MOCK_Address_HomeNo}","soi":"${MOCK_Address_Soi}","trok":"","moo":"","road":"${MOCK_Address_Road}","subDistrict":"${MOCK_Address_SubDistrict}","district":"${MOCK_Address_District}","province":"กรุงเทพมหานคร","postalCode":"10200"},"cardType":"Citizen ID","cardNumber":"${MOCK_CardNumber}","cardExpiryDate":"${MOCK_CardExpiryDate}","cardIssueDate":"${MOCK_CardIssueDate}","cardIssuePlace":"${MOCK_CardIssuePlace}","sex":"${MOCK_Sex}","dateOfBirth":"${MOCK_DateOfBirth}","bp1No":"${MOCK_Bp1No}","chipId":"${MOCK_ChipId}","manualKeyIn":False,"customerType":"221","foreigner":False,"isInvolvingPoliticiansFR":"2","isInvolvingPoliticiansTH":"2"},"cifForm":{"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"af8665d3-9e0e-4c98-82d8-a4d2b84d3cc2"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"รัชนี จันทเศียรทดสอบ","engTitle":"${MOCK_EngTitle}","engName":"RATCHANEE CHANTASIAN","dateOfBirth":"19790410","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"${MOCK_CardIssuePlace}","cardIssueDate":"20120411","cardExpiryDate":"20300409","legalAddr1":"35/10","legalAddr2":"ซ.สุขุมวิท 1","legalAddr3":"ถ.สุขุมวิท","legalSubDistrict":"0100","legalDistrict":"1","legalStateProv":"10","legalPostalCd":"10200","legalCountry":"TH","mailingAddr1":"35/10","mailingAddr2":"ซ.สุขุมวิท 1","mailingAddr3":"ถ.สุขุมวิท","mailingSubDistrict":"0100","mailingDistrict":"1","mailingStateProv":"10","mailingPostalCd":"10200","mailingCountry":"TH","occupationCd":"1107","subOccupationCd":"01","officeName":"กรุงไทย จำกัด","officeAddr1":"445","officeAddr2":"","officeAddr3":"","officeSubDistrict":"0100","officeDistrict":"1","officeStateProv":"10","officePostalCd":"10200","officeCountry":"TH","homePhone":"032900000","mobilePhone":"${OTP_Tel}","officePhone":"021111111","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"6","maritalStat":"S","sex":"${MOCK_Sex}","accountOpenDt":"20180326","kycStatus":"1","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"","personIDDocumentDetail":"","locationIDDocument":"","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"แขวงพระบรมมหาราชวัง","legalDistrictDesc":"เขตพระนคร","legalStateProvDesc":"กรุงเทพมหานคร","mailingSubDistrictDesc":"แขวงพระบรมมหาราชวัง","mailingDistrictDesc":"เขตพระนคร","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงพระบรมมหาราชวัง","officeDistrictDesc":"เขตพระนคร","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"40,001-60,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"722","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"3","ktbUserID":"","legalAddr4":"แขวงพระบรมมหาราชวัง","mailingAddr4":"แขวงพระบรมมหาราชวัง","officeAddr4":"แขวงพระบรมมหาราชวัง","occupationSector":"02","smsSaleCode":"","kycLastReviewDt":"20250209","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"200722","amdUnit":"","citizenID":"3914654278431","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200722,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@GMAIL.COM","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตบางรัก","citizenIssueDate":"20120411","citizenExpiryDate":"20300409","passportNo":"","passportCountry":"TH","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":True},"customerConsent":{"referenceId":"3914654278431","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]}]},"liveImageSuccess":"Y","facialConsent":"Y","fatcaInfo":None},"crsForm":{"crsInfo":{"firstName":"${MOCK_EngFirstName}","lastName":"${MOCK_EengLastName}","cityOfBirth":"BK","countryCodeOfBirth":"AX","suiteIdentifier":"2","floorIdentifier":"s","buildingIdentifier":"s","street":"s","countryCode":"AX","city":"xxx","countryOfTaxResidences":[{"crsCountryFlag":"N","resCountryCode":"TH","tin":"655"}]}}}]},"productInfo":{"travelCards":[],"debitCards":[{"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","insuranceAddress":None,"verificationService":${Verification_Service},"cardType":"${Card_Type}","cardGroup":"${Card_Group}","propertyInsuranceFlag":"${Property_Insurance_Flag}","cardShortDesc":"${Card_ShortDesc}","usageCode":"${Usage_Code}","usageCodeDesc":"${Usage_CodeDesc}","maskedCardNo":"","cardName":"R. CHANTASIAN","feeType":"${Fee_Type}","issueFee":${IssueFee},"annualFee":${AnnualFee},"collectedAnnualFee":${CollectedAnnualFee},"totalFee":${TotalFee},"accountNumber":"${ACCOUNT_NO}","accountNumber2":None,"accountNumber3":None,"mailingType":"BRANCH","mailingAddressType":"","productAddress":None,"otherAddress":None,"deliveryFee":None,"salesCode":"13772","ktbWaiveFlag":True,"memoNo":"","campaignDesc":"","appId":"${APP_ID}"}],"deposits":[],"cardMaintenances":[],"promptpayMaintenance":[],"tempCards":[],"promptpayGroups":None,"emoneys":[],"accountMaintenances":[],"mutualFundAccount":None,"insuranceTransactions":[],"newNext":None,"upLift":None,"statementRequests":[]},"customerAcceptConsent":False,"documentInfo":{"documents":[{"documentId":"PHOTO","uploadSessionId":"${PHOTO_UPLOAD_SESSION_ID}"}]},"opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","additionalInfo":{"sellerFirstName":"กาญจนา","sellerLastName":"น้อยชมภู","sellerPosition":"เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","sellerId":"551922"},"flow":"deposit","subFlow":"","needPrintedDocument":False,"sendCusEmailDocument":False,"portfolioInfo":{"mortgageRetentions":[{"accountName":"น.ส. รัชนี จันทเศียรทดสอบ With","accountNo":"100035628990","accountRelShipCd":"P","accountRelationship":"3","accountStatus":0,"accruedInterest":0,"acctCCSMSDt":"","acctLstPmtDt":"","acctPartnerLinkageFlg":"","acctRegSMSDt":"","acctRegSMSFlg":"0","acctSMSChnl":"","acctSMSMobile":"","acctSMSWFlg":"0","authLimit":1000000,"availBalAmt":1000000,"balAmt":0,"brnOwnerShip":86,"currCd":"THB","eduLoan":0,"intReceive":0,"lastSalPaidDt":"","linkTWTotalPayoffAmt":0,"loanAccountSubType":"00004","loanClassFinal":0,"loanSubAccountOption":0,"loanSubAccountOptionType":"","marketCode":"7813","marketCodeDesc":"สินเชื่อ Home For Cash สำหรับข้าราชการ - Promotion","maturityDt":"20290513","openAcctChannel":"","productGroup":"LN","productProgram":"","productType":7002,"smeCode":"","smsAlertMinAmt":0,"transactionLastDate":"","branchCode":"200086","branchName":"สาขาเซ็นทรัลบางนา","existHardStopIden":False}],"fnaInfo":None}}    json
    
    ELSE IF    '${Label_serviceType}' == 'TravelCards' and ${IS_NEW_NEXT} == ${TRUE}
        ${data}=    Evaluate      {"caseId":"${CASE_ID}","selectedLanguage":"th","customerInfo":{"personalInfos":[{"cardInfo":{"engTitle":"${MOCK_EngTitle}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","thaiTitle":"${MOCK_ThaiTitle}","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","address":{"homeNo":"${MOCK_Address_HomeNo}","soi":"${MOCK_Address_Soi}","trok":"","moo":"","road":"${MOCK_Address_Road}","subDistrict":"${MOCK_Address_SubDistrict}","district":"${MOCK_Address_District}","province":"กรุงเทพมหานคร","postalCode":"10200"},"cardType":"Citizen ID","cardNumber":"${MOCK_CardNumber}","cardExpiryDate":"${MOCK_CardExpiryDate}","cardIssueDate":"${MOCK_CardIssueDate}","cardIssuePlace":"${MOCK_CardIssuePlace}","sex":"${MOCK_Sex}","dateOfBirth":"${MOCK_DateOfBirth}","bp1No":"${MOCK_Bp1No}","chipId":"${MOCK_ChipId}","manualKeyIn":False,"customerType":"221","foreigner":False,"isInvolvingPoliticiansFR":"2","isInvolvingPoliticiansTH":"2"},"cifForm":{"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"af8665d3-9e0e-4c98-82d8-a4d2b84d3cc2"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"รัชนี จันทเศียรทดสอบ","engTitle":"${MOCK_EngTitle}","engName":"RATCHANEE CHANTASIAN","dateOfBirth":"19790410","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"${MOCK_CardIssuePlace}","cardIssueDate":"20120411","cardExpiryDate":"20300409","legalAddr1":"35/10","legalAddr2":"ซ.สุขุมวิท 1","legalAddr3":"ถ.สุขุมวิท","legalSubDistrict":"0100","legalDistrict":"1","legalStateProv":"10","legalPostalCd":"10200","legalCountry":"TH","mailingAddr1":"35/10","mailingAddr2":"ซ.สุขุมวิท 1","mailingAddr3":"ถ.สุขุมวิท","mailingSubDistrict":"0100","mailingDistrict":"1","mailingStateProv":"10","mailingPostalCd":"10200","mailingCountry":"TH","occupationCd":"1107","subOccupationCd":"01","officeName":"กรุงไทย จำกัด","officeAddr1":"445","officeAddr2":"","officeAddr3":"","officeSubDistrict":"0100","officeDistrict":"1","officeStateProv":"10","officePostalCd":"10200","officeCountry":"TH","homePhone":"032900000","mobilePhone":"${OTP_Tel}","officePhone":"021111111","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"6","maritalStat":"S","sex":"${MOCK_Sex}","accountOpenDt":"20180326","kycStatus":"1","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"","personIDDocumentDetail":"","locationIDDocument":"","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"แขวงพระบรมมหาราชวัง","legalDistrictDesc":"เขตพระนคร","legalStateProvDesc":"กรุงเทพมหานคร","mailingSubDistrictDesc":"แขวงพระบรมมหาราชวัง","mailingDistrictDesc":"เขตพระนคร","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงพระบรมมหาราชวัง","officeDistrictDesc":"เขตพระนคร","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"40,001-60,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"722","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"3","ktbUserID":"","legalAddr4":"แขวงพระบรมมหาราชวัง","mailingAddr4":"แขวงพระบรมมหาราชวัง","officeAddr4":"แขวงพระบรมมหาราชวัง","occupationSector":"02","smsSaleCode":"","kycLastReviewDt":"20250209","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"200722","amdUnit":"","citizenID":"3914654278431","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200722,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@GMAIL.COM","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตบางรัก","citizenIssueDate":"20120411","citizenExpiryDate":"20300409","passportNo":"","passportCountry":"TH","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":True},"customerConsent":{"referenceId":"3914654278431","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]}]},"liveImageSuccess":"Y","facialConsent":"Y","fatcaInfo":None},"crsForm":{"crsInfo":{"firstName":"${MOCK_EngFirstName}","lastName":"${MOCK_EengLastName}","cityOfBirth":"BK","countryCodeOfBirth":"AX","suiteIdentifier":"2","floorIdentifier":"s","buildingIdentifier":"s","street":"s","countryCode":"AX","city":"xxx","countryOfTaxResidences":[{"crsCountryFlag":"N","resCountryCode":"TH","tin":"655"}]}}}]},"productInfo":{"travelCards":[{"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","cardType":"${Card_Type}","insuranceAddress":None,"objectiveCode":"06","verificationService":${Verification_Service},"cardGroup":"${Card_Group}","propertyInsuranceFlag":"${Property_Insurance_Flag}","cardShortDesc":"${Card_ShortDesc}","usageCode":"${Usage_Code}","usageCodeDesc":"${Usage_CodeDesc}","issueFee":${IssueFee},"annualFee":${AnnualFee},"collectedAnnualFee":${CollectedAnnualFee},"totalFee":${TotalFee},"feeType":"${Fee_Type}","maskedCardNo":"","cardName":"R. CHANTASIAN","accountNumber":"${ACCOUNT_NO}","accountNumber2":None,"accountNumber3":None,"mailingType":"BRANCH","mailingAddressType":"","productAddress":None,"otherAddress":None,"deliveryFee":None,"salesCode":"13772","ktbWaiveFlag":True,"memoNo":"","campaignDesc":"","appId":"${APP_ID}"}],"debitCards":[],"deposits":[],"cardMaintenances":[],"promptpayMaintenance":[],"tempCards":[],"promptpayGroups":None,"emoneys":[],"accountMaintenances":[],"mutualFundAccount":None,"insuranceTransactions":[],"newNext":{"productId":"KTNEXT-1","productCode":"KTNEXT","productName":"Krungthai NEXT","productTypeId":"SV01-1","productTypeCode":"SV01","bypassFacialReason":"รูปบนบัตรประชาชนไม่อัปเดต","bypassFacialReasonDescription":"","bypassFacial":True,"bypassFlow":"registration","appId":"${APP_ID_NEXT}"},"upLift":None,"statementRequests":[]},"customerAcceptConsent":False,"documentInfo":{"documents":[{"documentId":"PHOTO","uploadSessionId":"${PHOTO_UPLOAD_SESSION_ID}"}]},"opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","additionalInfo":{"sellerFirstName":"กาญจนา","sellerLastName":"น้อยชมภู","sellerPosition":"เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","sellerId":"551922"},"flow":"deposit","subFlow":"","needPrintedDocument":False,"sendCusEmailDocument":False,"portfolioInfo":{"mortgageRetentions":[{"accountName":"น.ส. รัชนี จันทเศียรทดสอบ With","accountNo":"100035628990","accountRelShipCd":"P","accountRelationship":"3","accountStatus":0,"accruedInterest":0,"acctCCSMSDt":"","acctLstPmtDt":"","acctPartnerLinkageFlg":"","acctRegSMSDt":"","acctRegSMSFlg":"0","acctSMSChnl":"","acctSMSMobile":"","acctSMSWFlg":"0","authLimit":1000000,"availBalAmt":1000000,"balAmt":0,"brnOwnerShip":86,"currCd":"THB","eduLoan":0,"intReceive":0,"lastSalPaidDt":"","linkTWTotalPayoffAmt":0,"loanAccountSubType":"00004","loanClassFinal":0,"loanSubAccountOption":0,"loanSubAccountOptionType":"","marketCode":"7813","marketCodeDesc":"สินเชื่อ Home For Cash สำหรับข้าราชการ - Promotion","maturityDt":"20290513","openAcctChannel":"","productGroup":"LN","productProgram":"","productType":7002,"smeCode":"","smsAlertMinAmt":0,"transactionLastDate":"","branchCode":"200086","branchName":"สาขาเซ็นทรัลบางนา","existHardStopIden":False}],"fnaInfo":None}}    json
    
    ELSE
        ${data}=    Evaluate    {"caseId":"${CASE_ID}","selectedLanguage":"th","customerInfo":{"personalInfos":[{"cardInfo":{"engTitle":"${MOCK_EngTitle}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","thaiTitle":"${MOCK_ThaiTitle}","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","address":{"homeNo":"${MOCK_Address_HomeNo}","soi":"${MOCK_Address_Soi}","trok":"","moo":"","road":"${MOCK_Address_Road}","subDistrict":"${MOCK_Address_SubDistrict}","district":"${MOCK_Address_District}","province":"กรุงเทพมหานคร","postalCode":"10200"},"cardType":"Citizen ID","cardNumber":"${MOCK_CardNumber}","cardExpiryDate":"${MOCK_CardExpiryDate}","cardIssueDate":"${MOCK_CardIssueDate}","cardIssuePlace":"${MOCK_CardIssuePlace}","sex":"${MOCK_Sex}","dateOfBirth":"${MOCK_DateOfBirth}","bp1No":"${MOCK_Bp1No}","chipId":"${MOCK_ChipId}","manualKeyIn":False,"customerType":"221","foreigner":False,"isInvolvingPoliticiansFR":"2","isInvolvingPoliticiansTH":"2"},"cifForm":{"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"af8665d3-9e0e-4c98-82d8-a4d2b84d3cc2"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"รัชนี จันทเศียรทดสอบ","engTitle":"${MOCK_EngTitle}","engName":"RATCHANEE CHANTASIAN","dateOfBirth":"19790410","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"${MOCK_CardIssuePlace}","cardIssueDate":"20120411","cardExpiryDate":"20300409","legalAddr1":"35/10","legalAddr2":"ซ.สุขุมวิท 1","legalAddr3":"ถ.สุขุมวิท","legalSubDistrict":"0100","legalDistrict":"1","legalStateProv":"10","legalPostalCd":"10200","legalCountry":"TH","mailingAddr1":"35/10","mailingAddr2":"ซ.สุขุมวิท 1","mailingAddr3":"ถ.สุขุมวิท","mailingSubDistrict":"0100","mailingDistrict":"1","mailingStateProv":"10","mailingPostalCd":"10200","mailingCountry":"TH","occupationCd":"1107","subOccupationCd":"01","officeName":"กรุงไทย จำกัด","officeAddr1":"445","officeAddr2":"","officeAddr3":"","officeSubDistrict":"0100","officeDistrict":"1","officeStateProv":"10","officePostalCd":"10200","officeCountry":"TH","homePhone":"032900000","mobilePhone":"${OTP_Tel}","officePhone":"021111111","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"6","maritalStat":"S","sex":"${MOCK_Sex}","accountOpenDt":"20180326","kycStatus":"1","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"","personIDDocumentDetail":"","locationIDDocument":"","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"แขวงพระบรมมหาราชวัง","legalDistrictDesc":"เขตพระนคร","legalStateProvDesc":"กรุงเทพมหานคร","mailingSubDistrictDesc":"แขวงพระบรมมหาราชวัง","mailingDistrictDesc":"เขตพระนคร","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงพระบรมมหาราชวัง","officeDistrictDesc":"เขตพระนคร","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"40,001-60,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"722","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"3","ktbUserID":"","legalAddr4":"แขวงพระบรมมหาราชวัง","mailingAddr4":"แขวงพระบรมมหาราชวัง","officeAddr4":"แขวงพระบรมมหาราชวัง","occupationSector":"02","smsSaleCode":"","kycLastReviewDt":"20250209","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"200722","amdUnit":"","citizenID":"3914654278431","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200722,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@GMAIL.COM","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตบางรัก","citizenIssueDate":"20120411","citizenExpiryDate":"20300409","passportNo":"","passportCountry":"TH","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":True},"customerConsent":{"referenceId":"3914654278431","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]}]},"liveImageSuccess":"Y","facialConsent":"Y","fatcaInfo":None},"crsForm":{"crsInfo":{"firstName":"${MOCK_EngFirstName}","lastName":"${MOCK_EengLastName}","cityOfBirth":"BK","countryCodeOfBirth":"AX","suiteIdentifier":"2","floorIdentifier":"s","buildingIdentifier":"s","street":"s","countryCode":"AX","city":"xxx","countryOfTaxResidences":[{"crsCountryFlag":"N","resCountryCode":"TH","tin":"655"}]}}}]},"productInfo":{"travelCards":[{"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","cardType":"${Card_Type}","insuranceAddress":None,"objectiveCode":"06","verificationService":${Verification_Service},"cardGroup":"${Card_Group}","propertyInsuranceFlag":"${Property_Insurance_Flag}","cardShortDesc":"${Card_ShortDesc}","usageCode":"${Usage_Code}","usageCodeDesc":"${Usage_CodeDesc}","issueFee":${IssueFee},"annualFee":${AnnualFee},"collectedAnnualFee":${CollectedAnnualFee},"totalFee":${TotalFee},"feeType":"${Fee_Type}","maskedCardNo":"","cardName":"R. CHANTASIAN","accountNumber":"${ACCOUNT_NO}","accountNumber2":None,"accountNumber3":None,"mailingType":"BRANCH","mailingAddressType":"","productAddress":None,"otherAddress":None,"deliveryFee":None,"salesCode":"13772","ktbWaiveFlag":True,"memoNo":"","campaignDesc":"","appId":"${APP_ID}"}],"debitCards":[],"deposits":[],"cardMaintenances":[],"promptpayMaintenance":[],"tempCards":[],"promptpayGroups":None,"emoneys":[],"accountMaintenances":[],"mutualFundAccount":None,"insuranceTransactions":[],"newNext":None,"upLift":None,"statementRequests":[]},"customerAcceptConsent":False,"documentInfo":{"documents":[{"documentId":"PHOTO","uploadSessionId":"${PHOTO_UPLOAD_SESSION_ID}"}]},"opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","additionalInfo":{"sellerFirstName":"กาญจนา","sellerLastName":"น้อยชมภู","sellerPosition":"เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","sellerId":"551922"},"flow":"deposit","subFlow":"","needPrintedDocument":False,"sendCusEmailDocument":False,"portfolioInfo":{"mortgageRetentions":[{"accountName":"น.ส. รัชนี จันทเศียรทดสอบ With","accountNo":"100035628990","accountRelShipCd":"P","accountRelationship":"3","accountStatus":0,"accruedInterest":0,"acctCCSMSDt":"","acctLstPmtDt":"","acctPartnerLinkageFlg":"","acctRegSMSDt":"","acctRegSMSFlg":"0","acctSMSChnl":"","acctSMSMobile":"","acctSMSWFlg":"0","authLimit":1000000,"availBalAmt":1000000,"balAmt":0,"brnOwnerShip":86,"currCd":"THB","eduLoan":0,"intReceive":0,"lastSalPaidDt":"","linkTWTotalPayoffAmt":0,"loanAccountSubType":"00004","loanClassFinal":0,"loanSubAccountOption":0,"loanSubAccountOptionType":"","marketCode":"7813","marketCodeDesc":"สินเชื่อ Home For Cash สำหรับข้าราชการ - Promotion","maturityDt":"20290513","openAcctChannel":"","productGroup":"LN","productProgram":"","productType":7002,"smeCode":"","smsAlertMinAmt":0,"transactionLastDate":"","branchCode":"200086","branchName":"สาขาเซ็นทรัลบางนา","existHardStopIden":False}],"fnaInfo":None}}    json
    END
    
    ${upper}=    Convert To Upper Case    ${Overide}
    IF    '${upper}' == 'Y'
        ${cifForm}    Set Variable    {"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"47e63b21-195d-4744-8975-b10d92d1624b"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}","engTitle":"${MOCK_EngTitle}","engName":"${MOCK_EngFirstName} ${MOCK_EengLastName}","dateOfBirth":"19930424","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"สำนักงานเขตคลองเตย","cardIssueDate":"20200212","cardExpiryDate":"20280816","legalAddr1":"30","legalAddr2":"หมู่ 1 สามัคคี28","legalAddr3":"ถ.สามัคคี","legalSubDistrict":"0500","legalDistrict":"1","legalStateProv":"12","legalPostalCd":"11000","legalCountry":"TH","mailingAddr1":"51/70","mailingAddr2":"","mailingAddr3":"ถ.พัฒนาชนบท 3","mailingSubDistrict":"0200","mailingDistrict":"11","mailingStateProv":"10","mailingPostalCd":"10520","mailingCountry":"TH","occupationCd":"1257","subOccupationCd":"08","officeName":"BLUE","officeAddr1":"51/70","officeAddr2":"","officeAddr3":"ถ.พัฒนาชนบท 3","officeSubDistrict":"0200","officeDistrict":"11","officeStateProv":"10","officePostalCd":"10520","officeCountry":"TH","homePhone":"","mobilePhone":"${OTP_Tel}","officePhone":"0788885856","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"5","maritalStat":"S","sex":"M","accountOpenDt":"20241106","kycStatus":"1","thaiFirstName":"ชนัดดา","thaiMiddleName":"","thaiLastName":"พฤฒาการย์","engFirstName":"CHANADDA","engMiddleName":"","engLastName":"PHRUETTHAKAN","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"01","personIDDocumentDetail":"","locationIDDocument":"01","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"200000","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"ตำบลท่าทราย","legalDistrictDesc":"อำเภอเมืองนนทบุรี","legalStateProvDesc":"นนทบุรี","mailingSubDistrictDesc":"แขวงคลองสองต้นนุ่น","mailingDistrictDesc":"เขตลาดกระบัง","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงคลองสองต้นนุ่น","officeDistrictDesc":"เขตลาดกระบัง","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"30,001-40,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"0","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"4","ktbUserID":"","legalAddr4":"ตำบลท่าทราย","mailingAddr4":"แขวงคลองสองต้นนุ่น","officeAddr4":"แขวงคลองสองต้นนุ่น","occupationSector":"07","smsSaleCode":"","kycLastReviewDt":"20250327","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"0","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"${MOCK_CardNumber}","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"","amdUnit":"","citizenID":"${MOCK_CardNumber}","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200000,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"TH","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@gmail.com","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตคลองเตย","citizenIssueDate":"20200212","citizenExpiryDate":"20280816","passportNo":"","passportCountry":"","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":true},"customerConsent":{"referenceId":"${CUSTOMER_CIF}","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]}]},"facialConsent":"N","cbsInfoChanges":[{"field":"emailAddr","newValue":"${Email}","oldValue":"${Old_EmailAddr}"},{"field":"mobilePhone","newValue":"${OTP_Tel}","oldValue":"${Old_Tel}"}],"fatcaInfo":{"q1Flag":"0","q2Flag":"0","q3Flag":"0","q4Flag":"0","q5Flag":"0","q6Flag":"0","q8Flag":null,"q7Flag":"0","lastUIDFATCA":"${User_ID}"}}
        ${cifForm}    Replace Variables    ${cifForm}  
        # ${cifForm}    Clean string for load json    ${cifForm}
        ${cifForm} =   Evaluate    json.loads('${cifForm}')
        Set To Dictionary   ${data}[customerInfo][personalInfos][0]    cifForm=${cifForm} 
    END

    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200
    #Should Be Equal    ${response.content}    ${None}
    Sleep    2s

Open newnext if fact true
    IF    ${Is_open_newnext}
        Generate App ID Next
        Bypass face newnext with overide
    END

Checker approve newnext on local
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/approval
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    ${subFunctionData}=    Create Dictionary
    ...    syncDataFromCbs=${False}
    ...    updateMobileNumber=${False}
    ...    updateStatus=${False}
    ...    updateSegment=${False}
    ...    bypassFacial=${True}
    ...    bypassFlow=registration
    ...    bypassFacialReason=รูปบนบัตรประชาชนไม่อัปเดต
    ...    bypassFacialReasonDescription=
    ...    productCode=KTNEXT
    ...    productName=Krungthai NEXT
    ...    mobilePhone=${OTP_Tel}

    ${subFunction}=    Create Dictionary
    ...    subFunctionCode=KTNEXT
    ...    data=${subFunctionData}

    ${subFunctions}=    Create List    ${subFunction}

    ${data}=    Create Dictionary
    ...    subFunctions=${subFunctions}
    ...    branchCode=${Overide_branchCode}
    ...    customerNo=${CUSTOMER_CIF}
    ...    makerUserGroup=CSSM
    ...    transactionLimit=10000000

    ${payload}=    Create Dictionary
    ...    caseId=${CASE_ID}
    ...    functionCode=SUBMIT_CHECKER
    ...    type=L
    ...    cardNumber=${MOCK_CardNumber}
    ...    cardType=01
    ...    data=${data}
    ...    thaiName=${MOCK_ThaiTitle} ${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}
    ...    engName=${MOCK_EngTitle} ${MOCK_EngFirstName} ${MOCK_EengLastName}

    Log    ${payload}

    Create Session   approval    ${url}
    ${response}=    POST On Session    approval    ${uri}    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Set Test Variable    ${newnext_approvalId}    ${json["approvalId"]}  

Local newnext overide
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/approval/${newnext_approvalId}/approve/local
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    ${data_dict}=    Create Dictionary
    ...    username=${Overide_employeeId}   
    ...    secret=P@ssw0rd
    ...    data=${EMPTY}

    ${data}=    Create Dictionary
    ...    flow=deposit

    Set To Dictionary    ${data_dict}    data    ${data}

    Create Session   Local_overide    ${url}
    ${response}=    POST On Session    Local_overide    ${uri}    json=${data_dict}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain item    ${json}    approval1    ${Overide_employeeId}
    Dictionary Should Contain Key     ${json}    approval1Date
    Dictionary Should Contain Key     ${json}    approval1Status
    Dictionary Should Contain Key     ${json}    approvalBranchId
    Dictionary Should Contain Key     ${json}    approvalCount
    Dictionary Should Contain item    ${json}    approvalId    ${newnext_approvalId}
    Dictionary Should Contain Key     ${json}    approvalRequired
    Dictionary Should Contain Key     ${json}    approvalStatus
    Dictionary Should Contain Key     ${json}    branchId
    Dictionary Should Contain item    ${json}    cardNumber    ${MOCK_CardNumber}
    Dictionary Should Contain Key     ${json}    cardType
    Dictionary Should Contain Key     ${json}    checked
    Dictionary Should Contain Key     ${json}    createdDate
    Dictionary Should Contain item    ${json}    engName    ${MOCK_EngTitle} ${MOCK_EngFirstName} ${MOCK_EengLastName}
    Dictionary Should Contain item    ${json}    functionCode    SUBMIT_CHECKER
    Dictionary Should Contain Key     ${json}    lockBy
    Dictionary Should Contain Key     ${json}    sellerId    ${User_ID}
    Should Be Equal As Strings        ${json["sellerId"]}    ${User_ID}
    Dictionary Should Contain Key     ${json}    sscRequired
    Dictionary Should Contain item     ${json}    thaiName    ${MOCK_ThaiTitle} ${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}
    Dictionary Should Contain Key     ${json}    type
    Dictionary Should Contain Key     ${json}    updatedDate
    Dictionary Should Contain Key     ${json}    version
