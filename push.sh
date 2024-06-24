#!/bin/bash
# shellcheck disable=SC2034
MAX_RETRIES=5
# shellcheck disable=SC2034
RETRY_DELAY=3  # 单位：秒

COMMIT_DESC=""
# 检查是否提供了参数,-z 判断是否为空
if [ -z "$1" ]; then
  COMMIT_DESC="[INFO]:默认更新信息😑"
else
 # shellcheck disable=SC2034
 # shellcheck disable=SC2124

# 前缀
PREFIX="[INFO]"

# 判断字符串是否以指定前缀开头
if [[ "$@" == "$PREFIX"* ]]; then
  COMMIT_DESC="$@"
else
  COMMIT_DESC="[INFO]:$@"
fi

fi
# 检查是否提供了任何参数
if [ $# -eq 0 ]; then
    # shellcheck disable=SC2034
    COMMIT_DESC="[INFO]:默认更新信息😑"
fi
echo "[提交描述] $COMMIT_DESC"
chmod +x check_stage.sh
chmod +x check_workspace.sh
./check_workspace.sh
git add .
git commit -m "$COMMIT_DESC"
./check_stage.sh
# 尝试推送
attempt=0
while [ $attempt -lt $MAX_RETRIES ]; do
    git push
    # shellcheck disable=SC2181
    # 检查命令的退出状态码
    if [ $? -eq 0 ]; then
        echo "json_fix push succeeded."
        exit 0
    else
        attempt=$((attempt+1))
        echo "json_fix push failed. Retrying ${attempt}次..."
        sleep $RETRY_DELAY
    fi
done

if [ $attempt -eq $MAX_RETRIES ]; then
    echo "json_fix push failed after $MAX_RETRIES attempts."
    cat "$PUSH_LOG"
    exit 1
fi

# 检查命令的退出状态码
# shellcheck disable=SC2181
#if [ $? -ne 0 ]; then
#    echo "json_fix push failed."
#    exit 1
#else
#    echo "json_fix push succeeded."
#fi

#exit 0