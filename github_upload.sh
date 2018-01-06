#!/bin/sh
# github_upload.sh
echo -n "コミット対象パスを指定: "
read path
echo "$path をコミットします"
echo "# git add $path"
git add $path
echo -n "コミット時のメッセージを指定: "
read msg
echo "# git commit -m $msg"
git commit -m $msg
echo "githubへのアップロード"
echo "# git push -u origin master"
git push -u origin master

