*** Settings ***
Library    SeleniumLibrary  
Library    Collections
Library    String

*** Variables ***
${URL}=    https://www.datart.sk/
@{PList}    
@{BuyButtons}
@{ProductNames}
@{BasketProductNames}
@{BasketProductNamesRemove}
${#}=    0
*** Test Cases ***
Finding 3 most expensive iPhones
    #Opening the browser and closing additional popups/cookies
   Open Browser       ${URL}    chrome    options=add_experimental_option("detach", True)
   Maximize Browser Window
    #Cookies
    Wait Until Element Is Visible    xpath=//button[contains(@id,'c-t-bn')]
    Click Element    xpath=//button[contains(@id,'c-t-bn')]

    #Clicking through Categorie
    Click Element   xpath=//span[@class='link-name']//strong[contains(text(),'Telefóny')]
    Click Element   xpath=//div[@class='category-tree-box bg-white']//span[contains(text(),'Apple iPhone')]   
    
    #Finding the most expensive
        Wait Until Element Is Visible    xpath=//li[contains(@class,'sort-panel-slider-item')]//a[contains(text(),'Najdrahší')]
        Click Element    xpath=//li[contains(@class,'sort-panel-slider-item')]//a[contains(text(),'Najdrahší')]
        sleep    2s

    #Filtering for number of products on page
    Click Element    xpath=//div[@class="pagination-per-page"]/..//a[contains(text(),"48")]

    #Getting prices
    #First Page
    ${AllItemPrices}=    Get WebElements    xpath=//div[@class='item-price']
    FOR    ${Price}    IN    @{AllItemPrices}
            ${Prices}=    Get Element Attribute    ${Price}    data-product-price
            ${PricesInt}=    Convert To Integer    ${Prices}  
            Append To List    ${PList}    ${PricesInt}
        END
    #Next Pages
    ${Pages}=    Get WebElements    xpath=//a[@class="page-link "]
    ${LastPage}    Get Text    ${Pages}[-1]
    Log    ${LastPage}
    ${Page}=    Get WebElement    xpath=//a[@class="page-link "]
    
    FOR    ${Page}    IN RANGE    1    ${LastPage}    1
    Click Element    xpath=//a[@class="page-link next-page "]
        ${AllItemPrices}=    Get WebElements    xpath=//div[@class='item-price']
        FOR    ${Price}    IN    @{AllItemPrices}
            ${Prices}=    Get Element Attribute    ${Price}    data-product-price
            ${PricesInt}=    Convert To Integer    ${Prices}  
            Append To List    ${PList}    ${PricesInt}
        END
    END
        #${PlistLast}=    Get Slice From List    ${PList}    -1
        FOR    ${Counter}    IN    @{PList}
         IF    ${Counter} == ${PList}[-1]    BREAK
            Log    ${Counter}
            ${#+1}=    Evaluate    ${#}+1
            Should Be True    ${Counter}>=${PList}[${#+1}]
            ${#}=    Evaluate    ${#}+1
            
        END
    
    #Changing the page to #1
    Click Element    xpath=//li[@class="page-item"]/..//a[contains(text(),'1')]
    #Picking 3 most expensive items
        ${BuyButtons}=    Get WebElements    xpath=//div[@class="item-cart"]/..//span[contains(text(),'Vložiť do košíka')]
        ${BuyButton}=    Get Slice From List    ${BuyButtons}    0    3 
        #Log To Console    ${BuyButton}
        FOR    ${BB}    IN    @{BuyButton}
            Click Element    ${BB} 
            Set Selenium Speed    1s
            Wait Until Element Is Visible    xpath=//div[@class="modal-content"]/..//button[@aria-label="Close"]
            Click Element    xpath=//div[@class="modal-content"]/..//button[@aria-label="Close"]
            Set Selenium Speed    0s
        END

        #Start of Comparison method
        ${AllProductNames}=    Get WebElements    xpath=//h3[@class="item-title"]/..//a[contains(@href,"/mobilny-telefon-apple")]
        ${AllProductNames1}=    Get Slice From List    ${AllProductNames}    0    3
        FOR    ${X}    IN    @{AllProductNames1}
            ${PNs}=    Get Element Attribute    ${X}    href
            Append To List    ${ProductNames}    ${PNs}    
        END
        Log    ${ProductNames}

        #Opening and checking the basket
        Click Element    xpath=//div[@class="head-cart-count"]/..//img[contains(@class,"cart-full")]
        ${AllBasketProductNames}=    Get WebElements    xpath=//div[@class="basket-item-title"]//a[contains(@href,'mobilny-telefon-apple-iphone')]
        FOR    ${Y}    IN    @{AllBasketProductNames}
            ${BPNs}=    Get Element Attribute    ${Y}    href 
            Append To List    ${BasketProductNames}    ${BPNs}    
        END
        Log    ${BasketProductNames}
        Should Be Equal    ${ProductNames}    ${BasketProductNames}

        #Removing item and chcecking if it is removed
        Click Element   xpath=//div[@class="basket-item-remove"]
        Sleep    1s
         ${AllBasketProductNamesRemove}=    Get WebElements    xpath=//div[@class="basket-item-title"]//a[contains(@href,'mobilny-telefon-apple-iphone')]
        FOR    ${YRemove}    IN    @{AllBasketProductNamesRemove}
            ${BPNsR}=    Get Element Attribute    ${YRemove}    href 
            Append To List    ${BasketProductNamesRemove}    ${BPNsR}
        END
        Log    ${BasketProductNamesRemove}
        Should Not Be Equal    ${BasketProductNames}    ${BasketProductNamesRemove}

        #Closing Borwser
        Close Browser