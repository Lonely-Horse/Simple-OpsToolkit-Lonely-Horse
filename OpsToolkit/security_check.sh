#!/bin/bash
#系统安全巡查脚本

echo "=== 系统安全巡查报告 ==="
echo "检查时间: $(date)"
echo

#1.用户安全检查
echo "--- 用户账户检查 ---"
echo "空密码用户:"
awk -F: '($2 == ""){print $1}' /etc/shadow

echo -e "\n非系统用户(UID>=1000):"
awk -F: '($3 >= 1000) {print $1 "{UID:" $3 "}"}' /etc/shadow

echo -e "\nsudo权限用户:"
grep -po '^sudo.+:\K.*$' /etc/shadow

#2.登录安全检查
echo -e ”\n--- 登录安全 ---“
echo "最近登录失败:"
lastb | head -5

echo -e "\n当前登录用户:"
who

echo -e "\n登录失败尝试:"
faillock --user | head -10

#3.文件权限检查
echo -e "\n--- 文件权限检查 ---"
echo "SUID文件:"
find / -type f -perm /4000 2>/dev/null | head -10

#4.服务安全
echo -e "\n--- 服务安全 ---"
echo "监听端口:"
ss -tunlp | awk 'NR>1 {print $5,$7}' | head -10

#5.系统更新检查
echo -e "\n--- 系统更新 ---"
if command -v dnf &>/dev/null; then
	echo "可更新软件包:"
	dnf check-update | head -5
elif command -v yum &>/dev/null; then
	echo "可更新软件包:"
	yum list --upgradable 2>/dev/null | head -5
fi

#write by Lonely Horse

