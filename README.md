# AI/SW 개발 워크스테이션 구축

`Requirements.md`의 첫 주차 필수 요구사항을 기준으로 CLI 실습, Docker 기본 운영, Dockerfile 기반 커스텀 이미지, 포트 매핑, 바인드 마운트, 볼륨 영속성, Git/GitHub 연동을 한 저장소에 정리했다.

## 1. 프로젝트 개요

- 목표: 터미널 중심으로 개발 워크스테이션을 구축하고, Docker 컨테이너를 직접 다뤄 보며 재현 가능한 실행 환경을 만든다.
- 선택한 구현 방식: `nginx:alpine` 기반 커스텀 이미지 + 정적 HTML 페이지
- 제출 기준: README만 읽어도 수행 절차, 검증 방법, 결과 위치를 확인할 수 있어야 한다.
- GitHub 저장소: `https://github.com/NiceTry3675/E1-1`

## 2. 실행 환경

- OS: Ubuntu 24.04.3 LTS on WSL2
- Shell: bash
- Terminal: Codex bash session
- Docker: 28.3.0 (Docker Desktop / `desktop-linux` context)
- Git: 2.43.0
- VS Code: 1.112.0

전체 로그: [environment.txt](docs/logs/environment.txt)

```text
+ uname -a
Linux localhost 6.6.87.2-microsoft-standard-WSL2 ...
+ git --version
git version 2.43.0
+ code --version
1.112.0
```

### 현재 복습 환경 (`mac + OrbStack`)

이 저장소의 제출 로그는 `Ubuntu on WSL2` 기준으로 남겨 두고, 현재 머신에서는 같은 과제를 `macOS + OrbStack`으로 다시 따라가며 개념을 복습했다.

- OS: macOS 15.7.4
- Shell: `zsh`
- Docker: 28.5.2 (`orbstack` context)
- Git: 2.53.0
- GitHub CLI: 2.89.0 설치됨, `gh auth login` 완료

현재 환경 로그:

- [environment-mac-orbstack.txt](docs/logs/environment-mac-orbstack.txt)
- [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)
- [volume-mac-orbstack.txt](docs/logs/volume-mac-orbstack.txt)
- [git-config-mac-orbstack.txt](docs/logs/git-config-mac-orbstack.txt)

## 3. 수행 체크리스트

- [x] 터미널 기본 조작 및 파일/디렉터리 생성
- [x] 파일 1개, 디렉터리 1개 권한 변경 실습
- [x] Docker 설치/동작 점검
- [x] `hello-world` 실행
- [x] `ubuntu` 컨테이너 내부 명령 실행
- [x] `Dockerfile` 기반 커스텀 이미지 빌드
- [x] 포트 매핑 접속 확인 (`8080`, `8081`)
- [x] 바인드 마운트 변경 반영 확인 (`8083`)
- [x] named volume 영속성 확인
- [x] Git 사용자 정보 / 기본 브랜치 설정
- [x] GitHub CLI 로그인 상태 확인

## 4. 결과 위치와 검증 방법

- 환경 정보: [environment.txt](docs/logs/environment.txt)
- 터미널 기본 조작 / 권한: [cli-session.txt](docs/logs/cli-session.txt)
- Docker 설치 점검 / 기본 운영 / `hello-world` / `ubuntu`: [docker-basics.txt](docs/logs/docker-basics.txt)
- `attach` / `exec` 관찰: [container-observation.txt](docs/logs/container-observation.txt)
- Dockerfile 빌드 / 포트 매핑 / 웹 로그: [custom-image.txt](docs/logs/custom-image.txt)
- 바인드 마운트: [bind-mount.txt](docs/logs/bind-mount.txt)
- 바인드 마운트 경로 오류 재현: [bind-mount-invalid-path.txt](docs/logs/bind-mount-invalid-path.txt)
- 볼륨 영속성: [volume.txt](docs/logs/volume.txt)
- Git 설정: [git-config.txt](docs/logs/git-config.txt)
- GitHub 인증 상태: [github-auth.txt](docs/logs/github-auth.txt)
- GitHub 원격 생성 / push: [github-remote.txt](docs/logs/github-remote.txt)
- 현재 mac 환경 정보: [environment-mac-orbstack.txt](docs/logs/environment-mac-orbstack.txt)
- 현재 mac Docker 복습 로그: [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)
- 현재 mac 볼륨 복습 로그: [volume-mac-orbstack.txt](docs/logs/volume-mac-orbstack.txt)
- 현재 mac Git/GitHub 상태: [git-config-mac-orbstack.txt](docs/logs/git-config-mac-orbstack.txt)
- Docker Compose 보너스 실습 로그: [compose-bonus.txt](docs/logs/compose-bonus.txt)
- 현재 유지 중인 Compose 스택 상태: [compose-live-status.txt](docs/logs/compose-live-status.txt)
- GitHub SSH 전환 로그: [github-ssh.txt](docs/logs/github-ssh.txt)

