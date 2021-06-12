사용자의 환경에 [Vagrant](https://www.vagrantup.com/downloads)와 [VirtualBox](https://www.virtualbox.org/wiki/Downloads)가 미리 설치되있어야 함

Vagrantfile이 위치한 경로에서 다음을 입력

```sh
$ vagrant plugin install vagrant-env
$ vagrant up --color

# 기본 값일 경우, $ vagrant ssh m1
$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')
```

Vagrant 명령어는 [blog](https://dragonz.dev/devops/vagrant/command&code)에서 참고


가상머신 삭제할때 삭제가 잘안되는 경우가 있다 `C:\Users\USERNAME\VirtualBox VMs` 경로(VirtualBox 가상머신 저장 경로)에서 확인하고 남아있다면 수동으로 삭제할 것