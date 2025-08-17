*** Settings ***
Resource    ../keywords/General_Keywords.robot
Resource    ../keywords/Login_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Open_Account_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Add_Card_Keywords.robot
Resource    ${CURDIR}/../keywords/OTP_Mobile_Keyword.robot
Resource    ${CURDIR}/../resources/config/${env}/config.robot
Library     ${CURDIR}/../python_script/EmailLibrary.py
Suite Setup    Run Keywords    Read File Excel    ${Data_File}    ${Data_Sheet}    AND    Clean Log Warnings
# Suite Teardown    Search Deposits Information
Variables         ${CURDIR}/../resources/config/email_config.yaml
Variables         ${CURDIR}/../resources/config/mobile_config.yaml

*** Variables ***
${Data_File}        ${CURDIR}/../resources/data/${env}/TD_ESOL_Add_Card_API.xlsx
${Data_Sheet}       TC_ESOL_Open_Account


*** Test Cases ***
Esoution_open_account_TC001
    [Documentation]    Open Next Saving Account
    [Tags]    High    Yes    Positive    debitCard     EN    TC001
    #debug
    Get Test Data    1
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    Update OTP Telephone
    Generate Saving App ID Next    type=DP
    Open newnext if fact true
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Deposit Information Consent
    Verify KYC
    Submission Information

Esoution_open_account_TC002
    [Documentation]    Open Zero Tax Account
    [Tags]    High    Yes    Positive    debitCard     EN    TC002    test
    #debug
    Get Test Data    2
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone
    GET Term Ammount
    Generate Saving App ID Next
    Open newnext if fact true
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Deposit Information Consent
    Verify KYC
    Submission Information

Esoution_open_account_TC003
    [Documentation]    Open Next Saving Account and Zero Tax Account
    [Tags]    High    Yes    Positive    debitCard     EN    TC03
    #debug   
    Get Test Data    3
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone
    GET Term Ammount
    Generate Saving App ID Next
    Open newnext if fact true
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Deposit Information Consent
    Verify KYC
    Submission Information

Esoution_open_account_TC004
    [Documentation]    Open MFOA Account
    [Tags]    High    Yes    Positive    MFOA     EN    TC04
    #debug   
    Get Test Data    4
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve MFOA Get Case ID
    Retrieve MFOA Continue
    Upload Documents Photo
    Bypass face with overide
    Calculate risk score
    knowledge assessment
    Update OTP Telephone
    Generate MFOA App ID Next
    Open newnext if fact true
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Deposit Information Consent
    Verify KYC
    Submission Information
    Sleep    5s
    
    