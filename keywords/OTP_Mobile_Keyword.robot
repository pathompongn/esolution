*** Settings ***
Variables   ${CURDIR}/../resources/config/mobile_config.yaml

*** Variables ***
${btn_Search_mobile}         ${Samsung_A71.btn_Search_mobile}
${edit_Search_mobile}        ${Samsung_A71.edit_Search_mobile}


*** Keywords ***
Open App 
    Open Application   ${HostAppium}
    ...   appium:automationName=${Samsung_A71.AutomationName}
    ...   appium:platformName=${Samsung_A71.PlatformName}  
    ...   appium:platformVersion=${Samsung_A71.PlatformVersion}
    ...   appium:deviceName=${Samsung_A71.DeviceName}  
    ...   appium:noReset=${Samsung_A71.noReset}
    ...   appium:appPackage=${Samsung_A71.AppPackage}
    ...   appium:appActivity=${Samsung_A71.AppActivity}

Get_OTP_SMS
    [Arguments]     ${aug_search}         
    Open App 
    AppiumLibrary.Wait Until Page Contains Element      ${btn_Search_mobile}     10s
    AppiumLibrary.Wait Until Element Is Visible     ${btn_Search_mobile}     60s
    AppiumLibrary.Click Element                     ${btn_Search_mobile}
    AppiumLibrary.Wait Until Element Is Visible     ${edit_Search_mobile}     60s

    FOR    ${i}    IN RANGE    1    60
        AppiumLibrary.Input Text                        ${edit_Search_mobile}         ${aug_search}
        ${Result}=    Run Keyword And Ignore Error    AppiumLibrary.Wait Until Element Is Visible    //android.widget.TextView[contains(@resource-id,'com.samsung.android.messaging:id/search_status_message')]
        Exit For Loop IF   '${RESULT}[0]'=='PASS'
        #Run Keyword IF     '${RESULT}[0]'!='PASS'        Selenium2Library.Click Element    ${locator}         
        Sleep    1s
    END
    AppiumLibrary.Click Element                     //android.widget.TextView[contains(@resource-id,'com.samsung.android.messaging:id/search_status_message')]

    
    #AppiumLibrary.Wait Until Element Is Visible ${ele_msg} 3s
    sleep         1s
    AppiumLibrary.Wait Until Element Is Visible     //android.widget.TextView[contains(@text,"${aug_search}")]     30s
    ${statu_text}=     AppiumLibrary.Get Element Attribute         //android.widget.TextView[contains(@text,"${aug_search}")]        text 
    #log to console      Text:${statu_text}
    ${str1}=     Get Regexp Matches     ${statu_text}     [0-9]{6}
    log to console      OTP:${str1}[0]
    Close Application
    RETURN     ${str1}[0]
    #AppiumLibrary.Wait Until Element Is Visible     ${btn_back}     5s
    #AppiumLibrary.Click Element     ${btn_back}