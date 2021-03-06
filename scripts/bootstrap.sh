#!/bin/bash
#
# Program: Initial vagrant.
# History: 2017/1/16 Kyle.b Release, 2021/03/15 rayshoo Modified
set -e
REPOS_DIR="/etc/yum.repos.d"
MIRROR_DIR="/home/vagrant/files/mirror"
OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)
VERSION=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)

case "${OS_NAME}" in
  "CentOS")
    if [ ! -z $1 ] && [ $1 == "mirror" ]; then
      if [ -f "${MIRROR_DIR}/${VERSION}/vansinetes.repo" ]; then
        if [ ${VERSION} -lt 8 ]; then
          files=( "CentOS-Base.repo")

          now=$(date +"%m_%d_%Y")
          cp /etc/yum/pluginconf.d/fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf_$now.backup 2>/dev/null || true
          sed -i -e 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf 2>/dev/null || true
        else
          files=( "CentOS-Linux-AppStream.repo" "CentOS-Linux-BaseOS.repo" "CentOS-Linux-Extras.repo")
        fi
        
        mkdir ${REPOS_DIR}/backup 2>/dev/null || true
        for file in ${files[@]}; do
            mv ${REPOS_DIR}/${file} ${REPOS_DIR}/backup 2>/dev/null || true
        done

        cp ${MIRROR_DIR}/${VERSION}/vansinetes.repo ${REPOS_DIR}
      fi
    fi

    if [ ${VERSION} -lt 8 ]; then
      sudo yum install -y epel-release
      sudo yum install -y ansible sshpass
    else
      sudo dnf install -y epel-release
      sudo dnf install -y ansible sshpass
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