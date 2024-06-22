#!/bin/bash

DESC=""
if [ -z "$1" ]; then
  DESC="INFO:默认更新信息"
else
 # shellcheck disable=SC2034
 DESC="$1"
fi
echo "commit info:$DESC"
git add .
git commit -m "$DESC"
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