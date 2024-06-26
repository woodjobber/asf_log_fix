#!/bin/bash
BASE_VERSION='1.0.0'
if [ -f ".app_version" ]; then
    # shellcheck disable=SC2006
    VER=`cat .app_version`
else
    VER=${BASE_VERSION}
    echo $VER > .app_version
fi
if [ -f ".old_app_version" ]; then
    # shellcheck disable=SC2006
    OLD_VER=`cat .old_app_version`
else
    OLD_VER=${BASE_VERSION}
    echo ${OLD_VER} > .old_app_version
fi
if [ -f ".build_seq" ]; then
    # shellcheck disable=SC2006
    BLD=`cat .build_seq`
else
    BLD='0'
fi

# 要比较的两个字符串
STRING1="${VER}"
STRING2="${OLD_VER}"

# 比较字符串是否相等
if [ "$STRING1" = "$STRING2" ]; then
  echo "新老版本相等：$STRING1 和 $STRING2"
else
  echo "新老版本不相等：$STRING1 和 $STRING2"
  echo "$VER" > .old_app_version
  BLD='0'
fi


((BLD++))
echo "$BLD" > .build_seq
echo "Version: $VER ($BLD)" > .current_version
echo "更新后版本：$STRING1 build:$BLD"
NEW_VERSION="$STRING1+$BLD"
sed -i '' "s|version:.*|version: $NEW_VERSION|g" pubspec.yaml
# 要检查的文件路径
FILE_PATH="lib/version_info.dart"

# 检查文件是否存在
if [ ! -f "$FILE_PATH" ]; then
  # 文件不存在，创建文件
  touch "$FILE_PATH"
  echo "文件不存在，已创建：$FILE_PATH"
else
  echo "文件已存在：$FILE_PATH"
fi
echo "
// Auto-generated by update-version.sh. Do not edit.

class WebVersionInfo {
  static const String name = '$VER';
  static const int build = $BLD;
}

" > lib/version_info.dart

exit 0