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
Retrieve Get Case ID MFOA
    #retrieve_case
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_CASE_RETRIEVE}
    Log    url = ${url}${uri}

    # ${data}=    Evaluate     {"cardInfo":${CARD_INFO},"channel":"android","flow":"insurance","sellerInfo":{"firstName":"ผุสพร","lastName":"ปุสสเด็จ","position":"รองผู้จัดการธุรกิจการขาย","userGroup":"CSSM","licenses":[{"licenseType":"ICC2","licenseNo":"056711","licenseExp":"20261231","errorFlag":${False},"expired":${False}},{"licenseType":"LF","licenseNo":"5203017345","licenseExp":"20261028","errorFlag":${False},"expired":${False}},{"licenseType":"NON LIFE","licenseNo":"5204021477","licenseExp":"20261028","errorFlag":${False},"expired":${False}}]},"subFlow":"","data":{},"draftedCaseId":"","skipIntroduction":${False},"mcToolRefNo":"${MC_TOOL_REFNO}","opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":${False},"vcLimitationTypes":[]},"vcSelectedProducts":["${ProductID}"]}}    json
    ${data}=    Evaluate     {"cardInfo":${CARD_INFO},"channel":"android","flow":"mfoa","sellerInfo":{"firstName":"${FirstNameEmployee}","lastName":"${LastNameEmployee}","position":"${POSITION}","userGroup":"${RoleClassCode}","licenses":${LICENSES}},"subFlow":"","data":{},"draftedCaseId":"","skipIntroduction":${False},"mcToolRefNo":"${MC_TOOL_REFNO}","opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":${False},"vcLimitationTypes":[]},"vcSelectedProducts":["${ProductID}"]}}    json
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
    Set Test Variable    ${additionalInfo}
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
    Set Test Variable    ${flow}    ${json["flow"]}

    Set Global Variable    ${CASE_ID}          ${json["caseId"]}
    Set Global Variable    ${WS_REF_ID}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["inquiryCIFDetailRespHeader"]["wsRefId"]}
    Set Global Variable    ${SELECT_PRODUCT}   ${json["vcInfo"]["vcSelectedProducts"][0]}
    Set Global Variable    ${AGE_CUSTOMER}     ${json["customerInfo"]["personalInfos"][0]["age"]}
    Set Global Variable    ${PHONT_OLD}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["mobilePhone"]}
    Set Global Variable    ${EMAIL_OLD}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["emailAddr"]}
    Set Global Variable    ${POSTAL_CODE}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["legalPostalCd"]}
    
    Set To Dictionary    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}      emailAddr=${Email}
    Set To Dictionary    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}      mobilePhone=${OTP_Tel}
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

Retrieve Continue MFOA
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/continue
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
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
    
    
    Dictionary Should Contain Key    ${json["customerInfo"]["personalInfos"][0]["cifExistingData"]}    customerNo  
    Set Suite Variable    ${CUSTOMER_CIF}    ${json["customerInfo"]["personalInfos"][0]["cifExistingData"]["customerNo"]}

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
    Set Global Variable    ${vcInfo}    ${json["vcInfo"]}
    ${vc_assessment_id_status}=    Run Keyword And Return Status    Get From Dictionary    ${json["vcInfo"]}    vcAssessmentId   
    IF    ${vc_assessment_id_status}
        Set Global Variable    ${VC_ASSESSMANT_ID}    ${json["vcInfo"]["vcAssessmentId"]}
        Set Global Variable    ${VC_APPROACH_CODE}    ${json["vcInfo"]["highestVcApproachCode"]}
        Set Global Variable    ${VC_SELECT_PRODUCT}    ${json["vcInfo"]["vcSelectedProducts"][0]}
        ${vc_group_codes}=    Get From Dictionary    ${json["vcInfo"]}    vcGroupCodes
        ${vc_group_codes_length}=    Get Length    ${vc_group_codes}
        IF    ${vc_group_codes_length} > 0
            Set Global Variable    ${VC_GROUP_CODE}    ${vc_group_codes}[0]
            # Ensure VC_SELECT_PRODUCT is set before trying to split it
            IF    '${VC_SELECT_PRODUCT}' != '${EMPTY}'
                ${VC_SELECT_Split}=    Split String    ${VC_SELECT_PRODUCT}     separator=-
                Set Global Variable    ${VC_PRODUCT_CODE}    ${VC_SELECT_Split}[0]
            END
        ELSE
            Set Global Variable    ${VC_GROUP_CODE}    ${EMPTY}
            Set Global Variable    ${VC_PRODUCT_CODE}    ${EMPTY}
        END
    END 
    ${vcInfo}    Convert To String    ${json["vcInfo"]}
    ${vcInfo}    Replace String    ${vcInfo}    '    "
    ${vcInfo}=    Replace String    ${vcInfo}    True    true
    ${vcInfo}=    Replace String    ${vcInfo}    False    false
    Set Global Variable    ${VC_INFO}    ${vcInfo}

    ${productInfo}    Convert To String    ${json["productInfo"]}
    ${productInfo}    Replace String    ${productInfo}    '    "
    Set Global Variable    ${PRODUCT_INFO}    ${productInfo}
    
    @{FUND_ACCOUNT_NO_LIST}    Create List
    ${fund_deposits}=    Get From Dictionary    ${json}[portfolioInfo][fundProfile]    accountInfo
    Set Test Variable    ${kcifInfo}    ${json}[portfolioInfo][fundProfile][kcifInfo]
    Set Test Variable    ${KCIF_NO}    ${json}[portfolioInfo][fundProfile][accountInfo][0][kcifNo]
    Set Test Variable    ${Fund_account}    ${json}[portfolioInfo][fundProfile][accountInfo][0][accountId]
    Set Test Variable    ${Fund_accountType}    ${json}[portfolioInfo][fundProfile][accountInfo][0][accountType]
    Set Test Variable    ${mutualFundConsent}    ${json}[customerInfo][personalInfos][0][cifForm][mutualFundConsent]
    
    @{ACCOUNT_NO_LIST}    Create List
    ${deposits}=    Get From Dictionary    ${json['portfolioInfo']}    deposits
    FOR    ${deposit}    IN    @{deposits}
        ${group}=    Get From Dictionary    ${deposit}    productGroup
        ${status}=   Get From Dictionary    ${deposit}    accountStatus
        ${avail}=    Get From Dictionary    ${deposit}    availBalAmt
        Run Keyword If    '${group}' == 'SAV' and ${status} == 0 and ${avail} > ${sav_min}
        ...    Append To List    ${ACCOUNT_NO_LIST}    ${deposit['accountNo']}
    END
    Log    ${ACCOUNT_NO_LIST}
    Set Suite Variable    ${ACCOUNT_NO_LIST}
    ${list_length}=    Get Length    ${ACCOUNT_NO_LIST}
    Run Keyword If    ${list_length} > 1    Set Global Variable    ${ACCOUNT_NO_1}    ${ACCOUNT_NO_LIST}[0]

Update OTP Telephone MFOA
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=CIKCIFInformation&option=draft

    Log    url = ${url}${uri}

    ${CBS_INFO_json}=    Convert String to JSON    ${CBS_INFO}
    Set To Dictionary    ${CBS_INFO_json}    emailAddr=${Email}
    Set To Dictionary    ${CBS_INFO_json}    mobilePhone=${OTP_Tel}
    ${CBS_INFO_str}    Convert Json To String    ${CBS_INFO_json}
    ${CBS_INFO}     Replace String    ${CBS_INFO_str}     '    "
    Set Global Variable    ${CBS_INFO}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Update_OTP_Telephone.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    # Log    ${json_text_replaced}
    # ${json_data}=    Evaluate    json.loads($json_text_replaced)
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}
    ${json_data}=    Convert String to JSON    ${json_text_replaced}
    Set To Dictionary    ${json_data}    flow=mfoa
    
    Set Test Variable    ${json_kcifInfo}    ${kcifInfo}
    Set To Dictionary    ${json_data}[productInfo]    kcifInfo=${kcifInfo}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    update_case_tel    ${url}
    ${response}=    PUT On Session    update_case_tel    ${uri}    headers=${headers}    json=${json_data}   
    Should Be Equal As Strings    ${response.status_code}    200

