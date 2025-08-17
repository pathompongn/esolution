*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           String
Library           OperatingSystem
Library           DateTime
Library           json
Library           JSONLibrary
Library           base64
Library           Process
Library           BuiltIn

*** Keywords ***
Generate UUID
    ${uuid}=    Evaluate    str(uuid.uuid4())    modules=uuid
    Set Global Variable    ${UUID}    ${uuid}
    Log    UUID: ${uuid}

Generate Token ID
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_GENERATE_TOKEN_ID}
    Log    url = ${url}${uri}
    
    ${data}=    Set Variable    {"username": "${User_ID}","password": "${Password}","uuid": "${UUID}","mode": "force"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Authorization=Basic YWRtaW46cGFzc3dvcmQ=
    ...    Content-Type=application/json
    ...    x-correlation-id=d2f646b2-6e8f-4aad-a9e4-ad873f42c380-crid
    ...    x-channel-id=WB
    ...    accept-language=${Language}-TH

    Create Session    generate_token    ${url}
    ${response}=    POST On Session    generate_token    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    
    Dictionary Should Contain Key    ${json}    accessToken
    Dictionary Should Contain Key    ${json}    refreshToken
    Dictionary Should Contain Key    ${json}    sessionState
    Dictionary Should Contain Key    ${json}    lastSuccessLogin

    Set Global Variable    ${ACCESS_TOKEN}    ${json["accessToken"]}
    Set Global Variable    ${REFRESH_TOKEN}    ${json["refreshToken"]}

    ${parts}=    Split String    ${ACCESS_TOKEN}    .
    Length Should Be    ${parts}    3
    ${payload_b64}=    Set Variable    ${parts[1]}
    ${payload_len}=    Get Length    ${payload_b64}
    ${mod}=    Evaluate    ${payload_len} % 4
    ${padding}=    Evaluate    4 - ${mod} if ${mod} > 0 else 0
    ${pad_string}=    Evaluate    "=" * ${padding}
    ${payload_b64_padded}=    Catenate    SEPARATOR=    ${payload_b64}    ${pad_string}
    ${payload_bytes}=    Evaluate    base64.urlsafe_b64decode("""${payload_b64_padded}""")    base64
    ${payload_str}=    Convert To String    ${payload_bytes}
    ${payload}=    Convert String to JSON    ${payload_str}

    Set Global Variable    ${KCS_BRANCH_CODE}    ${payload["kcsbranchcode"]}
    Set Global Variable    ${OLD_KCS_BRANCH_CODE}    ${payload["kcsbranchcode"]}

Get New Branch ID
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    /ktb/rest/esolution/v1/user/branch/delegate/${User_ID}
    Log    url = ${url}${uri}

    ${headers}=    Create Dictionary
    ...    Accept=*/*
    ...    Accept-Language=th-TH,th;q=0.9
    ...    Connection=keep-alive
    ...    Authorization=Bearer ${ACCESS_TOKEN}
    ...    Accept-Encoding=gzip, deflate, br

    Create Session    generate_token    ${url}
    ${response}=    GET On Session    generate_token    ${uri}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}
    Log     ${json}
    
    ${branchCode}     Run Keyword And Return Status    Dictionary Should Contain Key    ${json}[0]    branchCode
    ${branchName}     Run Keyword And Return Status    Dictionary Should Contain Key    ${json}[0]    branchName

    IF    ${branchCode} and ${branchName}
        Set Test Variable    ${branchCode}    ${json}[0][branchCode]
        Set Test Variable    ${branchName}    ${json}[0][branchName]
        FOR    ${item}    IN    @{json}
            IF    '${json}[0][branchCode]'!='${KCS_BRANCH_CODE}'
                Set Test Variable    ${branchCode}    ${item}[branchCode]
                Set Test Variable    ${branchName}    ${item}[branchName]
                Exchange Token ID
                Exit For Loop
            END
        END
        
        
    END

Exchange Token ID
    ${url}=    Set variable    ${BASE_CONFIG_PROTOCAL}://${BASE_CONFIG_HOST}:${BASE_CONFIG_PORT}
    ${uri}=    Set variable    ${URI_EXCHANGE_TOKEN_ID}
    Log    url = ${url}${uri}
    
    ${data}=    Set Variable    {"refreshToken":"${REFRESH_TOKEN}","attributes":{"kcsbranchcode":"${branchCode}","isDelegate":true,"service":"esolution","originalBranch":"${KCS_BRANCH_CODE}"},"uuid":"${UUID}"}
    Log    ${data}

    ${headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Accept-Language=en-US,en;q=0.9
    ...    Connection=keep-alive
    ...    Content-Type=application/json
    
    Create Session    generate_token    ${url}
    ${response}=    POST On Session    generate_token    ${uri}    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Convert String to JSON    ${response.content}

    Set Global Variable    ${ACCESS_TOKEN}    ${json["accessToken"]}
    Set Global Variable    ${REFRESH_TOKEN}    ${json["refreshToken"]}

    ${parts}=    Split String    ${ACCESS_TOKEN}    .
    Length Should Be    ${parts}    3
    ${payload_b64}=    Set Variable    ${parts[1]}
    ${payload_len}=    Get Length    ${payload_b64}
    ${mod}=    Evaluate    ${payload_len} % 4
    ${padding}=    Evaluate    4 - ${mod} if ${mod} > 0 else 0
    ${pad_string}=    Evaluate    "=" * ${padding}
    ${payload_b64_padded}=    Catenate    SEPARATOR=    ${payload_b64}    ${pad_string}
    ${payload_bytes}=    Evaluate    base64.urlsafe_b64decode("""${payload_b64_padded}""")    base64
    ${payload_str}=    Convert To String    ${payload_bytes}
    ${payload}=    Convert String to JSON    ${payload_str}

    Set Global Variable    ${KCS_BRANCH_CODE}    ${payload["kcsbranchcode"]}