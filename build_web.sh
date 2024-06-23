#!/bin/bash
# shellcheck disable=SC2034
MAX_RETRIES=5
# shellcheck disable=SC2034
RETRY_DELAY=3  # 单位：秒

# 定义临时文件用于存储构建输出
BUILD_LOG="$(pwd)/build.log"
if [ -e "$BUILD_LOG" ]; then
    rm -f "$BUILD_LOG"
fi
PUSH_LOG="$(pwd)/push.log"
if [ -e "$PUSH_LOG" ]; then
    rm -f "$PUSH_LOG"
fi
rm -f push.log
rm -f build.log
echo '开始执行任务构建与发布任务...'
echo '[任务]执行构建 web ...'
args=("")
# 检查是否提供了任何参数
if [ $# -eq 0 ]; then
    args=("默认更新信息😑")
else
    # shellcheck disable=SC2124
    # shellcheck disable=SC2034
    args=("$@")
fi
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
echo "构建产物移动到：${target_folder}"
find "${target_folder}" -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -rf {} +

# shellcheck disable=SC2048
rsync -av --ignore-existing --progress --exclude='.*' "$source_folder/" "$target_folder"
# shellcheck disable=SC2164
cd "$target_folder"
# 尝试推送
attempt=0
git add .
git commit -m '[INFO]: 自动构建并发布'
echo "[任务]执行web app发布任务..."
while [ $attempt -lt $MAX_RETRIES ]; do
    git push > "$PUSH_LOG" 2>&1
    # shellcheck disable=SC2181
    # 检查命令的退出状态码
    if [ $? -eq 0 ]; then
        echo "Flutter web push succeeded."
        break
    else
        attempt=$((attempt+1))
        echo "Flutter web push failed. Retrying${attempt}..."
        sleep $RETRY_DELAY
    fi
done

if [ $attempt -eq $MAX_RETRIES ]; then
    echo "Flutter web push failed after $MAX_RETRIES attempts."
    cat "$PUSH_LOG"
    exit 1
fi
# shellcheck disable=SC2181
## 检查命令的退出状态码
#if [ $? -ne 0 ]; then
#    echo "Flutter web push failed."
#    cat "$PUSH_LOG"
#    exit 1
#else
#    echo "Flutter web push succeeded."
#fi
# shellcheck disable=SC2086
# shellcheck disable=SC2164
cd ${CUR_DIR0}
echo '[任务]执行推送[json_fix]到远端仓库任务...'
if [ -z "${args[0]}" ]; then
    ./push.sh
else
    ./push.sh "${args[@]}"
fi
rm -f push.log
rm -f build.log
chmod +x refresh_project_dir.sh
./refresh_project_dir.sh
echo '全部结束'
exit 0