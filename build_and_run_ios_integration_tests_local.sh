# from https://github.com/flutter/flutter/tree/master/packages/integration_test#ios-device-testing
output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="14.4"

# Pass --simulator if building for the simulator.
flutter build ios integration_test/app_test.dart --debug --simulator

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64-armv7.xctestrun"
popd

# run tests
xcodebuild test-without-building -xctestrun "build/ios_integ/Build/Products/Runner_iphoneos14.4-arm64-armv7.xctestrun" -destination 'platform=iOS Simulator,name=iPhone 12 Pro Max'
