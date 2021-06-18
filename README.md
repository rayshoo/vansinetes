사용자의 환경에 [Vagrant](https://www.vagrantup.com/downloads)와 [VirtualBox](https://www.virtualbox.org/wiki/Downloads)가 미리 설치되있어야 함

Vagrantfile이 위치한 경로에서 다음을 입력

```sh
$ vagrant plugin install vagrant-env
$ debug=true root_pass=true vagrant up --color

# 기본 값일 경우, $ vagrant ssh m1
$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')

# 별도의 ssh client 를 사용할 경우, vagrant@locahost:5750 으로도 접속이 가능하다.
$ ssh -p 5750 vagrant@localhost
```

Vagrant 명령어는 [blog](https://dragonz.dev/devops/vagrant/command&code)에서 참고


가상머신 삭제할때 삭제가 잘 안되는 경우가 있다 `C:\Users\USERNAME\VirtualBox VMs` 경로(VirtualBox 가상머신 저장 경로)에서 확인하고 남아있다면 수동으로 삭제할 것