# commit changes to git 
function commit
	git add --all
	git commit -m $argv[1]
end