## 5. 디렉터리 구조 설계 기준

이 저장소는 "실행 파일", "증거", "실습 흔적"을 분리하는 기준으로 구성했다.

- `site/`: 커스텀 이미지에 실제로 복사되는 웹 서버 정적 파일을 둔다. 빌드 대상이 명확해야 해서 런타임 산출물과 분리했다.
- `docs/logs/`: 평가자가 명령어 입력과 출력 결과를 바로 따라갈 수 있도록 로그만 모아 둔다. README에서는 이 폴더를 증거 인덱스로 사용한다.
- `docs/screenshots/`: 브라우저 접속, VS Code 연동처럼 로그만으로 부족한 시각 증거를 분리한다.
- `practice/cli-lab/`: `mkdir`, `cp`, `mv`, `rm`, `chmod` 같은 CLI 실습 흔적을 남기는 별도 공간이다. 제출용 앱 파일과 섞이지 않게 분리했다.
- `practice/bind-proof/`: 바인드 마운트 전용 테스트 디렉터리다. `site/`와 분리해 두어 커스텀 이미지의 고정 결과와 바인드 마운트의 "호스트 변경 전/후" 실험이 서로 영향을 주지 않게 했다.
- `bonus/compose-stack/`: Docker Compose 보너스 과제 전용 디렉터리다. `compose.yaml`, 커스텀 웹 이미지 Dockerfile, 환경 변수 파일을 묶어 두었다.

## 6. 재현성 기준

포트와 볼륨은 "이름과 역할을 먼저 고정하고, 로그에서 같은 이름을 반복 사용"하는 방식으로 정리했다.

- 커스텀 이미지 이름은 `workstation-nginx:1.0`으로 고정했다. README와 로그에서 같은 이름을 사용하므로 그대로 다시 빌드할 수 있다.
- 포트 역할을 분리했다. `8080`, `8081`은 같은 이미지를 두 번 실행하는 포트 매핑 검증용이고, `8083`은 바인드 마운트 변경 반영 확인용이다.
- 볼륨 이름을 `week1-data`로 고정해서, 생성 컨테이너와 재실행 컨테이너가 같은 저장소를 공유하도록 만들었다.
- README에는 "어떤 명령으로 무엇을 검증했는지"를 적고, 상세 출력은 `docs/logs/`로 링크했다. 그래서 문서만 읽고도 같은 순서로 재현할 수 있다.
- WSL + Docker Desktop과 native Linux/macOS의 bind mount 경로 차이는 문서에 분리해 적어 환경 차이 때문에 막히지 않도록 했다.

### mac + OrbStack에서 다시 따라할 때 바뀌는 점

- 절대 경로 예시는 `/home/...` 대신 `/Users/<username>/...` 형태로 읽으면 된다.
- WSL 로그에서 `docker.exe`로 실행한 명령은 macOS에서는 모두 `docker`로 그대로 바꿔 쓰면 된다.
- Docker context는 `desktop-linux` 대신 `orbstack`으로 보인다.
- bind mount는 `\\wsl.localhost\\...` 경로 변환 없이 `-v "$(pwd)/practice/bind-proof:/usr/share/nginx/html"`처럼 현재 경로를 직접 연결하면 된다.
- 현재 mac 환경에서는 `gh auth login`은 완료됐지만, Git 전역 `user.name`, `user.email`, `init.defaultBranch`는 아직 비어 있었다. 따라서 GitHub 인증과 별개로 Git 기본 설정은 한 번 더 채워야 한다.

