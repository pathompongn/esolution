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
Retrieve MFOA Get Case ID
    #retrieve_case
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_CASE_RETRIEVE}
    Log    url = ${url}${uri}

    ${data}=    Evaluate    {"cardInfo": {"engTitle": "${MOCK_EngTitle}","engFirstName": "${MOCK_EngFirstName}","engMiddleName": "","engLastName": "${MOCK_EengLastName}","thaiTitle": "${MOCK_ThaiTitle}","thaiFirstName": "${MOCK_ThaiFirstName}","thaiMiddleName": "","thaiLastName": "${MOCK_ThaiLastName}","address": {"homeNo": "${MOCK_Address_HomeNo}","soi": "${MOCK_Address_Soi}","trok": "","moo": "","road": "${MOCK_Address_Road}","subDistrict": "แขวงพระบรมมหาราชวัง","district": "เขตพระนคร","province": "กรุงเทพมหานคร","postalCode": "10200"},"cardType": "Citizen ID","cardNumber": "${MOCK_CardNumber}","cardExpiryDate": "${MOCK_CardExpiryDate}","cardIssueDate": "${MOCK_CardIssueDate}","cardIssuePlace": "${MOCK_CardIssuePlace}","sex": "${MOCK_Sex}","dateOfBirth": "${MOCK_DateOfBirth}","bp1No": "${MOCK_Bp1No}","chipId": "${MOCK_ChipId}","customerType": "221","foreigner": False,"manualKeyIn": False},"channel": "android","flow": "mfoa","sellerInfo": {"firstName": "กาญจนา","lastName": "น้อยชมภู","position": "เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","userGroup": "BRSUP","licenses": [{"licenseType": "ICC2","licenseNo": "062783","licenseExp": "20341231","errorFlag": False,"expired": False},{"licenseType": "LF","licenseNo": "5603007437","licenseExp": "20410623","errorFlag": False,"expired": False},{"licenseType": "NON LIFE","licenseNo": "5604011546","licenseExp": "20320623","errorFlag": False,"expired": False}]},"subFlow": "","data": {},"draftedCaseId": "","skipIntroduction": False,"mcToolRefNo": "${MC_TOOL_REFNO}","opportunityLogRefNo": "${OPPORTUNITY_LOG_REFNO}"}    json
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    Retrieve_CaseID    ${url}
    ${response}=    POST On Session    Retrieve_CaseID    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    Dictionary Should Contain Key     ${json}    caseId
    Dictionary Should Contain Key     ${json}    branchCode
    Dictionary Should Contain Key     ${json}    employeeId
    Dictionary Should Contain Key     ${json}    employeeIdNoAx
    Dictionary Should Contain Key     ${json}    employeeUserGroup
    Dictionary Should Contain Key     ${json}    employeeLicenses
    ${employeeLicenses}=    Set Variable    ${json["employeeLicenses"][0]}
    Dictionary Should Contain Key     ${employeeLicenses}    licenseType
    Dictionary Should Contain Key     ${employeeLicenses}    licenseNo
    Dictionary Should Contain Key     ${employeeLicenses}    licenseExp
    Dictionary Should Contain Key     ${employeeLicenses}    errorFlag
    Dictionary Should Contain Key     ${employeeLicenses}    expired
    Dictionary Should Contain Key     ${json}    channel
    Dictionary Should Contain Key     ${json}    flow
    Dictionary Should Contain Key     ${json}    createdDate
    Dictionary Should Contain Key     ${json}    savedDate
    Dictionary Should Contain Key     ${json}    caseStatus
    Dictionary Should Contain Key     ${json}    customerInfo
    Dictionary Should Contain Key     ${json}    productInfo
    ${productInfo}=    Set Variable    ${json["productInfo"]}
    Dictionary Should Contain Key     ${productInfo}    travelCards
    Dictionary Should Contain Key     ${productInfo}    debitCards
    Dictionary Should Contain Key     ${productInfo}    deposits
    Dictionary Should Contain Key     ${productInfo}    cardMaintenances
    Dictionary Should Contain Key     ${productInfo}    promptpayMaintenance
    Dictionary Should Contain Key     ${productInfo}    tempCards
    Dictionary Should Contain Key     ${productInfo}    promptpayGroups
    Dictionary Should Contain Key     ${productInfo}    emoneys
    Dictionary Should Contain Key     ${productInfo}    accountMaintenances
    Dictionary Should Contain Key     ${json}    additionalInfo
    ${additionalInfo}=    Set Variable    ${json["additionalInfo"]}
    Dictionary Should Contain Key     ${additionalInfo}    sellerFirstName
    Dictionary Should Contain Key     ${additionalInfo}    sellerLastName
    Dictionary Should Contain Key     ${additionalInfo}    sellerPosition
    Dictionary Should Contain Key     ${additionalInfo}    workbenchSubmit
    Dictionary Should Contain Key     ${json}    portfolioInfo
    Dictionary Should Contain Key     ${json}    subFlow
    Dictionary Should Contain item    ${json}    opportunityLogRefNo    ${OPPORTUNITY_LOG_REFNO}
    Dictionary Should Contain Key     ${json}    needPrintedDocument
    Dictionary Should Contain Key     ${json}    sendCusEmailDocument
    Dictionary Should Contain Key     ${json}    caseMaintenance
    Dictionary Should Contain Key     ${json}    customerAcceptConsent
    
    Set Suite Variable    ${CASE_ID}    ${json["caseId"]}

