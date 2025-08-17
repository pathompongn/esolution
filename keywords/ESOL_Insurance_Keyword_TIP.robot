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
Get Server TIP
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}
    
    ${headers}=    Create Dictionary
    ...    Connection=keep-alive

 
    Create Session    generate_server    ${url}
    ${response}=    GET On Session    generate_server    ${uri}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${set_cookie}=    Get From Dictionary    ${response.headers}    Set-Cookie

    Log To Console    ${set_cookie}
    ${set_cookie_re1}    Replace String       ${set_cookie}    Server=    ${EMPTY}
    ${set_cookie_re2}    Replace String       ${set_cookie_re1}    ; path=/; Httponly; Secure    ${EMPTY}
    
    Set Global Variable    ${SERVER_TIP}    ${set_cookie_re2}
    
TIP Get Access Token
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${data}=    Set Variable    [{"pr1":"ESO","pr2":"${CASE_ID}","pr3":"${PLAN_CODE}","pr4":"N"}]
    log    ${data}

    ${status_token}     Set Variable    False
    ${start}    Set Variable    0

    WHILE    ${start} < 10 and not ${status_token}
        ${headers}=    Create Dictionary
        ...    Connection=keep-alive
        ...    Next-Action=${next_action_token}
        ...    Cookie=Server=${SERVER_TIP}
        
        Create Session    tip    ${url}
        ${response}=    POST On Session    tip    ${uri}    data=${data}   headers=${headers}
        Should Be Equal As Strings    ${response.status_code}    200  
        Log    ${response.headers}
        ${status_token}     Run Keyword And Return Status     Get From Dictionary    ${response.headers}    Set-Cookie
        Exit For Loop If    ${status_token}
        Sleep    10s
        Get Server TIP
        ${start}=    Evaluate    ${start} + 1
    END

    ${set_cookie}    Get From Dictionary    ${response.headers}    Set-Cookie
    ${set_cookie_re1}    Replace String       ${set_cookie}    accessToken=    ${EMPTY}
    ${set_cookie_re2}    Replace String       ${set_cookie_re1}    ; Path=/    ${EMPTY}
    
    Set Global Variable    ${ACCESS_TOKEN_TIP}    ${set_cookie_re2}

TIP 2
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${data}=    Set Variable    [{"pr1":"ESO","pr2":"${CASE_ID}","pr3":"${PLAN_CODE}","pr4":"N"}]
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Connection=keep-alive
    ...    Next-Action=${next_action2}
    ...    Cookie=Server=${SERVER_TIP}; accessToken=${ACCESS_TOKEN_TIP}

    Create Session    tip    ${url}
    ${response}=    POST On Session    tip    ${uri}    data=${data}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200  
    

TIP 3
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${data}=    Set Variable    [{"pr1":"ESO","pr2":"${CASE_ID}","pr3":"${PLAN_CODE}","pr4":"N"}]
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Connection=keep-alive
    ...    Next-Action=${next_action3}
    ...    Cookie=Server=${SERVER_TIP}; accessToken=${ACCESS_TOKEN_TIP}

    Create Session    tip    ${url}
    ${response}=    POST On Session    tip    ${uri}    data=${data}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200  

TIP Get Subcampaign ID
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${data}=    Set Variable    [{"pr1":"ESO","pr2":"${CASE_ID}","pr3":"${PLAN_CODE}","pr4":"N"}]
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Connection=keep-alive
    ...    Next-Action=${next_action_subcampaign_id}
    ...    Cookie=Server=${SERVER_TIP}; accessToken=${ACCESS_TOKEN_TIP}

    Create Session    tip    ${url}
    ${response}=    POST On Session    tip    ${uri}    data=${data}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200  
    Log    ${response.content}
    Log    ${response.headers}

    ${response_text}=    Convert To String    ${response.content}
    ${response_text}=     Evaluate    '''${response_text}.encode("latin1").decode("utf-8")'''
    @{lines}=    Split String    ${response_text}    \n
    ${json_string}=    Replace String    ${lines[1]}    1:    ${EMPTY}
    # ${fixed_json}=    Evaluate    '''${json_string}.encode("latin1").decode("utf-8")'''
    ${json}=    Convert String to JSON    ${json_string}
    ${subcampaign_id}=    Get Value From Json    ${json}    $.data.planDetails.subcampaignId
    
    Set Global Variable    ${SUBCAMPAIGN_ID}    ${subcampaign_id}[0]


