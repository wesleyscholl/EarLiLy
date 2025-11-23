#!/bin/bash

# EarLiLy Build Script
# Builds the iOS app for simulator or device

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_FILE="$PROJECT_DIR/EarLiLy.xcodeproj"
SCHEME="EarLiLy"

echo "🌼 Building EarLiLy..."
echo "Project: $PROJECT_FILE"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or not in PATH"
    exit 1
fi

# Build for simulator
echo "📱 Building for iOS Simulator..."
xcodebuild \
    -project "$PROJECT_FILE" \
    -scheme "$SCHEME" \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
    clean build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "🚀 To run the app:"
    echo "   1. Open EarLiLy.xcodeproj in Xcode"
    echo "   2. Select a simulator from the device menu"
    echo "   3. Press Cmd + R to run"
    echo ""
    echo "Or use: open EarLiLy.xcodeproj"
else
    echo ""
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
