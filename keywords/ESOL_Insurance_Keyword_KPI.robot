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
Generate Token KPI
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    ${uri}=    Set variable    ${URI_GENERATE_TOKEN_ID_KPI}
    Log    url = ${url}${uri}
    
    ${data}=    Set Variable    {"clientId":"eso_web","clientSecret":"2AEQiXdVp2ca1jcvbNE4AZvGbPGDTceo","service":"eso_web","uuid":"${UUID}"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=*/*
    ...    Accept-Encoding=gzip, deflate, br, zstd
    ...    Accept-Language=en-US,en;q=0.9,th;q=0.8,th-TH;q=0.7

    Create Session    generate_token    ${url}
    ${response}=    POST On Session    generate_token    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json}    accessToken
    Dictionary Should Contain Key    ${json}    refreshToken

    Set Global Variable    ${ACCESS_TOKEN_KPI}    ${json["accessToken"]}
    Set Global Variable    ${REFRESH_TOKEN_KPI}    ${json["refreshToken"]}

STEP 1 SUBMIT KPI Safe Loan
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_ktb_get}=    Set Variable    /saletools/transaction/ktb/get
    Log    url = ${url}${uri_transaction_ktb_get}

    ${data_transaction_ktb_get}=    Set Variable    {"caseID":"${CASE_ID}","planCode":"${PLAN_CODE}"}
    Log    ${data_transaction_ktb_get}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response1}=    POST On Session    transaction_kpi    ${uri_transaction_ktb_get}    data=${data_transaction_ktb_get}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json1}=    Convert String to JSON    ${response1.content}    
    Dictionary Should Contain Key    ${json1}    status
    Dictionary Should Contain Key    ${json1}    message
    Should Be Equal As Strings    ${json1["status"]}    True
    Should Be Equal As Strings    ${json1["message"]}    success

    #### insured/getAge
    ${uri_getAge}=    Set Variable    /saletools/insured/getAge
    Log    url = ${url}${uri_getAge}

    ${data_getAge}=    Set Variable    {"caseID":"${CASE_ID}"}
    Log    ${data_getAge}

    ${response2}=    POST On Session    transaction_kpi    ${uri_getAge}    data=${data_getAge}    headers=${headers}
    Should Be Equal As Strings    ${response2.status_code}    200
    ${json2}=    Convert String to JSON    ${response2.content}   
    Dictionary Should Contain Key    ${json2}    status
    Dictionary Should Contain Key    ${json2}    message
    Should Be Equal As Strings    ${json2["status"]}    True
    Should Be Equal As Strings    ${json2["message"]}    success

    ####### getSumInsuredList
    ${uri_getSumInsuredList}=    Set Variable    /saletools/plan/getSumInsuredList
    Log    url = ${url}${uri_getSumInsuredList}

    # ${data_getSumInsuredList}=    Set Variable    {"caseID":"${CASE_ID}","paType": "${PA_Type}"}
    ${data_getSumInsuredList}=    Set Variable    {"caseID":"${CASE_ID}"}
    Log    ${data_getSumInsuredList}

    ${response3}=    POST On Session    transaction_kpi    ${uri_getSumInsuredList}    data=${data_getSumInsuredList}    headers=${headers}
    Should Be Equal As Strings    ${response3.status_code}    200
    ${json3}=    Convert String to JSON    ${response3.content}   
    Dictionary Should Contain Key    ${json3}    status
    Dictionary Should Contain Key    ${json3}    message

    Should Be Equal As Strings    ${json3["status"]}    True
    Should Be Equal As Strings    ${json3["message"]}    success
    Should Be Equal As Strings    ${json3["data"]["result"]["resultMessage"]}    success

    Set Global Variable    ${SumInsuredMin}    ${json3["data"]["plan.sumInsured"][0]}

    ####### plan/get
    ${uri_plan_get}=    Set Variable    /saletools/plan/get
    Log    url = ${url}${uri_plan_get}

    ${data_plan_get}=    Set Variable    {"transactionId": "${CASE_ID}"}
    Log    ${data_plan_get}

    ${response4}=    POST On Session    transaction_kpi    ${uri_plan_get}    data=${data_plan_get}    headers=${headers}
    Should Be Equal As Strings    ${response4.status_code}    200
    ${json4}=    Convert String to JSON    ${response4.content}   
    Dictionary Should Contain Key    ${json4}    status
    Dictionary Should Contain Key    ${json4}    message

    Should Be Equal As Strings    ${json4["status"]}    True
    Should Be Equal As Strings    ${json4["message"]}    success

    ##### getYearList
    ${uri_getYearList}=    Set Variable    /saletools/plan/getYearList
    Log    url = ${url}${uri_getYearList}

    # ${data_getYearList}=    Set Variable    {"caseID":"${CASE_ID}","paType":"${PA_Type}","sumInsured":${SumInsuredMin}}
    ${data_getYearList}=    Set Variable    {"caseID":"${CASE_ID}","sumInsured":${SumInsuredMin}}
    Log    ${data_getYearList}

    ${response5}=    POST On Session    transaction_kpi    ${uri_getYearList}    data=${data_getYearList}    headers=${headers}
    Should Be Equal As Strings    ${response5.status_code}    200
    ${json5}=    Convert String to JSON    ${response5.content}   
    Dictionary Should Contain Key    ${json5}    status
    Dictionary Should Contain Key    ${json5}    message

    Should Be Equal As Strings    ${json5["status"]}    True
    Should Be Equal As Strings    ${json5["message"]}    success
    Should Be Equal As Strings    ${json5["data"]["result"]["resultMessage"]}    success

    Set Global Variable    ${periodMin}    ${json5["data"]["plan.period"][0]}

    ##### getFromKPI
    ${uri_getFromKPI}=    Set Variable    /saletools/plan/getFromKPI
    Log    url = ${url}${uri_getFromKPI}

    # ${data_getFromKPI}=    Set Variable    {"caseID":"${CASE_ID}","paType":"superprotection","sumInsured":${SumInsuredMin},"period": 1}
    ${data_getFromKPI}=    Set Variable    {"caseID":"${CASE_ID}","sumInsured":${SumInsuredMin},"period": ${periodMin}}
    Log    ${data_getFromKPI}

    ${response6}=    POST On Session    transaction_kpi    ${uri_getFromKPI}    data=${data_getFromKPI}    headers=${headers}
    Should Be Equal As Strings    ${response6.status_code}    200
    ${json6}=    Convert String to JSON    ${response6.content}   
    Dictionary Should Contain Key    ${json6}    status
    Dictionary Should Contain Key    ${json6}    message

    Should Be Equal As Strings    ${json6["status"]}    True
    Should Be Equal As Strings    ${json6["message"]}    success
    Should Be Equal As Strings    ${json6["data"]["result"]["resultMessage"]}    success

    Set Global Variable    ${PRODUCT_NAME_TH}    ${json6["data"]["plan"][0]["planNameTh"]} 
    Set Global Variable    ${PRODUCT_CODE_KPI}    ${json6["data"]["plan"][0]["productCode"]} 

    ##### submit
    ${uri_submit}=    Set Variable    /saletools/plan/submit
    Log    url = ${url}${uri_submit}

    ${DATE}=    Get Current Date    result_format=%Y%m%d
    Set Global Variable    ${TODAY}    ${DATE}

    ${data_submit}=    Set Variable    {"transactionId":"${CASE_ID}","productCode":"${PRODUCT_CODE_KPI}","productId":"${PRODUCT_CODE_KPI}","coverStartDate":"${DATE}","sumInsured":${SumInsuredMin},"period":${periodMin}}
    Log    ${data_submit}

    ${response7}=    POST On Session    transaction_kpi    ${uri_submit}    data=${data_submit}    headers=${headers}
    Should Be Equal As Strings    ${response7.status_code}    200
    ${json7}=    Convert String to JSON    ${response7.content}   
    Dictionary Should Contain Key    ${json7}    status
    Dictionary Should Contain Key    ${json7}    message

    Should Be Equal As Strings    ${json7["status"]}    True
    Should Be Equal As Strings    ${json7["message"]}    success

    Set Global Variable    ${DATA_ID}    ${json7["data"]["id"]}
    Set Global Variable    ${TOTAL_PREM}    ${json7["data"]["totalPrem"]}
    Set Global Variable    ${PRODUCT_NAME_TH}    ${json7["data"]["productNameTh"]}
    Set Global Variable    ${PRODUCT_NAME_EN}    ${json7["data"]["productNameEn"]}

STEP 1 SUBMIT KPI No-Worry Loan
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_ktb_get}=    Set Variable    /saletools/transaction/ktb/get
    Log    url = ${url}${uri_transaction_ktb_get}

    ${data_transaction_ktb_get}=    Set Variable    {"caseID":"${CASE_ID}","planCode":"${PLAN_CODE}"}
    Log    ${data_transaction_ktb_get}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response1}=    POST On Session    transaction_kpi    ${uri_transaction_ktb_get}    data=${data_transaction_ktb_get}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json1}=    Convert String to JSON    ${response1.content}    
    Dictionary Should Contain Key    ${json1}    status
    Dictionary Should Contain Key    ${json1}    message
    Should Be Equal As Strings    ${json1["status"]}    True
    Should Be Equal As Strings    ${json1["message"]}    success

    #### insured/getAge
    ${uri_getAge}=    Set Variable    /saletools/insured/getAge
    Log    url = ${url}${uri_getAge}

    ${data_getAge}=    Set Variable    {"caseID":"${CASE_ID}"}
    Log    ${data_getAge}

    ${response2}=    POST On Session    transaction_kpi    ${uri_getAge}    data=${data_getAge}    headers=${headers}
    Should Be Equal As Strings    ${response2.status_code}    200
    ${json2}=    Convert String to JSON    ${response2.content}   
    Dictionary Should Contain Key    ${json2}    status
    Dictionary Should Contain Key    ${json2}    message
    Should Be Equal As Strings    ${json2["status"]}    True
    Should Be Equal As Strings    ${json2["message"]}    success

    ####### getSumInsuredList
    ${uri_getSumInsuredList}=    Set Variable    /saletools/plan/getSumInsuredList
    Log    url = ${url}${uri_getSumInsuredList}

    ${data_getSumInsuredList}=    Set Variable    {"caseID":"${CASE_ID}","paType": "${PA_Type}"}
    Log    ${data_getSumInsuredList}

    ${response3}=    POST On Session    transaction_kpi    ${uri_getSumInsuredList}    data=${data_getSumInsuredList}    headers=${headers}
    Should Be Equal As Strings    ${response3.status_code}    200
    ${json3}=    Convert String to JSON    ${response3.content}   
    Dictionary Should Contain Key    ${json3}    status
    Dictionary Should Contain Key    ${json3}    message

    Should Be Equal As Strings    ${json3["status"]}    True
    Should Be Equal As Strings    ${json3["message"]}    success
    Should Be Equal As Strings    ${json3["data"]["result"]["resultMessage"]}    success

    Set Global Variable    ${SumInsuredMin}    ${json3["data"]["plan.sumInsured"][0]}

    ####### plan/get
    ${uri_plan_get}=    Set Variable    /saletools/plan/get
    Log    url = ${url}${uri_plan_get}

    ${data_plan_get}=    Set Variable    {"transactionId": "${CASE_ID}"}
    Log    ${data_plan_get}

    ${response4}=    POST On Session    transaction_kpi    ${uri_plan_get}    data=${data_plan_get}    headers=${headers}
    Should Be Equal As Strings    ${response4.status_code}    200
    ${json4}=    Convert String to JSON    ${response4.content}   
    Dictionary Should Contain Key    ${json4}    status
    Dictionary Should Contain Key    ${json4}    message

    Should Be Equal As Strings    ${json4["status"]}    True
    Should Be Equal As Strings    ${json4["message"]}    success

    ##### getYearList
    ${uri_getYearList}=    Set Variable    /saletools/plan/getYearList
    Log    url = ${url}${uri_getYearList}

    ${data_getYearList}=    Set Variable    {"caseID":"${CASE_ID}","paType":"${PA_Type}","sumInsured":${SumInsuredMin}}
    Log    ${data_getYearList}

    ${response5}=    POST On Session    transaction_kpi    ${uri_getYearList}    data=${data_getYearList}    headers=${headers}
    Should Be Equal As Strings    ${response5.status_code}    200
    ${json5}=    Convert String to JSON    ${response5.content}   
    Dictionary Should Contain Key    ${json5}    status
    Dictionary Should Contain Key    ${json5}    message

    Should Be Equal As Strings    ${json5["status"]}    True
    Should Be Equal As Strings    ${json5["message"]}    success
    Should Be Equal As Strings    ${json5["data"]["result"]["resultMessage"]}    success

    Set Global Variable    ${periodMin}    ${json5["data"]["plan.period"][0]}

    ##### getFromKPI
    ${uri_getFromKPI}=    Set Variable    /saletools/plan/getFromKPI
    Log    url = ${url}${uri_getFromKPI}

    ${data_getFromKPI}=    Set Variable    {"caseID":"${CASE_ID}","paType":"superprotection","sumInsured":${SumInsuredMin},"period": 1}
    Log    ${data_getFromKPI}

    ${response6}=    POST On Session    transaction_kpi    ${uri_getFromKPI}    data=${data_getFromKPI}    headers=${headers}
    Should Be Equal As Strings    ${response6.status_code}    200
    ${json6}=    Convert String to JSON    ${response6.content}   
    Dictionary Should Contain Key    ${json6}    status
    Dictionary Should Contain Key    ${json6}    message

    Should Be Equal As Strings    ${json6["status"]}    True
    Should Be Equal As Strings    ${json6["message"]}    success
    Should Be Equal As Strings    ${json6["data"]["result"]["resultMessage"]}    success

    Set Global Variable    ${PRODUCT_NAME_TH}    ${json6["data"]["plan"][0]["planNameTh"]} 
    Set Global Variable    ${PRODUCT_CODE_KPI}    ${json6["data"]["plan"][0]["productCode"]} 

    ##### submit
    ${uri_submit}=    Set Variable    /saletools/plan/submit
    Log    url = ${url}${uri_submit}

    ${DATE}=    Get Current Date    result_format=%Y%m%d
    Set Global Variable    ${TODAY}    ${DATE}

    ${data_submit}=    Set Variable    {"transactionId":"${CASE_ID}","productCode":"${PRODUCT_CODE_KPI}","productId":"${PRODUCT_CODE_KPI}","coverStartDate":"${DATE}","sumInsured":${SumInsuredMin},"period":${periodMin}}
    Log    ${data_submit}

    ${response7}=    POST On Session    transaction_kpi    ${uri_submit}    data=${data_submit}    headers=${headers}
    Should Be Equal As Strings    ${response7.status_code}    200
    ${json7}=    Convert String to JSON    ${response7.content}   
    Dictionary Should Contain Key    ${json7}    status
    Dictionary Should Contain Key    ${json7}    message

    Should Be Equal As Strings    ${json7["status"]}    True
    Should Be Equal As Strings    ${json7["message"]}    success

    Set Global Variable    ${DATA_ID}    ${json7["data"]["id"]}
    Set Global Variable    ${TOTAL_PREM}    ${json7["data"]["totalPrem"]}
    Set Global Variable    ${PRODUCT_NAME_TH}    ${json7["data"]["productNameTh"]}
    Set Global Variable    ${PRODUCT_NAME_EN}    ${json7["data"]["productNameEn"]}

STEP 2 UPDATE KPI
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### getByTransactionId
    ${uri_getByTransactionId}=    Set Variable    /saletools/insured/getByTransactionId
    Log    url = ${url}${uri_getByTransactionId}

    ${data_getByTransactionId}=    Evaluate    {"transactionId": "${CASE_ID}"}    json
    Log    ${data_getByTransactionId}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response1}=    POST On Session    transaction_kpi    ${uri_getByTransactionId}    json=${data_getByTransactionId}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json1}=    Convert String to JSON    ${response1.content}    
    Dictionary Should Contain Key    ${json1}    status
    Dictionary Should Contain Key    ${json1}    message
    Should Be Equal As Strings    ${json1["status"]}    True
    Should Be Equal As Strings    ${json1["message"]}    success

    ### insured/update
    ${uri_update}=    Set Variable    /saletools/insured/update
    Log    url = ${url}${uri_update}

    ${data_update}=    Evaluate    {"transactionId":"${CASE_ID}","id":${DATA_ID},"titleId":2,"nameTH":"${MOCK_ThaiFirstName}","surNameTH":"${MOCK_ThaiLastName}","nationality":"TH","nationalityTH":"ไทย","nationalityEng":"Thai","idcard":"${MOCK_CardNumber}","loanAmt":${Loan_Amount},"loanTerm":${Loan_Term_Year},"loanTerm2":${Loan_Term_Months},"occupationCode":"0400","occupationRemark":"","maritalStatus":"S","legalHouseNo":"111","legalMoo":"บางบัวทอง","legalLane":"","legalRoad":"21","legalSubDistrictCode":"810303","legalDistrictCode":"8103","legalProvinceCode":"81","legalPostalCode":"81120","legalCountry":"TH","sendPolicyBy":"E","email":"${Email}","mobilePhone":"${OTP_Tel}"}    json
    Log    ${data_update}

    Create Session    transaction_kpi    ${url}
    ${response2}=    POST On Session    transaction_kpi    ${uri_update}    json=${data_update}    headers=${headers}
    Should Be Equal As Strings    ${response2.status_code}    200
    ${json2}=    Convert String to JSON    ${response2.content}   

    Dictionary Should Contain Key    ${json2}    status
    Dictionary Should Contain Key    ${json2}    message

    Should Be Equal As Strings    ${json2["status"]}    True
    Should Be Equal As Strings    ${json2["message"]}    success
    Should Be Equal As Strings    ${json2["data"]["status"]}    True

STEP 3 SUBMIT health Question KPI PAL00050
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### healthQuestion
    ${uri_healthQuestion}=    Set Variable    /saletools/transaction/healthQuestion/submit
    Log    url = ${url}${uri_healthQuestion}

    ${data_healthQuestion}=    Evaluate    {"transactionId":"${CASE_ID}","healthQuestionAnswer":[{"questionId":"TMQ043","questionDescTh":"ท่านมีหรือได้ขอเอาประกันภัยสุขภาพ ประกันภัยอุบัติเหตุ หรือประกันชีวิต ไว้กับบริษัทอื่น หรือบริษัท กรุงไทยพานิชประกันภัย จำกัด (มหาชน) หรือไม่?","questionDescEn":"","answer":"N","answerDetail":""},{"questionId":"TMQ064","questionDescTh":"ท่านกำลังป่วยเป็น หรือเคยเป็น หรือมีอาการรับรู้ได้ด้วยตนเอง หรือเคยได้รับการตรวจรักษา หรือบอกกล่าว หรือคำแนะนำจากแพทย์เกี่ยวกับโรคลมชัก โรคหัวใจ โรคภาวะหายใจอุดกั้น โรคความดันโลหิตสูง โรคเบาหวาน โรคมะเร็งทุกชนิด โรคกระดูกหรือกล้ามเนื้อ โรคเอดส์หรือมีเชื้อไวรัส HIV โรค SLE / DLE หรือมีความผิดปกติที่ร้ายแรงทางร่างกายหรือจิตใจ หรือไม่?","questionDescEn":"","answer":"N","answerDetail":""}]}    json
    Log    ${data_healthQuestion}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri_healthQuestion}    json=${data_healthQuestion}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}    

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message
    
    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

STEP 3 SUBMIT health Question KPI HL000005
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### healthQuestion
    ${uri_healthQuestion}=    Set Variable    /saletools/transaction/healthQuestion/submit
    Log    url = ${url}${uri_healthQuestion}

    ${data_healthQuestion}=     Evaluate     {"transactionId":"${CASE_ID}","healthQuestionAnswer":[{"questionId":"PABQ001","answer":"N","questionDescEn":"","questionDescTh":"ท่านเคยถูกปฏิเสธการขอเอาประกันชีวิต หรือการขอเอาประกันภัยอุบัติเหตุ หรือการขอเอาประกันภัยโรคร้ายแรง หรือถูกปฏิเสธการต่ออายุสัญญาประกันภัยหรือถูกเรียกเก็บเบี้ยประกันภัยเพิ่ม หรือ เปลี่ยนแปลงเงื่อนไขสำหรับการประกันภัยดังกล่าวหรือไม่","answerDetail":""},{"questionId":"PABQ002","answer":"N","questionDescEn":"","questionDescTh":"ในระยะเวลา 5 ปีที่ผ่านมา ท่านเคยเจ็บป่วย หรือได้รับบาดเจ็บ หรือเคยเข้าพักรักษาตัวในโรงพยาบาล หรือสถานพยาบาลเวชกรรมด้วยสาเหตุของโรค หรือการบาดเจ็บร้ายแรงใช่หรือไม่","answerDetail":""},{"questionId":"PABQ003","answer":"N","questionDescEn":"","questionDescTh":"ท่านเคยได้รับการรักษา หรือเคยได้รับการบอกเล่าจากแพทย์ ว่าท่านเป็นโรคหัวใจ โรคความดันโลหิต โรคตับ โรคไต โรคเบาหวาน โรคลมชัก โรคเอดส์ หรือมีเลือดบวกต่อไวรัส HIV โรคเลือด โรคเกี่ยวกับสมอง โรคมะเร็ง โรคปอด โรคของกระดูกและกล้ามเนื้อ โรคของระบบทางเดินอาหาร หรือโรคอื่นใด หรือ มีโรคประจำตัวใช่หรือไม่","answerDetail":""},{"questionId":"PABQ004","answer":"N","questionDescEn":"","questionDescTh":"ขณะนี้ท่านกำลังเจ็บป่วย หรือบาดเจ็บ หรือมีอวัยวะส่วนหนึ่งส่วนใดพิการหรือไม่สมประกอบ หรือมีความบกพร่องทางจิต ใช่หรือไม่","answerDetail":""},{"questionId":"PABQ005","answer":"N","questionDescEn":"","questionDescTh":"ท่านเคยใช้ยาเสพติดให้โทษ หรือดื่มสุรา หรือสิ่งมึนเมา หรือเครื่องดื่มที่มีแอลกอฮอล์เป็นประจำ หรือเคยรับการรักษาเกี่ยวกับโรคพิษสุราเรื้อรังหรือยาเสพติดให้โทษ ใช่หรือไม่","answerDetail":""}]}    json
    Log    ${data_healthQuestion}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri_healthQuestion}    json=${data_healthQuestion}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}    

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message
    
    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

STEP 4 SUBMIT createOrUpdate KPI
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### createOrUpdate
    ${uri_createOrUpdate}=    Set Variable    /saletools/beneficiary/createOrUpdate
    Log    url = ${url}${uri_createOrUpdate}

    ${data_createOrUpdate}=    Evaluate    {"transactionId":"${CASE_ID}","beneficiaries":[{"transactionId":"${CASE_ID}","order":1,"baneficiaryType":"P","nameTH":"ตามกฎหมายกำหนด","relationCode":999,"ratio":100,"remark":"remarked","relationTH":"ตามกฎหมายกำหนด"}]}    json
    Log    ${data_createOrUpdate}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri_createOrUpdate}    json=${data_createOrUpdate}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}    

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

STEP 5 CONSENT SUBMIT KPI
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### taxExemption
    ${uri_taxExemption}=    Set Variable    /saletools/transaction/taxExemption/submit
    Log    url = ${url}${uri_taxExemption}

    ${data_taxExemption}=    Evaluate    {"transactionId":"${CASE_ID}","taxExemption":${False},"taxExemptionId":"${MOCK_CardNumber}"}    json
    Log    ${data_taxExemption}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response1}=    POST On Session    transaction_kpi    ${uri_taxExemption}    json=${data_taxExemption}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json1}=    Convert String to JSON    ${response1.content}    

    Dictionary Should Contain Key    ${json1}    status
    Dictionary Should Contain Key    ${json1}    message

    Should Be Equal As Strings    ${json1["status"]}    True
    Should Be Equal As Strings    ${json1["message"]}    success

    #### consent/submit
    ${uri_consent}=    Set Variable    /saletools/transaction/consent/submit
    Log    url = ${url}${uri_consent}

    ${data_consent}=    Set Variable    {"transactionId":"${CASE_ID}","consent":true,"consentCheck":true}
    Log    ${data_consent}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response2}=    POST On Session    transaction_kpi    ${uri_consent}    data=${data_consent}    headers=${headers}
    Should Be Equal As Strings    ${response2.status_code}    200
    ${json2}=    Convert String to JSON    ${response2.content}    

    Dictionary Should Contain Key    ${json2}    status
    Dictionary Should Contain Key    ${json2}    message

    Should Be Equal As Strings    ${json2["status"]}    True
    Should Be Equal As Strings    ${json2["message"]}    success

Review Data KPT
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    ${uri}=    Set Variable    /saletools/transaction/review
    Log    url = ${url}${uri}

    ${data}=    Evaluate    {"transactionId":"${CASE_ID}"}    json
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri}    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}    

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

Confirm KPI
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    ${uri}=    Set Variable    /saletools/transaction/confirm
    Log    url = ${url}${uri}

    ${data}=    Evaluate    {"transactionId":"${CASE_ID}"}    json
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}
    ...    Accept-Encoding=gzip, deflate, br
    ...    Connection=keep-alive

    Create Session    transaction_kpi    ${url}
    ${response}=    POST On Session    transaction_kpi    ${uri}    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}    

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success
    Should Be Equal As Strings    ${json["data"]}    send premium success

Update Insurance KPI Information Consent
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_KPI.json
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

Update Insurance KPI Nonlife Information Consent
    [Arguments]    ${medthod}=tranfer
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_KPI_Nonlife.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    IF    "${medthod}"=="QR"
        ${productInfo}=    Set Variable    [{"productId":"${VC_SELECT_PRODUCT}","productCode":"${PLAN_CODE}","productName":"ประกัน PA สุขใจชัวร์","productTypeId":"NL-1","productTypeCode":"NL","productBusinessCode":"${PLAN_CODE}","subCategoryCode":"NLPANL","appId":"${APP_ID}","detailedSaleSheetLink":"b26c2df9-bfc3-4f4c-ad88-4ddbf8263cf7","companyId":"${COMPANY_ID}","companyName":"${Company_Name}","refererName":"${FirstNameEmployee} ${LastNameEmployee}","refererBranchCode":"${OLD_KCS_BRANCH_CODE}","planName":"${PLAN_DESC}","selectedBranch":"${KCS_BRANCH_CODE}","loanApplication":null,"planId":"${PLAN_ID}","planCode":"${PLAN_CODE}","refererId":"${User_ID}","customerAddrVerified":true,"insurancePremium":${INSURANCE_PREMIUM},"amt":${INSURANCE_PREMIUM},"appFormUploadSessionId":"${APP_FORM_UPLOAD_SESSION_ID}","ddrRegistration":${DDR_Registration},"billPaymentInfo":null,"ktcPaymentInfo":null,"qrPaymentInfo":{"ref1":"${APPLICATION_NO}"},"paymentMethod":"QR"}]
        ${productInfo}    Replace Variables    ${productInfo}  
        ${productInfo} =   Evaluate    json.loads('${productInfo}')
        Set To Dictionary    ${json_data['productInfo']}     insuranceTransactions=${productInfo}
    END
    

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Connection=keep-alive
    ...    Content-Type=application/json    

    Create Session    update_case_Info    ${url}
    ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

# Update Insurance KPI QR
#     ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
#     ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
#     Log    url = ${url}${uri}

#     ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_KPI_QR.json
#     ${json_text_replaced}=    Replace Variables    ${json_text}
#     ${json_data}=    Evaluate    json.loads($json_text_replaced)

#     ${headers}=    Create Dictionary
#     ...    Authorization=Bearer ${ACCESS_TOKEN}
#     ...    Connection=keep-alive
#     ...    Content-Type=application/json    

#     Create Session    update_case_Info    ${url}
#     ${response}=    PUT On Session    update_case_Info    ${uri}    headers=${headers}    json=${json_data}
#     Should Be Equal As Strings    ${response.status_code}    200


Status Payment KPI
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_INSURANCE}/${CASE_ID}/payment/${APP_ID}-1/status?action=PendingActions
    Log    url = ${url}${uri}
    
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    
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

    IF    '${json["result"]} ' == 'SUCCESS'
        ${QR_Payment_Status}=    Set Variable    ${True}
    ELSE
        ${QR_Payment_Status}=    Set Variable    ${False}
        Should Be Equal As Strings    ${json["errDesc"]}    Payment status checking exceeded limit 3 times
    END

    Set Test Variable    ${QR_Payment_Status}    ${QR_Payment_Status}



Update Insurance KPI Pending Actions
    [Arguments]    ${medthod}=tranfer
    IF    ${QR_Payment_Status} == ${False}
        ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
        ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=PendingActions
        Log    url = ${url}${uri}

        ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_KPI_Nonlife.json
        ${json_text_replaced}=    Replace Variables    ${json_text}
        ${json_data}=    Evaluate    json.loads($json_text_replaced)
        
        IF    "${medthod}"=="QR"
            ${productInfo}=    Set Variable    [{"productId":"${VC_SELECT_PRODUCT}","productCode":"${PLAN_CODE}","productName":"ประกัน PA สุขใจชัวร์","productTypeId":"NL-1","productTypeCode":"NL","productBusinessCode":"${PLAN_CODE}","subCategoryCode":"NLPANL","appId":"${APP_ID}","detailedSaleSheetLink":"b26c2df9-bfc3-4f4c-ad88-4ddbf8263cf7","companyId":"${COMPANY_ID}","companyName":"${Company_Name}","refererName":"${FirstNameEmployee} ${LastNameEmployee}","refererBranchCode":"${OLD_KCS_BRANCH_CODE}","planName":"${PLAN_DESC}","selectedBranch":"${KCS_BRANCH_CODE}","loanApplication":null,"planId":"${PLAN_ID}","planCode":"${PLAN_CODE}","refererId":"${User_ID}","customerAddrVerified":true,"insurancePremium":${INSURANCE_PREMIUM},"amt":${INSURANCE_PREMIUM},"appFormUploadSessionId":"${APP_FORM_UPLOAD_SESSION_ID}","ddrRegistration":${DDR_Registration},"billPaymentInfo":null,"ktcPaymentInfo":null,"qrPaymentInfo":{"ref1":"${APPLICATION_NO}"},"paymentMethod":"QR"}]
            ${productInfo}    Replace Variables    ${productInfo}  
            ${productInfo} =   Evaluate    json.loads('${productInfo}')
            Set To Dictionary    ${json_data['productInfo']}     insuranceTransactions=${productInfo}
        END

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
    END
Update Insurance KPI QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=Consent
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_KPI.json
    ${json_text_replaced}=    Replace Variables    ${json_text}
    ${json_data}=    Evaluate    json.loads($json_text_replaced)

    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     billPaymentInfo=${None}
    Set To Dictionary    ${json_data['productInfo']['insuranceTransactions'][0]}     paymentMethod=QR
    ${qr_dict}=    Evaluate    {'ref1': '${APPLICATION_NO}'}
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

Update Insurance KPI Pending Actions QR
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}
    ${uri}=    Set Variable    ${URI_ESOL_CASE}/${CASE_ID}?action=PendingActions
    Log    url = ${url}${uri}

    ${json_text}=    Get File   ${CURDIR}/../resources/data/json/Insurance_KPI.json
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

KPI Nonlife Get Transaction KTB
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_ktb_get}=    Set Variable    /saletools/transaction/ktb/get
    Log    url = ${url}${uri_transaction_ktb_get}

    ${data_transaction_ktb_get}=    Set Variable    {"caseID":"${CASE_ID}","planCode":"${PLAN_CODE}"}
    Log    ${data_transaction_ktb_get}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    transaction_kpi    ${url}
    ${response1}=    POST On Session    transaction_kpi    ${uri_transaction_ktb_get}    data=${data_transaction_ktb_get}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json1}=    Convert String to JSON    ${response1.content}    
    Dictionary Should Contain Key    ${json1}    status
    Dictionary Should Contain Key    ${json1}    message
    Should Be Equal As Strings    ${json1["status"]}    True
    Should Be Equal As Strings    ${json1["message"]}    success

KPI Nonlife Get Suminsured
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_get_suminsured}=    Set Variable    /saletools/plan/getFromKPI
    Log    url = ${url}${uri_transaction_get_suminsured}

    ${body}=    Create Dictionary
    ...    caseID=${CASE_ID}
    ...    paType=${PA_Type}
    ...    planCode=${PLAN_CODE}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    get_suminsured    ${url}
    ${response1}=    POST On Session    get_suminsured    ${uri_transaction_get_suminsured}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json}=    Convert String to JSON    ${response1.content}    
    Dictionary Should Contain Key    ${json["data"]["plan"][0]["plan"][0]}    sumInsured
    Set Test Variable    ${SumInsuredMin}    ${json["data"]["plan"][0]["plan"][0]["sumInsured"]}

KPI Nonlife Get Plan Detail
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_get_plan_detail}=    Set Variable    /saletools/plan/get
    Log    url = ${url}${uri_transaction_get_plan_detail}

    ${body}=    Create Dictionary
    ...    transactionId=${CASE_ID}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    get_suminsured    ${url}
    ${response1}=    POST On Session    get_suminsured    ${uri_transaction_get_plan_detail}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200

KPI Nonlife Step 1 Submit
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_submit}=    Set Variable    /saletools/plan/submit
    Log    url = ${url}${uri_transaction_submit}

    ${DATE}=    Get Current Date    result_format=%Y%m%d
    Set Test Variable    ${TODAY}    ${DATE}
    
    ${body}=    Create Dictionary
    ...    transactionId=${CASE_ID}
    ...    productCode=${kpi_productCode}
    ...    productId=${kpi_productId}
    ...    planCode=${PLAN_CODE}
    ...    coverStartDate=${TODAY}
    ...    sumInsured=${SumInsuredMin}
    ...    period=${3}
    ...    sex=M

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    get_suminsured    ${url}
    ${response1}=    POST On Session    get_suminsured    ${uri_transaction_submit}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json}=    Convert String to JSON    ${response1.content}

    Dictionary Should Contain Key    ${json["data"]}    id
    Set Test Variable    ${DATA_ID}    ${json["data"]["id"]}

KPI Nonlife Step 2 Update
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_update}=    Set Variable    /saletools/insured/update
    Log    url = ${url}${uri_transaction_update}
    
    ${body}=    Create Dictionary
    ...    transactionId=${CASE_ID}
    ...    id=${DATA_ID}  # ใช้ตัวแปรที่เป็นตัวเลข
    ...    titleId=${2}             # ตัวเลขสามารถใส่โดยตรง
    ...    nameTH=${MOCK_ThaiFirstName}
    ...    surNameTH=${MOCK_ThaiLastName}
    ...    nationality=TH
    ...    nationalityTH=ไทย
    ...    nationalityEng=Thai
    ...    idcard=${MOCK_CardNumber}
    ...    telHome=${EMPTY}          # สำหรับสตริงว่าง
    ...    telOffice=029000000
    ...    mobilePhone=${OTP_Tel}
    ...    loanAmt=${0}              # ตัวเลข
    ...    loanTerm=${None}          # สำหรับค่า null ใน JSON
    ...    loanTerm2=${None}         # สำหรับค่า null ใน JSON
    ...    occupationCode=0400
    ...    occupationRemark=${EMPTY}
    ...    maritalStatus=S
    ...    legalHouseNo=111
    ...    legalMoo=บางบัวทอง
    ...    legalLane=${EMPTY}
    ...    legalRoad=21
    ...    legalSubDistrictCode=810303
    ...    legalDistrictCode=8103
    ...    legalProvinceCode=81
    ...    legalPostalCode=81120
    ...    legalCountry=TH
    ...    weight=0.00
    ...    height=0.00
    ...    mobilePhoneCareCard=${OTP_Tel}
    ...    sendPolicyBy=E
    ...    email=${Email}
    ...    mobilePhoneContact=${OTP_Tel}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    get_suminsured    ${url}
    ${response1}=    POST On Session    get_suminsured    ${uri_transaction_update}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json}=    Convert String to JSON    ${response1.content}

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success
    Should Be Equal As Strings    ${json["data"]["status"]}    True


KPI Nonlife Step 3 Submit Health Question
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_submit}=    Set Variable    /saletools/transaction/healthQuestion/submit
    Log    url = ${url}${uri_transaction_submit}
    
    ${body}=    Evaluate    {"transactionId":"${CASE_ID}","healthQuestionAnswer":[{"questionId":"TMQ043","questionDescTh":"ท่านมีหรือได้ขอเอาประกันภัยสุขภาพ ประกันภัยอุบัติเหตุ หรือประกันชีวิต ไว้กับบริษัทอื่น หรือบริษัท กรุงไทยพานิชประกันภัย จำกัด (มหาชน) หรือไม่?","questionDescEn":"","answer":"N","answerDetail":""},{"questionId":"TMQ064","questionDescTh":"ท่านกำลังป่วยเป็น หรือเคยเป็น หรือมีอาการรับรู้ได้ด้วยตนเอง หรือเคยได้รับการตรวจรักษา หรือบอกกล่าว หรือคำแนะนำจากแพทย์เกี่ยวกับโรคลมชัก โรคหัวใจ โรคภาวะหายใจอุดกั้น โรคความดันโลหิตสูง โรคเบาหวาน โรคมะเร็งทุกชนิด โรคกระดูกหรือกล้ามเนื้อ โรคเอดส์หรือมีเชื้อไวรัส HIV โรค SLE / DLE หรือมีความผิดปกติที่ร้ายแรงทางร่างกายหรือจิตใจ หรือไม่?","questionDescEn":"","answer":"N","answerDetail":""}]}    json

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    submit_health    ${url}
    ${response1}=    POST On Session    submit_health    ${uri_transaction_submit}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json}=    Convert String to JSON    ${response1.content}

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

KPI Nonlife Step 4 Create Or Update Beneficiary
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_submit}=    Set Variable    /saletools/beneficiary/createOrUpdate
    Log    url = ${url}${uri_transaction_submit}
    
    ${body}=    Evaluate    {"transactionId":"${CASE_ID}","beneficiaries":[{"transactionId":"${CASE_ID}","order":1,"baneficiaryType":"P","nameTH":"ตามกฎหมายกำหนด","relationCode":999,"ratio":100,"remark":"remarked","relationTH":"ตามกฎหมายกำหนด"}]}    json

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    create_beneficiary    ${url}
    ${response1}=    POST On Session    create_beneficiary    ${uri_transaction_submit}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json}=    Convert String to JSON    ${response1.content}

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

KPI Nonlife Step 5 Tax Exemption Submit
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    #### transaction/ktb/get
    ${uri_transaction_submit}=    Set Variable    /saletools/transaction/taxExemption/submit
    Log    url = ${url}${uri_transaction_submit}
    
    ${body}=    Evaluate    {"transactionId":"${CASE_ID}","taxExemptionId":${None},"taxExemption":${False},"taxDeductionType":"self","payerTaxId":"${MOCK_CardNumber}","payerTitle":"นางสาว","payerTitleId":2,"payerFirstName":"${MOCK_ThaiFirstName}","payerLastName":"${MOCK_ThaiLastName}","payerAddress":"111","payerAddressMoo":"บางบัวทอง","payerAddressRoad":"21","payerAddressSoi":"","payerAddressSubDistrict":"เกาะกลาง","payerAddressDistrict":"เกาะลันตา","payerAddressProvince":"กระบี่","payerAddressPostCode":"81150","payerAddressSubDistrictCode":"810303","payerAddressDistrictCode":"8103","payerAddressProvinceCode":"81","rdFlagStatus":0,"confirmToRdFlag":${None},"confirmToRdDate":${None}}    json

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    create_beneficiary    ${url}
    ${response1}=    POST On Session    create_beneficiary    ${uri_transaction_submit}    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response1.status_code}    200
    ${json}=    Convert String to JSON    ${response1.content}

    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success

KPI Nonlife Step 6 Consent Submit
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    ${uri_consent}=    Set Variable    /saletools/transaction/consent/submit
    Log    url = ${url}${uri_consent}

    ${data_consent}=    Evaluate    {"transactionId":"${CASE_ID}","consent":${True},"consentCheck":${True}}    json
    Log    ${data_consent}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    transaction_kpi    ${url}
    ${response2}=    POST On Session    transaction_kpi    ${uri_consent}    json=${data_consent}    headers=${headers}
    Should Be Equal As Strings    ${response2.status_code}    200
    ${json2}=    Convert String to JSON    ${response2.content}    

    Dictionary Should Contain Key    ${json2}    status
    Dictionary Should Contain Key    ${json2}    message

    Should Be Equal As Strings    ${json2["status"]}    True
    Should Be Equal As Strings    ${json2["message"]}    success

KPI Nonlife Step 7 Renewal Submit
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    ${uri_review}=    Set Variable    /saletools/transaction/renewal/submit
    Log    url = ${url}${uri_review}

    ${data_renew}=    Set Variable    {"transactionId":"${CASE_ID}","bankBRCode":"","agentCodeKPI":"","branchName":"","accountNo":"","accountName":"","paymentMethod":"","isAutoRenewal":${DDR_Registration}}
    Log    ${data_renew}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    renew_submit    ${url}
    ${response}=    POST On Session    renew_submit    ${uri_review}    data=${data_renew}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json2}=    Convert String to JSON    ${response.content} 

    Dictionary Should Contain Key    ${json2}    status
    Dictionary Should Contain Key    ${json2}    message

    Should Be Equal As Strings    ${json2["status"]}    True
    Should Be Equal As Strings    ${json2["message"]}    success

KPI Nonlife Step 8 Confirm
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_KPI}
    ${uri_confirm}=    Set Variable    /saletools/transaction/confirm
    Log    url = ${url}${uri_confirm}

    ${data_confirm}=    Evaluate    {"transactionId":"${CASE_ID}"}    json
    Log    ${data_confirm}

    ${headers}=    Create Dictionary
    ...    API-Key=${KPI_API_KEY}
    ...    Accept=application/json, text/plain, */*
    ...    Content-Type=application/json
    ...    channelID=eso_web
    ...    productType=${PA_Type}
    ...    Authorization=Bearer ${ACCESS_TOKEN_KPI}

    Create Session    confirm_submit    ${url}
    ${response}=    POST On Session    confirm_submit    ${uri_confirm}    json=${data_confirm}    headers=${headers}
    
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content} 
    Dictionary Should Contain Key    ${json}    status
    Dictionary Should Contain Key    ${json}    message

    Should Be Equal As Strings    ${json["status"]}    True
    Should Be Equal As Strings    ${json["message"]}    success
