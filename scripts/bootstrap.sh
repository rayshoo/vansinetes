#!/bin/bash
#
# Program: Initial vagrant.
# History: 2017/1/16 Kyle.b Release, 2021/03/15 rayshoo Modified
set -e
OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)

case "${OS_NAME}" in
  "CentOS")
    version=$(grep '^VERSION_ID=' /etc/os-release | sed s'/VERSION_ID=//')

    if [ $version == "\"8\"" ] ; then
      options=( "fastestmirror=1" "max_parallel_downloads=8" )

      for option in ${options[@]}; do
      IFS='=' read -ra arr <<< $option
        {
          result=$(grep ${arr[0]} /etc/dnf.conf)
        }||
        {
          result=""
        }
        if [ -z $result ] ; then
          cat << EOF >> /etc/dnf.conf
$option
EOF
        fi
      done
      sudo dnf install -y epel-release
      sudo dnf install -y ansible sshpass
    else
      sudo yum install -y epel-release
      sudo yum install -y ansible sshpass
    fi
  ;;
  "Ubuntu")
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo apt-get install -y ansible sshpass
  ;;
  *)
    echo "${OS_NAME} is not support ..."; exit 1
esac