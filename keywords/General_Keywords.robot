*** Settings ***
Library    	SeleniumLibrary
Library    	Collections
Library     BuiltIn
Library     RequestsLibrary
Library    	DateTime
Library    	String
Library 	ExcelLibrary
Library     AppiumLibrary
Variables   ${CURDIR}/../resources/config/mobile_config.yaml


*** Keywords ***
Read File Excel
    [Arguments]    ${File_Name}    ${Sheet_Name}
    Log    ${File_Name}|${Sheet_Name}
    Open Excel Document    ${File_Name}    TestCase
    @{colData}=    Read Excel Column    col_num=1    sheet_name=${Sheet_Name}
    ${maxRow}=    Get Length    ${colData}
    @{TEST_DATA}=    Create List
    @{REFERENCE_NO_RESULT}=    Create List

    FOR    ${index}    IN RANGE    1    ${maxRow} + 1
        @{currentData}=    Read Excel Row    row_num=${index}    sheet_name=${Sheet_Name}
        Exit For Loop If    '${currentData}[0]' == '${None}'
        Append To List    ${TEST_DATA}    ${currentData}
        Append To List    ${REFERENCE_NO_RESULT}    ${EMPTY}
    END

    Set Suite Variable    ${TEST_DATA}
    Set Suite Variable    ${REFERENCE_NO_RESULT}
    Close Current Excel Document

Get Test Data
    [Arguments]    ${Testcase_No}
    Log    ${TEST_DATA}[${Testcase_No}]
    FOR    ${index}    ${item}    IN ENUMERATE    @{TEST_DATA}[0]
        IF    '${item}' != 'Remarks'
            ${TEST_DATA}[${Testcase_No}][${index}]=    Set Variable If    '${TEST_DATA}[${Testcase_No}][${index}]' == '${None}'    ${EMPTY}    ${TEST_DATA}[${Testcase_No}][${index}]
            Set Suite Variable    ${${item}}    ${TEST_DATA}[${Testcase_No}][${index}]
        END
    END

Write File Excel
    #Ex. Write File Excel    eTax_Portal_Login    1    Reference_No    abcd
    [Arguments]    ${Sheet_Name}    ${Testcase_No}    ${Col_Name}    ${Value}
    @{Cols_Name_Header}=    Read Excel Row    row_num=1    sheet_name=${Sheet_Name}
    ${Current_Row}=    Evaluate    ${Testcase_No} + 1

    FOR    ${index}    ${item}    IN ENUMERATE    @{Cols_Name_Header}
        IF    '${item}' == '${Col_Name}'
            ${Current_Col}=    Evaluate    ${index} + 1
            Write Excel Cell    row_num=${Current_Row}    col_num=${Current_Col}     value=${Value}   sheet_name=${Sheet_Name}
            Exit For Loop
        END
    END

Save File Excel
    [Arguments]    ${File_Name}
    Save Excel Document    ${File_Name}

Close File Excel
    Close Current Excel Document

Close All File Excel Documents
    [Documentation]    Close all open documents before starting test case
    Run Keyword And Ignore Error    Close All Excel Documents

Cleansing string
    [Arguments]    ${text}    ${clean_space}=${True}
    IF    ${clean_space}
       ${text}=    Replace String    ${text}    ${SPACE}    ${EMPTY} 
    END
    # ${text}=    Replace String    ${text}    (    ${EMPTY}
    # ${text}=    Replace String    ${text}    )    ${EMPTY}
    ${text}=    Replace String    ${text}    \n    ${SPACE}
    ${text}=    Replace String    ${text}    \'  "
    ${text}=    Replace String    ${text}    True    true
    ${text}=    Replace String    ${text}    False    false
    ${text}=    Replace String    ${text}    None    null

    Return From Keyword    ${text}

Get Reference No To Result
    [Arguments]    ${Testcase_No}
    ${REFERENCE_NO_RESULT}[${Testcase_No}]=    Set Variable    ${Reference_No}

Write Reference No To Excel
    [Arguments]    ${File_Name}    ${Sheet_Name}
    @{arrPath}=    Split String    ${File_Name}    /
    @{arrFilename}=    Split String    ${arrPath}[-1]    .
	${dateToday}=    Get Current Date    result_format=%Y%m%d
    ${currentTime}=    Get Current Date    result_format=%H%M%S
    ${File_Name_Result}=    Set Variable    ${arrFilename}[0]_${dateToday}_${currentTime}_Result.${arrFilename}[1]
    Open Excel Document    ${File_Name}    TestCase
    ${REFERENCE_NO_RESULT}[0]=    Set Variable    Reference_No
    ${Col_Num}=    Get Index From List    ${TEST_DATA}[0]    Reference_No
    ${Col_Num}=    Evaluate    ${Col_Num} + 1
    Write Excel Column    col_num=${Col_Num}    col_data=${REFERENCE_NO_RESULT}    sheet_name=${Sheet_Name}
    Save File Excel    ${CURDIR}/../results/${File_Name_Result}
    Close Current Excel Document

Log Pretty Json Content
    [Arguments]    ${response}    ${isDebug}=True
    ${logResp}    Decode Bytes To String    ${response.content}    UTF-8
    Log    Response Data: ${logResp}
    Run Keyword If    ${isDebug}    Log    ResponseData >>> ${logResp}

Convert Format Date And Time At YYYY-MM-DDThh:mm:ss.milZ
    #วันที่ที่ระบุ Today, Today-1, Today+1, 2024-11-13 (format = YYYY-MM-DDThh:mm:ss.milZ | 2024-11-13T00:00:00.700Z)
    [Arguments]    ${strDate}
    ${strDate}=    Convert To Lower Case    ${strDate}
    IF    'today-' in '${strDate}' or 'today+' in '${strDate}'
        ${strDiffDay}=    Remove String    ${strDate}    today
        ${dateToday}=    Get Current Date
        ${currentDate}=    Add Time To Date    ${dateToday}    ${strDiffDay} days
    ELSE IF    '${strDate}' == 'today'
        ${currentDate}=    Get Current Date
    ELSE
        ${currentDate}=    Get Current Date
        @{strDateTime}=    Split String    ${currentDate}    ${SPACE}
        ${currentDate}=    Set Variable    ${strDate}${SPACE}${strDateTime}[1]
    END
    ${strCurrentDate}=    Replace String    ${currentDate}    ${SPACE}    T
    RETURN    ${strCurrentDate}Z

Convert Format Date At YYYY-MM-DD
    #วันที่ที่ระบุ Today, Today-1, Today+1, 2024-11-13 (format = YYYY-MM-DD | 2024-11-13)
    [Arguments]    ${strDate}
    ${strDate}=    Convert To Lower Case    ${strDate}
    IF    'today-' in '${strDate}' or 'today+' in '${strDate}'
        ${strDiffDay}=    Remove String    ${strDate}    today
        ${dateToday}=    Get Current Date    result_format=%Y-%m-%d
        ${currentDate}=    Add Time To Date    ${dateToday}    ${strDiffDay} days    result_format=%Y-%m-%d
    ELSE IF    '${strDate}' == 'today'
        ${currentDate}=    Get Current Date    result_format=%Y-%m-%d
    ELSE
        ${currentDate}=    Set Variable    ${strDate}
    END
    RETURN    ${currentDate}

Clean Log Warnings
    ${EMPTY}=    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

Generate MC Tool Reference No
    #generate_mctool_refno
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_GENERATE_MC_REFNO}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    Generate_MC    ${url}
    ${response}=    GET On Session    Generate_MC    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200

    Set Suite Variable    ${MC_TOOL_REFNO}    ${response.content}-1
    #Log    Text: ${MC_TOOL_REFNO}

Generate Opportunity Reference No
    #generate_opportunity_refno
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_GENERATE_OPP_REFNO}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    Generate_Opp    ${url}
    ${response}=    GET On Session    Generate_Opp    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200

    Set Suite Variable    ${OPPORTUNITY_LOG_REFNO}    ${response.content}-1

