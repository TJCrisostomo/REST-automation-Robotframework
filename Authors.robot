*** Settings ***
Library         REST    http://localhost:3000
Library		JSONLibrary
Library		Collections

*** Variables ***
${json_post}         {"first_name":"James","last_name":"Rollins"}
${json_put}         {"first_name":"Jason","last_name":"Matthews"}


*** Test Cases ***
GET an existing Author
	GET         /authors/1
	Integer     response body id	1
	String      response body first_name	Mark
	String      response body last_name	Twain
	[Teardown]	Output	response body	file_path=${CURDIR}/author.json


POST a new Author
	&{res}=		POST	/authors	${json_post}
	Integer		response status		201
	String      response body first_name	James
	String      response body last_name	Rollins
	${jsondb}=	Load Json From File	/test-automation-assignment/db.json
	Should Contain	${jsondb}	"first_name":"James","last_name":"Rollins"
	[Teardown]	Output  response body	file_path=${CURDIR}/new_author.json

PUT existing Author
	PUT         /authors/${res.body['id']}	${json_put}
	Integer		response status		200
	String		response body first_name	Jason
	String		response body last_name		Matthews
	${jsondb}=	Load Json From File	/test-automation-assignment/db.json
	Should Contain	${jsondb}	"first_name":"Jason","last_name":"Matthews"
	[Teardown]	Output  response body	file_path=${CURDIR}/update_author.json


DELETE existing Author
	DELETE      /authors/${res.body['id']}
	Integer     response status           200
	${jsondb}=	Load Json From File	/test-automation-assignment/db.json
	Should Not Contain	${jsondb}	"first_name":"Jason","last_name":"Matthews"
