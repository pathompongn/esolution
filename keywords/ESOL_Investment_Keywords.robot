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
VC_FORM
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/${CASE_ID}/appform/VC_FORM
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    get_bond_product    ${url}
    ${response}=    GET On Session     get_bond_product       ${uri}     headers=${headers}
    Log    ${response.status_code}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    
Get Product Bond stockCodeList
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_GET_BOND_PRODUCT}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    get_bond_product    ${url}
    ${response}=    GET On Session     get_bond_product       ${uri}     headers=${headers}
    Log    ${response.status_code}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${json}=    Convert String to JSON    ${response.content}
    ${found}    Set Variable    ${False}
    FOR    ${item}    IN    @{json}
        IF    '${item}[symbol]' == '${symbol}'
            ${stockCodeList}    Set Variable    ${item}[stockCodeList]
            Dictionary Should Contain Key    ${item}    minUnit
            Dictionary Should Contain Key    ${item}    valPerShare
            # ${minAmount}    Evaluate    format(float(${item['minUnit']}) * float(${item['valPerShare']}), ".2f")
            ${minAmount}=    Evaluate    int(float(${item['minUnit']}) * float(${item['valPerShare']}))
            Set Test Variable    ${minAmount}   
            Set Test Variable    ${minUnit}    ${item["minUnit"]}
            Set Test Variable    ${stockCodeList}
            ${found}    Set Variable    ${True}
            Exit For Loop
        END
    END
    Run Keyword If    not ${found}    Fail    Not Found For Symbol: ${symbol}
        

Product Instrument Detail
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_GET_BOND_INSTRUMENT_DETAIL}
    Log    url = ${url}${uri}
    
    Create Session    instrument_detail    ${url}
    &{json_data}=    Create Dictionary
    ...    stockCodeList=${stockCodeList}
    ...    symbol=${symbol}
   
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
   
    ${response}    POST On Session  instrument_detail  ${uri}  headers=${headers}    json=${json_data}  expected_status=any    
 
    Log    ${response.status_code}
    Log    ${response.text}
    
    Should Be Equal As Strings    ${response.status_code}        200
    # ${test}=    Convert String to JSON    ${response.text}
    ${maturityYear}=    Evaluate    datetime.datetime.now().year    modules=datetime
    ${maturityYear}    Evaluate    ${maturityYear}+543
    Set Test Variable    ${maturityYear}
    Set Test Variable    ${data_for_retrieve}    ${response.text}

MCTool OTP Bond
    [Arguments]    ${event}=OTP
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/mctool
    Log    url = ${url}${uri}
    
    Create Session    mctool_otp_bond    ${url}
    ${product_info}=    Create Dictionary    productTypeId=${ProductTypeId}    productId=${ProductID}
    @{mcToolProductInfos}=    Create List    ${product_info}
    &{json_data}=    Create Dictionary
    ...    event=${event}
    ...    caseId=${CASE_ID}
    ...    refNo=${MC_TOOL_REFNO}
    ...    mcToolProductInfos=${mcToolProductInfos}
   
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
   
    ${response}    POST On Session  mctool_otp_bond  ${uri}  headers=${headers}    json=${json_data}
 
    Log    ${response.status_code}
    Log    ${response.text}
    
    Should Be Equal As Strings    ${response.status_code}        200
    # ${json}=    Convert String to JSON    ${response.content}
    # Dictionary Should Contain Item    ${json}    refNo    ${MC_TOOL_REFNO}
    # Dictionary Should Contain Item    ${json}    event    OTP

Update RA
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/bond/${CASE_ID}/assessment/update/RA
    Log    url = ${url}${uri}
    
    Create Session    update_ra    ${url}
    &{json_data}=    Create Dictionary
    ...    derivativeRiskConsent=N
    ...    foreignRiskConsent=N
    ...    overRiskConsent=Y
   
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
   
    ${response}    POST On Session  update_ra  ${uri}  headers=${headers}    json=${json_data}
 
    Log    ${response.status_code}
    Log    ${response.text}
    
    Should Be Equal As Strings    ${response.status_code}        200

