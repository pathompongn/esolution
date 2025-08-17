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

*** Keywords ***
Retrieve Get Case ID Insurance
    #retrieve_case
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_CASE_RETRIEVE}
    Log    url = ${url}${uri}

    # ${data}=    Evaluate     {"cardInfo":${CARD_INFO},"channel":"android","flow":"insurance","sellerInfo":{"firstName":"ผุสพร","lastName":"ปุสสเด็จ","position":"รองผู้จัดการธุรกิจการขาย","userGroup":"CSSM","licenses":[{"licenseType":"ICC2","licenseNo":"056711","licenseExp":"20261231","errorFlag":${False},"expired":${False}},{"licenseType":"LF","licenseNo":"5203017345","licenseExp":"20261028","errorFlag":${False},"expired":${False}},{"licenseType":"NON LIFE","licenseNo":"5204021477","licenseExp":"20261028","errorFlag":${False},"expired":${False}}]},"subFlow":"","data":{},"draftedCaseId":"","skipIntroduction":${False},"mcToolRefNo":"${MC_TOOL_REFNO}","opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":${False},"vcLimitationTypes":[]},"vcSelectedProducts":["${ProductID}"]}}    json
    ${data}=    Evaluate     {"cardInfo":${CARD_INFO},"channel":"android","flow":"insurance","sellerInfo":{"firstName":"${FirstNameEmployee}","lastName":"${LastNameEmployee}","position":"${POSITION}","userGroup":"${RoleClassCode}","licenses":${LICENSES}},"subFlow":"","data":{},"draftedCaseId":"","skipIntroduction":${False},"mcToolRefNo":"${MC_TOOL_REFNO}","opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":${False},"vcLimitationTypes":[]},"vcSelectedProducts":["${ProductID}"]}}    json
    log    ${data}
    
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}

    Create Session    Retrieve_CaseID    ${url}
    ${response}=    POST On Session    Retrieve_CaseID    ${uri}    json=${data}    headers=${headers}
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
    Set Test Variable    ${flow}    ${json["flow"]}
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

    Set Global Variable    ${CASE_ID}          ${json["caseId"]}
    Set Global Variable    ${WS_REF_ID}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["inquiryCIFDetailRespHeader"]["wsRefId"]}
    Set Global Variable    ${SELECT_PRODUCT}   ${json["vcInfo"]["vcSelectedProducts"][0]}
    Set Global Variable    ${AGE_CUSTOMER}     ${json["customerInfo"]["personalInfos"][0]["age"]}
    Set Global Variable    ${PHONT_OLD}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["mobilePhone"]}
    Set Global Variable    ${EMAIL_OLD}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["emailAddr"]}
    Set Global Variable    ${POSTAL_CODE}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["legalPostalCd"]}

    ${cbsInfo}    Convert To String    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}
    ${cbsInfo}    Replace String    ${cbsInfo}    '    "
    ${cbsInfo}=    Replace String    ${cbsInfo}    True    true
    ${cbsInfo}=    Replace String    ${cbsInfo}    False    false
    Set Global Variable    ${CBS_INFO}         ${cbsInfo}

    ${customerConsent}    Convert To String    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["customerConsent"]}
    ${customerConsent}    Replace String    ${customerConsent}    '    "
    ${customerConsent}=    Replace String    ${customerConsent}    True    true
    ${customerConsent}=    Replace String    ${customerConsent}    False    false
    Set Global Variable    ${CUSTOMER_CONSENT}    ${customerConsent}

    ${additionalInfo}    Convert To String    ${json["additionalInfo"]}
    ${additionalInfo}    Replace String    ${additionalInfo}    '    "
    ${additionalInfo}=    Replace String    ${additionalInfo}    True    true
    ${additionalInfo}=    Replace String    ${additionalInfo}    False    false
    Set Global Variable    ${ADD_INFO}         ${additionalInfo}

    ${mortgageRetentions}    Convert To String    ${json["portfolioInfo"]["mortgageRetentions"]}
    ${mortgageRetentions}    Replace String    ${mortgageRetentions}    '    "
    ${mortgageRetentions}=    Replace String    ${mortgageRetentions}    True    true
    ${mortgageRetentions}=    Replace String    ${mortgageRetentions}    False    false
    Set Global Variable    ${RETENTION}        ${mortgageRetentions}