Retrieve MFOA Continue
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/continue
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    Retrieve_Continue    ${url}
    ${response}=    POST On Session  Retrieve_Continue  ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    ${flag}=    Set Variable    ${FALSE}

    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    branchCode
    Dictionary Should Contain Key     ${json}    employeeId
    Dictionary Should Contain Key     ${json}    employeeIdNoAx
    Dictionary Should Contain Key     ${json}    employeeUserGroup
    Dictionary Should Contain Key     ${json}    employeeLicenses
    Dictionary Should Contain Key     ${json}    channel
    Dictionary Should Contain Key     ${json}    flow
    Dictionary Should Contain Key     ${json}    createdDate
    Dictionary Should Contain Key     ${json}    savedDate
    Dictionary Should Contain Key     ${json}    caseStatus
    Dictionary Should Contain Key     ${json}    customerInfo
    ${customerInfo}=    Set Variable    ${json["customerInfo"]}
    Dictionary Should Contain Key     ${customerInfo}    personalInfos
    Dictionary Should Contain Key     ${customerInfo}[personalInfos][0][cifExistingData]    customerNo
    Dictionary Should Contain Key     ${customerInfo}[personalInfos][0][cifExistingData]    mobilePhone
    Dictionary Should Contain Key     ${customerInfo}[personalInfos][0][cifExistingData]    emailAddr
    ${Old_EmailAddr}    Set Variable    ${customerInfo}[personalInfos][0][cifExistingData][emailAddr]
    ${Old_Tel}    Set Variable    ${customerInfo}[personalInfos][0][cifExistingData][mobilePhone]
    Set Test Variable   ${Old_EmailAddr}
    Set Test Variable   ${Old_Tel}
    Dictionary Should Contain Key     ${json}    productInfo
    Dictionary Should Contain Key     ${json}    additionalInfo
    Dictionary Should Contain Key     ${json}    portfolioInfo

    @{deposits}=    Set Variable    ${json["portfolioInfo"]["deposits"]}
    ${Length_ITEM} =	Get Length      ${deposits}
    FOR    ${index}    IN RANGE    0    ${Length_ITEM}
        IF    '${Label_serviceType}' == 'AccounMaintenance'
            IF    '${deposits}[${index}][productGroup]' == '${SearchProductGroup}' and '${deposits}[${index}][accountStatus]' == '${SearchAcStatus}'
                
                IF    '${RemoveAcEduFlag}' == 'true'
                    IF    '${deposits}[${index}][eduLoan]' == '1'
                        Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
                        Dictionary Should Contain Key     ${deposits}[${index}]    productName
                        Dictionary Should Contain Key     ${deposits}[${index}]    productType
                        Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
                        ${flag}=    Set Variable    ${TRUE}
                        Exit For Loop
                    END
                    
                ELSE
                    Dictionary Should Contain Key     ${deposits}[${index}]    accountName
                    Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
                    Dictionary Should Contain Key     ${deposits}[${index}]    accountRelShipCd
                    Dictionary Should Contain Key     ${deposits}[${index}]    accountRelationship
                    Dictionary Should Contain Key     ${deposits}[${index}]    accountStatus
                    Dictionary Should Contain Key     ${deposits}[${index}]    accruedInterest
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctCCSMSDt
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctLstPmtDt
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctPartnerLinkageFlg
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctRegSMSDt
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctRegSMSFlg
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctSMSChnl
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctSMSMobile
                    Dictionary Should Contain Key     ${deposits}[${index}]    acctSMSWFlg
                    Dictionary Should Contain Key     ${deposits}[${index}]    authLimit
                    Dictionary Should Contain Key     ${deposits}[${index}]    availBalAmt
                    Dictionary Should Contain Key     ${deposits}[${index}]    balAmt
                    Dictionary Should Contain Key     ${deposits}[${index}]    brnOwnerShip
                    Dictionary Should Contain Key     ${deposits}[${index}]    currCd
                    Dictionary Should Contain Key     ${deposits}[${index}]    eduLoan
                    Dictionary Should Contain Key     ${deposits}[${index}]    intReceive
                    Dictionary Should Contain Key     ${deposits}[${index}]    lastSalPaidDt
                    Dictionary Should Contain Key     ${deposits}[${index}]    linkTWTotalPayoffAmt
                    Dictionary Should Contain Key     ${deposits}[${index}]    loanAccountSubType
                    Dictionary Should Contain Key     ${deposits}[${index}]    loanClassFinal
                    Dictionary Should Contain Key     ${deposits}[${index}]    loanSubAccountOption
                    Dictionary Should Contain Key     ${deposits}[${index}]    loanSubAccountOptionType
                    Dictionary Should Contain Key     ${deposits}[${index}]    marketCode
                    Dictionary Should Contain Key     ${deposits}[${index}]    marketCodeDesc
                    Dictionary Should Contain Key     ${deposits}[${index}]    maturityDt
                    Dictionary Should Contain Key     ${deposits}[${index}]    openAcctChannel
                    Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
                    Dictionary Should Contain Key     ${deposits}[${index}]    productProgram
                    Dictionary Should Contain Key     ${deposits}[${index}]    productType
                    Dictionary Should Contain Key     ${deposits}[${index}]    smeCode
                    Dictionary Should Contain Key     ${deposits}[${index}]    smsAlertMinAmt
                    Dictionary Should Contain Key     ${deposits}[${index}]    transactionLastDate
                    Dictionary Should Contain Key     ${deposits}[${index}]    productName
                    Dictionary Should Contain Key     ${deposits}[${index}]    bulkFlag
                    Dictionary Should Contain Key     ${deposits}[${index}]    identifications
                    Dictionary Should Contain Key     ${deposits}[${index}]    updatedDetail
                    Dictionary Should Contain Key     ${deposits}[${index}]    accountBalAmt
                    ${flag}=    Set Variable    ${TRUE}
                    Exit For Loop
                END

            END
        
        ELSE
            IF    '${deposits}[${index}][productGroup]' == 'SAV' and '${deposits}[${index}][accountStatus]' == '0' #and ${deposits}[${index}][availBalAmt] > 2000
                Dictionary Should Contain Key     ${deposits}[${index}]    accountName
                Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
                Dictionary Should Contain Key     ${deposits}[${index}]    accountRelShipCd
                Dictionary Should Contain Key     ${deposits}[${index}]    accountRelationship
                Dictionary Should Contain Key     ${deposits}[${index}]    accountStatus
                Dictionary Should Contain Key     ${deposits}[${index}]    accruedInterest
                Dictionary Should Contain Key     ${deposits}[${index}]    acctCCSMSDt
                Dictionary Should Contain Key     ${deposits}[${index}]    acctLstPmtDt
                Dictionary Should Contain Key     ${deposits}[${index}]    acctPartnerLinkageFlg
                Dictionary Should Contain Key     ${deposits}[${index}]    acctRegSMSDt
                Dictionary Should Contain Key     ${deposits}[${index}]    acctRegSMSFlg
                Dictionary Should Contain Key     ${deposits}[${index}]    acctSMSChnl
                Dictionary Should Contain Key     ${deposits}[${index}]    acctSMSMobile
                Dictionary Should Contain Key     ${deposits}[${index}]    acctSMSWFlg
                Dictionary Should Contain Key     ${deposits}[${index}]    authLimit
                Dictionary Should Contain Key     ${deposits}[${index}]    availBalAmt
                Dictionary Should Contain Key     ${deposits}[${index}]    balAmt
                Dictionary Should Contain Key     ${deposits}[${index}]    brnOwnerShip
                Dictionary Should Contain Key     ${deposits}[${index}]    currCd
                Dictionary Should Contain Key     ${deposits}[${index}]    eduLoan
                Dictionary Should Contain Key     ${deposits}[${index}]    intReceive
                Dictionary Should Contain Key     ${deposits}[${index}]    lastSalPaidDt
                Dictionary Should Contain Key     ${deposits}[${index}]    linkTWTotalPayoffAmt
                Dictionary Should Contain Key     ${deposits}[${index}]    loanAccountSubType
                Dictionary Should Contain Key     ${deposits}[${index}]    loanClassFinal
                Dictionary Should Contain Key     ${deposits}[${index}]    loanSubAccountOption
                Dictionary Should Contain Key     ${deposits}[${index}]    loanSubAccountOptionType
                Dictionary Should Contain Key     ${deposits}[${index}]    marketCode
                Dictionary Should Contain Key     ${deposits}[${index}]    marketCodeDesc
                Dictionary Should Contain Key     ${deposits}[${index}]    maturityDt
                Dictionary Should Contain Key     ${deposits}[${index}]    openAcctChannel
                Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
                Dictionary Should Contain Key     ${deposits}[${index}]    productProgram
                Dictionary Should Contain Key     ${deposits}[${index}]    productType
                Dictionary Should Contain Key     ${deposits}[${index}]    smeCode
                Dictionary Should Contain Key     ${deposits}[${index}]    smsAlertMinAmt
                Dictionary Should Contain Key     ${deposits}[${index}]    transactionLastDate
                Dictionary Should Contain Key     ${deposits}[${index}]    productName
                Dictionary Should Contain Key     ${deposits}[${index}]    bulkFlag
                Dictionary Should Contain Key     ${deposits}[${index}]    identifications
                Dictionary Should Contain Key     ${deposits}[${index}]    updatedDetail
                Dictionary Should Contain Key     ${deposits}[${index}]    accountBalAmt
                
                ${flag}=    Set Variable    ${TRUE}
                Exit For Loop
                
            END
        
        END
    
    END

    Dictionary Should Contain Key     ${json}    subFlow
    Dictionary Should Contain Key     ${json}    opportunityLogRefNo
    Dictionary Should Contain Key     ${json}    needPrintedDocument
    Dictionary Should Contain Key     ${json}    sendCusEmailDocument
    Dictionary Should Contain Key     ${json}    caseMaintenance
    Dictionary Should Contain Key     ${json}    customerAcceptConsent

    IF    ${flag}
        Set Suite Variable    ${ACCOUNT_NO}                ${deposits}[${index}][accountNo]
        Set Suite Variable    ${ACCOUNT_PRODUCT_NAME}      ${deposits}[${index}][productName]
        Set Suite Variable    ${ACCOUNT_PRODUCT_TYPE}      ${deposits}[${index}][productType]
        Set Suite Variable    ${ACCOUNT_PRODUCT_GROUP}     ${deposits}[${index}][productGroup]
    ELSE
        Fail    Not found account: ${account}
    END
    ${cifForm}=    Set Variable    ${json["customerInfo"]["personalInfos"][0]["cifForm"]}
    ${mutualFundConsent}    Set Variable    ${cifForm["mutualFundConsent"]}
    ${customerConsent}    Set Variable    ${cifForm["customerConsent"]}
    # Remove From Dictionary    ${customerConsent}    reviewedByCustomer

    Set Test Variable    ${mutualFundConsent}
    Set Test Variable    ${customerConsent}

    Remove From Dictionary    ${mutualFundConsent["consentList"][0]}    refId
    Remove From Dictionary    ${mutualFundConsent["consentList"][0]}    acceptedDate
    Remove From Dictionary    ${mutualFundConsent["consentList"][1]}    refId
    Remove From Dictionary    ${mutualFundConsent["consentList"][1]}    acceptedDate

    Set Suite Variable    ${CUSTOMER_CIF}    ${json["customerInfo"]["personalInfos"][0]["cifExistingData"]["customerNo"]}
    Set Suite Variable    ${OLD_MOBILE_PHONE}    ${json["customerInfo"]["personalInfos"][0]["cifExistingData"]["mobilePhone"]}