Varidate Quota Product
    ${URI_VARIDATE_QUOTA_PRODUCT}    Replace String    ${URI_VARIDATE_QUOTA_PRODUCT}    caseId    ${CASE_ID}
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_VARIDATE_QUOTA_PRODUCT}
    Log    url = ${url}${uri}
    
    Create Session    validate_quota_product    ${url}
    &{json_data}=    Create Dictionary
    ...    stockCodeList=${stockCodeList}
    ...    symbol=${symbol}
   
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
   
    ${response}    POST On Session  validate_quota_product  ${uri}  headers=${headers}    json=${json_data}
 
    Log    ${response.status_code}
    Log    ${response.text}
    
    Should Be Equal As Strings    ${response.status_code}        200

    ${json_response}=    Convert String to JSON    ${response.content}
    FOR    ${item}    IN    @{json_response}
        ${result}=    Get From Dictionary    ${item}    result
        ${type}=      Get From Dictionary    ${item}    type
        # Should Be True    '${result}' in ['SUCCESS', 'ALLOW']    Result was '${result}', but expected 'SUCCESS' or 'ALLOW'.
    END

Retrieve Get Case ID Investment PMB
    #retrieve_case
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_CASE_RETRIEVE}
    Log    url = ${url}${uri}

    # ${data}=    Evaluate     {"cardInfo":${CARD_INFO},"channel":"android","flow":"insurance","sellerInfo":{"firstName":"ผุสพร","lastName":"ปุสสเด็จ","position":"รองผู้จัดการธุรกิจการขาย","userGroup":"CSSM","licenses":[{"licenseType":"ICC2","licenseNo":"056711","licenseExp":"20261231","errorFlag":${False},"expired":${False}},{"licenseType":"LF","licenseNo":"5203017345","licenseExp":"20261028","errorFlag":${False},"expired":${False}},{"licenseType":"NON LIFE","licenseNo":"5204021477","licenseExp":"20261028","errorFlag":${False},"expired":${False}}]},"subFlow":"","data":{},"draftedCaseId":"","skipIntroduction":${False},"mcToolRefNo":"${MC_TOOL_REFNO}","opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":${False},"vcLimitationTypes":[]},"vcSelectedProducts":["${ProductID}"]}}    json
    # ${data}=    Evaluate     {"cardInfo":${CARD_INFO},"channel":"android","flow":"pmb","sellerInfo":{"firstName":"${FirstNameEmployee}","lastName":"${LastNameEmployee}","position":"${POSITION}","userGroup":"${RoleClassCode}","licenses":${LICENSES}},"subFlow":"","data":{},"draftedCaseId":"","skipIntroduction":${False},"mcToolRefNo":"${MC_TOOL_REFNO}","opportunityLogRefNo":"${OPPORTUNITY_LOG_REFNO}","selectedProductInfos":[{"data":${data_for_retrieve},"productCode":"${ProductCode}","productId":"${ProductID}","productTypeCode":"${ProductTypeCode}}]","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":${False},"vcLimitationTypes":[]},"vcSelectedProducts":["${ProductID}"]}}    json
    # log    ${data}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/pmb_retrieve_body.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}    ${False}
    ${data}=    Convert String to JSON    ${json_text_replaced}

    ${maturityYear}=    Convert To String    ${maturityYear}
    Set To Dictionary    ${data}[selectedProductInfos][0][data]     maturityYear=${maturityYear}
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${ACCESS_TOKEN}

    Create Session    Retrieve_CaseID    ${url}
    ${response}=    POST On Session    Retrieve_CaseID    ${uri}    json=${data}    headers=${headers}
    Log    ${response.status_code}
    Log    ${response.content}
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

    Set Test Variable    ${CASE_ID}          ${json["caseId"]}
    Set Test Variable    ${WS_REF_ID}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["inquiryCIFDetailRespHeader"]["wsRefId"]}
    Set Test Variable    ${SELECT_PRODUCT}   ${json["vcInfo"]["vcSelectedProducts"][0]}
    Set Test Variable    ${AGE_CUSTOMER}     ${json["customerInfo"]["personalInfos"][0]["age"]}
    Set Test Variable    ${PHONT_OLD}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["mobilePhone"]}
    Set Test Variable    ${EMAIL_OLD}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["emailAddr"]}
    Set Test Variable    ${POSTAL_CODE}        ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["legalPostalCd"]}
    
    Set To Dictionary    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}      emailAddr=${Email}
    Set To Dictionary    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}      mobilePhone=${OTP_Tel}
    ${cbsInfo}    Convert To String    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}
    ${cbsInfo}    Replace String    ${cbsInfo}    '    "
    ${cbsInfo}=    Replace String    ${cbsInfo}    True    true
    ${cbsInfo}=    Replace String    ${cbsInfo}    False    false
    
    Set Test Variable    ${CBS_INFO}         ${cbsInfo}

    ${customerConsent}    Convert To String    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["customerConsent"]}
    ${customerConsent}    Replace String    ${customerConsent}    '    "
    ${customerConsent}=    Replace String    ${customerConsent}    True    true
    ${customerConsent}=    Replace String    ${customerConsent}    False    false
    Set Test Variable    ${CUSTOMER_CONSENT}    ${customerConsent}

    ${additionalInfo}    Convert To String    ${json["additionalInfo"]}
    ${additionalInfo}    Replace String    ${additionalInfo}    '    "
    ${additionalInfo}=    Replace String    ${additionalInfo}    True    true
    ${additionalInfo}=    Replace String    ${additionalInfo}    False    false
    Set Test Variable    ${ADD_INFO}         ${additionalInfo}

    ${mortgageRetentions}    Convert To String    ${json["portfolioInfo"]["mortgageRetentions"]}
    ${mortgageRetentions}    Replace String    ${mortgageRetentions}    '    "
    ${mortgageRetentions}=    Replace String    ${mortgageRetentions}    True    true
    ${mortgageRetentions}=    Replace String    ${mortgageRetentions}    False    false
    Set Test Variable    ${RETENTION}        ${mortgageRetentions}

