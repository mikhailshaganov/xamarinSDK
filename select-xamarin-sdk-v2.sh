#!/bin/bash -e -o pipefail
# if [ -z "$1" ]; then
#   echo "No Xamarin SDK specified."
#   exit 0
# fi

echo "Set mono to ${mono}"

frameworkMono=mono
frameworkIOS=ios
frameworkAndroid=android
frameworkMac=mac

folderListPosition = 0
frameworkVersion = 0

for arg in "$@"
do

#Separate argument name and value
key=$(echo $arg | cut -f1 -d=)
value=$(echo $arg | cut -f2 -d=)

#Print message based on argument’s name
case $key in
mono) echo "mono = $value";;
ios) echo "ios = $value" ;;
android) echo "android = $value" ;;
mac) echo "mac = $value" ;;
*)
esac
done

if ![ -z "mono" ]; then
  IFS='.'
  read -a arr <<< "$frameworkMono"
  if ![${!arr[@]} == 2]
    echo "Wrong framework's versions."
  fi
  folderListPosition = 0;
  frameworkVersion = frameworkMono
fi


echo "Set SDK to ${frameworkVersion}"
FOLDERS_LIST=(
        '/Library/Frameworks/Mono.framework/Versions'
        '/Library/Frameworks/Xamarin.iOS.framework/Versions'
        '/Library/Frameworks/Xamarin.Android.framework/Versions'
        '/Library/Frameworks/Xamarin.Mac.framework/Versions'
    )

for FOLDER in "${FOLDERS_LIST[@]}"
do
    echo "Set Current folder for ${FOLDER}"
    sudo rm -f ${FOLDER}/Current
    sudo ln -s ${FOLDER}/${XAMARIN_SDK} ${FOLDER}/Current
done

function setCurrentFolder() {
    FOLDER = FOLDERS_LIST[folderListPosition]
    echo "Set Current folder for ${FOLDER}"
    sudo rm -f ${FOLDER}/Current
    sudo ln -s ${FOLDER}/${frameworkVersion} ${FOLDER}/Current
}



