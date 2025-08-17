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
Resource          ESOL_Insurance_Keyword.robot

*** Keywords ***
Generate Token CHUBB
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_CHUBB}
    ${uri}=    Set variable    ${URI_GENERATE_TOKEN_ID_CHUBB}/?Identity=ADB2C
    Log    url = ${url}${uri}

    ${data}=    Set Variable    {}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    App_ID=${App_ID_CHUBB}
    ...    App_Key=${App_Key_CHUBB}
    ...    Resource=${Resource_CHUBB}
    ...    Connection=keep-alive
    ...    Content-Type=application/json
    ...    apiVersion=1
    ...    Accept-Encoding=gzip, deflate, br

    Create Session    generate_token    ${url}
    ${response}=    POST On Session    generate_token    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json}    token_type
    Dictionary Should Contain Key    ${json}    expires_in
    Dictionary Should Contain Key    ${json}    ext_expires_in
    Dictionary Should Contain Key    ${json}    expires_on
    Dictionary Should Contain Key    ${json}    not_before
    Dictionary Should Contain Key    ${json}    access_token

    Set Global Variable    ${ACCESS_TOKEN_CHUBB}    ${json["access_token"]}

Transaction Info CHUBB
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_CHUBB}
    ${uri}=    Set variable    /sales.microsite/esolutions/insurance/transaction/info
    Log    url = ${url}${uri}

    ${DATE}=    Get Current Date    result_format=%Y%m%d
    Set Global Variable    ${TODAY}    ${DATE}
    ${TIME}=    Get Current Date    result_format=%H%M%S

    ${data}=    Set Variable    {"caseID":"${CASE_ID}","currentDt":"${DATE}","currentTime":"${TIME}","planCode":"${PLAN_CODE}"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    apiVersion=1
    ...    Content-Type=application/json
    ...    Ocp-Apim-Subscription-Key=${SUBSCRIPTION_KEY_CHUBB} 
    ...    Priority=u=1, i
    ...    X-Authorization=${X-Auth_CHUBB}
    ...    Authorization=Bearer ${ACCESS_TOKEN_CHUBB}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_info    ${url}
    ${response}=    POST On Session    transaction_info    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json}    respStatus

    Should Be Equal As Strings    ${json["respStatus"]}    Success

Get SuminsuredMin CHUBB    
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_CHUBB}
    ${uri}=    Set variable    /sales.microsite/PA/microsite/ktbpackages/list?Companycode=000031002
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    apiVersion=1
    ...    Content-Type=application/json
    ...    Ocp-Apim-Subscription-Key=${SUBSCRIPTION_KEY_CHUBB} 
    ...    Priority=u=1, i
    ...    X-Authorization=${X-Auth_CHUBB}
    ...    Authorization=Bearer ${ACCESS_TOKEN_CHUBB}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    SuminsuredMin    ${url}
    ${response}=    GET On Session    SuminsuredMin    ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    FOR    ${item}    IN    @{json['PackageLists']}
        ${is_match}=    Run Keyword And Return Status    Should Be Equal As Strings    ${item['PackageID']}    ${PLAN_CODE}
        IF    ${is_match}
            Set Global Variable    ${PRODUCT_ID_CHUBB}       ${item['ProductCode']}
            Set Global Variable    ${SUMINSURED_MIN}     ${item['SuminsuredMin']}
            ${suminsured}=    Evaluate    int(${SUMINSURED_MIN})
            Set Global Variable    ${SUMINSUREDMIN_CHUBB}    ${suminsured}
            Set Global Variable    ${COVERAGE_YEAR}    ${item['CoverageYear']}
            Log To Console    TTTT: ${PRODUCT_ID_CHUBB},${SUMINSUREDMIN_CHUBB},${COVERAGE_YEAR}
            Exit For Loop
        END
    END

