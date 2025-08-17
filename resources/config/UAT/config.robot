*** Variables ***
#${BASE_URL}                                https://biznext-channel.dev.krungthai.com:10443        #https://intapigw-uat2.esolnonprd.krungthai
${BASE_CONFIG_PROTOCAL}                     https
${BASE_CONFIG_HOST}                         intapigw-uat1.esolnonprd.krungthai    
${BASE_CONFIG_PORT}                         443

# Login
${URI_GENERATE_TOKEN_ID}                    /ktb/rest/esolution/v1/authentication/generateToken
${URI_EXCHANGE_TOKEN_ID}                    /ktb/rest/esolution/v1/authentication/exchangeToken

#Add Card
${URI_GENERATE_MC_REFNO}                    /ktb/rest/esolution/v1/case/mctool/generate/refno
${URI_GENERATE_OPP_REFNO}                   /ktb/rest/esolution/v1/case/opportunity/generate/refno
${URI_MC_TOOL}                              /ktb/rest/esolution/v1/case/mctool
${URI_CARD_INFO}                            /ktb/rest/esolution/v1/mock/cardInfo
${URI_CASE_RETRIEVE}                        /ktb/rest/esolution/v1/case/retrieve
${URI_ESOL_CASE}                            /ktb/rest/esolution/v1/case
${URI_ESOL_DOC}                             /ktb/rest/esolution/v1/document
${URI_ESOL_INSURANCE}                       /ktb/rest/esolution/v1/insurances
${URI_ESOL_DOC_CREATE}                      /ktb/rest/esolution/v1/document/createNew

# External Product
# Insurance
${URI_INSURANCE_PLAN}                        /ktb/rest/esolution/v1/insurances/data/plan/list
# KPI
${KPI_API_KEY}                               BQKxn7sXrAEw8s3e0ZpQU3DlAi4j918w
${BASE_CONFIG_KPI}                           uat-api-esolution.kpi.co.th
${URI_GENERATE_TOKEN_ID_KPI}                 /authen/authentication/generateServiceToken
#CHUBB
${BASE_CONFIG_CHUBB}                         apacuat.chubbdigital.com
${URI_GENERATE_TOKEN_ID_CHUBB}               /enterprise.operations.authorization
${App_ID_CHUBB}                              462c3c2d-7cb5-4da3-a66b-1e3fe35a4e9c
${App_Key_CHUBB}                             NSc8Q~5yUPAz1D_G1LM_XvdhWonuBFQvxY.gGddJ
${Resource_CHUBB}                            4daf4ae6-d43e-4001-9234-3a0510609784
${SUBSCRIPTION_KEY_CHUBB}                    8b2c8948544e4d8199af1191ff0980e3
${X-Auth_CHUBB}                              1182-hPBNKw8xvp7xSFPldtWYbCcMflXU/5JfzAoI0xhR1ts=
#TIP
${BASE_CONFIG_TIP}                           esolution-font-uat.tipinsure.com
${next_action_token}                         40b50a8840ebbdb8b2ad487cb007153acc6fb36088
${next_action_subcampaign_id}                40fc0c04c5312e16e0ae3e43b28467267f44f44011
${next_action_suminsured}                    401f79bf3dcece95fa3ce6ad49e19e37a70f751237
${next_action_submit}                        402f8648f1056c755482b256b3dc6f5fe0164f9ea6
${next_action2}                              4082a3a26dd220de986fa69d753894c1b6268135a8
${next_action3}                              4082a3a26dd220de986fa69d753894c1b6268135a8


#MFOA
${URI_MFOA_FUND_DETAILS}                    /ktb/rest/esolution/v1/discovery/product/mutual-fund/FundCode/detail
${URI_MFOA_FUND_EffectiveDate}              /ktb/rest/esolution/v1/case/caseId/mutual-fund/bulk-allotment
${URI_MFOA_FUND_ASSESSMENT}                 /ktb/rest/esolution/v1/case/vulnerable-customer/assessment/caseId
${URI_MFOA_FUND_PERFORMANCE}                /ktb/rest/esolution/v1/discovery/product/mutual-fund/performance
${URI_MFOA_AUTH_SIGNATURE}                  /ktb/rest/esolution/v1/document/createNew
${URI_MFOA_FUND_HOLIDAY}                    /ktb/rest/esolution/v1/case/caseId/mutual-fund/fund-holiday?requiredNextMonth=true
${URI_MFOA_FUND_CONSENT_VALIDATION}         /ktb/rest/esolution/v1/case/caseId/mutual-fund/bulk-consent-validation
${URI_MFOA_FUND_CFPF_VALIDATION}            /ktb/rest/esolution/v1/case/caseId/mutual-fund/cfpf-validation
${URI_MFOA_FUND_STATUS}                     /ktb/rest/esolution/v1/case/caseId/mutual-fund/submission/transaction
${URI_MFOA_FUND_PROFILE}                    /ktb/rest/esolution/v1/case/caseId/portfolio/type/mutual-fund

#Bond
${URI_GET_BOND_PRODUCT}                    /ktb/rest/esolution/v1/bond/product
${URI_GET_BOND_INSTRUMENT_DETAIL}          /ktb/rest/esolution/v1/bond/product/instrument-detail
${URI_VARIDATE_QUOTA_PRODUCT}              /ktb/rest/esolution/v1/bond/caseId/quota/validate
${URI_VULNERABLE_CUSTOMER_START}           /ktb/rest/esolution/v1/case/vulnerable-customer/verification/start
${URI_VULNERABLE_CUSTOMER_VERIFY}          /ktb/rest/esolution/v1/case/vulnerable-customer/verification/verify
