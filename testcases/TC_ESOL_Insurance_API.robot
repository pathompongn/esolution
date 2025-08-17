*** Settings ***
Resource    ../keywords/General_Keywords.robot
Resource    ../keywords/Login_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Open_Account_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Add_Card_Keywords.robot
Resource    ${CURDIR}/../keywords/ESOL_Insurance_Keyword.robot
Resource    ${CURDIR}/../keywords/ESOL_Insurance_Keyword_KPI.robot
Resource    ${CURDIR}/../keywords/ESOL_Insurance_Keyword_CHUBB.robot
Resource    ${CURDIR}/../keywords/ESOL_Insurance_Keyword_TIP.robot
Resource    ${CURDIR}/../resources/config/${env}/config.robot
Suite Setup    Run Keywords    Read File Excel    ${Data_File}    ${Data_Sheet}    AND    Clean Log Warnings
# Suite Teardown    Search Deposits Information

*** Variables ***
${Data_File}        ${CURDIR}/../resources/data/${env}/TD_ESOL_Insurance_API.xlsx
${Data_Sheet}       TC_ESOL_Insurance

*** Test Cases ***
Esoution_open_insurance_TC001
    [Documentation]    Open Insurance - สินเชื่อหายห่วง KPI
    [Tags]    insurance    TC001    
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token KPI
    STEP 1 SUBMIT KPI No-Worry Loan
    STEP 2 UPDATE KPI
    STEP 3 SUBMIT health Question KPI PAL00050
    STEP 4 SUBMIT createOrUpdate KPI
    STEP 5 CONSENT SUBMIT KPI
    Review Data KPT
    Confirm KPI
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance KPI Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=PAL00050
    View PDF Insurance Report
    
Esoution_open_insurance_TC002
    [Documentation]    Open Insurance - สินเชื่อปลอดภัย KPI
    [Tags]    insurance    TC002
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token KPI
    STEP 1 SUBMIT KPI Safe Loan
    STEP 2 UPDATE KPI
    STEP 3 SUBMIT health Question KPI HL000005
    STEP 4 SUBMIT createOrUpdate KPI
    STEP 5 CONSENT SUBMIT KPI
    Review Data KPT
    Confirm KPI
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance KPI Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=HL000005
    View PDF Insurance Report

Esoution_open_insurance_TC003
    [Documentation]    Open Insurance - สินเชื่อมีสุข CHUBB
    [Tags]    insurance    TC003
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=CESOKTBLT
    View PDF Insurance Report

Esoution_open_insurance_TC004
    [Documentation]    Open Insurance - สินเชื่อสบายใจ CHUBB
    [Tags]    insurance    TC004
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=CESOKTBLP
    View PDF Insurance Report

Esoution_open_insurance_TC005
    #รอดำเนินการ
    [Documentation]    Open Insurance - สินเชื่อปลอดภัย TIP
    [Tags]    insurance    TC005
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    
Esoution_open_insurance_QR_TC006
    [Documentation]    Open Insurance - สินเชื่อหายห่วง KPI QR code payment
    [Tags]    insurance    TC006
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token KPI
    STEP 1 SUBMIT KPI No-Worry Loan
    STEP 2 UPDATE KPI
    STEP 3 SUBMIT health Question KPI PAL00050
    STEP 4 SUBMIT createOrUpdate KPI
    STEP 5 CONSENT SUBMIT KPI
    Review Data KPT
    Confirm KPI
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance KPI QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance KPI Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=PAL00050
    [Teardown]    View PDF Insurance Report

Esoution_open_insurance_QR_TC007
    [Documentation]    Open Insurance - สินเชื่อปลอดภัย KPI QR code payment
    [Tags]    insurance    TC007
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token KPI
    STEP 1 SUBMIT KPI Safe Loan
    STEP 2 UPDATE KPI
    STEP 3 SUBMIT health Question KPI HL000005
    STEP 4 SUBMIT createOrUpdate KPI
    STEP 5 CONSENT SUBMIT KPI
    Review Data KPT
    Confirm KPI
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    # Update Insurance KPI Information Consent
    Update Insurance KPI QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance KPI Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=HL000005
    [Teardown]    View PDF Insurance Report

