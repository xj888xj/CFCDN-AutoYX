#!/bin/bash

# 设置语言
export LANG=zh_CN.UTF-8

# 配置目录
BASE_DIR=$(pwd)
FDIP_DIR="${BASE_DIR}/FDIP"
CFST_DIR="${BASE_DIR}/CloudflareST"
URL="https://spurl.api.030101.xyz/50mb"
SAVE_PATH="${FDIP_DIR}/txt.zip"

# 创建所需目录
mkdir -p "${FDIP_DIR}"
mkdir -p "${CFST_DIR}"

# 6. 下载 CloudflareST_linux_amd64.tar.gz 文件到 CloudflareST 文件夹
echo "=========================下载和解压CloudflareST=========================="
if [ ! -f "${CFST_DIR}/CloudflareST" ]; then
    echo "CloudflareST文件不存在，开始下载..."
    wget -O "${CFST_DIR}/CloudflareST_linux_amd64.tar.gz" https://github.com/XIU2/CloudflareSpeedTest/releases/download/v2.2.5/CloudflareST_linux_amd64.tar.gz
    tar -xzf "${CFST_DIR}/CloudflareST_linux_amd64.tar.gz" -C "${CFST_DIR}"
    chmod +x "${CFST_DIR}/CloudflareST"
else
    echo "CloudflareST文件已存在，跳过下载步骤。"
fi

# 7. 执行 CloudflareST 进行测速
echo "======================运行 CloudflareSpeedTest ========================="
"${CFST_DIR}/CloudflareST" -tp 443 -f "${CFST_DIR}/ip.txt" -n 500 -dn 5 -tl 250 -tll 30 -o "${CFST_DIR}/ip.csv" -url "$URL"

# 8. 从 ip.csv 文件中筛选下载速度高于 5 的 IP地址，并删除重复的 IP 地址行，生成 yxip.txt
echo "==================筛选下载速度高于 5mb/s 的IP地址并去重===================="
awk -F, '!seen[$1]++' "${CFST_DIR}/ip.csv" | awk -F, 'NR>1 && $6 > 5 {print $1 "#" $6 "mb/s"}' > "${CFST_DIR}/yxip.txt"

echo "===============================脚本执行完成==============================="