Receive Status CHUBB
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_CHUBB}
    ${uri}=    Set variable    /sales.microsite/esolutions/insurance/receiveStatus
    Log    url = ${url}${uri}

    ${data}=    Set Variable    {"caseID":"${CASE_ID}","insureIDCardNo":"${MOCK_CardNumber}","productCode":"${PRODUCT_ID_CHUBB}"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Connection=keep-alive
    ...    Content-Type=application/json
    ...    Ocp-Apim-Subscription-Key=${SUBSCRIPTION_KEY_CHUBB} 
    ...    X-Authorization=${X-Auth_CHUBB}
    ...    apiVersion=1
    ...    Authorization=Bearer ${ACCESS_TOKEN_CHUBB}
    ...    Accept-Encoding=gzip, deflate, br

    Create Session    Receive    ${url}
    ${response}=    POST On Session    Receive    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

Calculate SumInsured
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_CHUBB}
    ${uri}=    Set variable    /sales.microsite/PA/microsite/ktbpackages?PackageID=${PLAN_CODE} &ProductCode=${PRODUCT_ID_CHUBB}&SumInsured=${SUMINSUREDMIN_CHUBB}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Connection=keep-alive
    ...    Content-Type=application/json
    ...    Ocp-Apim-Subscription-Key=${SUBSCRIPTION_KEY_CHUBB} 
    ...    X-Authorization=${X-Auth_CHUBB}
    ...    apiVersion=1
    ...    Authorization=Bearer ${ACCESS_TOKEN_CHUBB}
    ...    Accept-Encoding=gzip, deflate, br

    Create Session    ktbpackages    ${url}
    ${response}=    GET On Session    ktbpackages    ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    Set Global Variable    ${PACKAGES_CHUBB}    ${json['Packages'][0]}

Verify PA CHUBB
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_CHUBB}
    ${uri}=    Set variable    /sales.microsite/esolutions/insurance/verifyPA
    Log    url = ${url}${uri}

    ${DATE}=    Get Current Date    result_format=%Y-%m-%d

    ${data}=    Evaluate    {"verifyPA":{"ProductCode":"${PRODUCT_ID_CHUBB}","InsureHeight":"175","InsureWeight":"80","BeneficiaryName":"","BeneficiaryRelation":"","BeneficiaryTel":"","EffectiveDate":"${DATE}","SumInsured":"${SUMINSUREDMIN_CHUBB}","LoanContractNumber":"${ACCOUNT_NO}","IsTaxAcceptTerm":${False},"trustID":"${CASE_ID}","AutoFlag":"N","ReceiptInfo":{},"Packages":${PACKAGES_CHUBB}}}    json
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Connection=keep-alive
    ...    Content-Type=application/json
    ...    Ocp-Apim-Subscription-Key=${SUBSCRIPTION_KEY_CHUBB} 
    ...    X-Authorization=${X-Auth_CHUBB}
    ...    apiVersion=1
    ...    Authorization=Bearer ${ACCESS_TOKEN_CHUBB}
    ...    Accept-Encoding=gzip, deflate, br

    Create Session    Receive    ${url}
    ${response}=    POST On Session    Receive    ${uri}    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    Should Be Equal As Strings    ${json["MsgStatusCd"]}    SUCCESS

    Set Global Variable    ${CONTRACT_NUMBER_CHUBB}    ${json["ContractNumber"]} 

Update Insurance CHUBB Information Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json  

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_CHUBB.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200
    # ${json}=    Convert String to JSON    ${response.content}

Update Insurance CHUBB QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json  

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_CHUBB_QR.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200

# Update Insurance CHUBB Pending Actions
#     ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
#     ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=PendingActions
#     Log    url = ${url}${uri}

#     ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_CHUBB_QR_Pending.json
#     ${json_text_replaced}=    Replace Variables    ${json_text}
#     ${json_data}=    Evaluate    json.loads($json_text_replaced)

#     ${headers}=    Create Dictionary
#     ...    Authorization=Bearer ${ACCESS_TOKEN}
#     ...    Connection=keep-alive
#     ...    Content-Type=application/json    

#     Create Session    update_case_Info    ${url}
#     ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
#     Should Be Equal As Strings    ${response.status_code}    200
#     Sleep    2s

Update Insurance CHUBB Information Consent QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_CHUBB.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     billPaymentInfo=${None}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     paymentMethod=QR
    ${qr_dict}=    Evaluate    {'ref1': '${APPLICATION_NO}', 'ref2': '${CUSTOMER_CIF}'}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}    qrPaymentInfo=${qr_dict}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     ktcPaymentInfo=${None}

    Log    ${json_data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json    

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

Update Insurance CHUBB Pending Actions QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=PendingActions
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_CHUBB.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     billPaymentInfo=${None}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     paymentMethod=QR
    ${qr_dict}=    Evaluate    {"transactionId":"${APP_ID}-1","compCode":"${COMP_CODE}","result":"PENDING","manuallyVerify":${True},"errorCode":"PAYMENT_STATUS_EXCEED_LIMIT"}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}    qrPaymentInfo=${qr_dict}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     ktcPaymentInfo=${None}
    
    ${documents_dict}=    Evaluate    {"documentId":"QR_EVIDENCE","uploadSessionId":"${PAYMENT_UPLOAD_SESSION_ID}","mode":"CAPTURE","cardNumber":"${MOCK_CardNumber}","appId":"${CASE_ID}"}
    Set To Dictionary    ${json_data['documentInfo']}     documents[1]=${documents_dict}

    Log    ${json_data}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json    

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s