Generate App ID MFOA
    [Arguments]    ${Is_product2}=${False}
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
    
    IF    ${Is_product2}
        Set Suite Variable    ${APP_ID2}    ${json["appIds"][0]}
    ELSE
        Set Suite Variable    ${APP_ID}    ${json["appIds"][0]}
    END
    
Get Fund Profile
    ${URI_MFOA_FUND_PROFILE}    Replace String    ${URI_MFOA_FUND_PROFILE}    caseId    ${caseId}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_PROFILE}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    get_fund_profile    ${url}
    ${response}=    GET On Session     get_fund_profile       ${uri}     headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Set To Dictionary    ${json}[fundProfile][kcifInfo]    email=${Email}
    Set To Dictionary    ${json}[fundProfile][kcifInfo]    mobileNo=${OTP_Tel}

    Set Test Variable    ${identifications}    ${json["identifications"]}
    Set Test Variable    ${kcifInfo}    ${json}[fundProfile][kcifInfo]

Get Fund Details
    [Arguments]    ${Is_product2}=${False}
    IF    ${Is_product2}
        ${URI_MFOA_FUND_DETAILS}    Replace String    ${URI_MFOA_FUND_DETAILS}    FundCode    ${FundCode2}
    ELSE  
        ${URI_MFOA_FUND_DETAILS}    Replace String    ${URI_MFOA_FUND_DETAILS}    FundCode    ${FundCode}
    END
    
    
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_DETAILS}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    get_fund_details    ${url}
    ${response}=    GET On Session     get_fund_details       ${uri}     headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json}    fundCode
    Dictionary Should Contain Key    ${json}    fundType
    Dictionary Should Contain Key    ${json}    fundNameEn
    Dictionary Should Contain Key    ${json}    fundNameTh
    Dictionary Should Contain Key    ${json}    fundCategory
    Dictionary Should Contain Key    ${json}    amcCode
    Dictionary Should Contain Key    ${json}    riskLevel
    Dictionary Should Contain Key    ${json}    asOfDate
    # Dictionary Should Contain Key    ${json}    startDateTime
    Dictionary Should Contain Key    ${json}    endDateTime
    Dictionary Should Contain Key    ${json}    ipoFund
    Dictionary Should Contain Key    ${json}    tacticalFund
    Dictionary Should Contain Key    ${json}    popularFund
    Dictionary Should Contain Key    ${json}    foreignFund
    Dictionary Should Contain Key    ${json}    complexFund
    Dictionary Should Contain Key    ${json}    descriptionTH
    Dictionary Should Contain Key    ${json}    descriptionEN
    Dictionary Should Contain Key    ${json}    fundFactSheetTh
    Dictionary Should Contain Key    ${json}    fundPerformanceTh
    Dictionary Should Contain Key    ${json}    position
    Dictionary Should Contain Key    ${json}    categoryCode
    Dictionary Should Contain Key    ${json}    cioTaxTypeCode
    Dictionary Should Contain Key    ${json}    transactionMadeAllowFlag
    Dictionary Should Contain Key    ${json}    buyChannel
    Dictionary Should Contain Key    ${json}    subscriptionPeriodFlag
    Dictionary Should Contain Key    ${json}    switchInChannel
    Dictionary Should Contain Key    ${json}    switchInPeriodFlag
    Dictionary Should Contain Key    ${json}    sellChannel
    Dictionary Should Contain Key    ${json}    redemptionPeriodFlag
    Dictionary Should Contain Key    ${json}    switchOutChannel
    Dictionary Should Contain Key    ${json}    switchOutPeriodFlag
    Dictionary Should Contain Key    ${json}    switchPreOrderDay
    Dictionary Should Contain Key    ${json}    redemptionPreOrderDay
    Dictionary Should Contain Key    ${json}    subscriptionPreOrderDay
    Dictionary Should Contain Key    ${json}    buyTradeType
    Dictionary Should Contain Key    ${json}    sellTradeType
    Dictionary Should Contain Key    ${json}    switchInTradeType
    Dictionary Should Contain Key    ${json}    switchOutTradeType
    Dictionary Should Contain Key    ${json}    nav
    Dictionary Should Contain Key    ${json}    navAsOfDate
    Dictionary Should Contain Key    ${json}    navChange
    Dictionary Should Contain Key    ${json}    navChangePercent
    Dictionary Should Contain Key    ${json}    fundNavList
    @{fundNavList}=    Set Variable    ${json["fundNavList"]}
    FOR    ${navItem}    IN    @{fundNavList}
        Dictionary Should Contain Key    ${navItem}    period
        # Optionally, check for navChange and navChangePercent if they are expected to always exist
        ${hasNavChange}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${navItem}    navChange
        ${hasNavChangePercent}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${navItem}    navChangePercent
    END
    Dictionary Should Contain Key    ${json}    assetValue
    Dictionary Should Contain Key    ${json}    fxRisk
    Dictionary Should Contain Key    ${json}    fundDividend
    Dictionary Should Contain Key    ${json}    fundHealthInsurance
    Dictionary Should Contain Key    ${json}    subscriptionCutOffTime
    Dictionary Should Contain Key    ${json}    redemptionCutOffTime
    Dictionary Should Contain Key    ${json}    minFirstSubAmount
    Dictionary Should Contain Key    ${json}    minNexSubAmount
    Dictionary Should Contain Key    ${json}    minRedemptionAmount
    Dictionary Should Contain Key    ${json}    minRedemptionUnit
    Dictionary Should Contain Key    ${json}    minRemainingAmount
    Dictionary Should Contain Key    ${json}    minRemainingUnit
    Dictionary Should Contain Key    ${json}    redemptionSettlementDay
    Dictionary Should Contain Key    ${json}    fundFees
    
    ${min_amounts}=    Get From Dictionary    ${json}    minFirstSubAmount
    IF    ${min_amounts}<1
        ${min_amounts}=    Set Variable    1
    END

    ${min_nex_amounts}=    Get From Dictionary    ${json}    minNexSubAmount
    IF    ${min_amounts}<1
        ${min_nex_amounts}=    Set Variable    1
    END
    
    # Set Test Variables 
    Set Test Variable    ${nav}                 ${json}[nav]
    IF    ${Is_product2}
        Set Test Variable    ${mutualFundDetail2}        ${json}
        Set Test Variable    ${amcCode2}                 ${json}[amcCode]
        Set Test Variable    ${fundCode2}                ${json}[fundCode]
        Set Test Variable    ${minFirstSubAmount2}       ${min_amounts}
        Set Test Variable    ${minNexSubAmount2}         ${min_nex_amounts}
        Set Test Variable    ${fundNameEn2}              ${json}[fundNameEn]
    ELSE
        Set Test Variable    ${mutualFundDetail}        ${json}
        Set Test Variable    ${amcCode}                 ${json}[amcCode]
        Set Test Variable    ${fundCode}                ${json}[fundCode]
        Set Test Variable    ${minFirstSubAmount}       ${min_amounts}
        Set Test Variable    ${minNexSubAmount}         ${min_nex_amounts}
        Set Test Variable    ${fundNameEn}              ${json}[fundNameEn]
    END