MC Tool Introduc
    #mctool_introduce
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_MC_TOOL}
    Log    url = ${url}${uri}

    ${data}=    Set variable    {"event": "INTRODUCE","refNo": "${MC_TOOL_REFNO}"}
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    MC_Introduc    ${url}
    ${response}=    POST On Session    MC_Introduc    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain item    ${json}    refNo    ${MC_TOOL_REFNO}
    Dictionary Should Contain Key     ${json}    event
    Dictionary Should Contain Key     ${json}    eventDateTime

Get Card ID Information
    #cardInfo
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_CARD_INFO}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session    Get_Card_Info    ${url}
    ${response}=    GET On Session    Get_Card_Info    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log     ${json}

    ${CARD_INFO_DATA}    Convert To String    ${json}
    ${CARD_INFO_DATA}    Replace String    ${CARD_INFO_DATA}    '    "
    Set Global Variable    ${CARD_INFO}       ${CARD_INFO_DATA}

    Dictionary Should Contain Key     ${json}    bp1No
    Dictionary Should Contain Key     ${json}    chipId
    Dictionary Should Contain Key     ${json}    thaiTitle
    Dictionary Should Contain Key     ${json}    thaiFirstName
    Dictionary Should Contain Key     ${json}    thaiMiddleName
    Dictionary Should Contain Key     ${json}    thaiLastName
    Dictionary Should Contain Key     ${json}    engTitle
    Dictionary Should Contain Key     ${json}    engFirstName
    Dictionary Should Contain Key     ${json}    engMiddleName
    Dictionary Should Contain Key     ${json}    engLastName
    Dictionary Should Contain Key     ${json}    dateOfBirth
    Dictionary Should Contain Key     ${json}    cardType
    Dictionary Should Contain Key     ${json}    cardNumber
    Dictionary Should Contain Key     ${json}    cardIssueDate
    Dictionary Should Contain Key     ${json}    cardIssuePlace
    Dictionary Should Contain Key     ${json}    cardExpiryDate
    #Dictionary Should Contain Key     ${json}    cardPhotoIssueNo
    Dictionary Should Contain Key     ${json}    sex
    Dictionary Should Contain Key     ${json}    address
    Dictionary Should Contain Key     ${json["address"]}    homeNo
    Dictionary Should Contain Key     ${json["address"]}    soi
    Dictionary Should Contain Key     ${json["address"]}    trok
    Dictionary Should Contain Key     ${json["address"]}    moo
    Dictionary Should Contain Key     ${json["address"]}    road
    Dictionary Should Contain Key     ${json["address"]}    subDistrict
    Dictionary Should Contain Key     ${json["address"]}    district
    Dictionary Should Contain Key     ${json["address"]}    province
    
    Set Suite Variable    ${MOCK_Address}    ${json["address"]}
    Set Suite Variable    ${MOCK_EngTitle}    ${json["engTitle"]}
    Set Suite Variable    ${MOCK_EngFirstName}    ${json["engFirstName"]}
    Set Suite Variable    ${MOCK_EengLastName}    ${json["engLastName"]}
    Set Suite Variable    ${MOCK_ThaiTitle}    ${json["thaiTitle"]}
    Set Suite Variable    ${MOCK_ThaiFirstName}    ${json["thaiFirstName"]}
    Set Suite Variable    ${MOCK_ThaiLastName}    ${json["thaiLastName"]}
    Set Suite Variable    ${MOCK_Address_HomeNo}    ${json["address"]["homeNo"]}
    Set Suite Variable    ${MOCK_Address_Soi}    ${json["address"]["soi"]}
    Set Suite Variable    ${MOCK_Address_Moo}    ${json["address"]["moo"]}
    Set Suite Variable    ${MOCK_Address_Road}    ${json["address"]["road"]}
    Set Suite Variable    ${MOCK_Address_SubDistrict}    ${json["address"]["subDistrict"]}
    Set Suite Variable    ${MOCK_Address_District}    ${json["address"]["district"]}
    Set Suite Variable    ${MOCK_Address_Province}    ${json["address"]["province"]}
    Set Suite Variable    ${MOCK_CardNumber}    ${json["cardNumber"]}
    Set Suite Variable    ${MOCK_CardExpiryDate}    ${json["cardExpiryDate"]}
    Set Suite Variable    ${MOCK_CardIssueDate}    ${json["cardIssueDate"]}
    Set Suite Variable    ${MOCK_CardIssuePlace}    ${json["cardIssuePlace"]}
    Set Suite Variable    ${MOCK_Sex}    ${json["sex"]}
    Set Suite Variable    ${MOCK_DateOfBirth}    ${json["dateOfBirth"]}
    Set Suite Variable    ${MOCK_Bp1No}    ${json["bp1No"]}
    Set Suite Variable    ${MOCK_ChipId}    ${json["chipId"]}
    # Set Suite Variable    ${MOCK_CardPhotoIssueNo}    ${json["cardPhotoIssueNo"]}

Retrieve Get Case ID
    #retrieve_case
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_CASE_RETRIEVE}
    Log    url = ${url}${uri}

    ${data}=    Evaluate    {"cardInfo": {"engTitle": "${MOCK_EngTitle}","engFirstName": "${MOCK_EngFirstName}","engMiddleName": "","engLastName": "${MOCK_EengLastName}","thaiTitle": "${MOCK_ThaiTitle}","thaiFirstName": "${MOCK_ThaiFirstName}","thaiMiddleName": "","thaiLastName": "${MOCK_ThaiLastName}","address": {"homeNo": "${MOCK_Address_HomeNo}","soi": "${MOCK_Address_Soi}","trok": "","moo": "","road": "${MOCK_Address_Road}","subDistrict": "แขวงพระบรมมหาราชวัง","district": "เขตพระนคร","province": "กรุงเทพมหานคร","postalCode": "10200"},"cardType": "Citizen ID","cardNumber": "${MOCK_CardNumber}","cardExpiryDate": "${MOCK_CardExpiryDate}","cardIssueDate": "${MOCK_CardIssueDate}","cardIssuePlace": "${MOCK_CardIssuePlace}","sex": "${MOCK_Sex}","dateOfBirth": "${MOCK_DateOfBirth}","bp1No": "${MOCK_Bp1No}","chipId": "${MOCK_ChipId}","customerType": "221","foreigner": False,"manualKeyIn": False},"channel": "android","flow": "deposit","sellerInfo": {"firstName": "กาญจนา","lastName": "น้อยชมภู","position": "เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","userGroup": "BRSUP","licenses": [{"licenseType": "ICC2","licenseNo": "062783","licenseExp": "20341231","errorFlag": False,"expired": False},{"licenseType": "LF","licenseNo": "5603007437","licenseExp": "20410623","errorFlag": False,"expired": False},{"licenseType": "NON LIFE","licenseNo": "5604011546","licenseExp": "20320623","errorFlag": False,"expired": False}]},"subFlow": "","data": {},"draftedCaseId": "","skipIntroduction": False,"mcToolRefNo": "${MC_TOOL_REFNO}","opportunityLogRefNo": "${OPPORTUNITY_LOG_REFNO}","vulnerableCustomerDetail":{"customerLimitation":{"isRequiredAssistance":False,"vcLimitationTypes":[]},"selectedProductInfos":[{"productId":"${Product_ID}","productCode":"${Product_Code}","productTypeCode":"${Product_Type_Code}"}],"vcSelectedProducts":["${ProductID}"]}}    json
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
    ${cbsInfo}    Convert To String    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]}
    ${cbsInfo}    Replace String    ${cbsInfo}    '    "
    ${cbsInfo}=    Replace String    ${cbsInfo}    True    true
    ${cbsInfo}=    Replace String    ${cbsInfo}    False    false
    ${customerConsent}    Convert To String    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["customerConsent"]}
    ${customerConsent}    Replace String    ${customerConsent}    '    "
    ${customerConsent}=    Replace String    ${customerConsent}    True    true
    ${customerConsent}=    Replace String    ${customerConsent}    False    false
    Set Test Variable    ${CUSTOMER_CONSENT}    ${customerConsent}
    Set Test Variable    ${CBS_INFO}         ${cbsInfo}
    Set Test Variable    ${flow}    ${json["flow"]}
    Set Test Variable    ${CASE_ID}    ${json["caseId"]}

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