Retrieve Continue Insurance
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
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
            ELSE IF    '${SearchProductGroup}' == 'NEXT' and '${deposits}[${index}][accountStatus]' == '${SearchAcStatus}' and '${deposits}[${index}][productType]' == '2003'
                Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
                Dictionary Should Contain Key     ${deposits}[${index}]    productName
                Dictionary Should Contain Key     ${deposits}[${index}]    productType
                Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
                ${flag}=    Set Variable    ${TRUE}
                Exit For Loop
            END
        
        ELSE
            IF    '${deposits}[${index}][productGroup]' == 'SAV' and '${deposits}[${index}][accountStatus]' == '0' and ${deposits}[${index}][availBalAmt] > 2000
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
        Set Global Variable   ${ACCOUNT_NO}                ${deposits}[${index}][accountNo]
        Set Global Variable   ${ACCOUNT_PRODUCT_NAME}      ${deposits}[${index}][productName]
        Set Global Variable   ${ACCOUNT_PRODUCT_TYPE}      ${deposits}[${index}][productType]
        Set Global Variable    ${ACCOUNT_PRODUCT_GROUP}     ${deposits}[${index}][productGroup]
    ELSE
        Fail    Not found account: ${account}
    END

    Set Global Variable   ${CUSTOMER_CIF}    ${json["customerInfo"]["personalInfos"][0]["cifExistingData"]["customerNo"]}
    Set Global Variable    ${OLD_MOBILE_PHONE}    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["mobilePhone"]}
    Set Global Variable    ${OLD_EMAIL}    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["emailAddr"]}
        
    ${vc_assessment_id_status}=    Run Keyword And Return Status    Get From Dictionary    ${json["vcInfo"]}    vcAssessmentId   
        IF    ${vc_assessment_id_status}
        Set Global Variable    ${VC_ASSESSMANT_ID}    ${json["vcInfo"]["vcAssessmentId"]}
        Set Global Variable    ${VC_APPROACH_CODE}    ${json["vcInfo"]["highestVcApproachCode"]}
        Set Global Variable    ${VC_SELECT_PRODUCT}    ${json["vcInfo"]["vcSelectedProducts"][0]}
        Set Global Variable    ${VC_GROUP_CODE}    ${json["vcInfo"]["vcGroupCodes"][0]}
        ${VC_SELECT_Split}    Split String    ${VC_SELECT_PRODUCT}     separator=-
        Set Global Variable    ${VC_PRODUCT_CODE}    ${VC_SELECT_Split}[0]
    END 
    ${vcInfo}    Convert To String    ${json["vcInfo"]}
    ${vcInfo}    Replace String    ${vcInfo}    '    "
    ${vcInfo}=    Replace String    ${vcInfo}    True    true
    ${vcInfo}=    Replace String    ${vcInfo}    False    false
    Set Global Variable    ${VC_INFO}    ${vcInfo}

    ${productInfo}    Convert To String    ${json["productInfo"]}
    ${productInfo}    Replace String    ${productInfo}    '    "
    Set Global Variable    ${PRODUCT_INFO}    ${productInfo}

    Set Global Variable    ${VC_GROUP_CODE}    ${json["vcInfo"]["vcGroupCodes"][0]}

    @{ACCOUNT_NO_LIST}    Create List
    ${deposits}=    Get From Dictionary    ${json['portfolioInfo']}    deposits
    FOR    ${deposit}    IN    @{deposits}
        ${group}=    Get From Dictionary    ${deposit}    productGroup
        ${status}=   Get From Dictionary    ${deposit}    accountStatus
        ${avail}=    Get From Dictionary    ${deposit}    availBalAmt
        Run Keyword If    '${group}' == 'SAV' and ${status} == 0 and ${avail} > 200
        ...    Append To List    ${ACCOUNT_NO_LIST}    ${deposit['accountNo']}
    END
    Log    ${ACCOUNT_NO_LIST}
    Set Suite Variable    ${ACCOUNT_NO_LIST}
    ${list_length}=    Get Length    ${ACCOUNT_NO_LIST}
    Run Keyword If    ${list_length} > 0    Set Global Variable    ${ACCOUNT_NO_1}    ${ACCOUNT_NO_LIST}[0]