### mac + OrbStack 복습 순서

아래 순서대로 실행하면 WSL2에서 했던 핵심 흐름을 거의 그대로 다시 확인할 수 있다.

```bash
docker --version
docker info
docker context ls

docker build -t workstation-nginx:1.0 .
docker run -d --name web-8080 -p 8080:80 workstation-nginx:1.0
docker run -d --name web-8081 -p 8081:80 workstation-nginx:1.0
curl -s http://localhost:8080 | rg 'Codyssey E1-1|Bind mount status'
curl -s http://localhost:8081 | rg 'Codyssey E1-1|Bind mount status'

docker run -dit --name ubuntu-lab ubuntu bash
docker exec ubuntu-lab bash -lc 'ls / | head && echo hello-from-container'

docker run -d --name bind-web -p 8083:80 \
  -v "$(pwd)/practice/bind-proof:/usr/share/nginx/html" nginx:alpine
curl -s http://localhost:8083 | rg 'Bind mount status'

docker volume create week1-data
docker run -d --name vol-test -v week1-data:/data ubuntu sleep infinity
docker exec vol-test bash -lc 'echo hi > /data/hello.txt && cat /data/hello.txt'
docker rm -f vol-test
docker run -d --name vol-test2 -v week1-data:/data ubuntu sleep infinity
docker exec vol-test2 bash -lc 'cat /data/hello.txt'
```

## 7. 터미널 조작 로그

실습 경로는 `practice/cli-lab`이다. 절대 경로는 `/home/tomto/projects/codyssey/E1-1/practice/cli-lab`처럼 루트(`/`)부터 시작하는 경로이고, 상대 경로는 현재 위치를 기준으로 한 `practice/cli-lab`, `move-me/renamed.txt` 같은 경로다.

전체 로그: [cli-session.txt](docs/logs/cli-session.txt)

```text
+ pwd
/home/tomto/projects/codyssey/E1-1/practice/cli-lab
+ ls -la
total 8
drwxr-xr-x 2 tomto tomto 4096 ...
+ cat notes.txt
hello cli
+ mv notes-copy.txt renamed.txt
+ mv renamed.txt move-me/renamed.txt
+ rm -f empty.txt
```

## 8. 권한 실습

파일 권한은 `rwx`를 소유자/그룹/기타 사용자에 대해 숫자로 압축한 표기다. `644`는 `rw-r--r--`, `755`는 `rwxr-xr-x`를 뜻한다.

전체 로그: [cli-session.txt](docs/logs/cli-session.txt)

```text
+ ls -ld perm-file.txt perm-dir
drwxr-xr-x ... perm-dir
-rw-r--r-- ... perm-file.txt
+ chmod 600 perm-file.txt
+ chmod 700 perm-dir
+ ls -ld perm-file.txt perm-dir
drwx------ ... perm-dir
-rw------- ... perm-file.txt
+ chmod 644 perm-file.txt
+ chmod 755 perm-dir
```

## 9. Docker 설치 및 기본 점검

Docker Desktop이 실행된 뒤 `desktop-linux` context에서 동작하는 것을 확인했다.

전체 로그: [docker-basics.txt](docs/logs/docker-basics.txt)

```text
+ docker --version
Docker version 28.3.0, build 38b7060
+ docker.exe context ls
default
desktop-linux *
+ docker.exe info
Server Version: 28.3.0
Operating System: Docker Desktop
OSType: linux
```

## 10. Docker 기본 운영 명령

이미지 목록, 컨테이너 목록, 로그, 리소스 사용량을 확인했고, 별도 테스트 컨테이너에 대해 `docker stop`도 수행했다.

전체 로그: [docker-basics.txt](docs/logs/docker-basics.txt)

