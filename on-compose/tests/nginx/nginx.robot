*** Settings ***
Library   Browser
Library   Collections
Library   String
Library   OperatingSystem
Library   yaml

*** Variables ***
${source}  %{SOURCE_FILE}

*** Test Cases ***
Nginx Test Success
    ${targets}=  Create List
    ${file}=  Get File  ${source}  
    ${object}=  Create Dictionary
    ${isyaml}=  Evaluate   ".yaml" in """${source}"""
    IF  ${isyaml}
        ${object}=  yaml.Safe Load  ${file}
    ELSE 
        ${object}=  Evaluate  json.loads('''${file}''')  json
    END

    log  Targets are: ${object["targets"]}  WARN
    log  Message to check is: ${object["message"]}  WARN
    FOR  ${URL}  IN  @{object["targets"]}
        New Page  ${URL}
        Get Text  h1  contains  ${object["message"]} 
    END