Retrieve Continue
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
    ${additionalInfo}=    Set Variable    ${json["additionalInfo"]}
    Dictionary Should Contain Key     ${json}    portfolioInfo
    
    ${vcInfo}    Convert To String    ${json["vcInfo"]}
    ${vcInfo}    Replace String    ${vcInfo}    '    "
    ${vcInfo}=    Replace String    ${vcInfo}    True    true
    ${vcInfo}=    Replace String    ${vcInfo}    False    false
    Set Global Variable    ${VC_INFO}    ${vcInfo}

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
            IF    '${deposits}[${index}][productGroup]' == 'SAV' and '${deposits}[${index}][accountStatus]' == '0' # and ${deposits}[${index}][availBalAmt] > 2000
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

    Set Test Variable    ${CUSTOMER_CIF}    ${json["customerInfo"]["personalInfos"][0]["cifExistingData"]["customerNo"]}
    Set Test Variable    ${OLD_MOBILE_PHONE}    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["mobilePhone"]}
    Set Test Variable    ${OLD_EMAIL}    ${json["customerInfo"]["personalInfos"][0]["cifForm"]["cbsInfo"]["emailAddr"]}

Upload Documents Photo
    #doc_PHOTO
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_DOC}
    Log    url = ${url}${uri}
    
    ${file_path}    Set Variable    ${CURDIR}/../uploads/${Photo_File_Name}
    
    #${file_data}=    Get File For Streaming Upload    ${CURDIR}/../uploads/${Photo_File_Name}
    #Log    ${file_data}
    
    #${request_data}=    Convert To String    {"caseId": "${CASE_ID}", "documentId": "PHOTO", "cardNumber": "${MOCK_CardNumber}"}

    ${req}    Set Variable    {"caseId":"${CASE_ID}","documentId":"PHOTO","cardNumber":"${MOCK_CardNumber}"}
    
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

    Set Suite Variable    ${PHOTO_UPLOAD_SESSION_ID}    ${json["uploadSessionId"]}

Update VC
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=VcAssessment
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/update_phone.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    # ${json_text_replaced}=     Evaluate    '''${json_text_replaced}.encode("latin1").decode("utf-8")'''
    ${json_text_replaced}=    Cleansing string    ${json_text_replaced}    ${False}
    ${data}=    Convert String to JSON    ${json_text_replaced}
    ${option}    Create Dictionary    option=SELF
    ${historyVcLimitationTypes}    Create List    
    ${vcLimitationTypes}    Create List    ${1}
    Set To Dictionary    ${data['vcInfo']}     highestVcApproachCode=A2_B_D
    Set To Dictionary    ${data['vcInfo']}     vcThirdPersonInfo=${option}
    Set To Dictionary    ${data['vcInfo']}     historyVcLimitationTypes=${historyVcLimitationTypes}
    Set To Dictionary    ${data['vcInfo']}     vcLimitationTypes=${vcLimitationTypes}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json  
    
    Create Session    update_case_tel    ${url}
    ${response}=    PUT On Session    update_case_tel    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200

Update OTP Telephone
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