Retrieve Continue PMB
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/continue
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    Retrieve_Continue    ${url}
    ${response}=    POST On Session  Retrieve_Continue  ${uri}    headers=${headers}
    Log    ${response.status_code}
    Log    ${response.content}
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
            IF    '${deposits}[${index}][productGroup]' == 'SAV' and '${deposits}[${index}][accountStatus]' == '0' and ${deposits}[${index}][availBalAmt] > ${minAmount}
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

Update PMB Information Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=CustomerInformation&option=draft
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Put_Consent_PMB.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}    ${False}
    ${json_data}=    Convert String to JSON    ${json_text_replaced}
    ${maturityYear}=    Convert To String    ${maturityYear}
    Set To Dictionary    ${json_data}[productInfo][pmbTransactions][0][stockInfo]     maturityYear=${maturityYear}
    ${vcThirdPersonInfo}    Create Dictionary
    Set To Dictionary    ${json_data}[vcInfo]     vcThirdPersonInfo=${vcThirdPersonInfo}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json    

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200

Update Phone number And Email
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=CustomerInformation&option=draft
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/update_phone.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}    ${False}
    ${data}=    Convert String to JSON    ${json_text_replaced}
    
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json  

    Create Session    update_case_tel    ${url}
    ${response}=    PUT On Session    update_case_tel    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200
    #Should Be Equal As Strings    ${response.content.decode("utf-8")}    None
    Sleep    2s
    Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}

Verify KYC PMB
    #kyc
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/kyc
    Log    url = ${url}${uri}

    ${data}=    Evaluate    [{"beneficiary":False,"cardNumber":"${MOCK_CardNumber}","isInvolvingForeignPoliticianFlag":"2","isInvolvingPoliticianFlag":"2","nationality":"TH","occupationCode":"900001","thaiFirstName":"${MOCK_ThaiFirstName}","thaiLastName":"${MOCK_ThaiLastName}","thaiMiddleName":"","thaiTitle":"${MOCK_ThaiTitle}"}]    json
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session   verify_kyc    ${url}
    ${response}=    POST On Session    verify_kyc    ${uri}     headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    log    ${response.content}
    
    ${Result}=    Convert To String    1
    
    Dictionary Should Contain Key     ${json}    type
    Dictionary Should Contain Key     ${json}    date
    Dictionary Should Contain Key     ${json}    data
    Dictionary Should Contain Key     ${json["data"]}    kycResult
    Dictionary Should Contain item    ${json["data"]["kycResult"][0]}    result    ${Result}
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    date
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    scoring
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    amlStatus
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    amlSubListType
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    originalCode
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    originalMessage

