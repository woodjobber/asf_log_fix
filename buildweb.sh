#!/bin/bash

echo '开始执行build web ...'
./updateversion.sh
flutter build web --web-renderer html --no-tree-shake-icons --base-href /https://soer.top/json/  
echo '构建 web 结束 准备替换base-href'
find_text="\/https:\/\/soer.top\/json\/"
replace_text="https:\/\/soer.top\/json\/"
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

# shellcheck disable=SC2048
rsync -av --ignore-existing --exclude='.*' "$source_folder/" "$target_folder" "$*"
# shellcheck disable=SC2164
cd "$target_folder"
ls
git add .
git commit -m 'info: 自动构建'
git push
echo '全部结束'
exit $?