# AI/SW 개발 워크스테이션 구축

`Requirements.md`의 첫 주차 요구사항을 `macOS + OrbStack` 환경 기준으로 다시 정리했다. CLI 기본 조작, Docker 기본 운영, 커스텀 이미지 빌드, 포트 매핑, 바인드 마운트, 볼륨 영속성, Git/GitHub 연동, Docker Compose 보너스까지 한 저장소에서 재현할 수 있게 구성했다.

## 1. 프로젝트 개요

- 목표: 터미널 중심 개발 환경을 직접 다뤄 보고, Docker 실습 과정을 재현 가능한 로그로 남긴다.
- 선택한 구현 방식: `nginx:alpine` 기반 커스텀 이미지 + 정적 HTML 페이지
- 제출 기준: README만 읽어도 수행 절차, 검증 방법, 결과 위치를 따라갈 수 있어야 한다.
- GitHub 저장소: `https://github.com/NiceTry3675/E1-1`

## 2. 실행 환경

- OS: macOS 15.7.4
- Shell: `zsh`
- Docker: 28.5.2
- Docker context: `orbstack`
- Git: 2.53.0
- GitHub CLI: 2.89.0

전체 로그: [environment-mac-orbstack.txt](docs/logs/environment-mac-orbstack.txt)

```text
+ uname -a
Darwin ... 24.6.0 ...
+ docker context ls
orbstack *
+ docker info --format 'Server Version: {{.ServerVersion}} | Context: {{.ClientInfo.Context}} | Operating System: {{.OperatingSystem}} | OSType: {{.OSType}} | Architecture: {{.Architecture}}'
Server Version: 28.5.2 | Context: orbstack | Operating System: OrbStack | OSType: linux | Architecture: x86_64
```

## 3. 수행 체크리스트

- [x] 터미널 기본 조작 및 파일/디렉터리 생성
- [x] 파일 1개, 디렉터리 1개 권한 변경 실습
- [x] Docker 설치/동작 점검
- [x] `hello-world` 실행
- [x] `ubuntu` 컨테이너 내부 명령 실행
- [x] `attach` / `exec` 차이 관찰
- [x] `Dockerfile` 기반 커스텀 이미지 빌드
- [x] 포트 매핑 접속 확인 (`8080`, `8081`)
- [x] 바인드 마운트 변경 반영 확인 (`8083`)
- [x] named volume 영속성 확인
- [x] Git 사용자 정보 확인
- [x] GitHub CLI 로그인 상태 확인
- [x] GitHub SSH 연결 확인
- [x] Docker Compose 보너스 과제 수행

## 4. 결과 위치와 검증 방법

- 환경 정보: [environment-mac-orbstack.txt](docs/logs/environment-mac-orbstack.txt)
- 터미널 기본 조작 / 권한: [cli-session-mac-orbstack.txt](docs/logs/cli-session-mac-orbstack.txt)
- Docker 설치 점검 / 기본 운영 / `hello-world` / `docker stop`: [docker-basics-mac-orbstack.txt](docs/logs/docker-basics-mac-orbstack.txt)
- `attach` / `exec` 관찰: [container-observation-mac-orbstack.txt](docs/logs/container-observation-mac-orbstack.txt)
- Dockerfile 빌드 / 포트 매핑 / 바인드 마운트 / `ubuntu` 실습: [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)
- 볼륨 영속성: [volume-mac-orbstack.txt](docs/logs/volume-mac-orbstack.txt)
- Git / GitHub 상태: [git-config-mac-orbstack.txt](docs/logs/git-config-mac-orbstack.txt)
- GitHub SSH 전환 로그: [github-ssh.txt](docs/logs/github-ssh.txt)
- Docker Compose 보너스 실습 로그: [compose-bonus.txt](docs/logs/compose-bonus.txt)
- 현재 유지 중인 Compose 스택 상태: [compose-live-status.txt](docs/logs/compose-live-status.txt)

## 5. 디렉터리 구조 설계 기준

- `site/`: 커스텀 이미지에 복사되는 정적 웹 파일
- `docs/logs/`: 명령어 입력과 출력 결과를 모은 증거 로그
- `docs/screenshots/`: 브라우저 접속이나 VS Code 연동 같은 시각 증거
- `practice/cli-lab/`: CLI 실습 흔적을 남기는 공간
- `practice/bind-proof/`: 바인드 마운트 전용 테스트 디렉터리
- `bonus/compose-stack/`: Docker Compose 보너스 과제 전용 디렉터리

