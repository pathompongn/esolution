*** Settings ***
Resource    ../keywords/General_Keywords.robot
Resource    ../keywords/Login_Keywords.robot
Resource    ../keywords/ESOL_Add_Card_Keywords.robot
Resource    ../resources/config/${env}/config.robot
Suite Setup    Run Keywords    Read File Excel    ${Data_File}    ${Data_Sheet}    AND    Clean Log Warnings
Suite Teardown    Search Product Information

*** Variables ***
${Data_File}        ${CURDIR}/../resources/data/${env}/TD_ESOL_Add_Card_API.xlsx
${Data_Sheet}       TC_ESOL_Add_Card


*** Test Cases ***
Esoution_open_card_TC001
    [Documentation]    Open Normal Krungthai Home Plus Debit Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC01
    #debug
    Get Test Data    1
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
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC002
    [Documentation]    Open Normal Krungthai SME Debit Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC02
    #debug
    Get Test Data    2
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
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC003
    [Documentation]    Open Normal Krungthai TranXit Debit card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC03
    #debug
    Get Test Data    3
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
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC004
    [Documentation]    Open Normal Krungthai Care Debit Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC04
    #debug
    Get Test Data    4
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
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC005
    [Documentation]    Open Normal Krungthai Extra Care Debit Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC05
    #debug
    Get Test Data    5
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Update OTP Telephone
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC006
    [Documentation]    Open Normal Krungthai Ultra Care Debit Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC06
    #debug
    Get Test Data    6
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Update OTP Telephone
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC007
    [Documentation]    Open Normal Krungthai Classic Debit Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC07
    #debug
    Get Test Data    7
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Update OTP Telephone
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC008
    [Documentation]    Open Normal Krungthai Happy Life Card success
    [Tags]    High    Yes    Positive    debitCard     EN    TC08
    #debug
    Get Test Data    8
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    Update OTP Telephone
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC009
    [Documentation]    Open Normal Krungthai Travel UnionPay Debit Card success
    [Tags]    High    Yes    Positive    travelCard     EN    TC09
    #debug
    Get Test Data    9
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
    Generate App ID
    Open newnext if fact true
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC010
    [Documentation]    Open Travel Premium Mastercard Debit card success
    [Tags]    High    Yes    Positive    travelCard     EN    TC10
    #debug
    Get Test Data    10
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
    Generate App ID
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information


Esoution_open_card_TC011
    [Documentation]    Open Travel Platinum Mastercard Debit card success
    [Tags]    High    Yes    Positive    travelCard     EN    TC11
    #debug
    Get Test Data    11
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
    Generate App ID
    Open newnext if fact true
    MC Tool Product Information
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Card Information Consent
    Verify KYC
    Submission Information
