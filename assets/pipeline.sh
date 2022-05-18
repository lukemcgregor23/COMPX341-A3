#bin/bash

commit=true
run=true

while getopts c:m:r: flag
do
    case "${flag}" in
        c) commit=false;;
        m) message=${OPTARG};;
        r) run=false;;
    esac
done

npm install
npm build

if "$commit"
then
	if [$message == ""]
	then
		echo "No commit meessage given"
	else
		git add ../*
		git commit -m $1
		git push
	fi
fi
if "$run"
then
	npm run start
fi
