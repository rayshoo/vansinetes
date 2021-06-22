# Vansible with Kubeadm

**[Vansible with Kubespray](https://github.com/rayshoo/vansible_with_kubespray)의 후속 프로젝트**<br/>
**A follow-up project to [Vansible with Kubespray](https://github.com/rayshoo/vansible_with_kubespray)**
## 소개
쉽고 빠른 Docker+Kubernetes 개발, 학습 및 강의 환경 구축을 위해 설계된<br/>
Vagrant, Ansible, Kubeadm를 사용한 IaC(Infra as Code) 도구

## 사용 전 필요 조건

사용자의 환경에 [Vagrant](https://www.vagrantup.com/downloads)와 [VirtualBox](https://www.virtualbox.org/wiki/Downloads)가 미리 설치되있어야 한다.

## 사용 방법

<span>1.</span> [.env](.env) 파일을 구성한다.

<span>2.</span> [Vagrantfile](Vagrantfile)이 위치한 경로에서 하단의 명령어를 bash 쉘에 입력한다.

```sh
# 필수 플러그인 설치
$ vagrant plugin install vagrant-env

# 프로비전이 실패할 경우를 대비해서 초기 설치 상태로 스냅샷을 생성한다
$ provision=false vagrant up
$ vagrant snapshot save up

# 다음의 명령어로 저장한 스냅샷으로 초기화 가능
$ vagrant snapshot restore up

# root 패스워드 입력 시, 자동으로 설정된다
$ root_pass=true vagrant provision --color
# 더 정확한 정보를 확인하고 싶다면 debug 옵션을 추가 입력한다
$ debug=true vagrant provision --color

$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')

# 기본 설정이라면 아래의 명령어로 접속이 가능하다
$ vagrant ssh m1
$ ssh vagrant@10.254.1.51
$ ssh -p 5701 vagrant@localhost
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

사설 도커 레지스트리가 생성되며, insecure 옵션으로 https 없이도 사용 가능하다
```
$ curl http://m1:5000/v2/
{}
```

## 문제 해결

<span>1.</span> 프로비전이 실패한 경우 **vagrant provision** 명령어로 이를 다시 시도한다.

<span>2.</span> **vagrant destroy --force && vagrant up** 와 같이 가상머신을 삭제하고 다시 생성할때,<br/>
간혹 정상적으로 삭제된 것으로 보이지만 실제로는 삭제되지 않아서 실패하는 경우가 있으므로 버추얼 머신 환경설정의 가상머신 파일 저장 경로에서 이를 직접 확인해서 삭제 후 다시 시도한다.

<hr/>

## Introduce
IaC (Infra as Code) tool designed for easy and fast Docker + Kubernetes development, learning, and lecture environment construction<br/>
with using Vagrant, Ansible, Kubeadm.

## Requirements before use

[Vagrant](https://www.vagrantup.com/downloads) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) must be installed in the user's environment in advance.

## How to Use

<span>1.</span> Configure the [.env](.env) file.

<span>2.</span> Type the following command into the bash shell in the path where the [Vagrantfile](Vagrantfile) is located.

```sh
# Install required plugins
$ vagrant plugin install vagrant-env

# Create a snapshot of the initial installation state in case provisioning fails
$ provision=false vagrant up
$ vagrant snapshot save up

# It can be initialized with the saved snapshot with the following command
$ vagrant snapshot restore up

# It is automatically set when the root password is entered.
$ root_pass=true vagrant provision --color
# If you want to check more accurate information, add the debug option
$ debug=true vagrant provision --color

$ vagrant ssh $(vagrant status | tail -5 | sed -n '1p' | awk '{ print $1}')

# If it is the default setting, you can access it with the following command
$ vagrant ssh m1
$ ssh vagrant@10.254.1.51
$ ssh -p 5701 vagrant@localhost
```

## Note

Several aliases are automatically registered.

```
alias ans='ansible'
alias anp='ansible-playbook'
alias vi='vim'
alias d='docker'
alias k='kubectl'
```

A private docker registry is created and can be used without https with the insecure option
```
$ curl http://m1:5000/v2/
{}
```

## Trouble Shooting

<span>1.</span> If provisioning fails, try again with the **vagrant provision** command.

<span>2.</span> When deleting and recreating a virtual machine like **vagrant destroy --force && vagrant up**,<br/>
it appears to have been deleted normally, but it is not actually deleted once at a time. Check it yourself, delete it, and try again.

<hr/>

## 라이센스, License

### [Apache License 2.0](LICENSE)

### [Vim License](https://github.com/tpope/vim-pathogen/blob/master/LICENSE)

<hr/>

## 개인 블로그, Personal Blog

### [dragonz.dev](https://dragonz.dev)

<hr/>

## 공식 문서, Official Documents

### [Vagrant](https://www.vagrantup.com/docs)

### [Ansible](https://docs.ansible.com/)

### [Containred](https://containerd.io/)

### [Docker](https://docs.docker.com/)

### [Cri-o](https://cri-o.io/)

### [Kubernetes](https://kubernetes.io/ko/docs/home/)

<hr/>

## 추가 개발 예정, Development plan
- Add multi-master node keepalived, haproxy task
- docker runtime role
- cri-o runtime role
- install ruby environment role
- install nodejs environment role
- other cni plugins task

<hr/>
 
## 참고한 책, Book referenced

카와무라 세이고,기타노 타로오,나카야마 타카히로,구사카베 타카아키,리쿠르트 테크놀로지,
번역 양성건,영진닷컴(2020),IT 운용 체제 변화를 위한 데브옵스<br/>

정원천,공용준,홍석용,정경록,동양북스(2020),쿠버네티스 입문<br/>

용찬호,위키북스(2020),시작하세요! 도커/쿠버네티스

<hr/>

## 참고한 곳, Site referenced

### Shell script

[핸드오버,일상 메모장](https://hand-over.tistory.com/32)<br/>
[양햄찌가 만드는 세상](https://jhnyang.tistory.com/146)

### ruby<br/>

[조묵헌,Ruby 처음 배우기:데이터타입](https://smartbase.tistory.com/47)<br/>
[yundream,Joinc](https://www.joinc.co.kr/w/Site/Ruby/File)

### vagrant<br/>

[asdf,노력 이기는 재능 없고 노력 외면하는 결과도 없다](https://m.blog.naver.com/PostView.nhn?blogId=sory1008&logNo=220759961657&proxyReferer=https:%2F%2Fwww.google.com%2F)<br/>
[YOUNG.K](https://rangken.github.io/blog/2015/vagrant-1/)

### ansible<br/>

[세모데](https://semode.tistory.com/m/164)<br/>
[Sentimental Programmer](https://yoonbh2714.blogspot.com/2020/09/ansible-ssh-password.html)<br/>
[부들잎의 이것저것](https://forteleaf.tistory.com/entry/ansible-%EC%9E%90%EB%8F%99%ED%99%94%EC%9D%98-%EC%8B%9C%EC%9E%91)<br/>
[mydailytutorials,Working with Environment​ Variables in Ansible](https://www.mydailytutorials.com/working-with-environment%E2%80%8B-variables-in-ansible/)<br/>
[How to create a file in ansible](https://phoenixnap.com/kb/ansible-create-file)

### python j2 template<br/>

[Python2.net](https://www.python2.net/questions-962144.htm)<br/>

### kubernetes<br/>

[브랜든의 블로그](https://brenden.tistory.com/109)<br/>
[alice_k106님의 블로그](https://m.blog.naver.com/PostView.nhn?blogId=alice_k106&logNo=221315933945&proxyReferer=&proxyReferer=https:%2F%2Fwww.google.com%2F)<br/>
[teamsmiley 블로그](https://teamsmiley.github.io/2020/09/30/kubespray-01-vagrant/)

### lecture<br/>
[Just me and Opensource](https://www.youtube.com/user/wenkatn)<br/>
[조훈,다양한 환경을 앤서블(Ansible)로 관리하기 with 베이그런트(Vagrant)](https://www.inflearn.com/course/ansible-%EC%9D%91%EC%9A%A9/dashboard)<br/>

### git repository<br/>
[rayshoo/vansible_wish_kubespray](https://github.com/rayshoo/vansible_with_kubespray)<br/>
[kairen/kubeadm-ansible](https://github.com/kairen/kubeadm-ansible)<br/>
[junegunn/vim-plug](https://github.com/junegunn/vim-plug)<br/>
[pearofducks/ansible-vim](https://github.com/pearofducks/ansible-vim)<br/>
[tpope/vim-pathogen](https://github.com/tpope/vim-pathogen)<br/>
[chase/vim-ansible-yaml](https://github.com/chase/vim-ansible-yaml)<br/>
[telus/ansible-motd](https://github.com/telus/ansible-motd)