Submission Information PMB
    #submission
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/bond/${CASE_ID}/submission/start
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    
    Create Session    submission_Info    ${url}
    ${response}    POST On Session  submission_Info  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    log    ${response.content}

    Dictionary Should Contain Key     ${json[0]}    submissionStepTrackingId
    Dictionary Should Contain item    ${json[0]}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json[0]}    appId
    Dictionary Should Contain Key     ${json[0]}    pluginName
    Dictionary Should Contain Key     ${json[0]}    status
    Dictionary Should Contain Key     ${json[0]}    cardNumber
    Dictionary Should Contain Key     ${json[0]}    documentId
    Dictionary Should Contain Key     ${json[0]}    ticks
    Dictionary Should Contain Key     ${json[0]}    retryCount
    Dictionary Should Contain Key     ${json[0]}    createdDateTime
    Dictionary Should Contain Key     ${json[0]}    createdBy
    Dictionary Should Contain Key     ${json[0]}    branchIdCreated
    Dictionary Should Contain Key     ${json[0]}    level
    Dictionary Should Contain Key     ${json[0]}    hardStop
    Dictionary Should Contain Key     ${json[0]}    group

    ${json_string}=    Set Variable    ${response.content}
    ${json_list}=    Evaluate    json.loads($json_string)    json


