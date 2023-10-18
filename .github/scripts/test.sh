#!/bin/bash

export LC_ALL=en_US.UTF-8

SCHEME="SFSymbolsMacro"

DESTINATION="platform=macOS"

set -o pipefail && xcodebuild clean build test -scheme $SCHEME \
    -destination $DESTINATION | xcpretty
