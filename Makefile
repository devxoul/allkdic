# Usage:
#   make install               # 의존성 설치
#   make generate              # Tuist 프로젝트 생성
#   make build                 # 빌드
#   make run                   # 빌드 후 실행
#   make test                  # 유닛 테스트 실행
#   make clean                 # 빌드 캐시 정리
#   make lint                  # 포맷팅 검사
#   make lint-ci               # 포맷팅 검사 (CI용)
#   make format                # 코드 포맷팅
#   make bump VERSION=X.Y.Z    # 버전 및 빌드 번호 증가
#   make release               # App Store 배포

.PHONY: install generate build run test clean lint format bump release

install:
	tuist install

generate:
	tuist generate --no-open

build:
	tuist build Allkdic

run:
	@tuist build Allkdic
	@~/Library/Developer/Xcode/DerivedData/Allkdic-*/Build/Products/Debug/Allkdic.app/Contents/MacOS/Allkdic

test:
	xcodebuild test -workspace Allkdic.xcworkspace -scheme Allkdic -destination 'platform=macOS' | xcpretty

clean:
	tuist clean

lint:
	swift run --package-path BuildTools swiftformat . --lint

lint-ci:
	swift run --package-path BuildTools swiftformat . --lint --reporter github-actions-log

format:
	swift run --package-path BuildTools swiftformat .

bump:
	bundle exec fastlane bump version:$(VERSION)

release:
	bundle exec fastlane release
