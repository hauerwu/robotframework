*** Settings ***
Suite Setup     Check is docutils installed
Test Setup      Make test non-critical and fail it if docutils is not installed
Force Tags      regression  jybot  pybot
Resource        formats_resource.robot

*** Test Cases ***
One ReST
    [Setup]  NONE
    ${status}  ${msg} =  Run Keyword And Ignore Error  Run sample file and check tests  ${RESTDIR}${/}sample.rst
    Run Keyword If  "${DOCUTILS INSTALLED}" == "YES" and "${status}" == "FAIL"  FAIL  ${msg}
    Run Keyword Unless  "${DOCUTILS INSTALLED}" == "YES"  Clear error should be given when docutils is not installed

ReST With ReST Resource
    Previous Run Should Have Been Successful
    Check Test Case  Resource File

ReST Directory
    Run Suite Dir And Check Results  ${RESTDIR}

Directory With ReST Init
    Previous Run Should Have Been Successful
    Check Suite With Init  ${SUITE.suites[1]}

*** Keywords ***
Clear Error Should Be Given When Docutils Is Not Installed
    Stderr Should Match    [ ERROR ] Parsing '*rest?sample.rst' failed:
    ...  Using reStructuredText test data requires having 'docutils'
    ...  module version 0.9 or newer installed.${USAGE TIP}
