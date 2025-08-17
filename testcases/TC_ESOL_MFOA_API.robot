*** Settings ***
Resource    ../keywords/General_Keywords.robot
Resource    ../keywords/Login_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Open_Account_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Add_Card_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_MFOA_Keyword.robot
Resource    ${CURDIR}/../resources/config/${env}/config.robot
Library     ${CURDIR}/../python_script/EmailLibrary.py
Variables    ${CURDIR}/../resources/config/email_config.yaml
Suite Setup    Run Keywords    Read File Excel    ${Data_File}    ${Data_Sheet}    AND    Clean Log Warnings
# Suite Teardown    Search Deposits Information

*** Variables ***
${Data_File}        ${CURDIR}/../resources/data/${env}/TD_ESOL_MFOA_API.xlsx
${Data_Sheet}       TC_ESOL_MFOA

*** Test Cases ***
Esolution_MFOA_Buy_fund_TC001
    [Documentation]    ซื้อกองทุน
    [Tags]    MFOA    TC001    
    Get Test Data    1
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Check Result MFOA
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Buy_fund_TC002
    [Documentation]    ซื้อกองทุน
    [Tags]    MFOA    TC002   
    Get Test Data    2
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Buy_fund_TC003
    [Documentation]    ซื้อกองทุน - One time
    [Tags]    MFOA    TC003   
    Get Test Data    3
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Buy_fund_TC004
    [Documentation]    ซื้อกองทุน - Recurring
    [Tags]    MFOA    TC004   
    Get Test Data    4
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Buy_fund_TC005
    [Documentation]    ซื้อกองทุน - Bulk Buy
    [Tags]    MFOA    TC005
    Get Test Data    5
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation

    Generate App ID MFOA          Is_product2=${True}
    Get Fund Details              Is_product2=${True}
    Get Fund Effective Date       Is_product2=${True}
    Get Fund Assessment           Is_product2=${True}
    Get Fund Performance          Is_product2=${True}
    Get Fund Holiday              Is_product2=${True}
    Fund Consent Validation       Is_product2=${True}
    Fund CFPF Validation          Is_product2=${True}
    
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Buy_fund_TC006
    [Documentation]    ซื้อกองทุน - Bulk Buy
    [Tags]    MFOA    TC006
    Get Test Data    6
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation

    Generate App ID MFOA          Is_product2=${True}
    Get Fund Details              Is_product2=${True}
    Get Fund Effective Date       Is_product2=${True}
    Get Fund Assessment           Is_product2=${True}
    Get Fund Performance          Is_product2=${True}
    Get Fund Holiday              Is_product2=${True}
    Fund Consent Validation       Is_product2=${True}
    Fund CFPF Validation          Is_product2=${True}
    
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Sell_fund_TC007
    [Documentation]    ขายกองทุน
    [Tags]    MFOA    TC007   
    Get Test Data    7
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Sell Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Sell_fund_TC008
    [Documentation]    ขายกองทุน
    [Tags]    MFOA    TC008
    Get Test Data    8
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Sell Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA


Esolution_MFOA_Switch_fund_TC009
    [Documentation]    สับเปลี่ยนกองทุน amount
    [Tags]    MFOA    TC009
    Get Test Data    9
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Switch in Fund Details
    Get Fund Trade Calendar
    Get Switch in Fund Trade Calendar
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Get Switch in Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA

Esolution_MFOA_Switch_fund_TC010
    [Documentation]    สับเปลี่ยนกองทุน unit
    [Tags]    MFOA    TC010
    Get Test Data    10
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID MFOA
    Retrieve Continue MFOA
    Upload Documents Photo
    Get Fund Profile
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone MFOA
    Generate App ID MFOA
    Get Fund Details
    Get Switch in Fund Details
    Get Fund Trade Calendar
    Get Switch in Fund Trade Calendar
    Get Fund Effective Date
    Get Fund Assessment
    Get Fund Performance
    Auth Signature
    Get Fund Holiday
    Get Switch in Fund Holiday
    Fund Consent Validation
    Fund CFPF Validation
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update MFOA Information Consent
    Verify KYC    
    Submission Information
    Fund Status
    Get Report MFOA    productCode=ALL
    View PDF Report
    Check Result MFOA