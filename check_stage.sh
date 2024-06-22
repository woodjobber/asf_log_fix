#!/bin/bash

# 检查是否在Git仓库内
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "当前目录不是Git仓库"
    exit 1
fi

# 检查是否在Git仓库中
if [ ! -d .git ]; then
    echo "当前目录不是Git仓库"
    exit 1
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "有未提交的更改"
else
    echo "没有未提交的更改"
fi
git fetch origin

# 检查本地分支是否有未推送的提交
LOCAL0=$(git rev-parse @)
# shellcheck disable=SC1083
REMOTE0=$(git rev-parse @{u})
# shellcheck disable=SC1083
BASE0=$(git merge-base @ @{u})

if [ "$LOCAL0" = "$REMOTE0" ]; then
    echo "本地分支没有需要推送的文件"
    exit 0
elif [ "$LOCAL0" = "$BASE0" ]; then
    echo "本地分支落后于远程分支，有需要拉取的提交"
    exit 0
elif [ "$REMOTE0" = "$BASE0" ]; then
    echo "本地分支有未推送的提交"
    exit 1
else
    echo "本地分支和远程分支有分叉"
    exit 1
fi