Create Standing Payment Order Dictionary
    ${current_date}=    Get Current Date
    ${day}=    Convert Date    ${current_date}    result_format=%d
    ${start_date}=    Convert Date    ${current_date}    result_format=%Y-%m-%d
    ${end_date}=    Add Time To Date    ${current_date}    60 days    result_format=%Y-%m-%d

    ${standing_payment}=    Set Variable    {"standingPaymentAccountNumber":"${ACCOUNT_NO}","standingPaymentAmount":1000,"standingPaymentDate":"${day}","standingPaymentStartDate":"${start_date}","standingPaymentEndDate":"${end_date}","standingPaymentOrderAction":"ADD","standingPaymentEndOfMonth":${False}}
    ${standing_payment_json}=    Evaluate    ${standing_payment}    modules=json
    RETURN    ${standing_payment_json}
Update Deposit Information Consent
    #put case action=Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}
    ${fullnameTh}    Set Variable    ${MOCK_ThaiTitle} ${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}
    ${fullnameEn}    Set Variable    ${MOCK_EngTitle} ${MOCK_EngFirstName} ${MOCK_EengLastName}

    ${timestamp}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%fZ
    ${timestamp}=    Evaluate    "${timestamp}"[:23] + "Z"
    
    # ${data_json}    Replace Variables    {"caseId":"${CASE_ID}","selectedLanguage":"th","customerInfo":{"personalInfos":[{"cardInfo":{"engTitle":"${MOCK_EngTitle}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","thaiTitle":"${MOCK_ThaiTitle}","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","address":{"homeNo":"${MOCK_Address_HomeNo}","soi":"${MOCK_Address_Soi}","trok":"","moo":"","road":"${MOCK_Address_Road}","subDistrict":"${MOCK_Address_SubDistrict}","district":"${MOCK_Address_District}","province":"กรุงเทพมหานคร","postalCode":"10200"},"cardType":"Citizen ID","cardNumber":"${MOCK_CardNumber}","cardExpiryDate":"${MOCK_CardExpiryDate}","cardIssueDate":"${MOCK_CardIssueDate}","cardIssuePlace":"${MOCK_CardIssuePlace}","sex":"${MOCK_Sex}","dateOfBirth":"${MOCK_DateOfBirth}","bp1No":"${MOCK_Bp1No}","chipId":"${MOCK_ChipId}","manualKeyIn":False,"customerType":"221","foreigner":False,"isInvolvingPoliticiansFR":"2","isInvolvingPoliticiansTH":"2"},"cifForm":{"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"af8665d3-9e0e-4c98-82d8-a4d2b84d3cc2"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"รัชนี จันทเศียรทดสอบ","engTitle":"${MOCK_EngTitle}","engName":"RATCHANEE CHANTASIAN","dateOfBirth":"19790410","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"${MOCK_CardIssuePlace}","cardIssueDate":"20120411","cardExpiryDate":"20300409","legalAddr1":"35/10","legalAddr2":"ซ.สุขุมวิท 1","legalAddr3":"ถ.สุขุมวิท","legalSubDistrict":"0100","legalDistrict":"1","legalStateProv":"10","legalPostalCd":"10200","legalCountry":"TH","mailingAddr1":"35/10","mailingAddr2":"ซ.สุขุมวิท 1","mailingAddr3":"ถ.สุขุมวิท","mailingSubDistrict":"0100","mailingDistrict":"1","mailingStateProv":"10","mailingPostalCd":"10200","mailingCountry":"TH","occupationCd":"1107","subOccupationCd":"01","officeName":"กรุงไทย จำกัด","officeAddr1":"445","officeAddr2":"","officeAddr3":"","officeSubDistrict":"0100","officeDistrict":"1","officeStateProv":"10","officePostalCd":"10200","officeCountry":"TH","homePhone":"032900000","mobilePhone":"${OTP_Tel}","officePhone":"021111111","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"6","maritalStat":"S","sex":"${MOCK_Sex}","accountOpenDt":"20180326","kycStatus":"1","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","engFirstName":"${MOCK_EngFirstName}","engMiddleName":"","engLastName":"${MOCK_EengLastName}","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"","personIDDocumentDetail":"","locationIDDocument":"","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"แขวงพระบรมมหาราชวัง","legalDistrictDesc":"เขตพระนคร","legalStateProvDesc":"กรุงเทพมหานคร","mailingSubDistrictDesc":"แขวงพระบรมมหาราชวัง","mailingDistrictDesc":"เขตพระนคร","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงพระบรมมหาราชวัง","officeDistrictDesc":"เขตพระนคร","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"40,001-60,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"722","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"3","ktbUserID":"","legalAddr4":"แขวงพระบรมมหาราชวัง","mailingAddr4":"แขวงพระบรมมหาราชวัง","officeAddr4":"แขวงพระบรมมหาราชวัง","occupationSector":"02","smsSaleCode":"","kycLastReviewDt":"20250209","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"200722","amdUnit":"","citizenID":"3914654278431","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200722,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@GMAIL.COM","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตบางรัก","citizenIssueDate":"20120411","citizenExpiryDate":"20300409","passportNo":"","passportCountry":"TH","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":True},"customerConsent":{"referenceId":"3914654278431","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-09T18:05:32+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]}]},"liveImageSuccess":"Y","facialConsent":"Y","fatcaInfo":None},"crsForm":{"crsInfo":{"firstName":"${MOCK_EngFirstName}","lastName":"${MOCK_EengLastName}","cityOfBirth":"BK","countryCodeOfBirth":"AX","suiteIdentifier":"2","floorIdentifier":"s","buildingIdentifier":"s","street":"s","countryCode":"AX","city":"xxx","countryOfTaxResidences":[{"crsCountryFlag":"N","resCountryCode":"TH","tin":"655"}]}}}]},"productInfo":{"travelCards":[],"debitCards":[],"deposits":[],"cardMaintenances":[],"promptpayMaintenance":[],"tempCards":[],"promptpayGroups":None,"emoneys":[],"accountMaintenances":[],"mutualFundAccount":None,"insuranceTransactions":[],"newNext":None,"upLift":None,"statementRequests":[]},"customerAcceptConsent":True,"documentInfo":{"documents":[{"documentId":"PHOTO","uploadSessionId":"${PHOTO_UPLOAD_SESSION_ID}"}]},"opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","additionalInfo":{"sellerFirstName":"กาญจนา","sellerLastName":"น้อยชมภู","sellerPosition":"เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","sellerId":"551922"},"flow":"deposit","subFlow":"","needPrintedDocument":False,"sendCusEmailDocument":False,"portfolioInfo":{"mortgageRetentions":[],"fnaInfo":None},"vcInfo": ${vcInfo}}
    # ${data_json}=    Replace String    ${data_json}    true    True    
    # ${data_json}=    Replace String    ${data_json}    false    False    
    # ${data_json}=    Replace String    ${data_json}    null    None 
    # ${data}=    Evaluate    ${data_json}    json
    
    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Put_Consent_Open_Account.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}    ${False}
    ${data}=    Convert String to JSON    ${json_text_replaced}
    Set To Dictionary   ${data}[customerInfo][personalInfos][0][cardInfo]    cardType=Citizen ID

    ${upper}=    Convert To Upper Case    ${Overide}
    # IF    '${upper}' == 'Y'
    #     ${cifForm}    Set Variable    {"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"47e63b21-195d-4744-8975-b10d92d1624b"},"customerNo":"${CUSTOMER_CIF}","thaiTitle":"${MOCK_ThaiTitle}","thaiName":"${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}","engTitle":"${MOCK_EngTitle}","engName":"${MOCK_EngFirstName} ${MOCK_EengLastName}","dateOfBirth":"19930424","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"สำนักงานเขตคลองเตย","cardIssueDate":"20200212","cardExpiryDate":"20280816","legalAddr1":"30","legalAddr2":"หมู่ 1 สามัคคี28","legalAddr3":"ถ.สามัคคี","legalSubDistrict":"0500","legalDistrict":"1","legalStateProv":"12","legalPostalCd":"11000","legalCountry":"TH","mailingAddr1":"51/70","mailingAddr2":"","mailingAddr3":"ถ.พัฒนาชนบท 3","mailingSubDistrict":"0200","mailingDistrict":"11","mailingStateProv":"10","mailingPostalCd":"10520","mailingCountry":"TH","occupationCd":"1257","subOccupationCd":"08","officeName":"BLUE","officeAddr1":"51/70","officeAddr2":"","officeAddr3":"ถ.พัฒนาชนบท 3","officeSubDistrict":"0200","officeDistrict":"11","officeStateProv":"10","officePostalCd":"10520","officeCountry":"TH","homePhone":"","mobilePhone":"${OTP_Tel}","officePhone":"0788885856","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"5","maritalStat":"S","sex":"M","accountOpenDt":"20241106","kycStatus":"1","thaiFirstName":"ชนัดดา","thaiMiddleName":"","thaiLastName":"พฤฒาการย์","engFirstName":"CHANADDA","engMiddleName":"","engLastName":"PHRUETTHAKAN","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"01","personIDDocumentDetail":"","locationIDDocument":"01","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"200000","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"ตำบลท่าทราย","legalDistrictDesc":"อำเภอเมืองนนทบุรี","legalStateProvDesc":"นนทบุรี","mailingSubDistrictDesc":"แขวงคลองสองต้นนุ่น","mailingDistrictDesc":"เขตลาดกระบัง","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงคลองสองต้นนุ่น","officeDistrictDesc":"เขตลาดกระบัง","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"30,001-40,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"0","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"4","ktbUserID":"","legalAddr4":"ตำบลท่าทราย","mailingAddr4":"แขวงคลองสองต้นนุ่น","officeAddr4":"แขวงคลองสองต้นนุ่น","occupationSector":"07","smsSaleCode":"","kycLastReviewDt":"20250327","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"0","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"${MOCK_CardNumber}","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"","amdUnit":"","citizenID":"${MOCK_CardNumber}","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200000,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"TH","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"test@gmail.com","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตคลองเตย","citizenIssueDate":"20200212","citizenExpiryDate":"20280816","passportNo":"","passportCountry":"","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":true},"customerConsent":{"referenceId":"${CUSTOMER_CIF}","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-03-27T16:22:24+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"N"}]}]},"facialConsent":"N","cbsInfoChanges":[{"field":"emailAddr","newValue":"${Email}","oldValue":"${Old_EmailAddr}"},{"field":"mobilePhone","newValue":"${OTP_Tel}","oldValue":"${Old_Tel}"}],"fatcaInfo":null}
    #     ${cifForm}    Replace Variables    ${cifForm}  
    #     # ${cifForm}    Clean string for load json    ${cifForm}
    #     ${cifForm} =   Evaluate    json.loads('${cifForm}')
    #     Set To Dictionary   ${data}[customerInfo][personalInfos][0]    cifForm=${cifForm} 
    # END

    IF    '${Label}' == 'NextSaving'
        ${deposits}    Set Variable    [{"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","mailingAddressType":"MAILING","productTypeBusinessCode":"${productTypeBusinessCode}","productBusinessCode":"${productBusinessCode}","thaiAccountName":"${fullnameTh}","engAccountName":"${fullnameEn}","paymentConditionType":"SELF","paymentCondition":"สั่งจ่ายโดย ${fullnameTh} เท่านั้น","otherPaymentConditionPersons":[],"objectiveCode":"01","sourceOfIncomeCode":"01","sourceOfIncomeCountryCode":"TH","productAddress":null,"objectiveOther":null,"sourceOfIncomeOther":null,"cddInputTime":"${timestamp}","appId":"${APP_ID}"}]
        ${deposits}    Replace Variables    ${deposits}  
        # ${cifForm}    Clean string for load json    ${cifForm}
        # ${deposits}=    Evaluate    ${deposits}    modules=json
        ${deposits} =   Evaluate    json.loads('${deposits}')
        Set To Dictionary   ${data}[productInfo]    deposits=${deposits}
    ELSE IF    '${Label}' == 'ZeroTax'
        ${standingPaymentOrder}=    Create Standing Payment Order Dictionary
        ${deposits}    Set Variable    [{"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","mailingAddressType":"MAILING","productTypeBusinessCode":"${productTypeBusinessCode}","productBusinessCode":"${productBusinessCode}","accountInitTransfer":null,"standingPaymentOrder":${standingPaymentOrder},"objectiveCode":"01","sourceOfIncomeCode":"01","sourceOfIncomeCountryCode":"TH","productAddress":null,"paymentConditionType":"SELF","term":"${term}","termUnit":"${termUnit}","thaiAccountName":"${fullnameTh}","engAccountName":"${fullnameEn}","accountAffiliates":[{"accountNumber":"${ACCOUNT_NO}","affiliateType":"PRINCIPLE","option":"TRANSFER"},{"accountNumber":"${ACCOUNT_NO}","affiliateType":"INTEREST","option":"TRANSFER"}],"paymentCondition":"สั่งจ่ายโดย ${fullnameTh} เท่านั้น","otherPaymentConditionPersons":[],"objectiveOther":null,"sourceOfIncomeOther":null,"cddInputTime":"${timestamp}","appId":"${APP_ID}"}]
        ${deposits}    Replace Variables    ${deposits}  
        # ${cifForm}    Clean string for load json    ${cifForm}
        ${deposits}=    Replace String    ${deposits}    true    True    
        ${deposits}=    Replace String    ${deposits}    false    False    
        ${deposits}=    Replace String    ${deposits}    null    None    
        ${deposits}=    Evaluate    ${deposits}    modules=json
        # ${deposits} =   Evaluate    json.loads('${deposits}')
        Set To Dictionary   ${data}[productInfo]    deposits=${deposits}
    ELSE IF    '${Label}' == 'NextSaving_ZeroTax'
        ${deposits}    Set Variable    [{"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","mailingAddressType":"MAILING","productTypeBusinessCode":"${productTypeBusinessCode}","productBusinessCode":"${productBusinessCode}","accountInitTransfer":null,"standingPaymentOrder":null,"objectiveCode":"01","sourceOfIncomeCode":"01","sourceOfIncomeCountryCode":"TH","productAddress":null,"paymentConditionType":"SELF","term":"${term}","termUnit":"${termUnit}","thaiAccountName":"${fullnameTh}","engAccountName":"${fullnameEn}","accountAffiliates":[{"accountNumber":"${ACCOUNT_NO}","affiliateType":"PRINCIPLE","option":"TRANSFER"},{"accountNumber":"${ACCOUNT_NO}","affiliateType":"INTEREST","option":"TRANSFER"}],"paymentCondition":"สั่งจ่ายโดย ${fullnameTh} เท่านั้น","otherPaymentConditionPersons":[],"objectiveOther":null,"sourceOfIncomeOther":null,"cddInputTime":"${timestamp}","appId":"${APP_ID}"}]
        ${deposits}    Replace Variables    ${deposits}  
        # ${cifForm}    Clean string for load json    ${cifForm}
        ${deposits} =   Evaluate    json.loads('${deposits}')
        

        Generate Saving App ID Next
        ${NextSaving}    Set Variable    {"productId":"2003-5","productCode":"2003","productName":"Krungthai NEXT Savings","productTypeId":"SAV-1","productTypeCode":"SAV","mailingAddressType":"MAILING","productTypeBusinessCode":"SAV","productBusinessCode":"2003","thaiAccountName":"${fullnameTh}","engAccountName":"${fullnameEn}","paymentConditionType":"SELF","paymentCondition":"สั่งจ่ายโดย ${fullnameTh} เท่านั้น","otherPaymentConditionPersons":[],"objectiveCode":"01","sourceOfIncomeCode":"01","sourceOfIncomeCountryCode":"TH","productAddress":null,"objectiveOther":null,"sourceOfIncomeOther":null,"cddInputTime":"${timestamp}","appId":"${APP_ID}"}
        ${NextSaving}=    Evaluate    json.loads('''${NextSaving}''')    json
        Append To List    ${deposits}    ${NextSaving}

        Set To Dictionary   ${data}[productInfo]    deposits=${deposits}
    ELSE IF    '${Label}' == 'MFOA'
        ${mutualFundAccount}    Evaluate    {"productId":"${Product_ID}","productCode":"${Product_Code}","productName":"${Product_Name}","productTypeId":"${Product_TypeId}","productTypeCode":"${Product_Type_Code}","productBusinessCode":"${productBusinessCode}","applicationType":"ONBOARD","mailingAddressType":"C","receivingAccountId":"${ACCOUNT_NO}","receivingAccountNameTh":"${fullnameTh}","receivingAccountNameEn":"${fullnameEn}","appId":"${APP_ID}"}    json
        # ${NextSaving}=    Evaluate    json.loads('''${mutualFundAccount}''')    json

        ${kcifInfo}    Set Variable    {"occupationCode":"20","businessTypeCode":"${productTypeBusinessCode}","incomeCode":"LEVEL3","isPolitician":False,"investmentObjectiveCode":"Investment","sourceOfMoneyRevenueCode":"TH","sourceOfMoneyRevenueDescription":"ไทย","typeOfIncomeCode":"1","legalAddress":"3/140 หมู่ 3 ตรอกจันทร์ ซ.เอกชัยกอล์ฟ ถ.สุขุมวิท","legalCountryCode":"TH","legalDistrict":"เมืองสมุทรสาคร","legalSubDistrict":"บางน้ำจืด","legalProvince":"สมุทรสาคร","legalPostalCode":"74000","legalUniqueId":"6320","officeName":"-","officeAddress":"1234","officeCountryCode":"TH","officeDistrict":"ยานนาวา","officeSubDistrict":"ช่องนนทรี","officeProvince":"กรุงเทพมหานคร","officePostalCode":"10120","officeUniqueId":"22","currentAddress":"1234","currentCountryCode":"TH","currentDistrict":"ยานนาวา","currentSubDistrict":"ช่องนนทรี","currentProvince":"กรุงเทพมหานคร","currentPostalCode":"10120","currentUniqueId":"22","email":"${Email}","mobileNo":"${OTP_Tel}"}    
        # ${kcifInfo}    Replace String    ${kcifInfo}    True    true
        # ${kcifInfo}    Replace String    ${kcifInfo}    False    
        # ${kcifInfo}    Replace String    ${kcifInfo}    None    null
        ${kcifInfo}    Evaluate    ${kcifInfo}    json
        Set To Dictionary   ${data}    flow=mfoa
        ${nextFlows}    Create List    mfoa
        Set To Dictionary    ${data}    nextFlows=${nextFlows}
        Set To Dictionary    ${data}[productInfo]    kcifInfo=${kcifInfo}
        Set To Dictionary    ${data}[productInfo]    mutualFundAccount=${mutualFundAccount}
        
        Set To Dictionary    ${mutualFundConsent}            mutualFundAcctConsent=Y
        Set To Dictionary    ${mutualFundConsent}            omnibusConsent=Y
        Set To Dictionary    ${data["customerInfo"]["personalInfos"][0]["cifForm"]}    mutualFundConsent=${mutualFundConsent}

        ${customerConsent}    Evaluate    {"referenceId":"${MOCK_CardNumber}","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"${CUSTOMER_CIF}","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2024-06-12T09:45:27+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2024-06-12T09:45:27+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2024-06-12T09:45:27+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]}]}    json
        Set To Dictionary    ${data["customerInfo"]["personalInfos"][0]["cifForm"]}    customerConsent=${customerConsent}
    END

    IF    ${IS_NEW_NEXT}
        ${newnext}    Set Variable    {"productId":"KTNEXT-1","productCode":"KTNEXT","productName":"Krungthai NEXT","productTypeId":"SV01-1","productTypeCode":"SV01","bypassFacialReason":"รูปบนบัตรประชาชนไม่อัปเดต","bypassFacialReasonDescription":"","bypassFacial":True,"bypassFlow":"registration","appId":"${APP_ID_NEXT}"}
        ${newnext}    Replace Variables    ${newnext}  
        ${newnext}    Replace String    ${newnext}    True    true
        ${newnext}    Replace String    ${newnext}    False    false
        ${newnext}    Replace String    ${newnext}    None    null
        # ${cifForm}    Clean string for load json    ${cifForm}
        ${newnext} =   Evaluate    json.loads('${newnext}')
        Set To Dictionary   ${data}[productInfo]    newNext=${newNext}
    END

    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    
    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200

    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=CIKCIFInformation&option=draft
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200
    #Should Be Equal    ${response.content}    ${None}
    Sleep    2s

