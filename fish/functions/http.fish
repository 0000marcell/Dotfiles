# make curl with pretty printing
function http 
	curl -s $argv[1] | python -m json.tool
end
