# find in folder string folder
# ex fif 'User' ./ 
function fif
	echo | grep -R $argv[1] $argv[2]
end