```text
+ docker.exe images
hello-world
ubuntu
+ docker.exe ps -a
week1-hello   Exited (0)
+ docker.exe logs week1-hello
Hello from Docker!
+ docker.exe stats --no-stream ubuntu-lab
ubuntu-lab   0.00%   952KiB / 7.712GiB
+ docker.exe stop ubuntu-stop-demo
ubuntu-stop-demo
+ docker.exe ps -a --filter name=ubuntu-stop-demo
ubuntu-stop-demo   Exited (137)
```

## 11. 컨테이너 실행 실습

`hello-world`로 설치 확인을 마쳤고, `ubuntu-lab` 컨테이너 안에서 실제 명령을 실행했다.

전체 로그:

- [docker-basics.txt](docs/logs/docker-basics.txt)
- [container-observation.txt](docs/logs/container-observation.txt)

```text
+ docker.exe run --name week1-hello hello-world
Hello from Docker!
+
+ docker.exe run -dit --name ubuntu-lab ubuntu bash
+ docker.exe exec ubuntu-lab bash -lc 'ls / && echo hello-from-container'
bin
boot
...
hello-from-container
```

`attach`와 `exec` 차이 정리:

```text
+ timeout 2 script -qfc 'docker attach ubuntu-lab' /tmp/attach-observation.log
+ docker ps --filter name=ubuntu-lab
ubuntu-lab   Up
+ docker exec ubuntu-lab bash -lc 'echo exec-shell-exit-demo'
exec-shell-exit-demo
+ docker ps --filter name=ubuntu-lab
ubuntu-lab   Up
```

- `attach`는 컨테이너의 메인 프로세스 표준 입출력에 직접 붙는다.
- `exec`는 이미 실행 중인 컨테이너 안에 별도 프로세스를 추가 실행한다.
- 자동 로그에서는 `attach`를 제한 시간으로 붙였다 끊은 뒤에도 `ubuntu-lab`이 계속 `Up` 상태인 것을 확인했다.
- `exec`로 실행한 셸이 종료된 뒤에도 `docker ps`에서 `ubuntu-lab`이 계속 `Up` 상태라서, `exec`는 메인 프로세스를 종료시키지 않음을 확인했다.
- 이번 과제에서는 메인 `bash`를 유지한 채 실험해야 했기 때문에 관찰과 기록에는 `exec`가 더 안전했다.

## 12. Dockerfile 기반 커스텀 이미지

선택한 베이스 이미지는 `nginx:alpine`이다.

- 선택 이유: 포트 매핑과 브라우저/`curl` 검증이 단순하다.
- 커스텀 포인트 1: 제출용 정적 페이지를 `site/`에서 복사
- 커스텀 포인트 2: 기본 NGINX 페이지 대신 과제 식별 문구 노출

관련 파일:

