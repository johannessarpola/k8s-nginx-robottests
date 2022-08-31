*** Settings ***
Library   Browser
Library   Collections
Library   String
Library   OperatingSystem

*** Variables ***
${source}    %{SOURCE_FILE}

*** Test Cases ***
Nginx Test Success
    ${json}=    Get file    ${source}
    ${object}=    Evaluate    json.loads('''${json}''')    json

    log    Targets are: ${object["targets"]}    WARN
    log    Message to check is: ${object["message"]}    WARN
    FOR  ${URL}  IN  @{object["targets"]} 
        New Page    ${URL}
        Get Text    h1    contains    ${object["message"]} 
    END