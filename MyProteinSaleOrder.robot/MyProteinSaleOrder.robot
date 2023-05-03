*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
*** Variables ***
${URL}=    https://www.myprotein.sk/
${Browser}=    chrome
@{ProductName}
*** Test Case ***
Ordering with discount
    Open Browser       ${URL}    ${Browser}    options=add_experimental_option("detach", True)
    Maximize Browser Window
    #Cookies
    Wait Until Element Is Visible    xpath=//button[@id="onetrust-pc-btn-handler"]
    Click Element    xpath=//button[@id="onetrust-pc-btn-handler"]
    Wait Until Element Is Visible    xpath=//button[@class="ot-pc-refuse-all-handler"]
    Click Element    xpath=//button[@class="ot-pc-refuse-all-handler"]
    Wait Until Element Is Visible    xpath=//button[@class="emailReengagement_close_button"]
    Click Element    xpath=//button[@class="emailReengagement_close_button"]

    #Discount
  # ${DiscountAvailable}=    Get Element Count    xpath=//div[@class="stripBanner"]
   ${DiscountAvailable}=    Get Element Count    xpath=//p[@style="text-transform:none"]
   IF    $DiscountAvailable >= 1
      # ${DiscountText}=    Get Text    xpath=//div[@class="stripBanner"]
       ${DiscountText}=    Get Text    xpath=//p[@style="text-transform:none"]
    Should Contain    ${DiscountText}    ZĽAVA
    ${DiscountIndex}=    Get Lines Containing String    ${DiscountText}    KÓD:
    ${Discount}=    Fetch From Right    ${DiscountIndex}    KÓD: 
   END
    
    #Checking products
   # Click Element    xpath=//a[@class="stripBanner_text"]
    Click Element    xpath=//p[@style="text-transform:none"]
    Click Element    xpath=//input[@type="checkbox"]/..//input[contains(@aria-label,'Vegán')]
    Sleep    2s
    ${Products}=    Get WebElements    xpath=//h3[@data-track="product-title"]
    FOR    ${Product}    IN    @{Products}
        ${ProductName}=    Get Text    ${Product}
        #Append To List    ${ProductName}    ${ProductNames}
        IF    ${ProductName} == Hrachový Proteínový Izolát
            Click Element    ${Product}
    #Choosing Chocolate flavour if available... If not, choose whatever
            Wait Until Element Is Visible    xpath=//select[contains(@id,"product-variation-dropdown")]
            Click Element    xpath=//select[contains(@id,"product-variation-dropdown")]
            ${Flavour}=    Get Element Count    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[contains(text(),"Čokoláda")]
            IF    $Flavour >= 1
                Click Element    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[contains(text(),"Čokoláda")]
            ELSE 
                Click Element    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[@data-linked-product-id="default"]
            END
    #Picking weight of the product, when flavour is chosen    
            Wait Until Element Is Visible    xpath=    //button[contains(text(),"500 g")]
            ${Weight}=    Get Element Count     xpath=//button[contains(text(),"500 g")]
            IF    $Weight >= 1
            Click Element    xpath=//button[contains(text(),"500 g")]
            END
        ELSE IF    ${ProductName} == Sójový Proteínový Izolát
            Click Element    ${Product}
    #Choosing Chocolate flavour if available... If not, choose whatever
            Wait Until Element Is Visible    xpath=//select[contains(@id,"product-variation-dropdown")]
            Click Element    xpath=//select[contains(@id,"product-variation-dropdown")]
            ${Flavour}=    Get Element Count    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[contains(text(),"Čokoláda")]
            IF    $Flavour >= 1
                Click Element    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[contains(text(),"Čokoláda")]
            ELSE 
                Click Element    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[@data-linked-product-id="default"]
            END
    #Picking weight of the product, when flavour is chosen
            Wait Until Element Is Visible    xpath=    //button[contains(text(),"500 g")]
            ${Weight}=    Get Element Count     xpath=//button[contains(text(),"500 g")]
            IF    $Weight >= 1
            Click Element    xpath=//button[contains(text(),"500 g")]
            END
        ELSE IF    ${ProductName} == Vegánska Proteínová Zmes
            Click Element    ${Product}
    #Choosing Chocolate flavour if available... If not, choose whatever
            Wait Until Element Is Visible    xpath=//select[contains(@id,"product-variation-dropdown")]
            Click Element    xpath=//select[contains(@id,"product-variation-dropdown")]
            ${Flavour}=    Get Element Count    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[contains(text(),"Čokoláda")]
            IF    $Flavour >= 1
                Click Element    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[contains(text(),"Čokoláda")]
            ELSE 
                Click Element    xpath=//select[@class="athenaProductVariations_dropdown"]/..//option[@data-linked-product-id="default"]
            END
    #Picking weight of the product, when flavour is chosen
            Wait Until Element Is Visible    xpath=    //button[contains(text(),"500 g")]
            ${Weight}=    Get Element Count     xpath=//button[contains(text(),"500 g")]
            IF    $Weight >= 1
            Click Element    xpath=//button[contains(text(),"500 g")]
            END
            

        END
        
    END