Generate Saving App ID Next
    [Arguments]    ${type}=sv
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/app-id/${type}/generate?count=1
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    generate_appid    ${url}
    ${response}    POST On Session  generate_appid  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    appIds

    Set Suite Variable    ${APP_ID}    ${json["appIds"][0]}
    Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}

Generate MFOA App ID Next
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/app-id/MFOA/generate?count=1
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    generate_appid    ${url}
    ${response}    POST On Session  generate_appid  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    appIds

    Set Suite Variable    ${APP_ID}    ${json["appIds"][0]}
    Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}

knowledge assessment
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/${CASE_ID}/mutual-fund/knowledge-assessment
    Log    url = ${url}${uri}

    ${data}    Evaluate    {"kaAnswer":[{"id":1,"accepted":None,"detail":None,"isAccepted":False},{"id":2,"accepted":None,"detail":None,"isAccepted":False},{"id":3,"accepted":None,"detail":None,"isAccepted":False}],"kaTellerId":"13772","kaBranchCode":"200108","kaTellerLicenseNo":"056711","kaAnswerVersion":"2.0","updated":True}    json

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    generate_appid    ${url}
    ${response}    POST On Session  generate_appid  ${uri}  headers=${headers}    json=${data}

    Should Be Equal As Strings    ${response.status_code}    200
 

