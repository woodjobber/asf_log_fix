#!/bin/bash
#chmod +x 文件
# 版本文件路径
VERSION_FILE="version.txt"

# 检查版本文件是否存在
if [ ! -f "$VERSION_FILE" ]; then
    echo "1.0.0" > "$VERSION_FILE"
fi

# 读取当前版本号
CURRENT_VERSION=$(cat "$VERSION_FILE")
echo "Current version: $CURRENT_VERSION"

# 分解版本号为主要版本、次要版本和修订版本
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# 检查传递给脚本的参数
if [ "$1" == "major" ]; then
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
elif [ "$1" == "minor" ]; then
    MINOR=$((MINOR + 1))
    PATCH=0
elif [ "$1" == "patch" ]; then
    PATCH=$((PATCH + 1))
else
    echo "Usage: $0 {major|minor|patch} 例如: ./bump_version.sh patch"
    exit 1
fi

# 组合新的版本号
NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

# 更新版本文件
echo "$NEW_VERSION" > "$VERSION_FILE"
