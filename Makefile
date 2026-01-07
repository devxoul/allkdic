# Usage:
#   make generate              # Tuist 프로젝트 생성
#   make build                 # 빌드
#   make run                   # 빌드 후 실행
#   make clean                 # 빌드 캐시 정리
#   make bump VERSION=X.Y.Z    # 버전 및 빌드 번호 증가
#   make release               # App Store 배포
#   make test                  # 유닛 테스트 실행

.PHONY: run generate clean build release bump test

run:
	@tuist build Allkdic
	@~/Library/Developer/Xcode/DerivedData/Allkdic-*/Build/Products/Debug/Allkdic.app/Contents/MacOS/Allkdic

generate:
	tuist generate --no-open

build:
	tuist build Allkdic

clean:
	tuist clean

test:
	xcodebuild test -workspace Allkdic.xcworkspace -scheme Allkdic -destination 'platform=macOS' | xcpretty

bump:
	bundle exec fastlane bump version:$(VERSION)

release:
	bundle exec fastlane release