Calculate risk score
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/${CASE_ID}/mutual-fund/risk/calculation
    Log    url = ${url}${uri}
    
    ${data}=    Get File    ${CURDIR}/../resources/data/json/payload_cal_risk.json
    ${data}    Replace Variables    ${data}
    ${data} =   Evaluate    ${data}    json
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    Calculate_risk    ${url}
    ${response}    POST On Session  Calculate_risk  ${uri}  headers=${headers}    json=${data}
    Log    ${response.status_code}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    # Dictionary Should Contain Key     ${json}    appIds

    # Set Suite Variable    ${APP_ID}    ${json["appIds"][0]}
    # Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}


Search Deposits Information
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    search_card    ${url}
    ${response}    GET On Session  search_card  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    log    ${response.content}
    
    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    branchCode
    Dictionary Should Contain Key     ${json}    employeeId
    Dictionary Should Contain Key     ${json}    employeeIdNoAx
    Dictionary Should Contain Key     ${json}    employeeUserGroup
    Dictionary Should Contain Key     ${json}    employeeLicenses
    Dictionary Should Contain Key     ${json}    channel
    Dictionary Should Contain Key     ${json}    flow
    Dictionary Should Contain Key     ${json}    createdDate
    Dictionary Should Contain Key     ${json}    savedDate
    Dictionary Should Contain Key     ${json}    caseStatus
    Dictionary Should Contain Key     ${json}    customerInfo
    Dictionary Should Contain Key     ${json}    productInfo
    ${productInfo}=    Set Variable    ${json["productInfo"]}
    Dictionary Should Contain Key     ${productInfo}    debitCards

    IF    '${Label}' == 'NextSaving' or '${Label}' == 'NextSaving_ZeroTax'
        # ${deposits}=    Set Variable    ${json["productInfo"]["deposits"][0]}
        ${deposit}=    Evaluate    [x for x in ${json["productInfo"]["deposits"]} if x["productCode"] == "2003"]    json
        ${deposits} =   Set Variable   ${deposit}[0]
        Dictionary Should Contain Key    ${deposits}    productId    
        Dictionary Should Contain Key    ${deposits}    productCode    
        Dictionary Should Contain Key    ${deposits}    productTypeId  
        Dictionary Should Contain Key    ${deposits}    productTypeCode
        Dictionary Should Contain Key    ${deposits}    productName    
        Dictionary Should Contain Key    ${deposits}    productBusinessCode
        Dictionary Should Contain Key    ${deposits}    productTypeBusinessCode
        Dictionary Should Contain Key     ${deposits}    appId
        
        ${Result_Status}=    Set Variable    ${json["productInfo"]["deposits"][0]["result"]}
        IF    '${Result_Status}' == 'SUCCESS'
            Dictionary Should Contain item    ${deposits}    result    ${Transaction_Status}
            Dictionary Should Contain Key    ${deposits}    accountNumber
            Log    accountNumber: ${json["productInfo"]["deposits"][0]["accountNumber"]}
        ELSE
            ${Document_errorCode} =    Set Variable If    '${errorCode}' == '${EMPTY}'        null        ${errorCode}
            ${Document_errorDesc} =    Set Variable If    '${errorDesc}' == '${EMPTY}'        null        ${errorDesc}
            #${json_data}=    Set Variable    ${json["productInfo"]["debitCards"][0]["errorDesc"]}
            #Should Be Equal    ${json_data}    ${Document_errorDesc}
            #Should Be Equal    first    second   msg=${Document_errorDesc}
            Dictionary Should Contain item    ${deposits}    errorCode    ${Document_errorCode}
            Dictionary Should Contain item    ${deposits}    errorDesc    ${Document_errorDesc}
        END

        Dictionary Should Contain Key     ${deposits}    thaiAccountName
        Dictionary Should Contain Key     ${deposits}    engAccountName
        Dictionary Should Contain Key     ${deposits}    mailingAddressType
        Dictionary Should Contain item    ${deposits}    signatureResult    SUCCESS
        Dictionary Should Contain Key     ${deposits}    paymentConditionType
        Dictionary Should Contain Key     ${deposits}    paymentCondition
        Dictionary Should Contain Key     ${deposits}    otherPaymentConditionPersons
        Dictionary Should Contain Key     ${deposits}    cddInputTime
        Dictionary Should Contain Key     ${deposits}    signatureConsent
        Dictionary Should Contain Key     ${deposits}    signatureConsent
        Dictionary Should Contain item     ${deposits}    crsResult    SUCCESS
        Dictionary Should Contain Key     ${deposits}    openDateTime
    END

    IF    '${Label}' == 'ZeroTax' or '${Label}' == 'NextSaving_ZeroTax'
        # ${deposits} =   Set Variable   ${json["productInfo"]["deposits"][0]}
        ${deposit}=    Evaluate    [x for x in ${json["productInfo"]["deposits"]} if x["productCode"] == "3301"]    json
        ${deposits} =   Set Variable   ${deposit}[0]
        Dictionary Should Contain item    ${deposits}    productId    ${Product_ID}
        Dictionary Should Contain item    ${deposits}    productCode    ${Product_Code}
        Dictionary Should Contain item    ${deposits}    productTypeId    ${Product_TypeId}
        Dictionary Should Contain item    ${deposits}    productTypeCode    ${Product_Type_Code}
        Dictionary Should Contain item    ${deposits}    productName    ${Product_Name}
        Dictionary Should Contain item    ${deposits}    productBusinessCode    ${productBusinessCode}
        Dictionary Should Contain item    ${deposits}    productTypeBusinessCode    ${productTypeBusinessCode}
        Dictionary Should Contain Key     ${deposits}    appId
        
        ${Result_Status}=    Set Variable    ${json["productInfo"]["deposits"][0]["result"]}
        IF    '${Result_Status}' == 'SUCCESS'
            Dictionary Should Contain item    ${deposits}    result    ${Transaction_Status}
            Dictionary Should Contain Key    ${deposits}    accountNumber
            Log    accountNumber: ${json["productInfo"]["deposits"][0]["accountNumber"]}
        ELSE
            ${Document_errorCode} =    Set Variable If    '${errorCode}' == '${EMPTY}'        null        ${errorCode}
            ${Document_errorDesc} =    Set Variable If    '${errorDesc}' == '${EMPTY}'        null        ${errorDesc}
            #${json_data}=    Set Variable    ${json["productInfo"]["debitCards"][0]["errorDesc"]}
            #Should Be Equal    ${json_data}    ${Document_errorDesc}
            #Should Be Equal    first    second   msg=${Document_errorDesc}
            Dictionary Should Contain item    ${deposits}    errorCode    ${Document_errorCode}
            Dictionary Should Contain item    ${deposits}    errorDesc    ${Document_errorDesc}
        END

        Dictionary Should Contain Key     ${deposits}    thaiAccountName
        Dictionary Should Contain Key     ${deposits}    engAccountName
        Dictionary Should Contain Key     ${deposits}    mailingAddressType
        Dictionary Should Contain item    ${deposits}    signatureResult    SUCCESS
        Dictionary Should Contain Key     ${deposits}    paymentConditionType
        Dictionary Should Contain Key     ${deposits}    paymentCondition
        Dictionary Should Contain Key     ${deposits}    otherPaymentConditionPersons
        Dictionary Should Contain Key     ${deposits}    cddInputTime
        Dictionary Should Contain Key     ${deposits}    signatureConsent
        Dictionary Should Contain item     ${deposits}    crsResult    SUCCESS
        Dictionary Should Contain Key     ${deposits}    openDateTime
        Dictionary Should Contain Key     ${deposits}    term
        Dictionary Should Contain Key     ${deposits}    termUnit
    END

    IF    '${Label}' == 'MFOA'
        ${mutualFundAccount}=    Set Variable    ${json["productInfo"]["mutualFundAccount"]}
        # ${mutualFundAccount}=    Evaluate    [x for x in ${json["productInfo"]["mutualFundAccount"]} if x["productTypeCode"] == "MFOA"]    json
        
        Dictionary Should Contain Key    ${mutualFundAccount}    productId    
        Dictionary Should Contain Key    ${mutualFundAccount}    productCode    
        Dictionary Should Contain Key    ${mutualFundAccount}    productTypeId  
        Dictionary Should Contain Key    ${mutualFundAccount}    productTypeCode
        Dictionary Should Contain Key    ${mutualFundAccount}    productName    
        Dictionary Should Contain Key    ${mutualFundAccount}    productBusinessCode
        Dictionary Should Contain Key     ${mutualFundAccount}    appId
        
        ${Result_Status}=    Set Variable    ${json["productInfo"]["mutualFundAccount"]["result"]}
        IF    '${Result_Status}' == 'SUCCESS'
            Dictionary Should Contain item    ${mutualFundAccount}    result    ${Transaction_Status}
            Dictionary Should Contain Key    ${mutualFundAccount}    accountId
            Dictionary Should Contain Key    ${mutualFundAccount}    unitHolderNo
            Log    accountNumber: ${json["productInfo"]["mutualFundAccount"]["accountId"]}
            Log    unitHolderNo: ${json["productInfo"]["mutualFundAccount"]["unitHolderNo"]}
        ELSE
            ${Document_errorCode} =    Set Variable If    '${errorCode}' == '${EMPTY}'        null        ${errorCode}
            ${Document_errorDesc} =    Set Variable If    '${errorDesc}' == '${EMPTY}'        null        ${errorDesc}
            #${json_data}=    Set Variable    ${json["productInfo"]["debitCards"][0]["errorDesc"]}
            #Should Be Equal    ${json_data}    ${Document_errorDesc}
            #Should Be Equal    first    second   msg=${Document_errorDesc}
            Dictionary Should Contain item    ${mutualFundAccount}    errorCode    ${Document_errorCode}
            Dictionary Should Contain item    ${mutualFundAccount}    errorDesc    ${Document_errorDesc}
        END

        Dictionary Should Contain Key     ${mutualFundAccount}    receivingAccountId
        Dictionary Should Contain Key     ${mutualFundAccount}    receivingAccountNameTh
        Dictionary Should Contain Key     ${mutualFundAccount}    receivingAccountNameEn
        Dictionary Should Contain Key     ${mutualFundAccount}    mailingAddressType
        Dictionary Should Contain Key     ${mutualFundAccount}    accountNameTh
        Dictionary Should Contain Key     ${mutualFundAccount}    submitResult
        Dictionary Should Contain Key     ${mutualFundAccount}    crsResult

        ${kcifInfo} =   Set Variable   ${json["productInfo"]["kcifInfo"]}
        Dictionary Should Contain Key    ${kcifInfo}    email
        Dictionary Should Contain Key    ${kcifInfo}    mobileNo
        Dictionary Should Contain Key    ${kcifInfo}    legalAddress
        Dictionary Should Contain Key    ${kcifInfo}    legalSubDistrict
        Dictionary Should Contain Key    ${kcifInfo}    legalDistrict
        Dictionary Should Contain Key    ${kcifInfo}    legalProvince
        Dictionary Should Contain Key    ${kcifInfo}    legalPostalCode
        Dictionary Should Contain Key    ${kcifInfo}    legalUniqueId
        Dictionary Should Contain Key    ${kcifInfo}    legalCountryCode
        Dictionary Should Contain Key    ${kcifInfo}    officeName
        Dictionary Should Contain Key    ${kcifInfo}    officeAddress
        Dictionary Should Contain Key    ${kcifInfo}    officeSubDistrict
        Dictionary Should Contain Key    ${kcifInfo}    officeDistrict
        Dictionary Should Contain Key    ${kcifInfo}    officeProvince
        Dictionary Should Contain Key    ${kcifInfo}    officePostalCode
        Dictionary Should Contain Key    ${kcifInfo}    officeUniqueId
        Dictionary Should Contain Key    ${kcifInfo}    officeCountryCode
        Dictionary Should Contain Key    ${kcifInfo}    currentAddress
        Dictionary Should Contain Key    ${kcifInfo}    currentSubDistrict
        Dictionary Should Contain Key    ${kcifInfo}    currentDistrict
        Dictionary Should Contain Key    ${kcifInfo}    currentProvince
        Dictionary Should Contain Key    ${kcifInfo}    currentPostalCode
        Dictionary Should Contain Key    ${kcifInfo}    currentUniqueId
        Dictionary Should Contain Key    ${kcifInfo}    currentCountryCode
        Dictionary Should Contain Key    ${kcifInfo}    occupationCode
        Dictionary Should Contain Key    ${kcifInfo}    businessTypeCode
        Dictionary Should Contain Key    ${kcifInfo}    incomeCode
        Dictionary Should Contain Key    ${kcifInfo}    sourceOfMoneyRevenueCode
        Dictionary Should Contain Key    ${kcifInfo}    sourceOfMoneyRevenueDescription
        Dictionary Should Contain Key    ${kcifInfo}    typeOfIncomeCode
        Dictionary Should Contain Key    ${kcifInfo}    investmentObjectiveCode
        Dictionary Should Contain Key    ${kcifInfo}    copyFromCi
        Dictionary Should Contain Key    ${kcifInfo}    nameChanged
        Dictionary Should Contain Key    ${kcifInfo}    infoChanged
        Dictionary Should Contain Key    ${kcifInfo}    sync
        Dictionary Should Contain Key    ${kcifInfo}    isPolitician
    END

    IF    ${IS_NEW_NEXT}
        Dictionary Should Contain Key     ${productInfo}    newNext
        ${newNext}=    Set Variable    ${json["productInfo"]["newNext"]}
        Dictionary Should Contain Key    ${newNext}    productId
        Dictionary Should Contain Key    ${newNext}    productCode
        Dictionary Should Contain Key    ${newNext}    productTypeId
        Dictionary Should Contain Key    ${newNext}    productTypeCode
        Dictionary Should Contain Key    ${newNext}    productName
        Dictionary Should Contain item   ${newNext}    appId    ${APP_ID_NEXT}

        ${Result_Status}=    Set Variable    ${json["productInfo"]["newNext"]["result"]}
        IF    '${Result_Status}' == 'SUCCESS'
            Dictionary Should Contain item    ${newNext}    result    ${Transaction_Status}
        ELSE
            ${Document_errorCode} =    Set Variable If    '${errorCode}' == '${EMPTY}'        null        ${errorCode}
            ${Document_errorDesc} =    Set Variable If    '${errorDesc}' == '${EMPTY}'        null        ${errorDesc}
            #${json_data}=    Set Variable    ${json["productInfo"]["debitCards"][0]["errorDesc"]}
            #Should Be Equal    ${json_data}    ${Document_errorDesc}
            #Should Be Equal    first    second   msg=${Document_errorDesc}
        END
        Dictionary Should Contain Key    ${newNext}    syncDataFromCbs    
        Dictionary Should Contain Key    ${newNext}    updateMobileNumber    
        Dictionary Should Contain Key    ${newNext}    updateStatus
        Dictionary Should Contain Key    ${newNext}    updateSegment
        Dictionary Should Contain item   ${newNext}    bypassFacial    ${True}
        Dictionary Should Contain item   ${newNext}    bypassFlow      registration
        Dictionary Should Contain Key    ${newNext}    bypassFacialReason
        Dictionary Should Contain Key    ${newNext}    bypassFacialReasonDescription
        Dictionary Should Contain Key    ${newNext}    maintenance
        Dictionary Should Contain item   ${newNext}    bypassFacialResult    SUCCESS
        Dictionary Should Contain Key    ${newNext}    bypassFacialEndTime
        Dictionary Should Contain Key    ${newNext}    requiredApproval
    END
    
    Dictionary Should Contain Key     ${productInfo}    deposits
    Dictionary Should Contain Key     ${productInfo}    cardMaintenances
    Dictionary Should Contain Key     ${productInfo}    promptpayMaintenance
    Dictionary Should Contain Key     ${productInfo}    tempCards
    Dictionary Should Contain Key     ${productInfo}    emoneys
    Dictionary Should Contain Key     ${productInfo}    accountMaintenances
    Dictionary Should Contain Key     ${productInfo}    insuranceTransactions
    Dictionary Should Contain Key     ${productInfo}    statementRequests
    Dictionary Should Contain Key     ${json}    documentInfo
    Dictionary Should Contain Key     ${json}    approvalInfo
    Dictionary Should Contain Key     ${json}    additionalInfo
    Dictionary Should Contain Key     ${json}    portfolioInfo