- [Dockerfile](Dockerfile)
- [site/index.html](site/index.html)
- 전체 로그: [custom-image.txt](docs/logs/custom-image.txt)

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-workstation"
COPY site/ /usr/share/nginx/html/
```

## 13. 포트 매핑 및 접속 증거

동일 이미지를 두 번 실행해 `8080`, `8081` 포트로 각각 접근 가능한 것을 확인했다. 이것으로 이미지와 컨테이너가 분리되어 있고, 같은 이미지에서 여러 컨테이너를 반복 실행할 수 있음을 확인했다.

포트 매핑이 필요한 이유:

- 컨테이너 내부 포트 `80`은 기본적으로 컨테이너 네트워크 안에서만 열려 있다.
- 호스트 브라우저에서 `localhost:80`이나 `localhost:8080`으로 접근하려면, 호스트 포트와 컨테이너 포트를 `-p 호스트:컨테이너`로 연결해야 한다.
- 포트 매핑이 없으면 컨테이너 안의 웹 서버가 살아 있어도 호스트에서는 바로 접속할 수 없다.
- 따라서 포트 매핑은 "격리된 컨테이너 서비스"를 "호스트에서 접근 가능한 서비스"로 노출하는 연결 단계다.

전체 로그: [custom-image.txt](docs/logs/custom-image.txt)

브라우저 스크린샷:

![Docker browser proof](docs/screenshots/docker-browser-8080.png)

```text
+ docker.exe run -d --name week1-web-8080 -p 8080:80 workstation-nginx:1.0
+ docker.exe run -d --name week1-web-8081 -p 8081:80 workstation-nginx:1.0
+ curl -s http://localhost:8080 | rg 'Codyssey E1-1|Bind mount status'
<title>Codyssey E1-1</title>
<p id="bind-marker">Bind mount status: initial content</p>
+ curl -s http://localhost:8081 | rg 'Codyssey E1-1|Bind mount status'
<title>Codyssey E1-1</title>
<p id="bind-marker">Bind mount status: initial content</p>
```

## 14. 바인드 마운트 반영

호스트의 `practice/bind-proof/` 디렉터리를 NGINX 컨테이너에 읽기 전용으로 마운트하고, `8083` 포트에서 호스트 파일 내용을 직접 바꾼 뒤 컨테이너를 재생성하지 않고 응답이 바뀌는지 확인했다.

전체 로그: [bind-mount.txt](docs/logs/bind-mount.txt)

환경별 주의사항:

- 현재 로그의 `\\wsl.localhost\...` 경로는 `WSL + Docker Desktop` 조합에서 사용한 bind mount 경로다.
- native Linux/macOS에서는 같은 절차를 `-v "$(pwd)/practice/bind-proof:/usr/share/nginx/html:ro"`처럼 바로 현재 경로로 실행하면 된다.

```text
+ printf '%s\n' '<!doctype html>' '<html><body><p id="bind-marker">Bind mount status: before host edit</p></body></html>' > practice/bind-proof/index.html
+ cat practice/bind-proof/index.html
<!doctype html>
<html><body><p id="bind-marker">Bind mount status: before host edit</p></body></html>
+ docker.exe run -d --name week1-bind-proof -p 8083:80 -v '\\wsl.localhost\Ubuntu\home\tomto\projects\codyssey\E1-1\practice\bind-proof:/usr/share/nginx/html:ro' nginx:alpine
+ curl -s http://localhost:8083 | rg 'Bind mount status'
<html><body><p id="bind-marker">Bind mount status: before host edit</p></body></html>
+ printf '%s\n' '<!doctype html>' '<html><body><p id="bind-marker">Bind mount status: after host edit</p></body></html>' > practice/bind-proof/index.html
+ cat practice/bind-proof/index.html
<!doctype html>
<html><body><p id="bind-marker">Bind mount status: after host edit</p></body></html>
+ curl -s http://localhost:8083 | rg 'Bind mount status'
<html><body><p id="bind-marker">Bind mount status: after host edit</p></body></html>
```

정리:

- 바인드 마운트는 호스트 파일 변경이 컨테이너에 즉시 반영되는지 확인하는 데 적합하다.
- 소스 반영 확인이 목적일 때는 이미지 재빌드보다 빠르다.

## 15. Docker 볼륨 영속성 검증

named volume `week1-data`를 만들고, 컨테이너 삭제 전후로 같은 파일이 유지되는지 확인했다.

전체 로그: [volume.txt](docs/logs/volume.txt)

```text
+ docker.exe volume create week1-data
week1-data
+ docker.exe exec week1-volume bash -lc 'echo persisted-from-volume > /data/hello.txt && cat /data/hello.txt'
persisted-from-volume
+ docker.exe rm -f week1-volume
+ docker.exe exec week1-volume-2 bash -lc 'cat /data/hello.txt'
persisted-from-volume
```

정리:

- 바인드 마운트는 호스트 디렉터리와 연결된다.
- 볼륨은 Docker가 관리하는 저장소라서 컨테이너를 지워도 데이터가 남는다.

## 16. Git 설정 및 GitHub 연동

기본 브랜치를 `main`으로 설정했고, `git config --list`와 `gh auth status`를 명령어 포함 로그로 기록했다. 토큰과 이메일은 마스킹했다.

전체 로그:

- [git-config.txt](docs/logs/git-config.txt)
- [github-auth.txt](docs/logs/github-auth.txt)
- [github-remote.txt](docs/logs/github-remote.txt)

VS Code 연동 스크린샷:

![VS Code GitHub proof](docs/screenshots/vscode-source-control-github.png)

```text
git config --list
user.name=NiceTry3675
user.email=to***@hs.ac.kr
init.defaultbranch=main
```

```text
gh auth status
Logged in to github.com account NiceTry3675
Git operations protocol: https
Token: gho_************************************
```

```text
gh repo create E1-1 --public --source=. --remote=origin --push
https://github.com/NiceTry3675/E1-1
origin  https://github.com/NiceTry3675/E1-1.git (fetch)
origin  https://github.com/NiceTry3675/E1-1.git (push)
```

참고:

- 본 저장소는 CLI 로그와 VS Code 스크린샷을 함께 남겼다.

## 17. 핵심 개념 정리

### 이미지와 컨테이너 차이

- `빌드`: 이미지는 `Dockerfile`로 만드는 템플릿 결과물이다. 예를 들어 `docker build -t workstation-nginx:1.0 .`는 실행 가능한 청사진을 만든다.
- `실행`: 컨테이너는 이미지를 기반으로 실제 프로세스를 띄운 인스턴스다. 같은 이미지에서 `week1-web-8080`, `week1-web-8081`처럼 여러 컨테이너를 만들 수 있다.
- `변경`: 컨테이너 안에서 생긴 임시 변경은 컨테이너에 묶인다. 컨테이너를 지우면 사라질 수 있다. 반대로 이미지를 바꾸려면 `Dockerfile`이나 복사할 소스를 고쳐서 다시 빌드해야 한다.
- `정리`: 이미지는 "설계도", 컨테이너는 "실행 중인 복사본"이다. 그래서 이미지를 한 번 빌드해 두면 여러 컨테이너를 반복 실행해도 같은 시작 상태를 재현할 수 있다.

### 호스트 포트 충돌 진단 순서

호스트 포트가 이미 사용 중이라 포트 매핑이 실패하면 아래 순서로 확인한다.

1. 에러 메시지에서 어느 호스트 포트가 충돌했는지 먼저 확인한다.
2. `docker ps`로 같은 포트를 이미 쓰는 다른 컨테이너가 있는지 확인한다.
3. Docker 쪽이 아니면 `ss -ltnp | rg ':8080'` 같은 명령으로 호스트에서 해당 포트를 점유한 프로세스를 찾는다.
4. 충돌 원인이 테스트용 컨테이너면 `docker stop` 또는 `docker rm -f`로 정리한다.
5. 정리하기 어려운 프로세스면 다른 빈 포트로 바꿔 `-p 8084:80`처럼 다시 실행한다.
6. 마지막으로 브라우저나 `curl`로 새 포트가 실제로 열렸는지 다시 검증한다.

## 18. 트러블슈팅

### 1) WSL 셸에서 `docker`가 처음에는 잡히지 않음

- 문제: 초기 확인 시 WSL 셸에서 `docker` 명령이 없다는 메시지가 나왔다.
- 원인 가설: Docker Desktop 앱이 실행되지 않았거나 WSL 쪽 통합이 아직 연결되지 않았다.
- 확인: `docker.exe info`도 처음에는 `dockerDesktopLinuxEngine` 파이프를 찾지 못했다.
- 해결: Windows의 Docker Desktop을 실행한 뒤 다시 점검했고, 이후 `docker --version`, `docker.exe info`가 정상 동작했다.

### 2) 바인드 마운트 경로가 잘못되어 컨테이너 실행 실패

- 문제: 첫 바인드 마운트 시 `is not a valid Windows path` 오류가 발생했다.
- 원인 가설: `wslpath -w`로 만든 경로를 감싸는 quoting이 잘못되어 경로 앞뒤에 불필요한 문자가 붙었다.
- 확인: [bind-mount-invalid-path.txt](docs/logs/bind-mount-invalid-path.txt)에 잘못된 경로와 오류 메시지를 따로 기록했다.
- 해결: `WSL + Docker Desktop`에서는 `wslpath -w "$(pwd)/practice/bind-proof"`로 변환한 경로를 쓰고, native Linux/macOS에서는 `$(pwd)/practice/bind-proof`를 직접 사용하면 된다.

### 3) Git 기본 브랜치가 명시돼 있지 않음

- 문제: 전역 설정에 `init.defaultbranch`가 없었다.
- 원인 가설: Git 설치 후 기본 브랜치 설정을 따로 하지 않았다.
- 확인: `git config --global init.defaultBranch`가 빈 값이었다.
- 해결: `git config --global init.defaultBranch main`으로 고정하고 저장소를 `main` 브랜치로 초기화했다.

## 19. 보너스 과제: Docker Compose / 환경 변수

`Requirements.md`의 보너스 항목 중 로컬에서 바로 재현 가능한 항목을 현재 `mac + OrbStack` 환경에서 진행했다.

완료한 항목:

- Docker Compose 기초: 단일 서비스 `web`만 `up -d web --no-deps`로 실행
- Docker Compose 멀티 컨테이너: `web + echo` 두 서비스를 함께 실행
- Compose 운영 명령어: `up`, `ps`, `logs`, `down` 순서로 관리
- 환경 변수 활용: `.env.compose`, `.env.compose.override`로 포트/모드/응답 문구 변경
- GitHub SSH 키 설정: 새 `ed25519` 키 생성, GitHub 등록, 저장소 원격을 SSH로 전환

관련 파일:

- [compose.yaml](bonus/compose-stack/compose.yaml)
- [Dockerfile](bonus/compose-stack/Dockerfile)
- [entrypoint.sh](bonus/compose-stack/entrypoint.sh)
- [default.conf.template](bonus/compose-stack/nginx/default.conf.template)
- [index.template.html](bonus/compose-stack/site/index.template.html)
- [.env.compose](bonus/compose-stack/.env.compose)
- [.env.compose.override](bonus/compose-stack/.env.compose.override)
- [compose-bonus.txt](docs/logs/compose-bonus.txt)
- [compose-live-status.txt](docs/logs/compose-live-status.txt)
- [github-ssh.txt](docs/logs/github-ssh.txt)

핵심 검증:

- 단일 서비스 실행 시 `localhost:8090`에서 Compose로 빌드한 페이지가 열렸다.
- 멀티 컨테이너 실행 시 `localhost:8090/api/`가 `echo` 서비스 응답 `hello-from-compose-echo`를 반환했다.
- `docker compose exec -T web wget -qO- http://echo:5678/`로 컨테이너 간 서비스 이름 기반 통신을 확인했다.
- 환경 변수 오버라이드 파일을 적용했을 때 `localhost:8092` 페이지의 `App mode`가 `compose-env`로 바뀌고 `/api/` 응답도 `compose-env-reply`로 바뀌었다.

