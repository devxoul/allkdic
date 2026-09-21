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
#   make release               # App Store 배포 (로컬)
#   make release-ci            # App Store 배포 (CI, 환경변수 사용)

.PHONY: install generate build run test clean lint lint-ci format bump release release-ci

# `tuist build` is deprecated; the supported path is to generate the project and
# drive it through the `tuist xcodebuild` wrapper (plain xcodebuild plus Tuist
# insights). DERIVED_DATA is pinned so `run` knows exactly where the .app lands
# instead of globbing Xcode's hashed DerivedData directory.
XCODEBUILD_FLAGS = -workspace Allkdic.xcworkspace -scheme Allkdic -configuration Debug -destination 'platform=macOS'
DERIVED_DATA = .build/DerivedData

install:
	tuist install

generate:
	tuist generate --no-open

build: generate
	tuist xcodebuild build $(XCODEBUILD_FLAGS) -derivedDataPath $(DERIVED_DATA)

run: build
	@$(DERIVED_DATA)/Build/Products/Debug/Allkdic.app/Contents/MacOS/Allkdic

test: generate
	tuist xcodebuild test $(XCODEBUILD_FLAGS) -derivedDataPath $(DERIVED_DATA)

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

release-ci:
	bundle exec fastlane release_ci
