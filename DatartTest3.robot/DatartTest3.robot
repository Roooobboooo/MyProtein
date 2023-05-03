**** Settings ****
Library    SeleniumLibrary
Library    String
Library    Collections
**** Variables ****
${URL}=    https://www.datart.sk/
${Samsung}=    Samsung
${PopUp}=    xpath=//div[@class="exponea-colose-link exponea-code-not-shown"]
**** Test Case ****
Empty Basket Case
#Opening the browser and closing additional popups/cookies
   Open Browser       ${URL}    chrome    options=add_experimental_option("detach", True)
   Maximize Browser Window
    #Cookies
    Wait Until Element Is Visible    xpath=//button[contains(@id,'c-t-bn')]
    Click Element    xpath=//button[contains(@id,'c-t-bn')]

    #Basket
    Click Element    xpath=//div[@class="head-cart-count"]
    ${X}=    Get Text    xpath=//div[@class="basket-info-page"]
    Should Contain    ${X}   V košíku doposiaľ nemáte žiadny tovar
    Close Browser