현재 유지 중인 최종 스택:

- Compose project: `week1-bonus-live`
- 접속 주소: `http://localhost:8090`
- API 프록시: `http://localhost:8090/api/`

```text
+ docker compose -p week1-bonus-live -f bonus/compose-stack/compose.yaml --env-file bonus/compose-stack/.env.compose ps
NAME                      IMAGE                       SERVICE   PORTS
week1-bonus-live-echo-1   hashicorp/http-echo:1.0.0   echo      5678/tcp
week1-bonus-live-web-1    week1-bonus-live-web        web       0.0.0.0:8090->80/tcp

+ curl -s http://localhost:8090/api/
hello-from-compose-echo
```

메모:

- `web` 단독 실행도 가능하도록 NGINX upstream 해석을 런타임 DNS 방식으로 조정했다. 그래서 `echo` 없이 `web`만 실행해도 루트 페이지는 정상 기동한다.
- GitHub SSH는 `~/.ssh/id_ed25519_github` 키를 새로 만들고 GitHub 계정에 등록한 뒤, `origin`을 `git@github.com:NiceTry3675/E1-1.git`로 변경했다.
- 로컬 SSH 설정은 저장소 밖의 `~/.ssh/config`에 `Host github.com` 블록을 추가해 이 저장소가 GitHub 접속 시 해당 키를 사용하게 했다.

## 20. 보안 및 개인정보 보호

- README와 로그에는 토큰 전체 값을 남기지 않았다.
- Git 이메일은 마스킹했다.
- 비밀번호, 개인키, OTP 코드는 저장하지 않았다.
- GUI 스크린샷을 추가할 경우에도 주소창과 결과만 남기고 민감정보는 가린다.
