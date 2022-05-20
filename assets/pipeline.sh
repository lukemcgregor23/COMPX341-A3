#bin/bash
set +x
commit=true
run=true

while getopts crm: flag
do
    case "${flag}" in
        c) commit=false;;
        m) message=${OPTARG};;
        r) run=false;;
    esac
done

echo "Installing Dependancys"
npm install 1> '/tmp/nodeinstallerr.log' 2> '/dev/null'
if [ "$?" -ne 0 ];then 
	cat '/tmp/nodeinstallerr.log'
	echo "Failed to install dependancys... Exiting"
	exit
fi
echo "Building Application"
npm run build 1> '/tmp/nodebuilderr.log' 2> '/dev/null'
if [ "$?" -ne 0 ];then 
	cat '/tmp/nodebuilderr.log'
	echo "Failed to Build. This will not be pushed to GIT"
	exit
fi
if "$commit"
then
	if [ "$message" == "" ]
	then
		echo "No commit meessage given"
		exit
	else	
		echo "Pushing to GIT"
		git add ../* &> '/dev/null'
		git commit -m "$message"
		git push
	fi
fi
if "$run"
then
	npm run start
fi