Update OTP Telephone Insurance
    #update_case_tel
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=CustomerInformation&option=draft
    Log    url = ${url}${uri}

    ${CBS_INFO_json}=    Convert String to JSON    ${CBS_INFO}
    Set To Dictionary    ${CBS_INFO_json}    emailAddr=${Email}
    Set To Dictionary    ${CBS_INFO_json}    mobilePhone=${OTP_Tel}
    ${CBS_INFO_str}    Convert Json To String    ${CBS_INFO_json}
    ${CBS_INFO}     Replace String    ${CBS_INFO_str}     '    "
    Set Global Variable    ${CBS_INFO}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Update_OTP_Telephone.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    Accept=*/*
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive
    
    Create Session    update_case_tel    ${url}
    ${response}=    PUT On Session    update_case_tel    ${uri}    headers=${headers}    json=${json_data}   
    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s
    Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}

Get Insurance Plan
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_INSURANCE_PLAN}/${ProductID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    insurance_plan    ${url}
    ${response}=    GET On Session     insurance_plan    ${uri}     headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json[0]}    planId
    Dictionary Should Contain Key    ${json[0]}    planCode
    Dictionary Should Contain Key    ${json[0]}    planDesc

    Set Global Variable    ${PLAN_ID}          ${json[0]['planId']}
    Set Global Variable    ${PLAN_CODE}        ${json[0]['planCode']}
    Set Global Variable    ${PLAN_DESC}        ${json[0]['planDesc']}
    Set Global Variable    ${PRODUCT_GRP_ID}   ${json[0]['productGrpId']}
    Set Global Variable    ${COMPANY_ID}       ${json[0]['companyId']}

    # ${PLAN_DESC_Split}    Split String    string=${PLAN_DESC}     separator=
    # Set Global Variable    ${PLAN_DESC_NAME}    ${PLAN_DESC_Split}[0]

Generate Insurance App ID
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/app-id/LNINS/generate?count=1
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    generate_appid    ${url}
    ${response}    POST On Session  generate_appid  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    appIds

    Set Test Variable    ${APP_ID}    ${json["appIds"][0]}

Generate Insurance App ID NonLife
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/app-id/NL/generate?count=1
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    generate_appid    ${url}
    ${response}    POST On Session  generate_appid  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    appIds

    Set Test Variable    ${APP_ID}    ${json["appIds"][0]}

Transaction Initial
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_INSURANCE}/${CASE_ID}/transaction/initial/${APP_ID}
    Log    url = ${url}${uri}

    ${PLAN_DESC}=    Replace String    ${PLAN_DESC}    \xa0    ${SPACE}
    ${data}=    Evaluate    {"productId":"${PLAN_CODE}-1","productCode":"${PLAN_CODE}","productName":"${PLAN_DESC}","productTypeId":"${VC_GROUP_CODE}-1","productTypeCode":"${VC_GROUP_CODE}","productBusinessCode":"${PLAN_CODE}","appId":"${APP_ID}","detailedSaleSheetLink":"dd15999d-b859-45dc-8a99-67bc9375d8cc","companyId":"${COMPANY_ID}","companyName":"${Company_Name}","refererName":"${FirstNameEmployee} ${LastNameEmployee}","refererBranchCode":"${KCS_BRANCH_CODE}","planName":"${PLAN_DESC}","loanAcctNo":"${ACCOUNT_NO}","selectedBranch":"${KCS_BRANCH_CODE}","planId":"${PLAN_ID}","planCode":"${PLAN_CODE}","loanApplication":${None},"refererId":"${User_ID}","customerAddrVerified":${True}}    json
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    Create Session    transaction_initial    ${url}
    ${response}=    POST On Session    transaction_initial    ${uri}    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200

Get Application No
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_INSURANCE}/${CASE_ID}/transaction/premium/${APP_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Connection=keep-alive
    ...    Authorization=Bearer ${ACCESS_TOKEN}

    Create Session    Get_Application_No    ${url}    
    ${response}=    GET On Session   Get_Application_No    ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    Dictionary Should Contain Key    ${json}    appFormUploadSessionId
    Dictionary Should Contain Key    ${json}    insurancePremium
    Dictionary Should Contain Key    ${json}    autoFlag
    Dictionary Should Contain Key    ${json}    applicationNo

    Set Global Variable    ${APPLICATION_NO}    ${json["applicationNo"]}
    Set Global Variable    ${APP_FORM_UPLOAD_SESSION_ID}    ${json["appFormUploadSessionId"]}
    Set Global Variable    ${INSURANCE_PREMIUM}    ${json["insurancePremium"]}


Bill Payment Insurance
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable     ${URI_ESOL_INSURANCE}/${CASE_ID}/payment/${APP_ID}/bill-payment
    Log    url = ${url}${uri}

    ${data}=    Set Variable    {"transactionId": "${APP_ID}"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}    

    Dictionary Should Contain Key    ${json}    result

    Should Be Equal As Strings    ${json["result"]}    SUCCESS

# Insurance Submission
#     ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
#     ${uri}=    Set Variable     ${URI_ESOL_CASE}/${CASE_ID}/insurance/submission
#     Log    url = ${url}${uri}

#     ${headers}=    Create Dictionary
#     ...    Accept=*/*
#     ...    Content-Type=application/json
#     ...    Authorization=Bearer ${ACCESS_TOKEN}
#     ...    Accept-Encoding=gzip, deflate, br
#     ...    Connection=keep-alive
    
