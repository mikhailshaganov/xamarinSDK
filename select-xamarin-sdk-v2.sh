#!/bin/bash -e -o pipefail

framework_path() {
  case $1 in
  mono) echo '/Library/Frameworks/Mono.framework/Versions' ;;
  ios) echo '/Library/Frameworks/Xamarin.iOS.framework/Versions' ;;
  android) echo '/Library/Frameworks/Xamarin.Android.framework/Versions' ;;
  mac) echo '/Library/Frameworks/Xamarin.Mac.framework/Versions' ;;
  *) ;;
  esac
}

change_framework_version() {
  local framework=$1
  local version=$2

  echo "Select $framework $version"

  local countDigit=$(echo "${version}" | grep -o "\." | grep -c "\.")
  if [[ countDigit -gt 1 ]]; then
    echo "[WARNING] It is not recommended to specify version in "a.b.c.d" format because your pipeline can be broken suddenly in future. Use "a.b" format."
    exit 0
  fi

  local folder=$(framework_path "$framework")
  sudo rm -f ${folder}/Current
  sudo ln -s "${folder}/${version}" "${folder}/Current"
}

for arg in "$@"; do
  key=$(echo $arg | cut -f1 -d=)
  value=$(echo $arg | cut -f2 -d=)

  case $key in
  mono | ios | android | mac) change_framework_version $key $value ;;
  *)
  echo "Invalid parameter <${key}>"   
  ;;
  esac
done
