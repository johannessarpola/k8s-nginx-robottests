*** Settings ***
Library   Browser

*** Variables ***
${URL}      %{WEBSITE_URL}

*** Test Cases ***
Nginx Test Success
    New Page    ${URL}
    Get Text    h1    contains    Welcome to nginx!

#Nginx Test Failure
#    New Page    ${URL}
#    Get Text    h1    contains   I'm not on the page