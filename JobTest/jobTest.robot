**** Settings ****
Library    SeleniumLibrary
Library    String
Library    Collections
**** Variables ****
${URL}=    https://www.saucedemo.com/
@{Pass}
@{Name}
@{PricesList}
@{NPriceList}
${#}=    0
   
**** Test Case ****
Login Testing
    Open Browser    ${URL}    chrome    options=add_experimental_option("detach", True)    
    Maximize Browser Window
    #Name/Password
    ${Names}=    Get Text    xpath=//div[@id="login_credentials"]
    ${Name}=    Get Line    ${Names}    1

    ${Passwords}=    Get Text    xpath=//div[@class="login_password"]
    ${Password}=    Get Line    ${Passwords}    -1
    
    Input Text    xpath=//div[@class="form_group"]/..//input[@placeholder="Username"]    ${Name}
    Input Text    xpath=//div[@class="form_group"]/..//input[@placeholder="Password"]    ${Password}
    Click Element    xpath=//input[@name="login-button"]

    #Price    
    Click Element    xpath=//select[@class="product_sort_container"]
    Wait Until Element Is Visible    xpath=//select[@class="product_sort_container"]/..//option[@value="hilo"]
    Click Element    xpath=//select[@class="product_sort_container"]/..//option[@value="hilo"]

    ${TPrices}=    Get WebElements    xpath=//div[@class="inventory_item_price"]

    FOR    ${xTPrices}    IN    @{TPrices}
        ${yTPrices}=    Get Text    ${xTPrices} 
        ${$TPrices}=    Remove String    ${yTPrices}    $
        ${NPrices}=    Convert To Number    ${$TPrices}    
        Append to List    ${PricesList}    ${NPrices}
    END
    
    #Price checking
    ${NPrices-1}=    Get Slice From List    ${PricesList}   -1
    FOR    ${NPrice}    IN    @{PricesList}
        Append to List    ${NPriceList}    ${NPrice} 
        ${#+1}=    Evaluate    ${#}+1 
        ${NPrice+1}=    Get Slice From List    ${PricesList}    ${#}    ${#+1}
        SHould be True    ${NPriceList} >= ${NPrice+1}
        ${#}=    Evaluate    ${#}+1
        IF    ${NPrice} == ${NPrice-1}    BREAK
            Log    ${NPrice}
            Log    ${NPrice+1}
    END
    
    #Picking 3 most expensive
    ${BuyButtons}=    Get WebElements    xpath=//button[contains(@name,'add-to-cart')]
    ${3BuyButtons}=    Get Slice From List    ${BuyButtons}    0    3
    FOR    ${BuyButton}    IN    @{3BuyButtons}    
        Click Element    ${BuyButton}
        
    END
    
    #TC1
    Click Element    xpath=//a[@class="shopping_cart_link"]
    
    ${Labels}=    Get WebElements    xpath=//div[@class="inventory_item_name"]
    FOR    ${Label}    IN    @{Labels}
       Click Element    xpath=//button[contains(@id,'remove-sauce-labs')]
       ${NotRemoved}=    Get WebElements    xpath=//div[@class="inventory_item_name"]
       Should Not Be Equal    ${Labels}    ${NotRemoved}
    END

    #TC2
    Click Element    xpath=//a[@class="shopping_cart_link"]
    Click Element    xpath=//button[@name="checkout"]

    Input Text    xpath=//input[@id="first-name"]    Robert    
    Input Text    xpath=//input[@id="last-name"]    Kubjatko
    Input Text    xpath=//input[@id="postal-code"]    94901
    
    Click Element    xpath=//input[@id="continue"]
    Click Element    xpath=//button[@id="finish"]
    
    
    