Get Switch in Fund Details
    [Arguments]    ${Is_product2}=${False}
    ${URI_MFOA_FUND_DETAILS}    Replace String    ${URI_MFOA_FUND_DETAILS}    FundCode    ${SwitchToFund}
    
    
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_DETAILS}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    get_fund_details    ${url}
    ${response}=    GET On Session     get_fund_details       ${uri}     headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json}    fundCode
    Dictionary Should Contain Key    ${json}    fundType
    Dictionary Should Contain Key    ${json}    fundNameEn
    Dictionary Should Contain Key    ${json}    fundNameTh
    Dictionary Should Contain Key    ${json}    fundCategory
    Dictionary Should Contain Key    ${json}    amcCode
    Dictionary Should Contain Key    ${json}    riskLevel
    Dictionary Should Contain Key    ${json}    asOfDate
    # Dictionary Should Contain Key    ${json}    startDateTime
    Dictionary Should Contain Key    ${json}    endDateTime
    Dictionary Should Contain Key    ${json}    ipoFund
    Dictionary Should Contain Key    ${json}    tacticalFund
    Dictionary Should Contain Key    ${json}    popularFund
    Dictionary Should Contain Key    ${json}    foreignFund
    Dictionary Should Contain Key    ${json}    complexFund
    Dictionary Should Contain Key    ${json}    descriptionTH
    Dictionary Should Contain Key    ${json}    descriptionEN
    Dictionary Should Contain Key    ${json}    fundFactSheetTh
    Dictionary Should Contain Key    ${json}    fundPerformanceTh
    Dictionary Should Contain Key    ${json}    position
    Dictionary Should Contain Key    ${json}    categoryCode
    Dictionary Should Contain Key    ${json}    cioTaxTypeCode
    Dictionary Should Contain Key    ${json}    transactionMadeAllowFlag
    Dictionary Should Contain Key    ${json}    buyChannel
    Dictionary Should Contain Key    ${json}    subscriptionPeriodFlag
    Dictionary Should Contain Key    ${json}    switchInChannel
    Dictionary Should Contain Key    ${json}    switchInPeriodFlag
    Dictionary Should Contain Key    ${json}    sellChannel
    Dictionary Should Contain Key    ${json}    redemptionPeriodFlag
    Dictionary Should Contain Key    ${json}    switchOutChannel
    Dictionary Should Contain Key    ${json}    switchOutPeriodFlag
    Dictionary Should Contain Key    ${json}    switchPreOrderDay
    Dictionary Should Contain Key    ${json}    redemptionPreOrderDay
    Dictionary Should Contain Key    ${json}    subscriptionPreOrderDay
    Dictionary Should Contain Key    ${json}    buyTradeType
    Dictionary Should Contain Key    ${json}    sellTradeType
    Dictionary Should Contain Key    ${json}    switchInTradeType
    Dictionary Should Contain Key    ${json}    switchOutTradeType
    Dictionary Should Contain Key    ${json}    nav
    Dictionary Should Contain Key    ${json}    navAsOfDate
    Dictionary Should Contain Key    ${json}    navChange
    Dictionary Should Contain Key    ${json}    navChangePercent
    Dictionary Should Contain Key    ${json}    fundNavList
    @{fundNavList}=    Set Variable    ${json["fundNavList"]}
    FOR    ${navItem}    IN    @{fundNavList}
        Dictionary Should Contain Key    ${navItem}    period
        # Optionally, check for navChange and navChangePercent if they are expected to always exist
        ${hasNavChange}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${navItem}    navChange
        ${hasNavChangePercent}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${navItem}    navChangePercent
    END
    Dictionary Should Contain Key    ${json}    assetValue
    Dictionary Should Contain Key    ${json}    fxRisk
    Dictionary Should Contain Key    ${json}    fundDividend
    Dictionary Should Contain Key    ${json}    fundHealthInsurance
    Dictionary Should Contain Key    ${json}    subscriptionCutOffTime
    Dictionary Should Contain Key    ${json}    redemptionCutOffTime
    Dictionary Should Contain Key    ${json}    minFirstSubAmount
    Dictionary Should Contain Key    ${json}    minNexSubAmount
    Dictionary Should Contain Key    ${json}    minRedemptionAmount
    Dictionary Should Contain Key    ${json}    minRedemptionUnit
    Dictionary Should Contain Key    ${json}    minRemainingAmount
    Dictionary Should Contain Key    ${json}    minRemainingUnit
    Dictionary Should Contain Key    ${json}    redemptionSettlementDay
    Dictionary Should Contain Key    ${json}    fundFees
    
    ${min_redempt_amounts}=    Get From Dictionary    ${json}    minFirstSubAmount
    IF    ${min_redempt_amounts}<1
        ${min_redempt_amounts}=    Set Variable    1
    END

    ${min_unit}=    Evaluate    __import__('math').ceil(${min_redempt_amounts}/${nav})

    ${min_redempt_unit}=    Get From Dictionary    ${json}    minRedemptionUnit
    IF    ${min_redempt_unit}<1
        ${min_redempt_unit}=    Set Variable    1
    END

    ${min_nex_amounts}=    Get From Dictionary    ${json}    minNexSubAmount
    IF    ${min_nex_amounts}<1
        ${min_nex_amounts}=    Set Variable    1
    END

    ${min_remain_unit}=    Get From Dictionary    ${json}    minRemainingUnit
    IF    ${min_remain_unit}<1
        ${min_remain_unit}=    Set Variable    1
    END
    
    # Set Test Variables 
    Set Test Variable    ${SwitchIn_mutualFundDetail}        ${json}
    Set Test Variable    ${SwitchIn_amcCode}                 ${json}[amcCode]
    Set Test Variable    ${SwitchIn_fundCode}                ${json}[fundCode]
    Set Test Variable    ${min_redempt_amounts}              ${min_redempt_amounts}
    Set Test Variable    ${min_nex_amounts}                  ${min_nex_amounts}
    Set Test Variable    ${SwitchIn_fundNameEn}              ${json}[fundNameEn]
    Set Test Variable    ${min_unit}  

Get Sell Fund Effective Date
    [Arguments]    ${Is_product2}=${False}
    ${URI_MFOA_FUND_EffectiveDate}    Replace String    ${URI_MFOA_FUND_EffectiveDate}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_SELL_FUND_EffectiveDate}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    # ${fund_curent_date}=    DateTime.Get Current Date    Asia/Bangkok    result_format=%Y-%m-%dT%H:%M:%S%z
    ${utc_now}=    DateTime.Get Current Date    UTC
    ${fund_curent_date}=    DateTime.Add Time To Date    ${utc_now}    7 hours    result_format=%Y-%m-%dT%H:%M:%S
    ${fund_curent_date}=    Set Variable    ${fund_curent_date}+07:00

    ${payload}=    Create Dictionary
    ...    fundCode=${FundCode}
    ...    switchOutFundCode=${EMPTY}
    ...    transactionType=REDEMPTION
    ...    transactionDateTime=${fund_curent_date}
    # Log    Payload Dictionary: ${payload}
    
    Create Session    get_fund_details    ${url}
    ${response}=    POST On Session     get_fund_details       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Effective Date Response: ${json}

    Should Not Be Empty    ${json}    msg=Fund Effective Date response list should not be empty
    Dictionary Should Contain Key    ${json}    effectiveDate
    Dictionary Should Contain Key    ${json}    cutOffTime
    Dictionary Should Contain Key    ${json}    allotmentDate
    Dictionary Should Contain Key    ${json}    receivingDate
    Dictionary Should Contain Key    ${json}    calculatedNavDate
    # Dictionary Should Contain Key    ${json}    validDateTime

    Set Test Variable    ${allotmentDate}              ${json}[allotmentDate]
    Set Test Variable    ${cutOffTime}                 ${json}[cutOffTime]
    Set Test Variable    ${effectiveDate}              ${json}[effectiveDate]
    Set Test Variable    ${receivingDate}              ${json}[receivingDate]
    Set Test Variable    ${calculatedNavDate}          ${json}[calculatedNavDate]
    # Set Test Variable    ${validDateTime}              ${json}[validDateTime]

