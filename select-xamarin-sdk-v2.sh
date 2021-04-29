#!/bin/bash -e -o pipefail

echo "Set SDK"

get_framework_path() {
  local framework=$1
  case $framework in
  mono) echo '/Library/Frameworks/Mono.framework/Versions' ;;
  ios) echo '/Library/Frameworks/Xamarin.iOS.framework/Versions' ;;
  android) echo '/Library/Frameworks/Xamarin.Android.framework/Versions' ;;
  mac) echo '/Library/Frameworks/Xamarin.Mac.framework/Versions' ;;
  *) ;;
  esac
}

set_current_folder() {
  local framework=$1
  local version=$2
  local folderListPosition=$3

  echo "framework = $framework, version = $version"

  if [ ! -z ${framework} ]; then
    local countDigit=$(echo "${version}" | grep -o "\." | grep -c "\.")
    if [[ ! countDigit -eq 1 ]]; then
      echo "Wrong framework's versions."
      return
    fi
  fi

  local FOLDER=$(get_framework_path "$framework")
  echo "FOLDER=${FOLDER}"
  sudo rm -f ${FOLDER}/Current
  sudo ln -s "${FOLDER}/${version}" "${FOLDER}/Current"
}

for arg in "$@"; do
  key=$(echo $arg | cut -f1 -d=)
  value=$(echo $arg | cut -f2 -d=)

  case $key in
  mono) set_current_folder $key $value 1 ;;
  ios) set_current_folder $key $value 2 ;;
  android) set_current_folder $key $value 3 ;;
  mac) set_current_folder $key $value 4 ;;
  *) ;;
  esac
done
