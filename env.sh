#!/usr/bin/env sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
clear

showVersion() {
    echo "\033[0;32mYork Image Generator\033[0m"
    echo "version \033[0;33mv1.0.0\033[0m 2020-12-29 12:23:01"
    echo "Copyright (c) 2020-2021 York"
}

showFolder() {
    # 讀取所有 folder
    rawFolderList=($(ls | grep -v ".sh" | grep -v ".md"))
    echo "\033[0;32m編號\tDockerfile名稱\033[0m"
    # 依序顯示
    for i in ${!rawFolderList[@]}; do
        folderName=${rawFolderList[${i}]}
        echo "${i}\t${folderName}"
    done
}

while :
do
    showVersion
    echo "----------------------------------------"
    echo "選擇指令:"
    echo "----------------------------------------"
    echo "l.\t顯示所有 Image"
    echo "d.\t顯示所有 Dockerfile"
    echo "b.\t建立 Image"
    echo "p.\t推 Image"
    echo "q.\t離開"
    read -p "指令:" input

    clear

    case $input in
        l) # 顯示所有 Image
            docker images
            echo "----------------------------------------"
            ;;
        d) # 顯示所有 Dockerfile
            showFolder
            ;;
        b) # build Dockerfile
            clear
            echo "----------------------------------------"
            showFolder
            echo "----------------------------------------"
            read -p "選擇要建立的 Image number:" number
            clear
            # 讀取所有 Folder
            rawFolderList=($(ls | grep -v ".sh" | grep -v ".md"))
            # 建立 Image
            docker build -t  tinayork/${rawFolderList[${number}]} ./${rawFolderList[${number}]}
            echo "----------------------------------------"
            ;;
        p) # push image
            clear
            echo "----------------------------------------"
            showFolder
            echo "----------------------------------------"
            read -p "選擇要推的 Image number:" number
            clear
            # 讀取所有 Folder
            rawFolderList=($(ls | grep -v ".sh" | grep -v ".md"))
            # 推 Image 至 docker hub
            docker push tinayork/${rawFolderList[${number}]}
            echo "----------------------------------------"
            ;;
        *) # 離開程序
            exit
            ;;
    esac
done