#     ${response}=    POST On Session    transaction_kpi    ${uri}    headers=${headers}

#     ${all_passed}=    Set Variable    False
#     ${start}=        Set Variable    0
#     WHILE    ${start} < 10 and not ${all_passed}
#         Should Be Equal As Strings    ${response.status_code}    200
#         ${json}=    Convert String to JSON    ${response.content}    
#         Log    ${json}

#         Dictionary Should Contain Key    ${json["transactionStatuses"][0]}    paymentStatus
#         Dictionary Should Contain Key    ${json["transactionStatuses"][0]}    status

#         ${status1}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["transactionStatuses"][0]["paymentStatus"]}    PENDING
#         ${status2}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["transactionStatuses"][0]["status"]}    PAYMENT_SUCCESS

#         ${all_passed}=    Evaluate    ${status1} and ${status2}
#         Exit For Loop If    ${all_passed}

#         Sleep    10s
#         ${start}=    Evaluate    ${start} + 1
#     END

Insurance Submission Status
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable     ${URI_ESOL_CASE}/${CASE_ID}/insurance/submission/status
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${all_passed}=    Set Variable    False
    ${start}=        Set Variable    0
    WHILE    ${start} < 12 and not ${all_passed}
        ${response}=    POST On Session    transaction_kpi    ${uri}    headers=${headers}
        Should Be Equal As Strings    ${response.status_code}    200
        ${json}=    Convert String to JSON    ${response.content}    
        Log    ${json}

        Dictionary Should Contain Key    ${json}    transactionStatuses
        Dictionary Should Contain Key    ${json}    submissionStepTrackings

        ${status1}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["transactionStatuses"][0]["paymentStatus"]}    SUCCESS
        ${status2}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["submissionStepTrackings"][0]["status"]}    SUCCESS
        ${status3}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["submissionStepTrackings"][1]["status"]}    SUCCESS

        ${all_passed}=    Evaluate    ${status1} and ${status2} and ${status3}
        Exit For Loop If    ${all_passed}

        Sleep    10s
        ${start}=    Evaluate    ${start} + 1
    END
    IF    not ${all_passed}
        Fail
    END


Insurance Submission QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable     ${URI_ESOL_CASE}/${CASE_ID}/insurance/submission
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive
    
    ${response}=    POST On Session    transaction_kpi    ${uri}    headers=${headers}

    ${all_passed}=    Set Variable    False
    ${start}=        Set Variable    0
    WHILE    ${start} < 10 and not ${all_passed}
        Should Be Equal As Strings    ${response.status_code}    200
        ${json}=    Convert String to JSON    ${response.content}    
        Log    ${json}

        Dictionary Should Contain Key    ${json["transactionStatuses"][0]}    paymentStatus
        Dictionary Should Contain Key    ${json["submissionStepTrackings"][1]}    status


        ${status1}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["transactionStatuses"][0]["paymentStatus"]}    PENDING
        ${status2}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["submissionStepTrackings"][1]["status"]}    SUCCESS

        ${all_passed}=    Evaluate    ${status1} and ${status2}
        Exit For Loop If    ${all_passed}

        Sleep    10s
        ${start}=    Evaluate    ${start} + 1
    END