Get Fund Effective Date
    [Arguments]    ${Is_product2}=${False}
    ${URI_MFOA_FUND_EffectiveDate}    Replace String    ${URI_MFOA_FUND_EffectiveDate}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_EffectiveDate}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    # ${fund_curent_date}=    DateTime.Get Current Date    Asia/Bangkok    result_format=%Y-%m-%dT%H:%M:%S%z
    ${utc_now}=    DateTime.Get Current Date    UTC
    ${fund_curent_date}=    DateTime.Add Time To Date    ${utc_now}    7 hours    result_format=%Y-%m-%dT%H:%M:%S
    ${fund_curent_date}=    Set Variable    ${fund_curent_date}+07:00

    
    ${fund_item}=    Create Dictionary    fundCode    ${FundCode}
    @{fund_list}=    Create List    ${fund_item}
    ${payload}=    Create Dictionary
    ...    fundList=${fund_list}
    ...    transactionDateTime=${fund_curent_date}
    # Log    Payload Dictionary: ${payload}
    
    Create Session    get_fund_details    ${url}
    ${response}=    POST On Session     get_fund_details       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Effective Date Response: ${json}

    Should Not Be Empty    ${json}    msg=Fund Effective Date response list should not be empty
    Dictionary Should Contain Key    ${json}    fundList
    ${fund_effective_details}=    Set Variable    ${json}[fundList]
    FOR    ${item}    IN    @{fund_effective_details}
        Dictionary Should Contain Key    ${item}    fundCode
        Dictionary Should Contain Key    ${item}    effectiveDate
        Dictionary Should Contain Key    ${item}    cutOffTime
        Dictionary Should Contain Key    ${item}    allotmentDate
        Dictionary Should Contain Key    ${item}    calculatedNavDate
    END
    
    IF    ${Is_product2}
    # Set Test Variables 
    Set Test Variable    ${allotmentDate2}              ${json}[fundList][0][allotmentDate]
    Set Test Variable    ${cutOffTime2}                 ${json}[fundList][0][cutOffTime]
    Set Test Variable    ${effectiveDate2}              ${json}[fundList][0][effectiveDate]
    ELSE
    Set Test Variable    ${allotmentDate}              ${json}[fundList][0][allotmentDate]
    Set Test Variable    ${cutOffTime}                 ${json}[fundList][0][cutOffTime]
    Set Test Variable    ${effectiveDate}              ${json}[fundList][0][effectiveDate]
    END

Get Fund Assessment
    [Arguments]    ${Is_product2}=${False}
    ${URI_MFOA_FUND_ASSESSMENT}    Replace String    ${URI_MFOA_FUND_ASSESSMENT}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_ASSESSMENT}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    # Create the customerLimitation dictionary
    ${vcLimitationTypes_list}=    Create List  # Empty list for vcLimitationTypes
    ${customerLimitation_dict}=    Create Dictionary
    ...    isRequiredAssistance=${FALSE}
    ...    vcLimitationTypes=${vcLimitationTypes_list}
    ...    isForceUpdate=${FALSE}
    
    # Create the vcSelectedProducts list
    ${vcSelectedProducts_list}=    Create List    ${FundCode}
    
    # Create the final payload
    ${payload}=    Create Dictionary
    ...    customerLimitation=${customerLimitation_dict}
    ...    vcSelectedProducts=${vcSelectedProducts_list}
    Log    Payload Dictionary: ${payload}
    
    Create Session    get_fund_assessment    ${url}
    ${response}=    POST On Session     get_fund_assessment       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Assessment Response: ${json}

    Dictionary Should Contain Key    ${json}         vcAssessmentId
    Dictionary Should Contain Key    ${json}         highestVcApproachCode

    # Set Test Variables 
    IF    ${Is_product2}
        Set Test Variable    ${vcAssessmentId2}                  ${json}[vcAssessmentId]
        Set Test Variable    ${highestVcApproachCode2}           ${json}[highestVcApproachCode]
    ELSE
        Set Test Variable    ${vcAssessmentId}                  ${json}[vcAssessmentId]
        Set Test Variable    ${highestVcApproachCode}           ${json}[highestVcApproachCode] 
    END

Get Fund Performance
    [Arguments]    ${Is_product2}=${False}
    IF    ${Is_product2}
        ${fundCode}=    Set Variable    ${FundCode2}
    ELSE
        ${fundCode}=    Set Variable    ${FundCode}
    END
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_PERFORMANCE}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    # Create the dictionary
    ${payload}=    Create Dictionary
    ...    fundCode=${fundCode}
    ...    period=${Period_Performance}
    
    Create Session    get_fund_performance    ${url}
    ${response}=    POST On Session     get_fund_performance       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Performance Response: ${json}

    # Dictionary Should Contain Key    ${json}                    chartAxis
    # Dictionary Should Contain Key    ${json}                    navHistory
    # Dictionary Should Contain Key    ${json}[chartAxis]         yAxis
    # Dictionary Should Contain Key    ${json}[chartAxis]         xAxis

Auth Signature
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_MFOA_AUTH_SIGNATURE}
    Log    url = ${url}${uri}
    
    ${file_path}    Set Variable    ${CURDIR}/../uploads/${Signa_File_Name}

    ${req}    Set Variable    {"caseId":"${CASE_ID}","documentId":"AUTH_SIGNATURE","appId":"${APP_ID}","cardNumber":"${MOCK_CardNumber}"}
    
    ${file_data}=    Evaluate
    ...    {"file": open(r'${file_path}', 'rb'),"request": ('request', '${req}', 'application/json')}
    
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    
    Create Session    upload_photo    ${url}
    ${response}    POST On Session  upload_photo  ${uri}  headers=${headers}  files=${file_data}  expected_status=any    

    Log    ${response.status_code}
    Log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    uploadSessionId

    Set Test Variable    ${Auth_uploadSessionId}    ${json["uploadSessionId"]}

Get Next Month Year-Month
    ${current}=    Get Current Date    result_format=%Y-%m-%d
    ${year}=       Evaluate    int('${current}'[:4])
    ${month}=      Evaluate    int('${current}'[5:7]) + 1
    ${year}=       Evaluate    ${year} + (${month} - 1) // 12
    ${month}=      Evaluate    (${month} - 1) % 12 + 1
    ${next}=       Evaluate    f"{${year}}-{${month}:02}"
    Log    Current Year-Month: ${current}[:7]
    Log    Next Year-Month: ${next}
    RETURN    ${next}