Esoution_open_insurance_QR_TC008
    [Documentation]    Open Insurance - สินเชื่อมีสุข CHUBB QR code payment
    [Tags]    insurance    TC008
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance CHUBB Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=CESOKTBLT
    [Teardown]    View PDF Insurance Report

Esoution_open_insurance_QR_TC009
    [Documentation]    Open Insurance - สินเชื่อสบายใจ CHUBB QR code payment
    [Tags]    insurance    TC009
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB
    Get Application No
    # Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance CHUBB Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=CESOKTBLP
    [Teardown]    View PDF Insurance Report

Esoution_open_insurance_QR_TC010
    #รอดำเนินการ
    [Documentation]    Open Insurance - สินเชื่อปลอดภัย TIP QR code payment
    [Tags]    insurance    TC010
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
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID
    Get Insurance Plan
    Transaction Initial

Esoution_open_insurance_NonLife_TC011
    [Documentation]    Open Insurance - สุขภาพอุ่นใจ TIP
    [Tags]    insurance    TC011
    Get Test Data    11
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EHC000057
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC012
    [Documentation]    Open Insurance - ไมโครอินชัวรันซ์ TIP
    [Tags]    insurance    TC012
    Get Test Data    12
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit      
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EPA000024
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC013
    [Documentation]    Open Insurance - สุขใจวัยเกษียณ TIP
    [Tags]    insurance    TC013
    Get Test Data    13
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit     
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EPAS00021
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC014
    [Documentation]    Open Insurance - ไข้เลือดออก TIP
    [Tags]    insurance    TC014
    Get Test Data    14
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit     
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EHDHF1101
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC015
    [Documentation]    Open Insurance - เปย์สบาย TIP
    [Tags]    insurance    TC015
    Get Test Data    15
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured
    TIP Submit     
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EPAPAY001
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC016
    [Documentation]    Open Insurance - สุขใจชิลล์ TIP
    [Tags]    insurance    TC016
    Get Test Data    16
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured
    TIP Submit     
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EPANL0031
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC017
    [Documentation]    Open Insurance - มะเร็งใจแตก TIP
    [Tags]    insurance    TC017
    Get Test Data    17
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit     
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EHCC11001
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC018
    [Documentation]    Open Insurance - PM2.5 TIP
    [Tags]    insurance    TC018
    Get Test Data    18
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit     
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=EPM10001
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC019
    [Documentation]    Open Insurance - SCAN&GO CHUBB
    [Tags]    insurance    TC019
    Get Test Data    19
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=KTBLPT01
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC020
    [Documentation]    Open Insurance - PAใจกว้าง CHUBB
    [Tags]    insurance    TC020
    Get Test Data    20
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=KTBJAI01
    View PDF Insurance Report

Esoution_open_insurance_NonLife_TC021
    # รอดำเนินการ
    [Documentation]    Open Insurance - PAสุขใจชัวร์ KPI
    [Tags]    insurance    TC021
    Get Test Data    21
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial

    Generate Token KPI
    KPI Nonlife Get Transaction KTB
    KPI Nonlife Get Suminsured
    KPI Nonlife Get Plan Detail
    KPI Nonlife Step 1 Submit
    KPI Nonlife Step 2 Update
    KPI Nonlife Step 3 Submit Health Question
    KPI Nonlife Step 4 Create Or Update Beneficiary
    KPI Nonlife Step 5 Tax Exemption Submit
    KPI Nonlife Step 6 Consent Submit
    KPI Nonlife Step 7 Renewal Submit
    KPI Nonlife Step 8 Confirm

    Get Application No
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance KPI Nonlife Information Consent
    Verify KYC    
    Submission Information
    Bill Payment Insurance
    Insurance Submission Status
    Search Status
    Get Report Insurance    productCode=PAE01101
    View PDF Insurance Report  