Insurance Submission Status QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable     ${URI_ESOL_CASE}/${CASE_ID}/insurance/submission/status
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${all_passed}=    Set Variable    False
    ${start}=        Set Variable    0
    WHILE    ${start} < 10 and not ${all_passed}
        ${response}=    POST On Session    transaction_kpi    ${uri}    headers=${headers}
        Should Be Equal As Strings    ${response.status_code}    200
        ${json}=    Convert String to JSON    ${response.content}    
        Log    ${json}

        Dictionary Should Contain Key    ${json}    transactionStatuses
        Dictionary Should Contain Key    ${json}    submissionStepTrackings

        ${status1}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["transactionStatuses"][0]["paymentStatus"]}    PENDING
        ${status2}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["transactionStatuses"][0]["status"]}    POLICY_SUCCESS
        ${status3}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["submissionStepTrackings"][1]["status"]}    SUCCESS

        ${all_passed}=    Evaluate    ${status1} and ${status2} and ${status3}
        Exit For Loop If    ${all_passed}

        Sleep    10s
        ${start}=    Evaluate    ${start} + 1
    END

Search Status
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Connection=keep-alive
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br

    Create Session    Get_Status    ${url} 
    ${case_status}=    Set Variable    False
    ${start}=        Set Variable    0
    WHILE    ${start} < 6 and not ${case_status}
        ${response}=    GET On Session   Get_Status    ${uri}    headers=${headers}
        Should Be Equal As Strings    ${response.status_code}    200
        ${json}=    Convert String to JSON    ${response.content}  
        Log    ${json}

        Dictionary Should Contain Key    ${json}    caseStatus
        Dictionary Should Contain Key    ${json}    flow

        ${case_status}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["caseStatus"]}    SUCCESS
        ${flow_status}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["flow"]}    insurance

        Exit For Loop If    ${case_status} and ${flow_status}

        Sleep    10s
        ${start}=    Evaluate    ${start} + 1
    END    
    IF    not ${case_status}
        Fail
    END
    
    Dictionary Should Contain Key    ${json}    caseId
    Dictionary Should Contain Key    ${json}    branchCode
    Dictionary Should Contain Key    ${json}    employeeId
    Dictionary Should Contain Key    ${json}    employeeIdNoAx
    Dictionary Should Contain Key    ${json}    employeeUserGroup
    Dictionary Should Contain Key    ${json}    employeeLicenses
    Dictionary Should Contain Key    ${json}    channel
    Dictionary Should Contain Key    ${json}    customerInfo
    Dictionary Should Contain Key    ${json}    productInfo
    Dictionary Should Contain Key    ${json}    documentInfo
    Dictionary Should Contain Key    ${json}    approvalInfo
    Dictionary Should Contain Key    ${json}    additionalInfo
    Dictionary Should Contain Key    ${json}    portfolioInfo
    Dictionary Should Contain Key    ${json}    customerNoti
    Dictionary Should Contain Key    ${json}    subFlow
    Dictionary Should Contain Key    ${json}    opportunityLogRefNo
    Dictionary Should Contain Key    ${json}    needPrintedDocument
    Dictionary Should Contain Key    ${json}    sendCusEmailDocument
    Dictionary Should Contain Key    ${json}    caseMaintenance
    Dictionary Should Contain Key    ${json}    customerAcceptConsent
    Dictionary Should Contain Key    ${json}    selectedLanguage

    Dictionary Should Contain Key    ${json["productInfo"]}    insuranceTransactions
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    productId
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    productCode
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    productTypeId
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    productTypeCode
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    productName
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    productBusinessCode
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    appId
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    companyId
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    companyName
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    planId
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    planCode
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    planName
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    paymentMethod
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    transNo
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    refNo
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    sumInsured
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    insurancePremium
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    amt
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    ddrRegistration
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    selectedBranch
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    refererId
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    refererBranchCode
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    refererName
    # Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    loanAcctNo
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    customerAddrVerified
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    transStatus
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    sendPaymentResult
    Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}    getPolicyResult

    Should Be Equal As Strings    ${json["productInfo"]["insuranceTransactions"][0]["sendPaymentResult"]}    SUCCESS  
    Should Be Equal As Strings    ${json["productInfo"]["insuranceTransactions"][0]["getPolicyResult"]}    SUCCESS 

    ${PaymentMethod}    Get Value From Json    ${json}    $.productInfo.insuranceTransactions[0].paymentMethod
    IF    '${PaymentMethod}[0]' == 'TRANSFER'
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}                       billPaymentInfo
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    transactionId
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    compCode
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    acctNo
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    companyAcct
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    companyAcctBrCd
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    result
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    errorCode
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    errorDesc
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    extErrCode
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]}    manuallyVerify

        Should Be Equal As Strings    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]["result"]}    SUCCESS  
        Should Be Equal As Strings    ${json["productInfo"]["insuranceTransactions"][0]["billPaymentInfo"]["errorDesc"]}    SUCCESS

    ELSE IF    '${PaymentMethod}[0]' == 'QR'
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]}                     qrPaymentInfo
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["qrPaymentInfo"]}    transactionId
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["qrPaymentInfo"]}    compCode
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["qrPaymentInfo"]}    errorCode
        Dictionary Should Contain Key    ${json["productInfo"]["insuranceTransactions"][0]["qrPaymentInfo"]}    manuallyVerify
        
        Should Be Equal As Strings    ${json["productInfo"]["insuranceTransactions"][0]["qrPaymentInfo"]["result"]}    PENDING

    ELSE
        Fail
    END
    