TIP Get Suminsured
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${data}=    Set Variable    ["${SUBCAMPAIGN_ID}"]
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Connection=keep-alive
    ...    Next-Action=${next_action_suminsured}
    ...    Cookie=Server=${SERVER_TIP}; accessToken=${ACCESS_TOKEN_TIP}


    Create Session    tip    ${url}
    ${response}=    POST On Session    tip    ${uri}    data=${data}   headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200  
    ${response_content}=     Evaluate    '''${response.content}.encode("latin1").decode("utf-8")'''
    ${response_text}=    Convert To String    ${response_content}

    @{lines}=    Split String    ${response_text}    \n
    ${json_string}=    Replace String    ${lines[1]}    1:    ${EMPTY}
    ${json}=    Convert String to JSON    ${json_string}

    ${totalpremium}=     Get Value From Json    ${json}    $.totalpremium
    ${stamp}=            Get Value From Json    ${json}    $.stamp
    ${vat}=              Get Value From Json    ${json}    $.vat
    ${amount}=           Get Value From Json    ${json}    $.amount
    ${suminsured}=       Get Value From Json    ${json}    $.suminsured
    ${medsuminsured}=    Get Value From Json    ${json}    $.medsuminsured  
    
    Set Global Variable    ${TOTALPREMIUM}    ${totalpremium}[0]
    Set Global Variable    ${STAMP}    ${stamp}[0]
    Set Global Variable    ${VAT}    ${vat}[0]
    Set Global Variable    ${AMOUNT}    ${amount}[0]
    Set Global Variable    ${SUMINSURED}    ${suminsured}[0]
    Set Global Variable    ${MEDSUMINSURED}    ${medsuminsured}[0]


TIP 6
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${data}=    Set Variable    []
    log    ${data}

    ${headers}=    Create Dictionary
    ...    Connection=keep-alive
    ...    Next-Action=${next_action6}
    ...    Cookie=Server=${SERVER_TIP}; accessToken=${ACCESS_TOKEN_TIP}


    Create Session    tip    ${url}
    ${response}=    POST On Session    tip    ${uri}    data=${data}   headers=${headers}
    ${response_content}=     Evaluate    '''${response.content}.encode("latin1").decode("utf-8")'''
    Should Be Equal As Strings    ${response.status_code}    200  
    Log    ${response_content.content}
    Log    ${response.headers}

