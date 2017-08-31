*** Settings ***
Documentation     Test Cases to check User Story
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Library           Selenium2Library
Library						DateTime
Test Teardown			Close Browser

*** Variables ***
${SERVER}		localhost:3000
${HOME_URL}	http://${SERVER}/
${BROWSER}		chrome
${HOME_TITLE}	Petstore webapp

*** Keywords ***
User Has Access To WebApp
	Open Browser	${HOME_URL}	${BROWSER}

Home Page Is Rendered
	Location Should Be	${HOME_URL}
 	Page Should Contain	${HOME_TITLE}
	Wait Until Element Is Visible    css=div.pet-list

Date Displayed On The Page
	Element Should Be Visible    css=span.banner-date

Date Format Is
	[Arguments]		${date_format}
	${current_date}=	Get Current Date	result_format=${date_format}
	Element Text Should Be    css=span.banner-date    ${current_date}

Pet Lists Displayed In Table
 	Element Should Be Visible    css=tbody.pet-list
	${count_pet_items}=	Get Matching XPath Count	//tr[@class='pet-item']
	Should Be True    ${count_pet_items} > 0

User Can View Pets Name and Status
	Element Should Be Visible    css=span.pet.lbl.pet-name
	Element Should Be Visible    css=span.pet.lbl.pet-status

Fill In A Random Pet
	${current_dt}=	Get Current Date	result_format=datetime
	Set Test Variable    ${NEW_PET_NAME}    Name_${current_dt}
	Set Test Variable    ${NEW_PET_STATUS}    Status_${current_dt}
	Fill In A New Pet	${NEW_PET_NAME}	${NEW_PET_STATUS}

New Pet Displayed In Table
	Table Should Contain    css=table.table.table-hover    ${NEW_PET_NAME}
	Table Should Contain    css=table.table.table-hover    ${NEW_PET_STATUS}

Fill In A New Pet
	[Arguments]    ${name}	${status}
	Input Text    css=input.form-control.pet-name	${name}
	Input Text    css=input.form-control.pet-status	${status}

Create By Click
	Click Element    css=button#btn-create

Create By Enter
	Press Key    css=input.form-control.pet-status    \\13

User Add A New Pet
	[Arguments]    ${name}	${status}
	Fill In A New Pet	${name}	${status}
	Create By Enter



*** Test Cases ***
US01 Display The Current Date
    Given User Has Access To WebApp
		When Home Page Is Rendered
		Then Date Displayed On The Page
		And Date Format Is	%d-%m-%Y


US02 View The List of Pets
    Given User Has Access To WebApp
		When Home Page Is Rendered
		Then Pet Lists Displayed In Table
		And User Can View Pets Name and Status


US03 Add A New Pet And Click Create
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And Fill In A Random Pet
		Then Create By Click
		And New Pet Displayed In Table


US03 Add A New Pet And Enter
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And Fill In A Random Pet
		Then Create By Enter
		And New Pet Displayed In Table


US03 Pet Name And Status Are Mandatory
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And User Add A New Pet	${EMPTY}	${EMPTY}
		Then Pet Lists Displayed In Table