Esoution_open_insurance_NonLife_QR_TC022
    [Documentation]    Open Insurance - สุขภาพอุ่นใจ TIP QR code payment
    [Tags]    insurance    TC022
    Get Test Data    22
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EHC000057
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC023
    [Documentation]    Open Insurance - ไมโครอินชัวรันซ์ TIP QR code payment
    [Tags]    insurance    TC023
    Get Test Data    23
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EPA000024
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC024
    [Documentation]    Open Insurance - สุขใจวัยเกษียณ TIP QR code payment
    [Tags]    insurance    TC024
    Get Test Data    24
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EPAS00021
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC025
    [Documentation]    Open Insurance - ไข้เลือดออก TIP QR code payment
    [Tags]    insurance    TC025
    Get Test Data    25
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EHDHF1101
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC026
    [Documentation]    Open Insurance - เปย์สบาย TIP QR code payment
    [Tags]    insurance    TC026
    Get Test Data    26
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EPAPAY001
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC027
    [Documentation]    Open Insurance - สุขใจชิลล์ TIP QR code payment
    [Tags]    insurance    TC027
    Get Test Data    27
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EPANL0031
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC028
    [Documentation]    Open Insurance - มะเร็งใจแตก TIP QR code payment
    [Tags]    insurance    TC028
    Get Test Data    28
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EHCC11001
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC029
    [Documentation]    Open Insurance - PM2.5 TIP QR code payment
    [Tags]    insurance    TC029
    Get Test Data    29
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Get Server TIP
    TIP Get Access Token
    TIP Get Subcampaign ID 
    TIP Get Suminsured 
    TIP Submit   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance TIP QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance TIP Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR
    Search Status
    Get Report Insurance    productCode=EPM10001
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC030
    [Documentation]    Open Insurance - SCAN&GO CHUBB
    [Tags]    insurance    TC030
    Get Test Data    30
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB Information Consent QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance CHUBB Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR    
    Search Status
    Get Report Insurance    productCode=KTBLPT01
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC031
    [Documentation]    Open Insurance - PAใจกว้าง CHUBB
    [Tags]    insurance    TC031
    Get Test Data    31
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial
    Generate Token CHUBB
    Transaction Info CHUBB
    Get SuminsuredMin CHUBB   
    Receive Status CHUBB
    Calculate SumInsured
    Verify PA CHUBB   
    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance CHUBB Information Consent QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment
    QR Payment Image Upload
    Update Insurance CHUBB Pending Actions QR
    Insurance Submission QR
    Insurance Submission Status QR  
    Search Status
    Get Report Insurance    productCode=KTBJAI01
    View PDF Insurance Report

Esoution_open_insurance_NonLife_QR_TC032
    # รอดำเนินการ
    [Documentation]    Open Insurance - PAสุขใจชัวร์ KPI
    [Tags]    insurance    TC032
    Get Test Data    32
    Mock cid with employeeId
    Generate UUID
    Generate Token ID
    Get New Branch ID
    Get Employee Info
    Generate MC Tool Reference No
    Generate Opportunity Reference No
    MC Tool Introduc
    Get Card ID Information
    Retrieve Get Case ID Insurance
    Retrieve Continue Insurance
    Upload Documents Photo
    Bypass face with overide
    Update OTP Telephone Insurance
    Generate Insurance App ID NonLife
    Get Insurance Plan
    Transaction Initial

    Generate Token KPI
    KPI Nonlife Get Transaction KTB
    KPI Nonlife Get Suminsured
    KPI Nonlife Get Plan Detail
    KPI Nonlife Step 1 Submit
    KPI Nonlife Step 2 Update
    KPI Nonlife Step 3 Submit Health Question
    KPI Nonlife Step 4 Create Or Update Beneficiary
    KPI Nonlife Step 5 Tax Exemption Submit
    KPI Nonlife Step 6 Consent Submit
    KPI Nonlife Step 7 Renewal Submit
    KPI Nonlife Step 8 Confirm

    Get Application No
    Generate App ID Next
    Master Signature KTB
    Generate OTP
    Validate OTP
    Update Insurance KPI Nonlife Information Consent    medthod=QR
    Verify KYC    
    Submission Information
    QR Payment Insurance
    Status Payment KPI
    QR Payment Image Upload
    Update Insurance KPI Pending Actions    medthod=QR
    Insurance Submission QR
    Insurance Submission Status QR  
    Search Status
    Get Report Insurance    productCode=PAE01101
    View PDF Insurance Report  