TIP Submit
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_TIP}
    ${uri}=    Set Variable    /microsite/ktb_esolution?pr1=ESO&pr2=${CASE_ID}&pr3=${PLAN_CODE}&pr4=N
    Log    url = ${url}${uri}

    ${DATE}=    Get Current Date    result_format=%d/%m/%Y
    Set Global Variable    ${TODAY}    ${DATE}
    ${TIME}=    Get Current Date    result_format=%H:%M

    ${MOCK_DateOfBirth}     Convert Date    ${MOCK_DateOfBirth}    result_format=%d/%m/%Y

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/TIP_Submit.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    ${DATE}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S.%f
    ${Insurance_Period}    Convert To Integer    ${Insurance_Period}
    ${DAYS}    Evaluate    __import__('math').ceil(${Insurance_Period} * 365)
    ${Insurance_End}    Add Time To Date    ${DATE}    ${DAYS} days
    ${Insurance_End}     Convert Date    ${Insurance_End}    result_format=%d/%m/%Y
    ${ProductID_split}    Split String    ${ProductID}    -
    Log         ${PLAN_CODE}
    IF    '${DDR_Registration}' == 'true'
        Set To Dictionary    ${json_data[0]}    autoFlag=Y
    END
    IF    '${PLAN_CODE}' == 'EHC000057'      # สุขภาพอุ่นใจ
        Set To Dictionary    ${json_data[0]}     endDate=${Insurance_End} 
        Set To Dictionary    ${json_data[0]}    rdbQ1=N
        ...    rdbQ2=N
        ...    rdbQ3=N
        ...    rdbQ4=N
        ...    rdbQ5=N
        ...    rdbQ6=N
        ...    rdbQ7=N
    
    ELSE IF    '${PLAN_CODE}' == '${PLAN_CODE}'    # ไมโครอินชัวรันซ์
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}

    ELSE IF    '${PLAN_CODE}' == 'EPAS00021'    # สุขใจวัยเกษียณ
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}

    ELSE IF    '${PLAN_CODE}' == 'EHDHF1101'    # ไข้เลือดออก
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    medsuminsured=${MEDSUMINSURED}
        Delete Object From Json    ${json_data[0]}    $.diseases

    ELSE IF    '${PLAN_CODE}' == 'EPAPAY001'    # เปย์สบาย
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    rdbQ1=N
        ...    rdbQ2=N
        
    ELSE IF    '${PLAN_CODE}' == 'EPANL0031'    # สุขใจชิลล์
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    medsuminsured=${MEDSUMINSURED}

    ELSE IF    '${PLAN_CODE}' == 'EHCC11001'    # มะเร็งใจแตก
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    medsuminsured=${MEDSUMINSURED}
        Set To Dictionary    ${json_data[0]}    rdbQ1=N
        ...    rdbQ2=N    rdbQ3=N    rdbQ4=N
    
    ELSE IF    '${PLAN_CODE}' == 'EPM10001'    # PM2.5
        Set To Dictionary    ${json_data[0]}    brokerDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    brokerCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    brokerTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    brokerName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    brokerSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffDeptCode=${KCS_BRANCH_CODE}
        Set To Dictionary    ${json_data[0]}    staffCode=${User_ID}
        Set To Dictionary    ${json_data[0]}    staffTitle=นางสาว
        Set To Dictionary    ${json_data[0]}    staffName=${FirstNameEmployee}
        Set To Dictionary    ${json_data[0]}    staffSurName=${LastNameEmployee}
        Set To Dictionary    ${json_data[0]}    medsuminsured=${MEDSUMINSURED}
        Set To Dictionary    ${json_data[0]}    rdbQ1=N
        ...    rdbQ2=N
    
    END
    log    ${json_data}

    ${headers}=    Create Dictionary
    ...    Connection=keep-alive
    ...    Next-Action=${next_action_submit}
    ...    Cookie=Server=${SERVER_TIP}; accessToken=${ACCESS_TOKEN_TIP}

    Create Session    tip    ${url}
    ${response}=    POST On Session    tip    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200  
    ${json_content}=     Evaluate    '''${response.content}.encode("latin1").decode("utf-8")'''
    Log    ${json_content}

    ${response_text}=    Convert To String    ${json_content}

    @{lines}=    Split String    ${response_text}    \n
    ${json_string}=    Replace String    ${lines[1]}    1:    ${EMPTY}
    ${json}=    Convert String to JSON    ${json_string}

    ${respStatus}=     Get Value From Json    ${json}    $.respStatus
    ${errDesc}=        Get Value From Json    ${json}    $.errDesc

    Should Be Equal As Strings    ${respStatus}[0]    Success
    Should Be Equal As Strings    ${errDesc}[0]    Success

Update Insurance TIP Information Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_TIP.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json    

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

Update Insurance TIP QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_TIP.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     billPaymentInfo=${None}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     paymentMethod=QR
    ${qr_dict}=    Evaluate    {'ref1': '${APPLICATION_NO}', 'ref2': '${MOCK_CardNumber}ESO'}
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

Update Insurance TIP Pending Actions QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=PendingActions
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_TIP.json
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