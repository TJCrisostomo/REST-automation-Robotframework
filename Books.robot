*** Settings ***
Library         REST    http://localhost:3000
Library		JSONLibrary
Library		Collections


*** Variables ***
${json_post}         {"title":"Red Sparrow","author_id":12,"copyright":2000}
${json_put}         {"title":"Red Sparrow Updated","author_id":12,"copyright":2000}


*** Test Cases ***
GET an existing Book
	GET         /books/1
	Integer     response body id	1
	Integer     response body author_id	1
	String      response body title		"The Adventures of Tom Sawyer"
	Integer      response body copyright	1876
	[Teardown]	Output		response body	file_path=${CURDIR}/book.json


POST a new Book
	&{res}=		POST	/books	${json_post}
	Integer		response status		201
	Integer     response body author_id	12
	String      response body title		"Red Sparrow"
	Integer      response body copyright	2000
	${jsondb}=	Load Json From File	/test-automation-assignment/db.json
	Should Contain	${jsondb}	"title": "Red Sparrow"
	[Teardown]	Output  response body	file_path=${CURDIR}/new_book.json

PUT existing Book
	PUT         /books/${res.body['id']}	${json_put}
	Integer		response status		200
	Integer     response body author_id	12
	String      response body title		"Red Sparrow Updated"
	Integer      response body copyright	2000
	${jsondb}=	Load Json From File	/test-automation-assignment/db.json
	Should Contain	${jsondb}	"title": "Red Sparrow Updated"
	[Teardown]	Output  response body	file_path=${CURDIR}/update_book.json


DELETE existing Author
	DELETE      /books/${res.body['id']}
	Integer     response status           200
	${jsondb}=	Load Json From File	/test-automation-assignment/db.json
	Should Not Contain	${jsondb}	"title": "Red Sparrow Updated"