Get Fund Holiday
    [Arguments]    ${Is_product2}=${False}
    IF    ${Is_product2}
        ${fundCode}=    Set Variable    ${FundCode2}
    ELSE
        ${fundCode}=    Set Variable    ${FundCode}
    END
    ${URI_MFOA_FUND_HOLIDAY}    Replace String    ${URI_MFOA_FUND_HOLIDAY}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_HOLIDAY}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    ${current_year_month}=    Get Current Date    result_format=%Y-%m
    ${next_year_month}=    Get Next Month Year-Month
    
    # Create the dictionary
    ${payload}=    Create Dictionary
    ...    fundCode=${fundCode}
    ...    yearMonth=${current_year_month}
    
    Create Session    get_fund_holiday    ${url}
    ${response}=    POST On Session     get_fund_holiday       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Holiday Response: ${json}

    Dictionary Should Contain item     ${json}[0]                    fundCode         ${FundCode}
    Dictionary Should Contain item     ${json}[0]                    yearMonth        ${current_year_month}
    Dictionary Should Contain Key      ${json}[0]                    fundHolidayDate
    Dictionary Should Contain Key      ${json}[0]                    thaiHolidayList

    Dictionary Should Contain item     ${json}[1]                    fundCode         ${FundCode}
    Dictionary Should Contain item     ${json}[1]                    yearMonth        ${next_year_month}
    Dictionary Should Contain Key      ${json}[1]                    fundHolidayDate
    Dictionary Should Contain Key      ${json}[1]                    thaiHolidayList
    
    IF    ${Is_product2}
        Set Test Variable    ${holidayThisMonth2}    ${json}[0]
        Set Test Variable    ${holidayNextMonth2}    ${json}[1]
    ELSE
        Set Test Variable    ${holidayThisMonth}    ${json}[0]
        Set Test Variable    ${holidayNextMonth}    ${json}[1]
        
    END

Get Switch in Fund Holiday
    [Arguments]    ${Is_product2}=${False}
    ${fundCode}=    Set Variable    ${SwitchToFund}
    ${URI_MFOA_FUND_HOLIDAY}    Replace String    ${URI_MFOA_FUND_HOLIDAY}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_HOLIDAY}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    ${current_year_month}=    Get Current Date    result_format=%Y-%m
    ${next_year_month}=    Get Next Month Year-Month
    
    # Create the dictionary
    ${payload}=    Create Dictionary
    ...    fundCode=${fundCode}
    ...    yearMonth=${current_year_month}
    
    Create Session    get_fund_holiday    ${url}
    ${response}=    POST On Session     get_fund_holiday       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Holiday Response: ${json}

    Dictionary Should Contain item     ${json}[0]                    fundCode         ${FundCode}
    Dictionary Should Contain item     ${json}[0]                    yearMonth        ${current_year_month}
    Dictionary Should Contain Key      ${json}[0]                    fundHolidayDate
    Dictionary Should Contain Key      ${json}[0]                    thaiHolidayList

    Dictionary Should Contain item     ${json}[1]                    fundCode         ${FundCode}
    Dictionary Should Contain item     ${json}[1]                    yearMonth        ${next_year_month}
    Dictionary Should Contain Key      ${json}[1]                    fundHolidayDate
    Dictionary Should Contain Key      ${json}[1]                    thaiHolidayList
    
    Set Test Variable    ${SwitchIn_holidayThisMonth}    ${json}[0]
    Set Test Variable    ${SwitchIn_holidayNextMonth}    ${json}[1]

Get Fund Trade Calendar
    ${fundCode}=    Set Variable    ${FundCode}
    ${URI_MFOA_FUND_HOLIDAY}    Replace String    ${URI_MFOA_FUND_HOLIDAY}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_TRADE_CALENDAR}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    ${current_year_month}=    Get Current Date    result_format=%Y-%m
    ${next_year_month}=    Get Next Month Year-Month
    
    # Create the dictionary
    ${payload}=    Create Dictionary
    ...    fundCode=${fundCode}
    ...    yearMonth=${current_year_month}
    
    Create Session    get_fund_holiday    ${url}
    ${response}=    POST On Session     get_fund_holiday       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Holiday Response: ${json}

    Dictionary Should Contain item     ${json}[0]                    fundCode         ${FundCode}
    Dictionary Should Contain item     ${json}[0]                    yearMonth        ${current_year_month}
    Dictionary Should Contain Key      ${json}[0]                    tradeResult

    Set Test Variable    ${trade_calendar}    ${json}[0]

Get Switch in Fund Trade Calendar
    ${fundCode}=    Set Variable    ${SwitchToFund}
    ${URI_MFOA_FUND_HOLIDAY}    Replace String    ${URI_MFOA_FUND_HOLIDAY}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_TRADE_CALENDAR}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    ${current_year_month}=    Get Current Date    result_format=%Y-%m
    ${next_year_month}=    Get Next Month Year-Month
    
    # Create the dictionary
    ${payload}=    Create Dictionary
    ...    fundCode=${fundCode}
    ...    yearMonth=${current_year_month}
    
    Create Session    get_fund_holiday    ${url}
    ${response}=    POST On Session     get_fund_holiday       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Holiday Response: ${json}

    Dictionary Should Contain item     ${json}[0]                    fundCode         ${FundCode}
    Dictionary Should Contain item     ${json}[0]                    yearMonth        ${current_year_month}
    Dictionary Should Contain Key      ${json}[0]                    tradeResult

    Set Test Variable    ${SwitchIn_trade_calendar}    ${json}[0]

Fund Consent Validation
    [Arguments]    ${Is_product2}=${False}
    IF    ${Is_product2}
        ${fundCode}=    Set Variable    ${FundCode2}
    ELSE
        ${fundCode}=    Set Variable    ${FundCode}
    END
    ${URI_MFOA_FUND_CONSENT_VALIDATION}    Replace String    ${URI_MFOA_FUND_CONSENT_VALIDATION}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_CONSENT_VALIDATION}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    # Create the dictionary
    ${fundList}=    Create List    ${fundCode}
    ${payload}=    Create Dictionary
    ...    accountId=${Fund_account}
    ...    kcifNo=${KCIF_NO}
    ...    fundList=${fundList}
    
    Create Session    get_consent_validation    ${url}
    ${response}=    POST On Session     get_consent_validation       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Response: ${json}

    Dictionary Should Contain item     ${json}          kcifNo            ${KCIF_NO}
    Dictionary Should Contain item     ${json}          accountId         ${Fund_account}
    Dictionary Should Contain Key      ${json}          riskProfile
    Dictionary Should Contain Key      ${json}          fundList
    Dictionary Should Contain Key      ${json}          knowledgeAssessment

Fund CFPF Validation
    [Arguments]    ${Is_product2}=${False}
    IF    ${Is_product2}
        ${fundCode}=    Set Variable    ${FundCode2}
        ${amcCode}=    Set Variable    ${amcCode2}
    ELSE
        ${fundCode}=    Set Variable    ${FundCode}
        ${amcCode}=    Set Variable    ${amcCode}
    END
    ${URI_MFOA_FUND_CFPF_VALIDATION}    Replace String    ${URI_MFOA_FUND_CFPF_VALIDATION}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_CFPF_VALIDATION}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    # Create the dictionary
    ${fundList}=    Create List    ${fundCode}
    ${payload}=    Create Dictionary
    ...    accountId=${Fund_account}
    ...    amcCode=${amcCode}
    ...    isTaxDeductible=${False}
    ...    fundCode=${fundCode}
    
    Create Session    get_cfpf_validation    ${url}
    ${response}=    POST On Session     get_cfpf_validation       ${uri}     headers=${headers}    json=${payload}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Response: ${json}

    Dictionary Should Contain Key    ${json}    estimatedRemainingAmount
    Dictionary Should Contain Key    ${json}    estimatedOutstandingAmount
    Dictionary Should Contain Key    ${json}    estimatedRemainingUnit
    Dictionary Should Contain Key    ${json}    estimatedOutstandingUnit
    Dictionary Should Contain Key    ${json}    unitholderRefId
    Dictionary Should Contain Key    ${json}    unitholderId
    Dictionary Should Contain Key    ${json}    unitholderFcnRefId
    # Dictionary Should Contain Key    ${json}    saleCode
    # Dictionary Should Contain Key    ${json}    saleCodeBranch
    # Dictionary Should Contain Key    ${json}    saleCodeLicense
    Dictionary Should Contain Key    ${json}    isFirstSubscription
    Dictionary Should Contain Key    ${json}    isDeferUnitholder
    
    IF    ${Is_product2}
        Set Test Variable    ${estimatedRemainingAmount2}    ${json}[estimatedRemainingAmount]
        Set Test Variable    ${estimatedRemainingUnit2}      ${json}[estimatedRemainingUnit]
        Set Test Variable    ${unitholderId2}                ${json}[unitholderId]
    ELSE
        Set Test Variable    ${estimatedRemainingAmount}    ${json}[estimatedRemainingAmount]
        Set Test Variable    ${estimatedRemainingUnit}      ${json}[estimatedRemainingUnit]
        Set Test Variable    ${unitholderId}                ${json}[unitholderId]
        
    END
    
