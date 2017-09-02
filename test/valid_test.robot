*** Settings ***
Documentation     Test Cases to check User Story
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Library           Selenium2Library
Library						DateTime
Library						OperatingSystem
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

New Pet Displayed In Table
	Table Should Contain    css=table.table.table-hover    ${NEW_PET_NAME}
	Table Should Contain    css=table.table.table-hover    ${NEW_PET_STATUS}

Generate A New Random Pet
	${current_dt}=	Get Current Date	result_format=datetime
	Set Test Variable    ${NEW_PET_NAME}    New_Name_${current_dt}
	Set Test Variable    ${NEW_PET_STATUS}    New_Status_${current_dt}

Fill In A New Pet
	[Arguments]    ${name}=random	${status}=random
	Set Test Variable    ${NEW_PET_NAME}    ${name}
	Set Test Variable    ${NEW_PET_STATUS}    ${status}
	Run Keyword If    "${name}"=="random"    Generate A New Random Pet
	Input Text    css=input.form-control.pet-name	${NEW_PET_NAME}
	Input Text    css=input.form-control.pet-status	${NEW_PET_STATUS}

Add A New Pet
	[Arguments]    ${name}=random	${status}=random
	Fill In A New Pet    ${name}    ${status}
	Create By Enter

Create By Click
	Click Element    css=button#btn-create

Create By Enter
	Press Key    css=input.form-control.pet-status    \\13

Update Pet Name And Status
	${current_dt}=	Get Current Date	result_format=datetime
	Set Test Variable		${NEW_PET_NAME}    Update_Name_${current_dt}
	Set Test Variable		${NEW_PET_STATUS}    Update_Status_${current_dt}
	Click Element	css=span.pet.lbl.pet-name
	Input Text	css=input.pet.usr-input.pet-name	${NEW_PET_NAME}
	Press Key		css=input.pet.usr-input.pet-name	\\13
	Click Element	css=span.pet.lbl.pet-status
	Input Text	css=input.pet.usr-input.pet-status	${NEW_PET_STATUS}
	Press Key		css=input.pet.usr-input.pet-status	\\13



*** Test Cases ***
US01_01 Display The Current Date
		[Documentation]	As a pet store user I want to see the current date displayed
    Given User Has Access To WebApp
		When Home Page Is Rendered
		Then Date Displayed On The Page
		And Date Format Is	%d-%m-%Y


US02_01 View The List of Pets
		[Documentation]	As a pet store user I want to see my current pets Name and Status
    Given User Has Access To WebApp
		When Home Page Is Rendered
		Then Pet Lists Displayed In Table
		And User Can View Pets Name and Status


US03_01 Add A New Pet And Click Create
		[Documentation]	As a pet store user I want to see add a pet by clicking Create
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And Fill In A New Pet
		Then Create By Click
		And New Pet Displayed In Table


US03_02 Add A New Pet And Enter
		[Documentation]	As a pet store user I want to see add a pet by press Enter
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And Fill In A New Pet
		Then Create By Enter
		And New Pet Displayed In Table


US03_03 Pet Name And Status Are Mandatory
		[Documentation]	Check if Pet Name and Status are mandatory fields. This test is ignore because no spec about mandatory fields
		[Tags]	Ignore
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And Add A New Pet	${EMPTY}	${EMPTY}
		Then Element Should Contain	css=div.pet-form	"Error"


US04_01
		[Documentation]	As a pet store user I want to update Pet Name and Status
    Given User Has Access To WebApp
		When Home Page Is Rendered
		And Pet Lists Displayed In Table
		And Update Pet Name And Status
		Then New Pet Displayed In Table
