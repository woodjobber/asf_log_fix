#!/bin/bash

COMMIT_DESC=""
# 检查是否提供了参数,-z 判断是否为空
if [ -z "$1" ]; then
  COMMIT_DESC="INFO:默认更新信息😑"
else
 # shellcheck disable=SC2034
 # shellcheck disable=SC2124
 COMMIT_DESC="$@"
fi
# 检查是否提供了任何参数
if [ $# -eq 0 ]; then
    # shellcheck disable=SC2034
    COMMIT_DESC="INFO:默认更新信息😑"
fi
echo "[commit info:] COMMIT_DESC"
git add .
git commit -m "COMMIT_DESC"
git push

# 检查命令的退出状态码
# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    echo "json_fix push failed."
    exit 1
else
    echo "json_fix push succeeded."
fi

exit 0