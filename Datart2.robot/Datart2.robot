**** Settings ****
Library    SeleniumLibrary
Library    String
Library    Collections
**** Variables ****
${URL}=    https://www.datart.sk/
${Samsung}=    Samsung
${PopUp}=    xpath=//div[@class="exponea-colose-link exponea-code-not-shown"]
${Y}=    1
**** Test Case ****
Samsung Search
#Opening the browser and closing additional popups/cookies
   Open Browser       ${URL}    chrome    options=add_experimental_option("detach", True)
   Maximize Browser Window
    #Cookies
    Wait Until Element Is Visible    xpath=//button[contains(@id,'c-t-bn')]
    Click Element    xpath=//button[contains(@id,'c-t-bn')]
    #Samsung Search
    Input Text    xpath=//input[@type="search"]    ${Samsung}
    Click Element    xpath=//button[@class="btn btn-search"]/..//span[contains(text(),'Hľadať')]

    #Filtering for number of products on page
    Click Element    xpath=//div[@class="pagination-per-page"]/..//a[contains(text(),"54")]

    #First page
    ${Items}=    Get WebElements    xpath=//h3[@class="item-title"]
        FOR    ${X}    IN    @{Items}
            ${ItemLabels}=    Get Text    ${X}
            Should Contain    ${ItemLabels}    Samsung   
            Log    ${ItemLabels}
        END  
    
    #Next pages
   # ${PageCount}=    Get Text    xpath=//a[@class="page-link "]/..//a[contains(text(),'2')]
    ${Pages}=    Get WebElements    xpath=//a[@class="page-link "]
    ${LastPage}    Get Text    ${Pages}[-1]
    Log    ${LastPage}
    ${Page}=    Get WebElement    xpath=//a[@class="page-link "]
    
    FOR    ${Page}    IN RANGE    1    ${LastPage}    1
    Click Element    xpath=//a[@class="page-link next-page "]
    
    ${Items}=    Get WebElements    xpath=//h3[@class="item-title"]
        FOR    ${X}    IN    @{Items}
            ${ItemLabels}=    Get Text    ${X}
            Should Contain    ${ItemLabels}    Samsung   
            Log    ${ItemLabels}
        END

    END
    
    
        
   
