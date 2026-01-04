# 올ㅋ사전

[<img alt="appstore" height="20" src="https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us">](https://itunes.apple.com/kr/app/allkdic/id1033453958?l=en&mt=12)
[![Release](https://img.shields.io/github/release/devxoul/allkdic.svg?style=flat)](https://github.com/devxoul/allkdic/releases?style=flat)

맥에서 Option + Command + Space를 누르면 영어사전이 뙇!!!!

![allkdic](https://github.com/devxoul/allkdic/blob/gh-pages/gh-pages/images/screenshots/allkdic-2.png)

## 빌드 및 실행

[Tuist](https://tuist.dev)를 사용해서 프로젝트를 생성합니다.

```console
$ tuist install
$ tuist generate
```

### Xcode 사용

`Allkdic.xcworkspace` 파일을 Xcode로 열어서 빌드하고 실행할 수 있습니다.

```console
$ open Allkdic.xcworkspace
```

### CLI 사용

Makefile을 통해 터미널에서 빌드하고 실행할 수 있습니다.

```console
$ make generate  # 프로젝트 생성 (tuist generate)
$ make build     # 빌드만
$ make run       # 빌드 후 실행 (로그가 터미널에 출력됨)
$ make clean     # 빌드 캐시 정리
```

## 번역 문자열 관리하기

번역 문자열 관리 도구로 [POEditor](https://poeditor.com/)를 사용합니다. 여러분도 [직접 번역에 참여](https://poeditor.com/join/project/Q3GgzshlCz)하실 수 있습니다.

POEditor에 있는 문자열은 [poeditor-cli](https://github.com/StyleShare/poeditor-cli)를 사용해서 프로젝트로 받아옵니다.

```console
$ bundle exec poeditor pull
```

## 라이센스

올ㅋ사전은 MIT 라이센스 하에 배포됩니다.
