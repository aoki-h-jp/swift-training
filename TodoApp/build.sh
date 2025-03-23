#!/bin/sh

SCHEME='TodoApp'
SIM_NAME='iPhone SE (3rd generation)'
DESTINATION="platform=iOS Simulator,name=$SIM_NAME"
CONFIG='Debug'
DERIVED_DATA_PATH='./build'
APP_NAME='TodoApp'
APP_PATH="$DERIVED_DATA_PATH/Build/Products/$CONFIG-iphonesimulator/$APP_NAME.app"
BUNDLE_ID='com.example.TodoApp'

CLEAN=''; [ "$1" = "clean" ] && CLEAN='clean'

# アプリのビルド
xcodebuild -scheme $SCHEME -destination "$DESTINATION" -configuration $CONFIG -derivedDataPath $DERIVED_DATA_PATH $CLEAN build

# シミュレータの起動
xcrun simctl boot "$SIM_NAME"

# Xcodeのシミュレータアプリケーションを開く
open -a Simulator

# シミュレータにアプリをインストール
xcrun simctl install booted "$APP_PATH"

# シミュレータでアプリを起動
xcrun simctl launch booted "$BUNDLE_ID" 