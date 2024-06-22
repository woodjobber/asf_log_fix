#!/bin/bash

git add .
git commit -m 'info: 默认更新'
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