QR Payment Insurance
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable     ${URI_ESOL_INSURANCE}/${CASE_ID}/payment/${APP_ID}/qr-payment
    Log    url = ${url}${uri}

    ${data}=    Set Variable    {"transactionId": "${APP_ID}-1"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=application/octet-stream
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br, zstd
    # ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200

Status Payment
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_INSURANCE}/${CASE_ID}/payment/${APP_ID}-1/status?action=PendingActions
    Log    url = ${url}${uri}
    
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Accept=*/*
    ...    Accept-Encoding=gzip, deflate, br, zstd
    
    Create Session    status_payment    ${url}
    
    FOR    ${index}    IN RANGE    3
        ${response}=    GET On Session    status_payment    ${uri}    headers=${headers}  
        Should Be Equal As Strings    ${response.status_code}    200
        ${json}=    Convert String to JSON    ${response.content}    
        Log    ${json}    
        Sleep     2s
    END
    
    Dictionary Should Contain Key    ${json}    compCode
    Dictionary Should Contain Key    ${json}    result
    Dictionary Should Contain Key    ${json}    transactionId
    Dictionary Should Contain Key    ${json}    errDesc
    Dictionary Should Contain Key    ${json}    errCode

    Set Global Variable    ${COMP_CODE}    ${json['compCode']}

    Should Be Equal As Strings    ${json["errDesc"]}    Payment status checking exceeded limit 3 times

    IF    '${json["result"]} ' == 'SUCCESS'
        ${QR_Payment_Status}=    Set Variable    ${True}
    ELSE
        ${QR_Payment_Status}=    Set Variable    ${False}
    END

    Set Test Variable    ${QR_Payment_Status}    ${QR_Payment_Status}

QR Payment Image Upload
    IF    ${QR_Payment_Status} == ${False}
        ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
        ${uri}=    Set variable    ${URI_ESOL_DOC_CREATE}
        Log    url = ${url}${uri}
        
        ${DateOfBirth}    Replace String    ${MOCK_DateOfBirth}    /    ${EMPTY}

        ${file_path}    Set Variable    ${CURDIR}/../uploads/${Payment_File_Name}
        
        ${req}    Set Variable    {"caseId":"${CASE_ID}","documentId":"QR_EVIDENCE","appId":"${CASE_ID}","cardNumber":"${MOCK_CardNumber}","dateOfBirth":"${DateOfBirth}","overrideContentType":"application/pdf"}
        
        ${file_data}=    Evaluate
        ...    {"file": open(r'${file_path}', 'rb'),"request": ('request', '${req}', 'application/json')}
        
        ${headers}=    Create Dictionary
        ...    Authorization=Bearer ${ACCESS_TOKEN}
        ...    Accept=*/*
        ...    Accept-Encoding=gzip, deflate, br
        ...    Connection=keep-alive

        Create Session    upload_Payment    ${url}
        ${response}    POST On Session  upload_Payment  ${uri}  headers=${headers}  files=${file_data}  expected_status=any    

        Log    ${response.status_code}
        Log    ${response.content}
        Should Be Equal As Strings    ${response.status_code}    200
        ${json}=    Convert String to JSON    ${response.content}
        
        Dictionary Should Contain Key     ${json}    uploadSessionId

        Set Global Variable    ${PAYMENT_UPLOAD_SESSION_ID}    ${json["uploadSessionId"]}
    END
