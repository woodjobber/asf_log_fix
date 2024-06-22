#!/bin/bash
# 定义临时文件用于存储构建输出
BUILD_LOG="build.log"
if [ -f "$BUILD_LOG" ]; then
    rm "$BUILD_LOG"
fi
PUSH_LOG="push.log"
if [ -f "$PUSH_LOG" ]; then
    rm "$PUSH_LOG"
fi
echo '开始执行build web ...'
./updateversion.sh
# 执行 flutter build web 命令并重定向输出到临时文件
flutter build web --web-renderer html --no-tree-shake-icons --base-href /https://soer.top/json/ > "$BUILD_LOG" 2>&1
# shellcheck disable=SC2181
# 检查命令的退出状态码
if [ $? -ne 0 ]; then
    echo "Flutter web build failed."
    cat "$BUILD_LOG"
    exit 1
else
    echo "Flutter web build succeeded."
fi

echo '构建 web 结束 准备替换base-href'
find_text="\/https:\/\/soer.top\/json\/"
replace_text="https:\/\/soer.top\/json\/"
# shellcheck disable=SC2034
CUR_DIR0=$(pwd)
# shellcheck disable=SC2164
cd build/web/
# shellcheck disable=SC2006
cur_dir=`pwd`
echo '当前目录:' "${cur_dir}"

filename=index.html
sed -i '' "s/${find_text}/${replace_text}/g" ${filename} 

target_folder=${HOME}/Desktop/jsonviewer/web/
# 确保目标文件夹存在，如果不存在则创建
mkdir -p "$target_folder"
# shellcheck disable=SC2006
source_folder=`pwd`
echo "移动到：${target_folder}"
find "${target_folder}" -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -rf {} +

# shellcheck disable=SC2048
rsync -av --ignore-existing --progress --exclude='.*' "$source_folder/" "$target_folder"
# shellcheck disable=SC2164
cd "$target_folder"
git add .
git commit -m 'info: 自动构建'
git push > "$PUSH_LOG" 2>&1
# shellcheck disable=SC2181
# 检查命令的退出状态码
if [ $? -ne 0 ]; then
    echo "Flutter web push failed."
    cat "$PUSH_LOG"
    exit 1
else
    echo "Flutter web push succeeded."
fi
# shellcheck disable=SC2086
# shellcheck disable=SC2164
cd ${CUR_DIR0}
git add .
git commit -m 'info: 版本更新'
git push
echo '全部结束'
exit 0