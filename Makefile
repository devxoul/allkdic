WORKSPACE=Allkdic.xcworkspace
SCHEME=Allkdic

build:
	xctool build -workspace Allkdic.xcworkspace -scheme Allkdic

run:
	export BUILD_DIR=$(xctool -workspace $(WORKSPACE) -scheme $(SCHEME) -showBuildSettings | awk '{if($1 == "BUILD_DIR") print $3}')
	open $BUILD_DIR/Debug/Allkdic.app

test:
	xctool -workspace $(WORKSPACE) -scheme $(SCHEME) test