Remove special characters from test case name
    ${regex_pattern_for_remove_special_characters}=    Set Variable    '[^a-zA-Z0-9\u0E00-\u0E7F _-]'
    ${test_cases_name_without_special_characters}=     Replace String Using Regexp     ${TEST_NAME}     ${regex_pattern_for_remove_special_characters}     ${EMPTY}
    ${test_cases_name_without_special_characters}     Replace String    ${test_cases_name_without_special_characters}     search_for=${SPACE}     replace_with=_
    Set Test Variable    ${test_cases_name_without_special_characters}

Check PDF Text Before Logging Link
    [Arguments]    ${TARGET_WORD}    ${PDF_PATH}
    ${text}=    Evaluate
    ...    " ".join([p.extract_text() or "" for p in __import__('PyPDF2').PdfReader(r'''${PDF_PATH}''').pages])
    ${found}=    Evaluate    '${TARGET_WORD}' in '''${text}'''
    RETURN    ${found}
    
Get Report Insurance
    [Arguments]    ${productCode}
    # สินเชื่อปลอดภัย > HL000005
    # สินเชื่อมีสุข > CESOKTBLT
    # สินเชื่อสบายใจ > CESOKTBLP
    # สินเชื่อหายห่วง > PAL00050
    Sleep    10s
    Set pdf file path to variable
    ${current_date}=    Get Current Date    result_format=%Y%m%d

    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    /ktb/rest/esolution/v1/case/report/insurance-submission?fromDate=${current_date}&toDate=${current_date}&requestStatus=ALL&product=ALL&productCode=${productCode}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive
    # ${CASE_ID}=    Set Variable    200020-251200002752
    Create Session    transaction_kpi    ${url}
    ${response}=    GET On Session     transaction_kpi    ${uri}     headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    
    # ${pdf_path}=    Set Variable    ${OUTPUT DIR}${/}..${/}results${/}${pdf_file_path}
    ${pdf_path}=    Set Variable    ${CURDIR}${/}..${/}results${/}${pdf_file_path}
    Create Binary File    ${pdf_path}    ${response.content}

    ${found}    Check PDF Text Before Logging Link    ${CASE_ID}    ${pdf_path}
    Set Test Variable    ${found}
    Run Keyword If    '${found}' == 'True'
    ...    View PDF Insurance Report
    ...    ELSE
    ...    FAIL    ❌ ไม่พบคำ "${CASE_ID}" ใน PDF

Set pdf file path to variable
    ${current_date}=    Get Current Date    result_format=%Y%m%d
    Remove special characters from test case name
    ${pdf_file_path}         Set Variable          pdf_result${/}${current_date}${/}insurance${/}${test_cases_name_without_special_characters}.pdf
    Set Test Variable    ${pdf_file_path} 

View PDF Insurance Report
    Log    ${CASE_ID}
    IF    '${found}' == 'True'
        Log    <a href="${pdf_file_path}" target="_blank">📄 คลิกเพื่อดู PDF รายงาน</a>    html=True
    ELSE
        Log    ❌ ไม่พบคำ "${CASE_ID}" ใน PDF
    END