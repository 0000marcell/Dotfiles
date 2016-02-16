# find in folder string folder
function fif
	echo | grep -R $argv[1] $argv[2]
end
