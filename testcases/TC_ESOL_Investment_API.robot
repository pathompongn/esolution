*** Settings ***
Resource    ../keywords/General_Keywords.robot
Resource    ../keywords/Login_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Open_Account_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Add_Card_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Investment_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_MFOA_Keyword.robot
Resource    ${CURDIR}/../resources/config/${env}/config.robot
Library     ${CURDIR}/../python_script/EmailLibrary.py
Variables    ${CURDIR}/../resources/config/email_config.yaml

Suite Setup    Run Keywords    Read File Excel    ${Data_File}    ${Data_Sheet}    AND    Clean Log Warnings
# Suite Teardown    Search Deposits Information

*** Variables ***
${Data_File}        ${CURDIR}/../resources/data/${env}/TD_ESOL_Invest_API.xlsx
${Data_Sheet}       TC_ESOL_BOND

*** Test Cases ***
Esolution_Buy_Primary_Market_TC001
    [Documentation]    ซื้อหุ้นกู้
    [Tags]    bond    TC001    
    Get Test Data    1
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    # ${CASE_ID}    Set Variable    200740-251102005234
    # Set Test Variable    ${CASE_ID}
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    Get Product Bond stockCodeList
    Product Instrument Detail
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Investment PMB
    Retrieve Continue PMB
    Upload Documents Photo
    Bypass face with overide
    Generate OTP Mail
    Validate OTP Mail
    # Update OTP Telephone
    Update Phone number And Email
    # Update VC
    Calculate risk score
    Varidate Quota Product
    MCTool OTP Bond    event=PRODUCT_INFO
    Generate App ID    PMB
    # Vulnerable Customer Verification Start
    # Vulnerable Customer Verification Verify
    Update RA
    Master Signature KTB
    Generate OTP
    Validate OTP
    MCTool OTP Bond    event=OTP
    Verify KYC PMB
    Update PMB Information Consent    
    Submission Information PMB
    Check Result PMB
    [Teardown]    Run Keywords    Get Report PMB    
    ...    AND    View PDF Report

