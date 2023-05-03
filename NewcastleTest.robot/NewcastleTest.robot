*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
*** Variables ***
${URL}=    https://www.youtube.com/
${Text}=    Newcastle United
${Channel1}=    https://www.youtube.com/@NUFC
${Channel2}=    https://www.youtube.com/@JamesLawrenceAllcott
${Channel3}=    https://www.youtube.com/@EuroFootballDaily
*** Test Case ***
Searching for relevant videos
    Open Browser       ${URL}    chrome    options=add_experimental_option("detach", True)
    Maximize Browser Window

    #Closing PopUps
    Wait Until Element Is Visible    xpath=//button[contains(@aria-label,"Odmietnuť")]
    Click Element    xpath=//button[contains(@aria-label,"Odmietnuť")]
    
    Sleep    2s
    Wait Until Element Is Visible    xpath=//input[@id="search"]
    Input Text    xpath=//input[@id="search"]    ${Text}
    Click Element    xpath=//button[contains(@id,"search")]

    #Channel Names
    ${Channels}=    Get WebElements    xpath=//ytd-section-list-renderer[@class="style-scope ytd-two-column-search-results-renderer"]/..//div[@class="style-scope ytd-channel-name"]/..//a[@class="yt-simple-endpoint style-scope yt-formatted-string"]
    Log    ${Channels}
    FOR    ${Channel}    IN    @{Channels}
        ${ChannelName}=    Get Element Attribute    ${Channel}    href
        IF    $ChannelName == $Channel1
        Click Element    ${Channel}
            
        END
        
    END