Check Result PMB
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
    
    Dictionary Should Contain Key    ${json["productInfo"]}    pmbTransactions
    ${pmbTransactions_lenght}    Get Length    ${json["productInfo"]["pmbTransactions"]}
    FOR    ${i}    IN RANGE   0    ${pmbTransactions_lenght}
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    productId
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    productTypeCode
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    productCode
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    productTypeId
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    productName
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    productBusinessCode
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    appId
        ${stockInfo}    Set Variable    ${json["productInfo"]["pmbTransactions"][${i}]["stockInfo"]}
        Dictionary Should Contain Key    ${stockInfo}    symbol
        Dictionary Should Contain Key    ${stockInfo}    securityNameTH
        Dictionary Should Contain Key    ${stockInfo}    securityNameEN
        Dictionary Should Contain Key    ${stockInfo}    finalStartDate
        Dictionary Should Contain Key    ${stockInfo}    finalStopDate
        Dictionary Should Contain Key    ${stockInfo}    finalStartTime
        Dictionary Should Contain Key    ${stockInfo}    stockCodeList

        ${stockCodeLists}    Set Variable    ${stockInfo["stockCodeList"]}
        FOR    ${stockCodeList}    IN    @{stockCodeLists}
            Dictionary Should Contain Key    ${stockCodeList}    stcode
            Dictionary Should Contain Key    ${stockCodeList}    stCodeType
            Dictionary Should Contain Key    ${stockCodeList}    startDate
            Dictionary Should Contain Key    ${stockCodeList}    stopDate
            Dictionary Should Contain Key    ${stockCodeList}    startTime
            Dictionary Should Contain Key    ${stockCodeList}    stopTime
            Dictionary Should Contain Key    ${stockCodeList}    setFlg
            Dictionary Should Contain Key    ${stockCodeList}    overTime
        END
        Dictionary Should Contain Key    ${stockInfo}    pdAccount
        Dictionary Should Contain Key    ${stockInfo}    checkRichFlg
        Dictionary Should Contain Key    ${stockInfo}    riskRate
        Dictionary Should Contain Key    ${stockInfo}    minAge
        Dictionary Should Contain Key    ${stockInfo}    minUnit
        Dictionary Should Contain Key    ${stockInfo}    maxUnit
        Dictionary Should Contain Key    ${stockInfo}    incUnit
        Dictionary Should Contain Key    ${stockInfo}    valPerShare
        Dictionary Should Contain Key    ${stockInfo}    ageFlg
        Dictionary Should Contain Key    ${stockInfo}    checkRefRight
        Dictionary Should Contain Key    ${stockInfo}    dbaccFlg
        Dictionary Should Contain Key    ${stockInfo}    excFlg
        Dictionary Should Contain Key    ${stockInfo}    inqRightFlg
        Dictionary Should Contain Key    ${stockInfo}    qbrFlg
        Dictionary Should Contain Key    ${stockInfo}    redAmtFlg
        Dictionary Should Contain Key    ${stockInfo}    riskFlg
        Dictionary Should Contain Key    ${stockInfo}    scanFlg
        Dictionary Should Contain Key    ${stockInfo}    setFlg
        Dictionary Should Contain Key    ${stockInfo}    spicFlg
        Dictionary Should Contain Key    ${stockInfo}    unitFlg
        Dictionary Should Contain Key    ${stockInfo}    dupFlg
        Dictionary Should Contain Key    ${stockInfo}    ageStartDate
        Dictionary Should Contain Key    ${stockInfo}    ageEndDate
        Dictionary Should Contain Key    ${stockInfo}    limitFlag
        Dictionary Should Contain Key    ${stockInfo}    currency
        Dictionary Should Contain Key    ${stockInfo}    chkrlFlg
        Dictionary Should Contain Key    ${stockInfo}    scripOnlyFlg
        Dictionary Should Contain Key    ${stockInfo}    invType
        Dictionary Should Contain Key    ${stockInfo}    agencyCode
        Dictionary Should Contain Key    ${stockInfo}    rating
        ${courses}    Set Variable    ${stockInfo["courses"]}
        FOR    ${course}    IN    @{courses}
            Dictionary Should Contain Key    ${course}    courseId
            Dictionary Should Contain Key    ${course}    validityStartDate
        END 
        Dictionary Should Contain Key    ${stockInfo}    secProductType
        Dictionary Should Contain Key    ${stockInfo}    totalIntReceiveAcct
        ${interestReceiveAccts}    Set Variable    ${stockInfo["interestReceiveAccts"]}
        FOR    ${interestReceiveAcct}    IN    @{interestReceiveAccts}
            Dictionary Should Contain Key    ${interestReceiveAcct}    currencyIntReceiveAcct
            Dictionary Should Contain Key    ${interestReceiveAcct}    bankIntReceiveAcct
        END   
        Dictionary Should Contain Key    ${stockInfo}    dataSetInvestmentType
        Dictionary Should Contain Key    ${stockInfo}    dataSetTermRange
        Dictionary Should Contain Key    ${stockInfo}    isinCode
        Dictionary Should Contain Key    ${stockInfo}    securityType      
        Dictionary Should Contain Key    ${stockInfo}    securityCode
        Dictionary Should Contain Key    ${stockInfo}    subsPromoteDate
        Dictionary Should Contain Key    ${stockInfo}    issuerCode
        Dictionary Should Contain Key    ${stockInfo}    issuerNameTh
        Dictionary Should Contain Key    ${stockInfo}    dbtAge
        Dictionary Should Contain Key    ${stockInfo}    dbtInterestRate
        Dictionary Should Contain Key    ${stockInfo}    fxRisk
        Dictionary Should Contain Key    ${stockInfo}    issueDate
        Dictionary Should Contain Key    ${stockInfo}    maturityDate
        Dictionary Should Contain Key    ${stockInfo}    preCautionRequired
        Dictionary Should Contain Key    ${stockInfo}    riskRequired
        Dictionary Should Contain Key    ${stockInfo}    ptRequired
        Dictionary Should Contain Key    ${stockInfo}    kaRequired
        Dictionary Should Contain Key    ${stockInfo}    logoAssetCode
        Dictionary Should Contain Key    ${stockInfo}    walkInExceeded
        Dictionary Should Contain Key    ${stockInfo}    asOfDate
        Dictionary Should Contain Key    ${stockInfo}    documentList
        ${documentLists}    Set Variable    ${stockInfo["documentList"]}
        FOR    ${documentList}    IN    @{documentLists}
            Dictionary Should Contain Key    ${documentList}    docType
            Dictionary Should Contain Key    ${documentList}    fileName
            Dictionary Should Contain Key    ${documentList}    assetCode
            Dictionary Should Contain Key    ${documentList}    docName
        END 
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    amount
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    unit
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    sourceOfMoneyCode
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    sourceOfMoneyDesc
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    paymentMethod
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    paymentAccountNumber
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    receiveInterestAccounts
        ${receiveInterestAccounts}    Set Variable    ${json["productInfo"]["pmbTransactions"][${i}]["receiveInterestAccounts"]}
        FOR    ${receiveInterestAccount}    IN    @{receiveInterestAccounts}
            Dictionary Should Contain Key    ${receiveInterestAccount}    receiveInterestCurrency
            Dictionary Should Contain Key    ${receiveInterestAccount}    receiveInterestCurrency
            Dictionary Should Contain Key    ${receiveInterestAccount}    receiveInterestBankCd
        END 
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    receivingMethod
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    securityAccount
        Dictionary Should Contain Key    ${json["productInfo"]["pmbTransactions"][${i}]}    brokerCode
    END

Get Report PMB
    Sleep    10s
    Set pdf file path to variable   PMB
    ${current_date}=    Get Current Date    result_format=%Y%m%d

    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    /ktb/rest/esolution/v1/case/report/pmb-submission?fromDate=${current_date}&toDate=${current_date}&requestStatus=ALL&product=ALL
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
