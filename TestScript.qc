Test UbiComp
	var jsonCreate = { name: @String }
	var jsonGet = { userid: @Id int, status: "", name: @Ignore, date: @Ignore  }
	var jsonOut = { status: "OUT" }
	var jsonIn = { status: "IN" }
    request GetStatus
        GET
        http://localhost:3000/api/status/@id
        Precond: not empty
        STATE: none
        Postcond: returns body jsonGet AND returns code 200
    request ChangeStatusOut
    	POST
    	http://localhost:3000/api/out/@id
    	Precond: not empty
    	STATE: update jsonOut
    	Postcond: returns code 200   
    request ChangeStatusIn
    	POST
    	http://localhost:3000/api/in/@id
    	Precond: not empty
    	STATE: update jsonIn
    	Postcond: returns code 200    
    request CreateUser
        POST
        http://localhost:3000/api/users/nocreate
        body jsonCreate
        STATE: create jsonCreate
        Postcond: returns code 201