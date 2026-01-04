# 올ㅋ사전

[<img alt="appstore" height="20" src="https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us">](https://itunes.apple.com/kr/app/allkdic/id1033453958?l=en&mt=12)
[![Release](https://img.shields.io/github/release/devxoul/allkdic.svg?style=flat)](https://github.com/devxoul/allkdic/releases?style=flat)

맥에서 Option + Command + Space를 누르면 영어사전이 뙇!!!!

![allkdic](https://github.com/user-attachments/assets/082aec2a-654a-4540-b98a-43081a635532)

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

## 라이센스

올ㅋ사전은 MIT 라이센스 하에 배포됩니다.