Update OTP Telephone_Backup
    #update_case_tel
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}?action=CustomerInformation&option=draft
    Log    url = ${url}${uri}

    ${data}=    Evaluate    {"caseId":"${CASE_ID}","selectedLanguage":"th","customerInfo":{"personalInfos":[{"cardInfo":{"engTitle":"MISS","engFirstName":"RATCHANEE","engMiddleName":"","engLastName":"CHANTASIAN","thaiTitle":"น.ส.","thaiFirstName":"รัชนี","thaiMiddleName":"","thaiLastName":"จันทเศียรทดสอบ","address":{"homeNo":"35/10","soi":"ซ.สุขุมวิท 1","trok":"","moo":"","road":"ถ.สุขุมวิท","subDistrict":"แขวงพระบรมมหาราชวัง","district":"เขตพระนคร","province":"กรุงเทพมหานคร","postalCode":"10200"},"cardType":"Citizen ID","cardNumber":"${MOCK_CardNumber}","cardExpiryDate":"2030/04/09","cardIssueDate":"2012/04/11","cardIssuePlace":"สำนักงานเขตบางรัก","sex":"M","dateOfBirth":"1979/04/10","bp1No":"JT0000000000","chipId":"chipId1","manualKeyIn":False,"customerType":"221","foreigner":False},"cifForm":{"cbsInfo":{"inquiryCIFDetailRespHeader":{"responseCode":0,"responseDesc":"","wsRefId":"b4851128-15b4-46fc-be5f-190474857c86"},"customerNo":"33994576","thaiTitle":"น.ส.","thaiName":"รัชนี จันทเศียรทดสอบ","engTitle":"MISS","engName":"RATCHANEE CHANTASIAN","dateOfBirth":"19790410","cardNumber":"${MOCK_CardNumber}","cardType":"01","cardIssuingCountry":"สำนักงานเขตบางรัก","cardIssueDate":"20120411","cardExpiryDate":"20300409","legalAddr1":"35/10","legalAddr2":"ซ.สุขุมวิท 1","legalAddr3":"ถ.สุขุมวิท","legalSubDistrict":"0100","legalDistrict":"1","legalStateProv":"10","legalPostalCd":"10200","legalCountry":"TH","mailingAddr1":"35/10","mailingAddr2":"ซ.สุขุมวิท 1","mailingAddr3":"ถ.สุขุมวิท","mailingSubDistrict":"0100","mailingDistrict":"1","mailingStateProv":"10","mailingPostalCd":"10200","mailingCountry":"TH","occupationCd":"1107","subOccupationCd":"01","officeName":"กรุงไทย จำกัด","officeAddr1":"445","officeAddr2":"","officeAddr3":"","officeSubDistrict":"0100","officeDistrict":"1","officeStateProv":"10","officePostalCd":"10200","officeCountry":"TH","homePhone":"032900000","mobilePhone":"${OTP_Tel}","officePhone":"021111111","officePhoneExt":"","smsAlertPhone":"","nationality":"TH","incomeCd":"6","maritalStat":"S","sex":"M","accountOpenDt":"20180326","kycStatus":"1","thaiFirstName":"รัชนี","thaiMiddleName":"","thaiLastName":"จันทเศียรทดสอบ","engFirstName":"RATCHANEE","engMiddleName":"","engLastName":"CHANTASIAN","countryOfBirth":"TH","employeeCode":"0","amlStatus":"0","amlSubListType":"","personIDDocument":"","personIDDocumentDetail":"","locationIDDocument":"","locationIDDocumentDetail":"","politicianRelateFlag":"2","politicianRelateCode":"","responseUnit":"","rmid":"","smsAlertRegFlg":"0","legalSubDistrictDesc":"แขวงพระบรมมหาราชวัง","legalDistrictDesc":"เขตพระนคร","legalStateProvDesc":"กรุงเทพมหานคร","mailingSubDistrictDesc":"แขวงพระบรมมหาราชวัง","mailingDistrictDesc":"เขตพระนคร","mailingStateProvDesc":"กรุงเทพมหานคร","officeSubDistrictDesc":"แขวงพระบรมมหาราชวัง","officeDistrictDesc":"เขตพระนคร","officeStateProvDesc":"กรุงเทพมหานคร","incomeCdDesc":"40,001-60,000","custRegSMSDt":"","custCCSMSDt":"","custLstPmtDt":"","custSMSChnl":"","custSMSWFlg":"0","custFeeAmtAcct":"","custNbRegSMSFlg":"0","custNbRegSMSDt":"","custNbCCSMSDt":"","sourceOfIncomeCode":"","countryOfIncome":"","branchCd":"722","preciousCustFlg":"","netBankFlg":"0","smsAlertMinAmt":0,"ktbCustCd":"221","educationCd":"3","ktbUserID":"","legalAddr4":"แขวงพระบรมมหาราชวัง","mailingAddr4":"แขวงพระบรมมหาราชวัง","officeAddr4":"แขวงพระบรมมหาราชวัง","occupationSector":"02","smsSaleCode":"","kycLastReviewDt":"20250210","cifPictureFlag":"0","consentOfCustomerFlg":"","consentOfCustomerUpdDat":"","consentOfCustomerUpdChnl":"","consentOfCustomerUpdBranch":"","consentToDisclosure":"","consentOfCustomerUpdUser":"","juristicID":"","juristicRegisterDate":"","taxID":"","driverLicenseNo":"","otherIDType":"","otherIDNumber":"","cifPictureLastUpdDate":"","kycScore":"1","kycCommentCode":"04","custTyp":0,"isicCode":"","aeID":"","aoID":"","coAOID":"","coRMID":"","coAEID":"","amdOfficer1":"","amdOfficer2":"","amdOfficer3":"","coResponseUnit":"200722","amdUnit":"","citizenID":"${MOCK_CardNumber}","isicCD1":"","isicCD2":"","isicCD3":"","interPoliticianRelateFlag":"2","costCenter":200722,"driversLicenseExpDt":"","driversLicenseIssueDate":"","driversLicenseProvince":"","faxNumber":"","govOrgID":"","interOrgOvrseaGovId":"","othExpDt":"","overseaJuristicId":"","residencyCd":"TH","nameofSpouse":"","legalAddressType":"1","countryOfNation":"","amlListFlag":"0","swiftCode":"","dateOfDeath":"","numberOfEmployees":0,"emailAddr":"PONLAPT@GMAIL.COM","ekyc":"0","ial":"","citizenIssueCenter":"สำนักงานเขตบางรัก","citizenIssueDate":"20120411","citizenExpiryDate":"20300409","passportNo":"","passportCountry":"TH","passportIssueDate":"","passportExpiryDate":"","otherIDIssue":"","legalAddrOption":"1","officeAddrOption":"0","mailingAddrOption":"0","emailVerified":True},"customerConsent":{"referenceId":"${MOCK_CardNumber}","referenceIdType":"CN","issuingCountry":"TH","cifNumber":"33994576","consents":[{"consentId":"100101","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-10T16:35:33+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100102","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-10T16:35:33+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]},{"consentId":"100103","consentVersionMajor":2,"consentVersionMinor":0,"consentAnsDateTime":"2025-02-10T16:35:33+07:00","consentProviders":[],"questions":[{"questionId":1,"answerLanguage":"TH","answerCode":"Y"}]}]},"liveImageSuccess":"Y","facialConsent":"Y","fatcaInfo":None}}]},"productInfo":{"travelCards":[],"debitCards":[{"productId":"DC01-43","productCode":"DC01","productName":"Krungthai Master Debit card","productTypeId":"DC-183","productTypeCode":"DC"}],"deposits":[],"cardMaintenances":[],"promptpayMaintenance":[],"tempCards":[],"promptpayGroups":None,"emoneys":[],"accountMaintenances":[],"mutualFundAccount":None,"insuranceTransactions":[],"newNext":None,"upLift":None,"statementRequests":[]},"customerAcceptConsent":False,"documentInfo":{"documents":[{"documentId":"SELFIE","uploadSessionId":"598c039d-a981-4793-b644-c23d2ade81d1"}]},"opportunityLogRefNo":"{{opportunityLogRefNo}}-1","additionalInfo":{"sellerFirstName":"ไอวริญย์","sellerLastName":"สุภาศิริธนานนท์","sellerPosition":"เจ้าหน้าที่ซุปเปอร์ไวเซอร์บริการลูกค้า","sellerId":"550221"},"flow":"${flow}","subFlow":"","needPrintedDocument":False,"sendCusEmailDocument":False,"portfolioInfo":{"mortgageRetentions":[{"accountName":"น.ส. รัชนี จันทเศียรทดสอบ With","accountNo":"100035628990","accountRelShipCd":"P","accountRelationship":"3","accountStatus":0,"accruedInterest":0,"acctCCSMSDt":"","acctLstPmtDt":"","acctPartnerLinkageFlg":"","acctRegSMSDt":"","acctRegSMSFlg":"0","acctSMSChnl":"","acctSMSMobile":"","acctSMSWFlg":"0","authLimit":1000000,"availBalAmt":1000000,"balAmt":0,"brnOwnerShip":86,"currCd":"THB","eduLoan":0,"intReceive":0,"lastSalPaidDt":"","linkTWTotalPayoffAmt":0,"loanAccountSubType":"00004","loanClassFinal":0,"loanSubAccountOption":0,"loanSubAccountOptionType":"","marketCode":"7813","marketCodeDesc":"สินเชื่อ Home For Cash สำหรับข้าราชการ - Promotion","maturityDt":"20290513","openAcctChannel":"","productGroup":"LN","productProgram":"","productType":7002,"smeCode":"","smsAlertMinAmt":0,"transactionLastDate":"","branchCode":"200086","branchName":"สาขาเซ็นทรัลบางนา","existHardStopIden":False}],"fnaInfo":None}}    json
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    update_case_tel    ${url}
    ${response}=    PUT On Session    update_case_tel    ${uri}    headers=${headers}    json=${data}
    Should Be Equal As Strings    ${response.status_code}    200
    #Should Be Equal As Strings    ${response.content.decode("utf-8")}    None
    Sleep    2s
    Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}

Generate App ID
    [Arguments]    ${type}=CD
    #generate_appid
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/app-id/${type}/generate?count=1
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    generate_appid    ${url}
    ${response}    POST On Session  generate_appid  ${uri}  headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    appIds

    Set Suite Variable    ${APP_ID}    ${json["appIds"][0]}
    #Set Suite Variable    ${IS_NEW_NEXT}    ${FALSE}

Master Signature KTB
    #KTB_MASTER_SIGNATURE
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_DOC}
    Log    url = ${url}${uri}
    
    ${file_path}    Set Variable    ${CURDIR}/../uploads/${Signa_File_Name}
    
    ${req}    Set Variable    {"caseId":"${CASE_ID}","documentId":"KTB_MASTER_SIGNATURE","cardNumber":"${MOCK_CardNumber}"}
    
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

    Set Suite Variable    ${SIGNATURE_UPLOAD_SESSION_ID}    ${json["uploadSessionId"]}

Generate OTP Mail
    #otp_generate
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/email-otp/generate
    Log    url = ${url}${uri}

    ${payload}    Create Dictionary
    ...    email=${Email}
    ...    cardNumber=${MOCK_CardNumber}
    log    ${payload}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    Create Session   otp_generate    ${url}
    ${response}=    POST On Session    otp_generate    ${uri}    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.status_code}
    Log    ${response.content}
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    reference
    Dictionary Should Contain item    ${json}    transactionId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    validDuration

    Set Test Variable    ${OTP_MAIL_REFERENCE}    ${json["reference"]}

Validate OTP Mail
    #otp_generate
    ${OTP}=    Get OTP From Mail       ${Gmail.email}   ${Gmail.password}    ${OTP_MAIL_REFERENCE}
    Run Keyword If    '${OTP}' == 'None'    Fail    OTP not found
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/email-otp/validate
    Log    url = ${url}${uri}

    ${payload}    Create Dictionary
    ...    email=${Email}
    ...    reference=${OTP_MAIL_REFERENCE}
    ...    otp=${OTP}
    ...    transactionId=${CASE_ID}
    log    ${payload}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    Create Session   otp_generate    ${url}
    ${response}=    POST On Session    otp_generate    ${uri}    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.status_code}
    Log    ${response.content}

Generate OTP
    #otp_generate  
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/otp/generate
    Log    url = ${url}${uri}

    Set Suite Variable    ${TRANSACTION_ID}    ${CASE_ID}-1

    ${data}=    Set variable    {"transactionId":"${TRANSACTION_ID}","cardNumber":"${MOCK_CardNumber}","mobileNumber":"${OTP_Tel}","otpMode":"ONBOARD"}
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session   otp_generate    ${url}
    ${response}=    POST On Session    otp_generate    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key     ${json}    reference
    Dictionary Should Contain item    ${json}    transactionId    ${TRANSACTION_ID}
    Dictionary Should Contain Key     ${json}    validDuration

    Set Suite Variable    ${OTP_REFERENCE}    ${json["reference"]}

Validate OTP
    #otp_validate
    # Log To Console    \nRef. ${OTP_REFERENCE}
    # Log To Console    Enter your OTP:
    # ${OTP}=    Evaluate    input()

    ${OTP}=    Get OTP From Mail       ${Gmail.email}   ${Gmail.password}    ${OTP_REFERENCE}    
    Run Keyword If    '${OTP}' == 'None'    Fail    OTP not found
    # ${OTP}=    Get_OTP_SMS    ${OTP_REFERENCE}
    
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/otp/validate
    Log    url = ${url}${uri}

    ${data}=    Set variable    {"otp":"${OTP}","cardNumber":"${MOCK_CardNumber}","transactionId":"${TRANSACTION_ID}","mobileNumber":"${OTP_Tel}","otpMode":"ONBOARD","reference":"${OTP_REFERENCE}"}
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB

    Create Session   otp_generate    ${url}
    ${response}=    POST On Session    otp_generate    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    #Should Be Equal As Strings    ${response.content.decode("utf-8")}    None
    Sleep    2s

Verify KYC
    #kyc
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/kyc
    Log    url = ${url}${uri}

    ${data}=    Evaluate    [{"beneficiary":False,"isInvolvingPoliticianFlag":"2","isInvolvingForeignPoliticianFlag":"2","nationality":"TH","occupationCode":"110701","thaiTitle":"${MOCK_ThaiTitle}","thaiFirstName":"${MOCK_ThaiFirstName}","thaiMiddleName":"","thaiLastName":"${MOCK_ThaiLastName}","cardNumber":"${MOCK_CardNumber}","countryOfIncome":"TH","productCode":"2001"}]    json
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
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    productCode
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    amlSubListType
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    originalCode
    Dictionary Should Contain Key     ${json["data"]["kycResult"][0]}    originalMessage

Submission Information
    #submission
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/submission/start
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
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
    
    #FOR    ${item}    IN    @{json_list}
    #    Should Be Equal As Strings    ${item}[status]    SUCCESS
    #END

Mock cid with employeeId
    ${Card_number_exists}=    Run Keyword And Return Status    Variable Should Exist    ${Card_number}    
    IF    ${Card_number_exists} 
        IF    '${Card_number}'!='' 
            ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
            ${uri}=    Set variable    /ktb/rest/esolution/v1/mock/config
            Log    url = ${url}${uri}

            ${data}=    Evaluate    {"cardInfo":{"${User_ID}":{"bp1No":"JT0000000000","chipId":"chipId1","thaiTitle":"นาย","thaiFirstName":"เทส","thaiMiddleName":"","thaiLastName":"ออโต้เมท","engTitle":"MR","engFirstName":"Test","engMiddleName":"","engLastName":"Automate","dateOfBirth":"1992/08/12","cardType":"IDCARD","cardNumber":"${Card_number}","cardIssueDate":"2015/07/01","cardIssuePlace":"สำนักงานเขตคลองเตย","cardExpiryDate":"2026/12/31","cardPhotoIssueNo":"1944-07-09238402","sex":"M","address":{"homeNo":"3/140","soi":"ซ.เอกชัยกอล์ฟ","trok":"ตรอกจันทร์","moo":"หมู่ 3","road":"ถ.สุขุมวิท","subDistrict":"ตำบลบางน้ำจืด","district":"อำเภอเมืองสมุทรสาคร","province":"สมุทรสาคร"}}}}    json
            log    ${data}
            
            ${variable_exists}=    Run Keyword And Return Status    Variable Should Exist    ${Customer_Age}    
            IF    ${variable_exists}
                IF    '${Customer_Age}' != '' 
                    ${DATE}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S.%f
                    ${Customer_Age}    Convert To Integer    ${Customer_Age}
                    ${DAYS}    Evaluate    __import__('math').ceil((${Customer_Age} * 365) + (${Customer_Age} / 4) + 1)
                    ${DateOfBirth}    Subtract Time From Date    ${DATE}    ${DAYS} days
                    ${DateOfBirth}     Convert Date    ${DateOfBirth}    result_format=%Y/%m/%d

                    ${data}=    Evaluate    {"cardInfo":{"${User_ID}":{"bp1No":"JT0000000000","chipId":"chipId1","thaiTitle":"นาย","thaiFirstName":"เทส","thaiMiddleName":"","thaiLastName":"ออโต้เมท","engTitle":"MR","engFirstName":"Test","engMiddleName":"","engLastName":"Automate","dateOfBirth":"${DateOfBirth}","cardType":"IDCARD","cardNumber":"${Card_number}","cardIssueDate":"2015/07/01","cardIssuePlace":"สำนักงานเขตคลองเตย","cardExpiryDate":"2026/12/31","cardPhotoIssueNo":"1944-07-09238402","sex":"M","address":{"homeNo":"3/140","soi":"ซ.เอกชัยกอล์ฟ","trok":"ตรอกจันทร์","moo":"หมู่ 3","road":"ถ.สุขุมวิท","subDistrict":"ตำบลบางน้ำจืด","district":"อำเภอเมืองสมุทรสาคร","province":"สมุทรสาคร"}}}}    json
                    log    ${data}
                END
            END

            ${headers}=    Create Dictionary
            ...    Content-Type=application/json

            Create Session   mock_cid    ${url}
            ${response}=    POST On Session    mock_cid    ${uri}     headers=${headers}    json=${data}
            Should Be Equal As Strings    ${response.status_code}    200
            ${json}=    Convert String to JSON    ${response.content}
            log    ${response.content}
        END
    END

Bypass face with overide
    [Arguments]    ${flow}=${EMPTY}
    ${upper}=    Convert To Upper Case    ${Overide}
    Run Keyword If    '${upper}' == 'Y'    Get Checker for overide

    ${i}=    Set Variable    0
    ${upper}=    Convert To Upper Case    ${Overide}
    FOR    ${item}    IN    @{response_checker}
        Set Test Variable    ${index}    ${i}
        Run Keyword If    '${upper}' == 'Y'    Checker approve on local
        Run Keyword If    '${upper}' == 'Y'    Local overide
        Run Keyword If    ${approve_status_code} == 200     Exit For Loop 
        ${i}=    Evaluate    ${i} + 1
    END
    IF    ${approve_status_code} != 200
        Fail    msg=Checker approve failed with status code ${approve_status_code}
    END
    
    # Run Keyword If    ${Overide}    Checker approve on local
    # Run Keyword If    ${Overide}    Local overide

Bypass face newnext with overide
     
    Checker approve newnext on local
    Local newnext overide

Get Checker for overide    
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/user/checkers/${CASE_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    Create Session   get_checker    ${url}
    ${response}=    GET On Session    get_checker    ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    ${json_length}=    Get Length    ${json}
    Should Be True    ${json_length} > 0    msg=Response JSON is empty    
    IF  ${json_length} > 0
        Set Test Variable    ${response_checker}    ${json}
    ELSE
        Fail    msg=Not found overide 
    END

Checker approve on local
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/approval
    Log    url = ${url}${uri}

    Set Test Variable    ${Overide_employeeId}    ${response_checker[${index}]["employeeId"]} 
    Set Test Variable    ${Overide_name}          ${response_checker[${index}]["name"]}
    Set Test Variable    ${Overide_branchCode}    ${response_checker[${index}]["branchCode"]}  

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    ${data_dict}=    Create Dictionary
    ...    caseId=${CASE_ID}
    ...    functionCode=BYPASS_FACE
    ...    type=L
    ...    cardNumber=${MOCK_CardNumber}
    ...    cardType=01
    ...    data=${EMPTY}
    ...    thaiName=${MOCK_ThaiTitle} ${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}
    ...    engName=${MOCK_EngTitle} ${MOCK_EngFirstName} ${MOCK_EengLastName}
    
    ${data}=    Create Dictionary
    ...    customerNo=${CUSTOMER_CIF}
    ...    makerUserGroup=${RoleClassCode} 
    ...    transactionLimit=${1000000}
    ...    flow=${flow}


    Set To Dictionary    ${data_dict}    data    ${data}

    # IF    '${flow}' == 'mfoa'
    #     Set To Dictionary    ${data_dict}    data    {"customerNo":"${CUSTOMER_CIF}","makerUserGroup":"FP","transactionLimit":1000000,"flow":"mfoa"}
    # ELSE IF    '${flow}' == 'pmb'
    #     Set To Dictionary    ${data_dict}    data    {"customerNo":"${CUSTOMER_CIF}","makerUserGroup":"FP","transactionLimit":1000000,"flow":"pmb"}
    # END
    

    

    Create Session   approval    ${url}
    ${response}=    POST On Session    approval    ${uri}    json=${data_dict}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Set Test Variable    ${approvalId}    ${json["approvalId"]}  

Local overide
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/approval/${approvalId}/approve/local
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    ${data_dict}=    Create Dictionary
    ...    username=${Overide_employeeId}
    ...    secret=P@ssw0rd
    ...    data=${EMPTY}

    ${data}=    Create Dictionary
    ...    flow=${flow}

    Set To Dictionary    ${data_dict}    data    ${data}

    Create Session   Local_overide    ${url}
    ${response}=    POST On Session    Local_overide    ${uri}    json=${data_dict}    headers=${headers}    expected_status=any
    
    Set Test Variable    ${approve_status_code}    ${response.status_code}
    ${json}=    Convert String to JSON    ${response.content}
    
    IF    '${approve_status_code}' == '200'
        Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
        Dictionary Should Contain item    ${json}    approval1    ${Overide_employeeId}
        Dictionary Should Contain Key     ${json}    approval1Date
        Dictionary Should Contain Key     ${json}    approval1Status
        Dictionary Should Contain Key     ${json}    approvalBranchId
        Dictionary Should Contain Key     ${json}    approvalCount
        Dictionary Should Contain item    ${json}    approvalId    ${approvalId}
        Dictionary Should Contain Key     ${json}    approvalRequired
        Dictionary Should Contain Key     ${json}    approvalStatus
        Dictionary Should Contain Key     ${json}    branchId
        Dictionary Should Contain item    ${json}    cardNumber    ${MOCK_CardNumber}
        Dictionary Should Contain Key     ${json}    cardType
        Dictionary Should Contain Key     ${json}    checked
        Dictionary Should Contain Key     ${json}    createdDate
        Dictionary Should Contain item    ${json}    engName    ${MOCK_EngTitle} ${MOCK_EngFirstName} ${MOCK_EengLastName}
        Dictionary Should Contain item    ${json}    functionCode    BYPASS_FACE
        Dictionary Should Contain Key     ${json}    lockBy
        Dictionary Should Contain Key     ${json}    sellerId    ${User_ID}
        Should Be Equal As Strings        ${json["sellerId"]}    ${User_ID}
        Dictionary Should Contain Key     ${json}    sscRequired
        Dictionary Should Contain item     ${json}    thaiName    ${MOCK_ThaiTitle} ${MOCK_ThaiFirstName} ${MOCK_ThaiLastName}
        Dictionary Should Contain Key     ${json}    type
        Dictionary Should Contain Key     ${json}    updatedDate
        Dictionary Should Contain Key     ${json}    version
    END
Search Product Information
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
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
    IF    '${Label_serviceType}' == 'DebitCards'
        ${debitCards}=    Set Variable    ${json["productInfo"]["debitCards"][0]}
        Dictionary Should Contain item    ${debitCards}    productId    ${Product_ID}
        Dictionary Should Contain item    ${debitCards}    productCode    ${Product_Code}
        Dictionary Should Contain item    ${debitCards}    productTypeId    ${Product_TypeId}
        Dictionary Should Contain item    ${debitCards}    productTypeCode    ${Product_Type_Code}
        Dictionary Should Contain item    ${debitCards}    productName    ${Product_Name}
        Dictionary Should Contain Key     ${debitCards}    appId
        
        ${Result_Status}=    Set Variable    ${json["productInfo"]["debitCards"][0]["result"]}
        IF    '${Result_Status}' == 'SUCCESS'
            Dictionary Should Contain item    ${debitCards}    result    ${Transaction_Status}
        ELSE
            ${Document_errorCode} =    Set Variable If    '${errorCode}' == '${EMPTY}'        null        ${errorCode}
            ${Document_errorDesc} =    Set Variable If    '${errorDesc}' == '${EMPTY}'        null        ${errorDesc}
            #${json_data}=    Set Variable    ${json["productInfo"]["debitCards"][0]["errorDesc"]}
            #Should Be Equal    ${json_data}    ${Document_errorDesc}
            #Should Be Equal    first    second   msg=${Document_errorDesc}
            Dictionary Should Contain item    ${debitCards}    errorCode    ${Document_errorCode}
            Dictionary Should Contain item    ${debitCards}    errorDesc    ${Document_errorDesc}
        END

        Dictionary Should Contain Key     ${debitCards}    cardName
        Dictionary Should Contain Key     ${debitCards}    mailingType
        Dictionary Should Contain Key     ${debitCards}    mailingAddressType
        Dictionary Should Contain Key     ${debitCards}    productAddress
        Dictionary Should Contain item    ${debitCards}    cardShortDesc    ${Card_ShortDesc}
        Dictionary Should Contain Key     ${debitCards}    maskedCardNo
        Dictionary Should Contain item    ${debitCards}    cardType    ${Card_Type}
        Dictionary Should Contain item    ${debitCards}    usageCode    ${Usage_Code}
        Dictionary Should Contain Key     ${debitCards}    usageCodeDesc
        Dictionary Should Contain item    ${debitCards}    accountNumber    ${ACCOUNT_NO}
        Dictionary Should Contain Key     ${debitCards}    verificationService
        Dictionary Should Contain Key     ${debitCards}    salesCode
        Dictionary Should Contain Key     ${debitCards}    feeType
        Dictionary Should Contain Key     ${debitCards}    annualFee
        Dictionary Should Contain Key     ${debitCards}    issueFee
        Dictionary Should Contain Key     ${debitCards}    memoNo
        Dictionary Should Contain Key     ${debitCards}    campaignDesc
        Dictionary Should Contain Key     ${debitCards}    withdrawRefId
        Dictionary Should Contain Key     ${debitCards}    deliveryFeeWithdrawRefId
        Dictionary Should Contain Key     ${debitCards}    dummyCardNo
        Dictionary Should Contain item    ${debitCards}    cardGroup    ${Card_Group}
        Dictionary Should Contain Key     ${debitCards}    propertyInsuranceFlag
        Dictionary Should Contain Key     ${debitCards}    exemptAnnualFee
        Dictionary Should Contain Key     ${debitCards}    collectedAnnualFee
        Dictionary Should Contain Key     ${debitCards}    totalFee
        Dictionary Should Contain Key     ${debitCards}    toBePaid
        Dictionary Should Contain Key     ${debitCards}    toBePaidDeliveryFee
        Dictionary Should Contain Key     ${debitCards}    ktbWaiveFlag
        Dictionary Should Contain Key     ${debitCards}    supplementary
        Dictionary Should Contain Key     ${debitCards}    cardFee

        log    ${json["productInfo"]["debitCards"][0]["dummyCardNo"]}
    ELSE IF    '${Label_serviceType}' == 'TravelCards'
        Dictionary Should Contain Key     ${productInfo}    travelCards
        ${travelCards}=    Set Variable    ${json["productInfo"]["travelCards"][0]}
        Dictionary Should Contain item    ${travelCards}    productId    ${Product_ID}
        Dictionary Should Contain item    ${travelCards}    productCode    ${Product_Code}
        Dictionary Should Contain item    ${travelCards}    productTypeId    ${Product_TypeId}
        Dictionary Should Contain item    ${travelCards}    productTypeCode    ${Product_Type_Code}
        Dictionary Should Contain item    ${travelCards}    productName    ${Product_Name}
        Dictionary Should Contain Key     ${travelCards}    appId
        
        ${Result_Status}=    Set Variable    ${json["productInfo"]["travelCards"][0]["result"]}
        IF    '${Result_Status}' == 'SUCCESS'
            Dictionary Should Contain item    ${travelCards}    result    ${Transaction_Status}
        ELSE
            ${Document_errorCode} =    Set Variable If    '${errorCode}' == '${EMPTY}'        null        ${errorCode}
            ${Document_errorDesc} =    Set Variable If    '${errorDesc}' == '${EMPTY}'        null        ${errorDesc}
            #${json_data}=    Set Variable    ${json["productInfo"]["debitCards"][0]["errorDesc"]}
            #Should Be Equal    ${json_data}    ${Document_errorDesc}
            #Should Be Equal    first    second   msg=${Document_errorDesc}
            Dictionary Should Contain item    ${travelCards}    errorCode    ${Document_errorCode}
            Dictionary Should Contain item    ${travelCards}    errorDesc    ${Document_errorDesc}
        END

        Dictionary Should Contain Key     ${travelCards}    cardName
        Dictionary Should Contain Key     ${travelCards}    mailingType
        Dictionary Should Contain Key     ${travelCards}    mailingAddressType
        Dictionary Should Contain Key     ${travelCards}    productAddress
        Dictionary Should Contain item    ${travelCards}    cardShortDesc    ${Card_ShortDesc}
        Dictionary Should Contain Key     ${travelCards}    maskedCardNo
        Dictionary Should Contain item    ${travelCards}    cardType    ${Card_Type}
        Dictionary Should Contain item    ${travelCards}    usageCode    ${Usage_Code}
        Dictionary Should Contain Key     ${travelCards}    usageCodeDesc
        Dictionary Should Contain item    ${travelCards}    accountNumber    ${ACCOUNT_NO}
        Dictionary Should Contain Key     ${travelCards}    verificationService
        Dictionary Should Contain Key     ${travelCards}    salesCode
        Dictionary Should Contain Key     ${travelCards}    feeType
        Dictionary Should Contain Key     ${travelCards}    annualFee
        Dictionary Should Contain Key     ${travelCards}    issueFee
        Dictionary Should Contain Key     ${travelCards}    memoNo
        Dictionary Should Contain Key     ${travelCards}    campaignDesc
        Dictionary Should Contain Key     ${travelCards}    withdrawRefId
        # Dictionary Should Contain Key     ${travelCards}    withdrawResult
        Dictionary Should Contain Key     ${travelCards}    deliveryFeeWithdrawRefId
        # Dictionary Should Contain Key     ${travelCards}    sendFeeToCCMSResult
        Dictionary Should Contain Key     ${travelCards}    cardNo
        Dictionary Should Contain Key     ${travelCards}    expiryDate
        Dictionary Should Contain item    ${travelCards}    cardGroup    ${Card_Group}
        Dictionary Should Contain Key     ${travelCards}    propertyInsuranceFlag
        Dictionary Should Contain Key     ${travelCards}    exemptAnnualFee
        Dictionary Should Contain Key     ${travelCards}    collectedAnnualFee
        Dictionary Should Contain Key     ${travelCards}    totalFee
        Dictionary Should Contain Key     ${travelCards}    toBePaid
        Dictionary Should Contain Key     ${travelCards}    toBePaidDeliveryFee
        Dictionary Should Contain Key     ${travelCards}    ktbWaiveFlag
        Dictionary Should Contain Key     ${travelCards}    supplementary
        Dictionary Should Contain Key     ${travelCards}    cardFee

        log    ${json["productInfo"]["travelCards"][0]["cardNo"]}
    END

    IF    '${Label}' == 'NextSaving'
        ${deposits}=    Set Variable    ${json["productInfo"]["deposits"][0]}
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
        Dictionary Should Contain Key     ${deposits}    signatureConsent
        Dictionary Should Contain item     ${deposits}    crsResult    SUCCESS
        Dictionary Should Contain Key     ${deposits}    openDateTime
    ELSE IF    '${Label}' == 'ZeroTax'
        ${deposits} =   Set Variable   ${json["productInfo"]["deposits"][0]}
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

GET Term Ammount
    #otp_generate
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/case/${CASE_ID}/account/${Product_Code}/term-amount
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json

    Create Session   get_term_ammount    ${url}
    ${response}=    GET On Session    get_term_ammount    ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    ${json_length}=    Get Length    ${json}
    Should Be True    ${json_length} > 0    msg=Response JSON is empty
    IF  ${json_length} > 0
        Set Test Variable    ${term}    ${json[0]["term"]} 
        Set Test Variable    ${termUnit}    ${json[0]["termUnit"]}
        Set Test Variable    ${minAmount}    ${json[0]["minAmount"]}
        Set Test Variable    ${maxAmount}    ${json[0]["maxAmount"]}
    ELSE
        Fail    msg=Not found term-amount 
    END

Get standingPaymentEndDate
    Set Test Variable    ${term}    24
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    ${year}=    Evaluate    int(${today.split('-')[0]}) + (${term} // 12)
    ${month}=    Evaluate    int('${today.split("-")[1]}'.lstrip("0"))
    Run Keyword If    ${month} == 1    Set Variable    ${year}=    ${year - 1}
    Run Keyword If    ${month} == 1    Set Variable    ${month}=    12
    Run Keyword If    ${month} != 1    Set Variable    ${month}=    ${month - 1}
    ${month}=    Evaluate    "{:02d}".format(${month})
    ${year}=    Convert To String    ${year}
    ${standingPaymentEndDate}=    Set Variable    ${year}-${month}-30
    Log    ${standingPaymentEndDate}
    Set Test Variable    ${standingPaymentEndDate}

Get standingPaymentStartDate
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    ${year}=    Evaluate    int(${today.split('-')[0]})
    ${month}=    Evaluate    int('${today.split("-")[1]}'.lstrip("0")) + 1
    Run Keyword If    ${month} == 0    Set Variable    ${year}=    ${year - 1}
    Run Keyword If    ${month} == 0    Set Variable    ${month}=    12
    ${month}=    Evaluate    "{:02d}".format(${month})
    ${standingPaymentStartDate}=    Set Variable    ${year}-${month}-${PaymentDate}
    Log    ${standingPaymentStartDate}
    Set Test Variable    ${standingPaymentStartDate}

Get Account Savings Linkage Link
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/continue
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    get_account_savings    ${url}
    ${response}=    POST On Session  get_account_savings  ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    ${flag}=    Set Variable    ${FALSE}

    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    branchCode
    Dictionary Should Contain Key     ${json}    portfolioInfo

    @{deposits}=    Set Variable    ${json["portfolioInfo"]["deposits"]}
    ${Length_ITEM} =	Get Length      ${deposits}
    FOR    ${index}    IN RANGE    0    ${Length_ITEM}
        IF    '${deposits}[${index}][productGroup]' == 'SAV' and '${deposits}[${index}][accountStatus]' == '0'
            Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
            Dictionary Should Contain Key     ${deposits}[${index}]    productName
            Dictionary Should Contain Key     ${deposits}[${index}]    productType
            Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
            ${flag}=    Set Variable    ${TRUE}
            Exit For Loop
        END
    END

    IF    ${flag}
        Set Suite Variable    ${ACCOUNT_LINKAGE_LINK}                ${deposits}[${index}][accountNo]
        Set Suite Variable    ${ACCOUNT_TYPE_LINKAGE_LINK}      ${deposits}[${index}][productType]
    ELSE
        Fail    Not found account: ${account}
    END

Get Account KrungthaiNEXTSavings Linkage Link
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/continue
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    get_account_nextsavings    ${url}
    ${response}=    POST On Session  get_account_nextsavings  ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    ${flag}=    Set Variable    ${FALSE}

    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    branchCode
    Dictionary Should Contain Key     ${json}    portfolioInfo

    @{deposits}=    Set Variable    ${json["portfolioInfo"]["deposits"]}
    ${Length_ITEM} =	Get Length      ${deposits}
    FOR    ${index}    IN RANGE    0    ${Length_ITEM}
        IF    '${deposits}[${index}][productGroup]' == 'SAV' and '${deposits}[${index}][accountStatus]' == '0' and '${deposits}[${index}][productType]' == '2003'
            Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
            Dictionary Should Contain Key     ${deposits}[${index}]    productName
            Dictionary Should Contain Key     ${deposits}[${index}]    productType
            Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
            ${flag}=    Set Variable    ${TRUE}
            Exit For Loop
        END
    END

    IF    ${flag}
        Set Suite Variable    ${ACCOUNT_LINKAGE_LINK}                ${deposits}[${index}][accountNo]
        Set Suite Variable    ${ACCOUNT_TYPE_LINKAGE_LINK}      ${deposits}[${index}][productType]
    ELSE
        Fail    Not found account: ${account}
    END

Get Account ZeroTax Linkage Link
    #retrieve_continue
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_ESOL_CASE}/${CASE_ID}/retrieve/continue
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    
    Create Session    get_account_zerotax    ${url}
    ${response}=    POST On Session  get_account_zerotax  ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    ${flag}=    Set Variable    ${FALSE}

    Dictionary Should Contain item    ${json}    caseId    ${CASE_ID}
    Dictionary Should Contain Key     ${json}    branchCode
    Dictionary Should Contain Key     ${json}    portfolioInfo

    @{deposits}=    Set Variable    ${json["portfolioInfo"]["deposits"]}
    ${Length_ITEM} =	Get Length      ${deposits}
    FOR    ${index}    IN RANGE    0    ${Length_ITEM}
        IF    '${deposits}[${index}][productGroup]' == 'CD' and '${deposits}[${index}][productType]' == '3301'
            Dictionary Should Contain Key     ${deposits}[${index}]    accountNo
            Dictionary Should Contain Key     ${deposits}[${index}]    productName
            Dictionary Should Contain Key     ${deposits}[${index}]    productType
            Dictionary Should Contain Key     ${deposits}[${index}]    productGroup
            ${flag}=    Set Variable    ${TRUE}
            Exit For Loop
        END
    END

    IF    ${flag}
        Set Suite Variable    ${ACCOUNT_LINKAGE_LINK}                ${deposits}[${index}][accountNo]
        Set Suite Variable    ${ACCOUNT_TYPE_LINKAGE_LINK}      ${deposits}[${index}][productType]
    ELSE
        Fail    Not found account: ${account}
    END

Get Employee Info
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/user/me
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive
    ...    Accept=*/*
    
    Create Session    get_me    ${url}
    ${response}=    GET On Session  get_me  ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log    ${json}

    Set Global Variable    ${FirstNameEmployee}    ${json["firstName"]}
    Set Global Variable    ${LastNameEmployee}     ${json["lastName"]}
    Set Global Variable    ${POSITION}             ${json["position"]}
    Set Global Variable    ${RoleClassCode}        ${json["roleClass"]["code"]}
    Set Global Variable    ${LICENSES}             ${json["licenses"]}

Vulnerable Customer Verification Start
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_VULNERABLE_CUSTOMER_START}
    Log    url = ${url}${uri}
    
    Create Session    vulnerable_verification_start    ${url}
    ${json_data}=    Create Dictionary
    ...    caseId=${CASE_ID}
   
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
   
    ${response}    POST On Session  vulnerable_verification_start  ${uri}  headers=${headers}    json=${json_data}  expected_status=any    
 
    Log    ${response.status_code}
    Log    ${response.text}
    
    Should Be Equal As Strings    ${response.status_code}        200
    # ${test}=    Convert String to JSON    ${response.text}
    ${json}=    Convert String to JSON    ${response.content}
    Dictionary Should Contain Key     ${json}    vcVerificationId
    Dictionary Should Contain Key     ${json}    vcVerificationDateTime
    Set Test Variable    ${vcVerificationId}    ${json["vcVerificationId"]}
    
Vulnerable Customer Verification Verify
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set variable    ${URI_VULNERABLE_CUSTOMER_VERIFY}
    Log    url = ${url}${uri}
    
    Create Session    vulnerable_verification_verify    ${url}
    ${json_data}=    Create Dictionary
    ...    caseId=${CASE_ID}
    ...    reviewerEmpId=${Overide_employeeId}
    ...    secret=P@ssw0rd
    ...    vcVerificationId=${vcVerificationId}
   
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
   
    ${response}    POST On Session  vulnerable_verification_verify  ${uri}  headers=${headers}    json=${json_data}  expected_status=any    
 
    Log    ${response.status_code}
    Log    ${response.text}
    
    Should Be Equal As Strings    ${response.status_code}        200
    # ${test}=    Convert String to JSON    ${response.text}
    ${json}=    Convert String to JSON    ${response.content}
    Dictionary Should Contain Key     ${json}    vcVerificationId
    Dictionary Should Contain Key     ${json}    vcVerificationDateTime
    Set Test Variable    ${vcVerificationId}    ${json["vcVerificationId"]}

Check PDF Text Before Logging Link
    [Arguments]    ${TARGET_WORD}    ${PDF_PATH}
    ${text}=    Evaluate
    ...    " ".join([p.extract_text() or "" for p in __import__('PyPDF2').PdfReader(r'''${PDF_PATH}''').pages])
    ${found}=    Evaluate    '${TARGET_WORD}' in '''${text}'''
    RETURN    ${found}

Set pdf file path to variable
    [Arguments]    ${type}
    ${current_date}=    Get Current Date    result_format=%Y%m%d
    Remove special characters from test case name
    ${pdf_file_path}         Set Variable          pdf_result${/}${current_date}${/}${type}${/}${test_cases_name_without_special_characters}.pdf
    Set Test Variable    ${pdf_file_path} 

View PDF Report
    Log    ${CASE_ID}
    IF    '${found}' == 'True'
        Log    <a href="${pdf_file_path}" target="_blank">📄 คลิกเพื่อดู PDF รายงาน</a>    html=True
    ELSE
        Log    ❌ ไม่พบคำ "${CASE_ID}" ใน PDF
    END

Remove special characters from test case name
    ${regex_pattern_for_remove_special_characters}=    Set Variable    '[^a-zA-Z0-9\u0E00-\u0E7F _-]'
    ${test_cases_name_without_special_characters}=     Replace String Using Regexp     ${TEST_NAME}     ${regex_pattern_for_remove_special_characters}     ${EMPTY}
    ${test_cases_name_without_special_characters}     Replace String    ${test_cases_name_without_special_characters}     search_for=${SPACE}     replace_with=_
    Set Test Variable    ${test_cases_name_without_special_characters}

