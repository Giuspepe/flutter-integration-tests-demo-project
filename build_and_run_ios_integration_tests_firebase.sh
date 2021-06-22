#!/bin/bash
set -o xtrace


# from https://github.com/flutter/flutter/tree/master/packages/integration_test#ios-device-testing
output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="14.4"

flutter build ios integration_test/app_test.dart -release

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64-armv7.xctestrun"
popd

gcloud firebase test ios run \
    --test build/ios_integ/Build/Products/ios_tests.zip \
    --type xctest \
    --timeout 5m