.PHONY: run generate clean build

run:
	@tuist build Allkdic
	@~/Library/Developer/Xcode/DerivedData/Allkdic-*/Build/Products/Debug/Allkdic.app/Contents/MacOS/Allkdic

generate:
	tuist generate --no-open

build:
	tuist build Allkdic

clean:
	tuist clean
