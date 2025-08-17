*** Settings ***
Resource    ../keywords/General_Keywords.robot
Resource    ../keywords/Login_Keywords.robot
Resource    ../keywords/ESOL_Account_Maintenance.robot
Resource    ../resources/config/${env}/config.robot
Suite Setup    Run Keywords    Read File Excel    ${Data_File}    ${Data_Sheet}    AND    Clean Log Warnings
Suite Teardown    Search Product Information

*** Variables ***
${Data_File}        ${CURDIR}/../resources/data/${env}/TD_ESOL_Account_Maintenance.xlsx
${Data_Sheet}       TC_ESOL_Account_Maintenance


*** Test Cases ***
Esoution_account_maintenance_TC001
    [Documentation]    SAV Account แก้ไขสถานะบัญชี Active --> No-CR-Int
    [Tags]    High    Yes    Positive    EN    TC01
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
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC002
    [Documentation]    SAV Account แก้ไขสถานะบัญชี No-CR-Int --> Active
    [Tags]    High    Yes    Positive    EN    TC02
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC003
    [Documentation]    SAV Account แก้ไขชื่อบัญชี
    [Tags]    High    Yes    Positive    EN    TC03
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC004
    [Documentation]    SAV Account แก้ไขที่อยู่ (เพิ่มที่อยู่อื่น)
    [Tags]    High    Yes    Positive    EN    TC04
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC005
    [Documentation]    SAV Account Add Restriction
    [Tags]    High    Yes    Positive    EN    TC05
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC006
    [Documentation]    SAV Account Edit Restriction (แก้วันหมดอายุ)
    [Tags]    High    Yes    Positive    EN    TC06
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC007
    [Documentation]    SAV Account Delete Restriction
    [Tags]    High    Yes    Positive    EN    TC07
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
    #Bypass face with overide
    Update OTP Telephone
    Get Restriction
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC008
    [Documentation]    SAV Account ใช้บัญชีเพื่อรับเงิน กยศ.
    [Tags]    High    Yes    Positive    EN    TC08
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Upload Document Education
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC009
    [Documentation]    SAV Account ยกเลิกบัญชีรับเงิน กยศ.
    [Tags]    High    Yes    Positive    EN    TC09
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
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC011
    [Documentation]    Account Current 1001 กำหนด SPO โอนไป NEXT Savings 2003 ยอดเงิน 500 บาท กำหนด O/D Linkage Link กับ NEXT Savings 2003
    [Tags]    High    Yes    Positive    EN    TC11
    #debug
    Get Test Data    11
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC012
    [Documentation]    Account Current 1001 แก้ไข SPO โอนไป NEXT Savings 2003 - แก้ไขวันที่เริ่มต้น
    [Tags]    High    Yes    Positive    EN    TC12
    #debug
    Get Test Data    12
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Get Portfolio Overdraft
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC013
    [Documentation]    Account Current 1001 ยกเลิก SPO โอนไป NEXT Savings 2003
    [Tags]    High    Yes    Positive    EN    TC13
    #debug
    Get Test Data    13
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Get Portfolio Overdraft
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC014
    [Documentation]    Account Current 1001 แก้ไขบัญชี  O/D Linkage Link จาก NEXT Savings 2003 เป็น Savings 2001
    [Tags]    High    Yes    Positive    EN    TC14
    #debug
    Get Test Data    14
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    #Get Portfolio Overdraft
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC015
    [Documentation]    Account Savings 2001 กำหนด SPO (Zero TAX)
    [Tags]    High    Yes    Positive    EN    TC15
    #debug
    Get Test Data    15
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC016
    [Documentation]    Account Savings 2001 แก้ไข SPO (Zero TAX) - เปลี่ยนวันที่ตัดเงิน
    [Tags]    High    Yes    Positive    EN    TC16
    #debug
    Get Test Data    16
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Get SPO Account
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC017
    [Documentation]    Account Savings 2001 ยกเลิก SPO (Zero TAX)
    [Tags]    High    Yes    Positive    EN    TC17
    #debug
    Get Test Data    17
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Get SPO Account
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC018
    [Documentation]    Account Next Savings 2003 กำหนด SPO (Zero TAX) 
    [Tags]    High    Yes    Positive    EN    TC18
    #debug
    Get Test Data    18
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC019
    [Documentation]    Account Next Savings 2003 แก้ไข SPO (Zero TAX) - เปลี่ยนวันที่ตัดเงิน
    [Tags]    High    Yes    Positive    EN    TC19
    #debug
    Get Test Data    19
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Get SPO Account
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC020
    [Documentation]    Account Next Savings 2003 ยกเลิก SPO (Zero TAX)
    [Tags]    High    Yes    Positive    EN    TC20
    #debug
    Get Test Data    20
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Get SPO Account
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC021
    [Documentation]    current account 1001 กำหนด SPO (Zero TAX)
    [Tags]    High    Yes    Positive    EN    TC21
    #debug
    Get Test Data    21
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC022
    [Documentation]    Current account 1001 แก้ไข SPO (Zero TAX) - เปลี่ยนวันที่ตัดเงิน
    [Tags]    High    Yes    Positive    EN    TC22
    #debug
    Get Test Data    22
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Get SPO Account
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information

Esoution_account_maintenance_TC023
    [Documentation]    Current account 1001 ยกเลิก SPO (Zero TAX)
    [Tags]    High    Yes    Positive    EN    TC23
    #debug
    Get Test Data    23
    Generate UUID
    Generate Token ID
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID
    Retrieve Continue
    Upload Documents Photo
    #Bypass face with overide
    Update OTP Telephone
    Generate App ID
    Get SPO Account
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Account Maintenance Information Consent
    Verify KYC
    Submission Information