## 6. 재현성 기준

- 커스텀 이미지 이름은 `workstation-nginx:orbstack-review`로 다시 빌드해 검증했다.
- 포트 역할을 분리했다. `8080`, `8081`은 같은 이미지 반복 실행 검증용이고 `8083`은 바인드 마운트 반영 확인용이다.
- 볼륨 이름은 `week1-data-orbstack`으로 고정해서 영속성 확인에 사용했다.
- README에는 수행 순서를 적고, 상세 출력은 `docs/logs/`로 연결했다.

## 7. mac + OrbStack 복습 순서

아래 순서대로 실행하면 이 README의 핵심 실습을 그대로 따라갈 수 있다.

```bash
cd /Users/tomtom351778618/Documents/E1-1

docker --version
docker context ls
docker info

cd practice/cli-lab
pwd
ls -la
touch mac-empty.txt
printf 'hello mac cli\n' > mac-notes.txt
cat mac-notes.txt
cp mac-notes.txt mac-notes-copy.txt
mv mac-notes-copy.txt mac-renamed.txt
mv mac-renamed.txt mac-lab/move-me/mac-renamed.txt
rm -f mac-empty.txt
mkdir -p mac-perm-dir
touch mac-perm-file.txt
chmod 600 mac-perm-file.txt
chmod 700 mac-perm-dir

cd /Users/tomtom351778618/Documents/E1-1
docker build -t workstation-nginx:orbstack-review .
docker run -d --name orbstack-web-8080 -p 8080:80 workstation-nginx:orbstack-review
docker run -d --name orbstack-web-8081 -p 8081:80 workstation-nginx:orbstack-review
curl -s http://localhost:8080 | rg 'Codyssey E1-1|Bind mount status'
curl -s http://localhost:8081 | rg 'Codyssey E1-1|Bind mount status'

docker run -dit --name ubuntu-lab-orbstack ubuntu bash
docker exec ubuntu-lab-orbstack bash -lc 'ls / | head && echo hello-from-orbstack-container'

docker run -d --name orbstack-bind -p 8083:80 \
  -v "$(pwd)/practice/bind-proof:/usr/share/nginx/html" nginx:alpine
curl -s http://localhost:8083 | rg 'Bind mount status'

docker volume create week1-data-orbstack
docker run -d --name vol-test-orbstack -v week1-data-orbstack:/data ubuntu sleep infinity
docker exec vol-test-orbstack bash -lc 'echo hi-from-volume > /data/hello.txt && cat /data/hello.txt'
docker rm -f vol-test-orbstack
docker run -d --name vol-test-orbstack-2 -v week1-data-orbstack:/data ubuntu sleep infinity
docker exec vol-test-orbstack-2 bash -lc 'cat /data/hello.txt'
```

관련 로그:

- [cli-session-mac-orbstack.txt](docs/logs/cli-session-mac-orbstack.txt)
- [docker-basics-mac-orbstack.txt](docs/logs/docker-basics-mac-orbstack.txt)
- [container-observation-mac-orbstack.txt](docs/logs/container-observation-mac-orbstack.txt)
- [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)
- [volume-mac-orbstack.txt](docs/logs/volume-mac-orbstack.txt)

## 8. 터미널 조작 로그

실습 경로는 `practice/cli-lab`이다. 절대 경로는 `/Users/...`처럼 루트(`/`)부터 시작하는 경로이고, 상대 경로는 현재 위치를 기준으로 한 `practice/cli-lab`, `mac-lab/move-me/mac-renamed.txt` 같은 경로다.

전체 로그: [cli-session-mac-orbstack.txt](docs/logs/cli-session-mac-orbstack.txt)

```text
+ pwd
/Users/tomtom351778618/Documents/E1-1/practice/cli-lab
+ touch mac-empty.txt
+ printf "hello mac cli\n" > mac-notes.txt
+ cat mac-notes.txt
hello mac cli
+ mv mac-notes-copy.txt mac-renamed.txt
+ mv mac-renamed.txt mac-lab/move-me/mac-renamed.txt
+ rm -f mac-empty.txt
```

## 9. 권한 실습

