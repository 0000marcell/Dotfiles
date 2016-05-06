#curl with json 
# exemple: curl-json '{"username": "0000marcell@gmail.com","password":"123456"}' "http://localhost:3000/login"
function curl-json
	curl -v -H "Content-Type: application/json" -X POST -d $argv[1] $argv[2]
end

# curl with headers 
# exemple: curl-header '"Autorization: Bearer some bs"' "http://localhost:3000/endpoint"
function curl-header
	curl -v --header $argv[1] $argv[2]
end
