#!/bin/sh

# Change version in pubspec.yaml
# Change version in index.html
# Update readme.md
# Update changelog.txt (<= 500 characters)
# Copy secrets/GoogleService-Info.plist to ios/Runner
# Remove `pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '9.3.0'` from ios/Podfile

cd ..

echo "Build web release..."
cd packages/tricking_bees
flutter build web --dart-define environment=prod --no-tree-shake-icons

echo "Publish web release to firestore..."
firebase deploy