파일 권한은 `rwx`를 소유자, 그룹, 기타 사용자에 대해 숫자로 압축한 표기다. `644`는 `rw-r--r--`, `755`는 `rwxr-xr-x`를 뜻한다.

전체 로그: [cli-session-mac-orbstack.txt](docs/logs/cli-session-mac-orbstack.txt)

```text
+ ls -ld mac-perm-file.txt mac-perm-dir
drwxr-xr-x ... mac-perm-dir
-rw-r--r-- ... mac-perm-file.txt
+ chmod 600 mac-perm-file.txt
+ chmod 700 mac-perm-dir
+ ls -ld mac-perm-file.txt mac-perm-dir
drwx------ ... mac-perm-dir
-rw------- ... mac-perm-file.txt
+ chmod 644 mac-perm-file.txt
+ chmod 755 mac-perm-dir
```

## 10. Docker 설치 및 기본 점검

현재 Docker는 OrbStack context에서 동작한다.

전체 로그: [docker-basics-mac-orbstack.txt](docs/logs/docker-basics-mac-orbstack.txt)

```text
+ docker --version
Docker version 28.5.2, build ecc6942
+ docker info --format "Server Version: {{.ServerVersion}} | Context: {{.ClientInfo.Context}} | Operating System: {{.OperatingSystem}} | OSType: {{.OSType}}"
Server Version: 28.5.2 | Context: orbstack | Operating System: OrbStack | OSType: linux
+ docker pull hello-world
Status: Downloaded newer image for hello-world:latest
```

## 11. Docker 기본 운영 명령

이미지 목록, 컨테이너 목록, 로그, 리소스 사용량을 확인했고 테스트 컨테이너에 대해 `docker stop`도 수행했다.

전체 로그: [docker-basics-mac-orbstack.txt](docs/logs/docker-basics-mac-orbstack.txt)

```text
+ docker images
hello-world
ubuntu
+ docker ps -a
week1-hello-mac   Exited (0)
+ docker logs week1-hello-mac
Hello from Docker!
+ docker stats --no-stream ubuntu-stop-demo-mac
ubuntu-stop-demo-mac   0.00%   704KiB / 15.67GiB
+ docker stop ubuntu-stop-demo-mac
ubuntu-stop-demo-mac
```

## 12. 컨테이너 실행 실습

`hello-world`로 설치 확인을 마쳤고, `ubuntu-lab-orbstack` 컨테이너 안에서 실제 명령을 실행했다.

전체 로그:

- [docker-basics-mac-orbstack.txt](docs/logs/docker-basics-mac-orbstack.txt)
- [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)
- [container-observation-mac-orbstack.txt](docs/logs/container-observation-mac-orbstack.txt)

```text
+ docker run --name week1-hello-mac hello-world
Hello from Docker!

+ docker run -dit --name ubuntu-lab-orbstack ubuntu bash
+ docker exec ubuntu-lab-orbstack bash -lc 'ls / | head && echo hello-from-orbstack-container'
bin
boot
...
hello-from-orbstack-container
```

`attach`와 `exec` 차이 정리:

```text
+ docker attach ubuntu-observe-mac
+ docker ps --filter name=ubuntu-observe-mac
ubuntu-observe-mac   Up
+ docker exec ubuntu-observe-mac bash -lc 'echo exec-shell-exit-demo-mac'
exec-shell-exit-demo-mac
+ docker ps --filter name=ubuntu-observe-mac
ubuntu-observe-mac   Up
```

- `attach`는 컨테이너의 메인 프로세스 표준 입출력에 직접 붙는다.
- `exec`는 실행 중인 컨테이너 안에 별도 프로세스를 추가 실행한다.
- 이번 관찰에서는 `sleep infinity`를 메인 프로세스로 둔 뒤 `attach`를 붙였다 끊어도 컨테이너가 계속 `Up` 상태인 것을 확인했다.
- `exec`로 실행한 프로세스가 끝나도 메인 프로세스는 계속 살아 있으므로 컨테이너는 종료되지 않았다.

## 13. Dockerfile 기반 커스텀 이미지

선택한 베이스 이미지는 `nginx:alpine`이다.

- 선택 이유: 포트 매핑과 브라우저 또는 `curl` 검증이 단순하다.
- 커스텀 포인트 1: 제출용 정적 페이지를 `site/`에서 복사
- 커스텀 포인트 2: 기본 NGINX 페이지 대신 과제 식별 문구 노출

