#curl with json 
# exemple: curl-json '{"username": "0000marcell@gmail.com","password":"123456"}' "http://localhost:3000/login"
function curl-json
	curl -v -H "Content-Type: application/json" -X POST -d $argv[1] $argv[2]
end

# header ex: "Authorization: Bearer 89897878799"
# json get with header 
function curl-json-get
	curl -v -H  --header $argv[1] $argv[2] 
end

# ex curl-json-post "Authorization: Bearer 1929238" '{"todo": "this shit", "isCompleted": 0}' 'http://0.0.0.0:3000/api/v1/todos'
function curl-json-post
	curl -v -H "Content-Type: application/json" --header $argv[1] -X POST -d $argv[2] $argv[3] 
end
