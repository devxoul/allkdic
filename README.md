# 올ㅋ사전

[<img alt="appstore" height="20" src="https://devimages.apple.com.edgekey.net/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg">](https://itunes.apple.com/kr/app/allkdic/id1033453958?l=en&mt=12)
[![Release](http://img.shields.io/github/release/devxoul/allkdic.svg?style=flat)](https://github.com/devxoul/allkdic/releases?style=flat)

맥에서 Option + Command + Space를 누르면 영어사전이 뙇!!!!

![allkdic](https://github.com/devxoul/allkdic/blob/gh-pages/gh-pages/images/screenshots/allkdic-2.png)

## 빌드하기

[Tuist](https://tuist.dev)를 사용해서 프로젝트를 생성합니다.

```console
$ tuist install
$ tuist generate
```

이후 **`Allkdic.xcworkspace`** 파일을 Xcode로 열어서 빌드할 수 있습니다.

## 번역 문자열 관리하기

번역 문자열 관리 도구로 [POEditor](https://poeditor.com/)를 사용합니다. 여러분도 [직접 번역에 참여](https://poeditor.com/join/project/Q3GgzshlCz)하실 수 있습니다.

POEditor에 있는 문자열은 [poeditor-cli](https://github.com/StyleShare/poeditor-cli)를 사용해서 프로젝트로 받아옵니다.

```console
$ bundle exec poeditor pull
```

## 라이센스

올ㅋ사전은 MIT 라이센스 하에 배포됩니다.