관련 파일:

- [Dockerfile](Dockerfile)
- [site/index.html](site/index.html)
- 전체 로그: [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-workstation"
COPY site/ /usr/share/nginx/html/
```

## 14. 포트 매핑 및 접속 증거

동일 이미지를 두 번 실행해 `8080`, `8081` 포트로 각각 접근 가능한 것을 확인했다. 같은 이미지에서 여러 컨테이너를 반복 실행할 수 있다는 점도 함께 검증했다.

전체 로그: [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)

브라우저 스크린샷:

![Docker browser proof](docs/screenshots/docker-browser-8080.png)

```text
+ docker run -d --name orbstack-web-8080 -p 8080:80 workstation-nginx:orbstack-review
+ docker run -d --name orbstack-web-8081 -p 8081:80 workstation-nginx:orbstack-review
+ curl -s http://localhost:8080 | rg 'Codyssey E1-1|Bind mount status'
<title>Codyssey E1-1</title>
<p id="bind-marker">Bind mount status: initial content</p>
+ curl -s http://localhost:8081 | rg 'Codyssey E1-1|Bind mount status'
<title>Codyssey E1-1</title>
<p id="bind-marker">Bind mount status: initial content</p>
```

포트 매핑이 필요한 이유:

- 컨테이너 내부 포트 `80`은 기본적으로 컨테이너 네트워크 안에서만 열린다.
- 호스트 브라우저에서 접근하려면 `-p 호스트포트:컨테이너포트`로 연결해야 한다.
- 포트 매핑이 없으면 컨테이너 안의 웹 서버가 살아 있어도 호스트에서 바로 접속할 수 없다.

## 15. 바인드 마운트 반영

호스트 쪽 파일을 컨테이너 내부 경로에 직접 연결한 뒤, 호스트 파일을 수정했을 때 컨테이너 응답이 즉시 바뀌는지 확인했다.

전체 로그: [docker-orbstack-practice.txt](docs/logs/docker-orbstack-practice.txt)

```text
+ printf '%s\n' '<!doctype html>' '<html><body><p id="bind-marker">Bind mount status: before host edit</p></body></html>' > "/tmp/e1-bind-XXXXXX/index.html"
+ docker run -d --name orbstack-bind -p 8083:80 -v /tmp/e1-bind-XXXXXX:/usr/share/nginx/html nginx:alpine
+ curl -s http://localhost:8083 | rg 'Bind mount status'
<html><body><p id="bind-marker">Bind mount status: before host edit</p></body></html>
+ printf '%s\n' '<!doctype html>' '<html><body><p id="bind-marker">Bind mount status: mac orbstack live update</p></body></html>' > "/tmp/e1-bind-XXXXXX/index.html"
+ curl -s http://localhost:8083 | rg 'Bind mount status'
<html><body><p id="bind-marker">Bind mount status: mac orbstack live update</p></body></html>
```

정리:

- 바인드 마운트는 호스트 파일 변경이 컨테이너에 바로 반영되는지 확인할 때 적합하다.
- 개발 중 코드나 정적 파일을 빠르게 확인할 때 유용하다.

## 16. Docker 볼륨 영속성 검증

named volume `week1-data-orbstack`를 만들고, 컨테이너 삭제 전후로 같은 파일이 유지되는지 확인했다.

전체 로그: [volume-mac-orbstack.txt](docs/logs/volume-mac-orbstack.txt)

```text
+ docker volume create week1-data-orbstack
week1-data-orbstack
+ docker exec vol-test-orbstack bash -lc 'echo hi-from-volume > /data/hello.txt && cat /data/hello.txt'
hi-from-volume
+ docker rm -f vol-test-orbstack
+ docker exec vol-test-orbstack-2 bash -lc 'cat /data/hello.txt'
hi-from-volume
```

정리:

- 바인드 마운트는 호스트 디렉터리와 직접 연결된다.
- 볼륨은 Docker가 관리하는 저장소이므로 컨테이너를 지워도 데이터가 남는다.

## 17. Git 설정 및 GitHub 연동

현재 저장소는 `main` 브랜치를 사용하고 있고, GitHub CLI 로그인과 SSH 인증까지 확인했다.

전체 로그:

- [git-config-mac-orbstack.txt](docs/logs/git-config-mac-orbstack.txt)
- [github-ssh.txt](docs/logs/github-ssh.txt)

VS Code 연동 스크린샷:

![VS Code GitHub proof](docs/screenshots/vscode-source-control-github.png)

```text
+ git config user.name
NiceTry3675
+ git config user.email
tomtom35177@hs.ac.kr
+ git branch --show-current
main
+ git remote -v
origin  git@github.com:NiceTry3675/E1-1.git (fetch)
origin  git@github.com:NiceTry3675/E1-1.git (push)
```

```text
+ gh auth status
Logged in to github.com account NiceTry3675

+ ssh -T git@github.com
Hi NiceTry3675! You've successfully authenticated, but GitHub does not provide shell access.
```

## 18. 핵심 개념 정리

### 이미지와 컨테이너 차이

- 이미지는 `Dockerfile`로 만드는 실행 템플릿이다.
- 컨테이너는 이미지를 기반으로 실제로 실행된 인스턴스다.
- 같은 이미지에서 여러 컨테이너를 만들 수 있고, 각각은 독립적으로 실행된다.

### 포트 매핑

- 컨테이너 내부 서비스는 기본적으로 호스트에서 바로 보이지 않는다.
- `-p 8080:80`처럼 연결해야 호스트의 `localhost:8080`으로 접근할 수 있다.

### 바인드 마운트와 볼륨 차이

- 바인드 마운트는 호스트가 지정한 실제 경로를 컨테이너에 연결한다.
- 볼륨은 Docker가 관리하는 저장공간을 컨테이너에 연결한다.
- 개발 중 즉시 반영은 바인드 마운트가 직관적이고, 데이터 보존은 볼륨이 더 적합하다.

## 19. 트러블슈팅

### 1) `attach` 관찰용 `timeout` 명령이 macOS에는 기본 제공되지 않음

- 문제: Linux에서 쓰던 `timeout` 명령이 macOS에서는 바로 없었다.
- 확인: attach 관찰 로그를 만들 때 `timeout` 대신 다른 방법이 필요했다.
- 해결: `perl -e 'alarm shift; exec @ARGV' ...` 형태로 제한 시간을 줘서 `docker attach`를 짧게 붙였다 끊는 방식으로 기록했다.

### 2) 바인드 마운트 경로는 환경에 따라 다르게 잡아야 함

- 문제: WSL에서 쓰던 Windows 경로 변환 방식은 macOS에서 그대로 쓸 필요가 없다.
- 해결: mac + OrbStack에서는 `-v "$(pwd)/practice/bind-proof:/usr/share/nginx/html"`처럼 일반적인 POSIX 경로를 그대로 사용하면 된다.

### 3) GitHub 인증과 Git 설정은 별개임

- 문제: `gh auth login`이 되어 있어도 Git 작성자 정보가 자동으로 채워지지는 않는다.
- 해결: Git 설정은 별도로 확인했고, 현재 저장소 기준 `user.name`, `user.email`, `main` 브랜치 사용 상태를 로그로 남겼다.

## 20. 보너스 과제: Docker Compose / 환경 변수

`Requirements.md`의 보너스 항목 중 로컬에서 바로 재현 가능한 항목을 `mac + OrbStack` 환경에서 진행했다.

완료한 항목:

- Docker Compose 기초: 단일 서비스 `web`만 `up -d web --no-deps`로 실행
- Docker Compose 멀티 컨테이너: `web + echo` 두 서비스를 함께 실행
- Compose 운영 명령어: `up`, `ps`, `logs`, `down` 순서로 관리
- 환경 변수 활용: `.env.compose`, `.env.compose.override`로 포트, 모드, 응답 문구 변경
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
- `docker compose exec -T web wget -qO- http://echo:5678/`로 서비스 이름 기반 통신을 확인했다.
- 환경 변수 override 파일을 적용했을 때 `localhost:8092` 페이지의 `App mode`와 `/api/` 응답이 함께 바뀌었다.

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

## 21. 보안 및 개인정보 보호

- README와 로그에는 토큰 전체 값을 남기지 않았다.
- 비밀번호, 개인키, OTP 코드는 저장하지 않았다.
- GitHub SSH 공개키만 등록했고, 개인키는 로컬 `~/.ssh/`에만 보관한다.