Update MFOA Information Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Put_Consent_MFOA.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}
    ${json_data}=    Convert String to JSON    ${json_text_replaced}
    
    IF    '${transactionType}' == 'buy'
        IF  '${scheduleDate}'!=''
            ${future}=    Set Variable    {"recurringDate":"","scheduleDate":"${scheduleDate}","scheduleEndPeriod":"","scheduleStartPeriod":"","scheduleType":"FUTURE"}
            ${future}    Replace Variables    ${future} 
            ${future} =   Evaluate    json.loads('${future}')
            Set To Dictionary    ${json_data['productInfo']['mutualFundTransactions'][0]}     future=${True}
            Set To Dictionary    ${json_data['productInfo']['mutualFundTransactions'][0]}     futureTransaction=${future}
        ELSE IF    '${recur_start}'!='' and '${recur_end}'!='' and '${recurringDate}'!=''
            ${recur}=    Set Variable    {"recurringDate":"${recurringDate}","scheduleDate":"","scheduleEndPeriod":"${recur_end}","scheduleStartPeriod":"${recur_start}","scheduleType":"RECURRING"}
            ${recur}    Replace Variables    ${recur} 
            ${recur} =   Evaluate    json.loads('${recur}')
            Set To Dictionary    ${json_data['productInfo']['mutualFundTransactions'][0]}     future=${True}
            Set To Dictionary    ${json_data['productInfo']['mutualFundTransactions'][0]}     futureTransaction=${recur}
        END

        IF    '${FundCode2}' != '' 
            ${json_text}=    Get File   ${CURDIR}/../resources/data/json/MFOA_Product2.json
            ${json_text_replaced}=    Replace Variables    ${json_text}
            ${json_text_replaced}=    Cleansing string    ${json_text_replaced}
            ${json_data2}=    Convert String to JSON    ${json_text_replaced}

            IF  '${scheduleDate2}'!=''
                ${future}=    Set Variable    {"recurringDate":"","scheduleDate":"${scheduleDate2}","scheduleEndPeriod":"","scheduleStartPeriod":"","scheduleType":"FUTURE"}
                ${future}    Replace Variables    ${future} 
                ${future} =   Evaluate    json.loads('${future}')
                Set To Dictionary    ${json_data2}     future=${True}
                Set To Dictionary    ${json_data2}     futureTransaction=${future}
            ELSE IF    '${recur_start2}'!='' and '${recur_end2}'!='' and '${recurringDate2}'!=''
                ${recur}=    Set Variable    {"recurringDate":"${recurringDate2}","scheduleDate":"","scheduleEndPeriod":"${recur_end2}","scheduleStartPeriod":"${recur_start2}","scheduleType":"RECURRING"}
                ${recur}    Replace Variables    ${recur} 
                ${recur} =   Evaluate    json.loads('${recur}')
                Set To Dictionary    ${json_data2}     future=${True}
                Set To Dictionary    ${json_data2}     futureTransaction=${recur}
            END

            Append To List    ${json_data['productInfo']['mutualFundTransactions']}    ${json_data2}
        END
    ELSE IF    '${transactionType}' == 'sell'  
        ${json_MFOA_Sell_mutualFundTransactions}=    Get File   ${CURDIR}/../resources/data/json/MFOA_Sell_mutualFundTransactions.json
        ${json_MFOA_Sell_mutualFundTransactions}=    Replace Variables    ${json_MFOA_Sell_mutualFundTransactions}
        ${json_MFOA_Sell_mutualFundTransactions}=    Cleansing string    ${json_MFOA_Sell_mutualFundTransactions}
        ${json_MFOA_Sell_mutualFundTransactions}=    Convert String to JSON    ${json_MFOA_Sell_mutualFundTransactions}
        IF    '${sell_type}'=='AMOUNT'
            ${amount}=    Set Variable    ${sell_amount}
            ${unit}=    Set Variable    ${null}
            Set To Dictionary    ${json_MFOA_Sell_mutualFundTransactions}[0]     amount=${amount}
            Set To Dictionary    ${json_MFOA_Sell_mutualFundTransactions}[0]     unit=${unit}
        ELSE IF    '${sell_type}'=='UNIT'
            ${amount}=    Set Variable    ${null}
            ${unit}=    Set Variable    ${sell_amount}
        END
        Set To Dictionary    ${json_MFOA_Sell_mutualFundTransactions}[0]     amount=${amount}
        Set To Dictionary    ${json_MFOA_Sell_mutualFundTransactions}[0]     unit=${unit}
        

        Set To Dictionary    ${json_data['productInfo']}     mutualFundTransactions=${json_MFOA_Sell_mutualFundTransactions}
    ELSE IF    '${transactionType}' == 'switch'  
        ${json_MFOA_Switch_mutualFundTransactions}=    Get File   ${CURDIR}/../resources/data/json/MFOA_Switch_mutualFundTransactions.json
        ${json_MFOA_Switch_mutualFundTransactions}=    Replace Variables    ${json_MFOA_Switch_mutualFundTransactions}
        ${json_MFOA_Switch_mutualFundTransactions}=    Cleansing string    ${json_MFOA_Switch_mutualFundTransactions}
        ${json_MFOA_Switch_mutualFundTransactions}=    Convert String to JSON    ${json_MFOA_Switch_mutualFundTransactions}
        IF    '${switch_type}'=='AMOUNT'
            ${amount}=    Set Variable    ${min_redempt_amounts}
            ${unit}=    Set Variable    ${null}
            Set To Dictionary    ${json_MFOA_Switch_mutualFundTransactions}[0]     amount=${amount}
            Set To Dictionary    ${json_MFOA_Switch_mutualFundTransactions}[0]     unit=${unit}
        ELSE IF    '${switch_type}'=='UNIT'
            ${amount}=    Set Variable    ${null}
            ${unit}=    Set Variable    ${min_unit}
            Set To Dictionary    ${json_MFOA_Switch_mutualFundTransactions}[0]     switchOption=UNIT
            
        END
        Set To Dictionary    ${json_MFOA_Switch_mutualFundTransactions}[0]     amount=${amount}
        Set To Dictionary    ${json_MFOA_Switch_mutualFundTransactions}[0]     unit=${unit}


        Set To Dictionary    ${json_data['productInfo']}     mutualFundTransactions=${json_MFOA_Switch_mutualFundTransactions}
    END
    

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json    

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200

Fund Status
    ${URI_MFOA_FUND_STATUS}    Replace String    ${URI_MFOA_FUND_STATUS}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_MFOA_FUND_STATUS}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    fund_status    ${url}
    ${response}=    POST On Session     fund_status       ${uri}     headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    Fund Response: ${json}

