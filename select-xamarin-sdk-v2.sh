#!/bin/bash -e -o pipefail

echo "Set SDK"
FOLDERS_LIST=(
        '/Library/Frameworks/Mono.framework/Versions'
        '/Library/Frameworks/Xamarin.iOS.framework/Versions'
        '/Library/Frameworks/Xamarin.Android.framework/Versions'
        '/Library/Frameworks/Xamarin.Mac.framework/Versions'
    )

set_current_folder ()
{
    local framework=$1 
    local version=$2
    local folderListPosition=$3

    echo "framework = $framework, version = $version, folderListPosition = $folderListPosition"

    if [ ! -z ${framework} ]; 
    then 
      IFS='.'
      read -a arr <<< "$version"
      echo "split arr: ${#arr[@]}"
      if [[ ! ${#arr[@]} -eq 2 ]]; 
      then 
        echo "Wrong framework's versions."
        return
      fi
    fi

    FOLDER=${FOLDERS_LIST[folderListPosition]}
    echo "Set Current folder for ${FOLDER}"
    sudo rm -f ${FOLDER}/Current
    sudo ln -s ${FOLDER}/${version} ${FOLDER}/Current
}    


for arg in "$@"
do

#Separate argument name and value
key=$(echo $arg | cut -f1 -d=)
value=$(echo $arg | cut -f2 -d=)

#Print message based on argument’s name
case $key in
mono) set_current_folder $key $value 1;;
ios) set_current_folder $key $value 2;;
android) set_current_folder $key $value 3;;
mac) set_current_folder $key $value 4;;
*)
esac
done






