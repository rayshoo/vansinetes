#!/bin/bash

now=$(date +"%m_%d_%Y")
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_$now.backup
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

REPOS_DIR="/etc/yum.repos.d"
MIRROR_DIR="/home/vagrant/files/mirror"
OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)
VERSION=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)

if [ ${OS_NAME} == "CentOS" ]; then
  if [ ! -z $1 ] && [ $1 == "mirror" ]; then
    if [ -f "${MIRROR_DIR}/${VERSION}/vansinetes.repo" ]; then
      files=( "CentOS-Linux-AppStream.repo" "CentOS-Linux-BaseOS.repo" "CentOS-Linux-Extras.repo")
      
      mkdir ${REPOS_DIR}/backup 2>/dev/null || true
      for file in ${files[@]}; do
          mv ${REPOS_DIR}/${file} ${REPOS_DIR}/backup 2>/dev/null || true
      done
      
      cp ${MIRROR_DIR}/${VERSION}/vansinetes.repo ${REPOS_DIR}
    fi
  fi
fi