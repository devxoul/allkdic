project:
	rome download --platform macOS --cache-prefix $$(make swift_version) --concurrently
	if [ `rome list --missing --platform macOS --cache-prefix $$(make swift_version) | wc -l | awk '{ print $$1 }'` != 0 ]; then \
		make carthage_bootstrap; \
	fi
	xcodegen generate --use-cache
	bundle exec pod install

carthage_bootstrap:
	carthage checkout
	find Carthage/Checkouts -mindepth 1 -maxdepth 1 -type d -exec bash -c 'cd "$$1" && (test -d *.xcodeproj || swift package generate-xcodeproj)' -- {} \;
	carthage build --platform macOS --cache-builds
	rome upload --platform macOS --cache-prefix $$(make swift_version) --concurrently

swift_version:
	@echo `swift --version | sed -nE 's/.*version ([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/p'`
