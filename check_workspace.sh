#!/bin/bash

# 检查是否在Git仓库中
if [ ! -d .git ]; then
    echo "[GIT]: 当前目录不是Git仓库"
    exit 1
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "[GIT]: 有未提交的更改"
else
    echo "[GIT]: 没有未提交的更改"
fi
exit 0