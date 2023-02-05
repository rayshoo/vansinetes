# Vansinetes
## 메인
### [README](../README.md)

## 사용 전 필요 조건

사용자의 환경에 [Vagrant](https://www.vagrantup.com/downloads)와 [VirtualBox](https://www.virtualbox.org/wiki/Downloads)가 미리 설치되있어야 한다.

## 사용 방법

<span>1.</span> [.env](../.env), [templates/cluster.erb](../templates/cluster.erb) 파일들을 구성한다. (기본적인 세팅은 이미 되어있다.)
```sh
# .env
MIRROR_CHANGE=yes # 한국 사용자들은 centos 이미지를 사용할 경우, MIRROR_CHANGE를 활성화하는 것을 적극 권장한다.
```
<span>2.</span> 몇 가지 툴들은 프로비저닝 속도 단축을 위해 주석 처리되어있다. [ansible/site.yaml](../ansible/site.yaml)에서 필요한 부분을 주석 제거한다.

```sh
- name: utils, components install
  hosts: cluster
  roles:
  # - role: utils/k9s
  # - role: utils/stern
  # - role: utils/dashboard
  # - role: utils/builder
  # - role: utils/skopeo
  # - role: utils/compose
```

<span>3.</span> [Vagrantfile](../Vagrantfile)이 위치한 경로에서 하단의 명령어를 bash 쉘에 입력한다.

```sh
vagrant plugin install vagrant-env && \
vagrant up --no-provision && \
machines=$(vagrant status | tail -8 |  head -n 4 | awk '{ print $1}') && \
for machine in $machines; do
vagrant snapshot save $machine up
done && \
root_pass=vagrant vagrant provision --color && \
vagrant halt && \
for machine in $machines; do
vagrant snapshot save $machine kube
done && \
vagrant up

$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')
password: vagrant
```

## 명령어

```sh
# 필수 플러그인 설치
$ vagrant plugin install vagrant-env

# 프로비전이 실패할 경우를 대비해서 초기 설치 상태로 스냅샷을 생성한다
$ vagrant up --no-provision
$ vagrant snapshot save up

# 다음의 명령어로 저장한 스냅샷으로 초기화 가능
$ vagrant snapshot restore up

# root_pass=true 옵션을 지정하면 프롬프트에서 root 패스워드를 지정 가능하다
$ root_pass=true vagrant provision --color
# 혹은 터미널에 'true'와 'yes' 를 제외한 비밀번호를 직접 입력할 수도 있다
$ root_pass=<password> vagrant provision --color

# 더 자세한 정보를 확인하고 싶다면 debug 옵션을 추가 입력한다
$ debug=true root_pass=true vagrant provision --color

# 마스터 노드 접속
$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')

# 기본 설정이라면 아래의 명령어로 접속이 가능하다
$ vagrant ssh m1
$ ssh vagrant@10.254.1.51 # 리눅스 환경에서는 virtual box에서 별도의 호스트 네트워크 구성 필요
$ ssh -p 5701 vagrant@localhost

# 초기 vagrant 유저 비밀번호
vagrant
```

## 참고 사항

몇 가지 alias가 자동 등록된다.

```
alias ans='ansible'
alias anp='ansible-playbook'
alias vi='vim'
alias d='docker'
alias k='kubectl'
```

사설 도커 레지스트리가 생성되며, 초기 admin 계정으로 사용 가능하다.(password: admin)<br/>
사용자 설정은 [templates/cluster.erb](../templates/cluster.erb#118)에서 설정할 수 있다.
```
$ curl -u 'admin:admin' https://m1.dev/v2/
{}
$ curl -u 'admin:admin' https://registry.m1.dev/v2/
{}
```

vagrant 유저로 docker와 kubectl 명령어를 사용 가능하다.
```
$ d ps
$ k get nodes -o wide
```

## 문제 해결

<span>1.</span> 프로비전이 실패한 경우 **vagrant provision** 명령어로 이를 다시 시도한다.

<span>2.</span> **vagrant destroy --force && vagrant up** 와 같이 가상머신을 삭제하고 다시 생성할때,<br/>
간혹 정상적으로 삭제된 것으로 보이지만 실제로는 삭제되지 않아서 실패하는 경우가 있으므로 버추얼 머신 환경설정의 가상머신 파일 저장 경로에서 이를 직접 확인해서 삭제 후 다시 시도한다.