Check Result MFOA
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}


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
        ${flow_status}=    Run Keyword And Return Status    Should Be Equal As Strings    ${json["flow"]}    mfoa

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
    
    ${kcifInfo}    Set Variable    ${json["productInfo"]["kcifInfo"]}

    Dictionary Should Contain Key    ${kcifInfo}    requestRefId
    Dictionary Should Contain Key    ${kcifInfo}    kcifNo
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
    Dictionary Should Contain Key    ${kcifInfo}    workPositionDescription
    Dictionary Should Contain Key    ${kcifInfo}    currentAddress
    Dictionary Should Contain Key    ${kcifInfo}    currentSubDistrict
    Dictionary Should Contain Key    ${kcifInfo}    currentDistrict
    Dictionary Should Contain Key    ${kcifInfo}    currentProvince
    Dictionary Should Contain Key    ${kcifInfo}    currentPostalCode
    Dictionary Should Contain Key    ${kcifInfo}    currentUniqueId
    Dictionary Should Contain Key    ${kcifInfo}    currentCountryCode
    Dictionary Should Contain Key    ${kcifInfo}    occupationCode
    # Dictionary Should Contain Key    ${kcifInfo}    occupationDescription
    Dictionary Should Contain Key    ${kcifInfo}    businessTypeCode
    # Dictionary Should Contain Key    ${kcifInfo}    businessTypeDescription
    Dictionary Should Contain Key    ${kcifInfo}    incomeCode
    Dictionary Should Contain Key    ${kcifInfo}    sourceOfMoneyRevenueCode
    Dictionary Should Contain Key    ${kcifInfo}    typeOfIncomeCode
    # Dictionary Should Contain Key    ${kcifInfo}    typeOfIncomeDescription
    Dictionary Should Contain Key    ${kcifInfo}    investmentObjectiveCode
    # Dictionary Should Contain Key    ${kcifInfo}    investmentObjectiveDescription
    Dictionary Should Contain Key    ${kcifInfo}    copyFromCi
    Dictionary Should Contain Key    ${kcifInfo}    nameChanged
    Dictionary Should Contain Key    ${kcifInfo}    infoChanged
    Dictionary Should Contain Item    ${kcifInfo}    result    value=SUCCESS
    Dictionary Should Contain Key    ${kcifInfo}    submitResult
    Dictionary Should Contain Key    ${kcifInfo}    sync
    # Dictionary Should Contain Key    ${kcifInfo}    isPolitician

    ### mutualFundTransactions
    Dictionary Should Contain Key    ${json["productInfo"]}    mutualFundTransactions
    ${mutualFundTransactions_lenght}    Get Length    ${json["productInfo"]["mutualFundTransactions"]}
    FOR    ${i}    IN RANGE   0    ${mutualFundTransactions_lenght}
        IF  '${transactionType}'=='buy'
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    productId
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    productTypeCode
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    productCode
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    productTypeId
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    productName
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    productBusinessCode
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    paymentMethod
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    paymentAccountNumber
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    passbookSerialNumber
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    passbookBalance
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    paymentInfo
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    referCode
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    referBranchCode
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    amount
            ${paymentInfo}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["paymentInfo"]}
            Dictionary Should Contain Item    ${paymentInfo}    cancelled    ${FALSE}
            Dictionary Should Contain Item    ${paymentInfo}    src          ${0}
            Dictionary Should Contain Item    ${paymentInfo}    prc          ${0}
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    authorizeSigners
            ${authorizeSigners}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["authorizeSigners"]}
            FOR    ${signer}    IN    @{authorizeSigners}
                Dictionary Should Contain Key    ${signer}    cardType
                Dictionary Should Contain Key    ${signer}    cardNumber
                Dictionary Should Contain Key    ${signer}    engFirstName
                Dictionary Should Contain Key    ${signer}    engLastName
                Dictionary Should Contain Key    ${signer}    engMiddleName
                Dictionary Should Contain Key    ${signer}    engTitle
                Dictionary Should Contain Key    ${signer}    thaiFirstName
                Dictionary Should Contain Key    ${signer}    thaiLastName
                Dictionary Should Contain Key    ${signer}    thaiMiddleName
                Dictionary Should Contain Key    ${signer}    thaiTitle
                Dictionary Should Contain Item    ${signer}    manualKeyIn      ${FALSE}
                Dictionary Should Contain Item    ${signer}    foreigner       ${FALSE}
                Dictionary Should Contain Item    ${signer}    lifeTimeCard    ${FALSE}
            END
        ELSE IF    '${transactionType}'=='sell' and '${sell_type}'=='AMOUNT'
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    amount
        ELSE IF    '${transactionType}'=='sell' and '${sell_type}'=='UNIT'
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    unit
        ELSE IF    '${transactionType}'=='switch' and '${switch_type}'=='AMOUNT'
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    amount
        ELSE IF    '${transactionType}'=='switch' and '${switch_type}'=='UNIT'
            Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    unit
        END
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    appId
        Dictionary Should Contain Item    ${json["productInfo"]["mutualFundTransactions"][${i}]}    result    value=SUCCESS
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    mutualFundDetail
        IF    ${i}==0
            IF  '${scheduleDate}'!=''
                # Dictionary Should Contain Item    ${json["productInfo"]["mutualFundTransactions"][0]}    future    True
                ${futureTransaction}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["futureTransaction"]}
                Dictionary Should Contain Item    ${futureTransaction}    scheduleType    FUTURE
                Dictionary Should Contain Item    ${futureTransaction}    scheduleDate    ${scheduleDate}
                Dictionary Should Contain Key    ${futureTransaction}    recurringDate
            ELSE IF    '${recur_start}'!='' and '${recur_end}'!='' and '${recurringDate}'!=''
                ${futureTransaction}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["futureTransaction"]}
                Dictionary Should Contain Item    ${futureTransaction}                        scheduleType    RECURRING
                Dictionary Should Contain Key     ${futureTransaction}                        scheduleDate    
                Should Be Equal As Strings        ${futureTransaction["recurringDate"]}       ${recurringDate}
                Dictionary Should Contain Item    ${futureTransaction}                        scheduleEndPeriod      ${recur_end}
                Dictionary Should Contain Item    ${futureTransaction}                        scheduleStartPeriod    ${recur_start}
            END
        ELSE
            IF  '${scheduleDate2}'!=''
                # Dictionary Should Contain Item    ${json["productInfo"]["mutualFundTransactions"][0]}    future    True
                ${futureTransaction}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["futureTransaction"]}
                Dictionary Should Contain Item    ${futureTransaction}    scheduleType    FUTURE
                Dictionary Should Contain Item    ${futureTransaction}    scheduleDate    ${scheduleDate2}
                Dictionary Should Contain Key    ${futureTransaction}    recurringDate
            ELSE IF    '${recur_start2}'!='' and '${recur_end2}'!='' and '${recurringDate2}'!=''
                ${futureTransaction}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["futureTransaction"]}
                Dictionary Should Contain Item    ${futureTransaction}                        scheduleType    RECURRING
                Dictionary Should Contain Key     ${futureTransaction}                        scheduleDate    
                Should Be Equal As Strings        ${futureTransaction["recurringDate"]}       ${recurringDate2}
                Dictionary Should Contain Item    ${futureTransaction}                        scheduleEndPeriod      ${recur_end2}
                Dictionary Should Contain Item    ${futureTransaction}                        scheduleStartPeriod    ${recur_start2}
            END
        END
        ${mutualFundDetail}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["mutualFundDetail"]}
        Dictionary Should Contain Key    ${mutualFundDetail}    fundCode
        Dictionary Should Contain Key    ${mutualFundDetail}    fundType
        Dictionary Should Contain Key    ${mutualFundDetail}    fundNameEn
        Dictionary Should Contain Key    ${mutualFundDetail}    fundNameTh
        Dictionary Should Contain Key    ${mutualFundDetail}    fundCategory
        Dictionary Should Contain Key    ${mutualFundDetail}    amcCode
        Dictionary Should Contain Key    ${mutualFundDetail}    riskLevel
        Dictionary Should Contain Key    ${mutualFundDetail}    asOfDate
        Dictionary Should Contain Key    ${mutualFundDetail}    endDateTime
        Dictionary Should Contain Key    ${mutualFundDetail}    ipoFund
        Dictionary Should Contain Key    ${mutualFundDetail}    tacticalFund
        Dictionary Should Contain Key    ${mutualFundDetail}    popularFund
        Dictionary Should Contain Key    ${mutualFundDetail}    foreignFund
        Dictionary Should Contain Key    ${mutualFundDetail}    complexFund
        Dictionary Should Contain Key    ${mutualFundDetail}    descriptionTH
        Dictionary Should Contain Key    ${mutualFundDetail}    descriptionEN
        Dictionary Should Contain Key    ${mutualFundDetail}    fundFactSheetTh
        Dictionary Should Contain Key    ${mutualFundDetail}    fundPerformanceTh
        Dictionary Should Contain Key    ${mutualFundDetail}    position
        Dictionary Should Contain Key    ${mutualFundDetail}    categoryCode
        Dictionary Should Contain Key    ${mutualFundDetail}    cioTaxTypeCode
        Dictionary Should Contain Key    ${mutualFundDetail}    transactionMadeAllowFlag
        Dictionary Should Contain Key    ${mutualFundDetail}    buyChannel
        Dictionary Should Contain Key    ${mutualFundDetail}    subscriptionPeriodFlag
        Dictionary Should Contain Key    ${mutualFundDetail}    switchInChannel
        Dictionary Should Contain Key    ${mutualFundDetail}    switchInPeriodFlag
        Dictionary Should Contain Key    ${mutualFundDetail}    sellChannel
        Dictionary Should Contain Key    ${mutualFundDetail}    redemptionPeriodFlag
        Dictionary Should Contain Key    ${mutualFundDetail}    switchOutChannel
        Dictionary Should Contain Key    ${mutualFundDetail}    switchOutPeriodFlag
        Dictionary Should Contain Key    ${mutualFundDetail}    switchPreOrderDay
        Dictionary Should Contain Key    ${mutualFundDetail}    redemptionPreOrderDay
        Dictionary Should Contain Key    ${mutualFundDetail}    subscriptionPreOrderDay
        Dictionary Should Contain Key    ${mutualFundDetail}    buyTradeType
        Dictionary Should Contain Key    ${mutualFundDetail}    sellTradeType
        Dictionary Should Contain Key    ${mutualFundDetail}    switchInTradeType
        Dictionary Should Contain Key    ${mutualFundDetail}    switchOutTradeType
        Dictionary Should Contain Key    ${mutualFundDetail}    nav
        Dictionary Should Contain Key    ${mutualFundDetail}    navAsOfDate
        Dictionary Should Contain Key    ${mutualFundDetail}    navChange
        Dictionary Should Contain Key    ${mutualFundDetail}    navChangePercent
        Dictionary Should Contain Key    ${mutualFundDetail}    fundNavList
        ${fundNavList}=    Set Variable    ${mutualFundDetail}[fundNavList]
        FOR    ${navItem}    IN    @{fundNavList}
            Dictionary Should Contain Key    ${navItem}    period
            # Dictionary Should Contain Key    ${navItem}    navChange
            # Dictionary Should Contain Key    ${navItem}    navChangePercent
        END
        Dictionary Should Contain Key    ${mutualFundDetail}    assetValue
        Dictionary Should Contain Key    ${mutualFundDetail}    fxRisk
        Dictionary Should Contain Key    ${mutualFundDetail}    fundDividend
        Dictionary Should Contain Key    ${mutualFundDetail}    fundHealthInsurance
        Dictionary Should Contain Key    ${mutualFundDetail}    subscriptionCutOffTime
        Dictionary Should Contain Key    ${mutualFundDetail}    redemptionCutOffTime
        Dictionary Should Contain Key    ${mutualFundDetail}    minFirstSubAmount
        Dictionary Should Contain Key    ${mutualFundDetail}    minNexSubAmount
        Dictionary Should Contain Key    ${mutualFundDetail}    minRedemptionAmount
        Dictionary Should Contain Key    ${mutualFundDetail}    minRedemptionUnit
        Dictionary Should Contain Key    ${mutualFundDetail}    minRemainingAmount
        Dictionary Should Contain Key    ${mutualFundDetail}    minRemainingUnit
        Dictionary Should Contain Key    ${mutualFundDetail}    redemptionSettlementDay
        Dictionary Should Contain Key    ${mutualFundDetail}    fundFees

        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    requestRefId
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    accountId
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    unitHolderId
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    transactionType
        Dictionary Should Contain Item    ${json["productInfo"]["mutualFundTransactions"][${i}]}    submitResult    value=SUCCESS
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    future
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    taxFundConsent
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    signatureConsent
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    acceptRedemptCreditFee
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    acceptRedemptOverLimit
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    acceptRmfAgeLimit
        Dictionary Should Contain Key    ${json["productInfo"]["mutualFundTransactions"][${i}]}    transactionDetail
        ${transactionDetail}    Set Variable    ${json["productInfo"]["mutualFundTransactions"][${i}]["transactionDetail"]}
        Dictionary Should Contain Key    ${transactionDetail}    estimatedRemainingAmount
        Dictionary Should Contain Key    ${transactionDetail}    estimatedRemainingUnit
        Dictionary Should Contain Key    ${transactionDetail}    fundHoliday
        IF  '${transactionType}'=='buy'
            Dictionary Should Contain Key    ${transactionDetail}    nextFundHoliday
        END
        
        IF    ${i}==0
            IF  '${scheduleDate}'=='' and '${recur_start}'==''
                Dictionary Should Contain Key    ${transactionDetail}    allotmentDate
                Dictionary Should Contain Key    ${transactionDetail}    effectiveDate
                # Dictionary Should Contain Key    ${transactionDetail}    transactionDateTime
                Dictionary Should Contain Key    ${transactionDetail}    transactionId
            END
        ELSE
            IF  '${scheduleDate2}'=='' and '${recur_start2}'==''
                Dictionary Should Contain Key    ${transactionDetail}    allotmentDate
                Dictionary Should Contain Key    ${transactionDetail}    effectiveDate
                # Dictionary Should Contain Key    ${transactionDetail}    transactionDateTime
                Dictionary Should Contain Key    ${transactionDetail}    transactionId
            END
        END
        Dictionary Should Contain Key    ${transactionDetail}    requiredConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredOverRiskConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredExchangeRateConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredForeignRiskConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredConcentrationRiskConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredAccreditedInvestorRiskConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredTaxDeductibleConsent
        Dictionary Should Contain Key    ${transactionDetail}    isRequiredComplexFundConsent
        Dictionary Should Contain Key    ${transactionDetail}    isFirstSubscription
    
    END

Get Report MFOA
    [Arguments]    ${productCode}
    # สินเชื่อปลอดภัย > HL000005
    # สินเชื่อมีสุข > CESOKTBLT
    # สินเชื่อสบายใจ > CESOKTBLP
    # สินเชื่อหายห่วง > PAL00050
    Sleep    10s
    Set pdf file path to variable    MFOA
    ${current_date}=    Get Current Date    result_format=%Y%m%d

    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    /ktb/rest/esolution/v1/case/report/mfoa-submission?fromDate=${current_date}&toDate=${current_date}&requestStatus=ALL&product=ALL&productCode=${productCode}
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
    ...    View PDF Report
    ...    ELSE
    ...    FAIL    ❌ ไม่พบคำ "${CASE_ID}" ใน PDF

