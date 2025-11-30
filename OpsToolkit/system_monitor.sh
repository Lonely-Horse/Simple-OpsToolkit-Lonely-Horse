#!/bin/bash
#综合系统监控脚本

echo "=== 系统综合监控报告 ==="
echo "生成时间: $(date '+%y-%m-%d-%H-%M-%S')"
echo 

#1.系统基础的信息
echo "--- 系统基础信息 ---"
echo "主机名: $(hostname)"
echo "内核版本: $(uname -r)"
echo "系统运行: $(uptime -p)"
echo "当前负荷: $(uptime | awk -F'load average:' '{print $2}')"

#2.资源使用情况
echo -e "\n--- 资源使用情况 ---"
#CPU使用率
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print "%.lf%",$2}')
echo "CPU使用率: $cpu_usage"

#内存的使用
memory_info=$(free -m | awk 'NR==2{printf"已用:%sM/总:%sM(%.lf%)",$3,$2,$3*100/$2}')
echo "内存: $memory_info"

#磁盘的使用情况
echo "磁盘的使用:"
df -h | awk 'NR==1 || $6 == "/" {print}'

#3.进程的监控
echo -e "\n--- 进程监控 ---"
echo "CPU使用TOP5:"
ps aux --sort=-%cpu | head -6 | awk '{printf "%-10s %-8s %-6s %s\n",$1,$2,$3"%",$11}'

echo -e "\n内存使用TOP5:"
ps aux --sort=-%mem | head -6 | awk '{printf "%-10s %-8s %-6s %s\n",$1,$2,$4"%",$11}'

#4.服务状态检查
echo -e "\n--- 关键服务状态 ---"
services=("nginx" "sshd" "crond" "firewalld")
for service in "${services[@]}"; do
	if systemctl is-active "$service" >/dev/null 2>&1; then
		echo "√ $service: 运行中"
	else
		echo "× $service: 未运行"
	fi
done

#5.网络连接检查
echo -e "\n--- 网络连接 ---"
echo "SSH连接数量:$(ss -tun | grep :22 | wc -l)"
echo "ESTABLISHED连接:$(ss -tun | grep ESTAB | wc -l)"

#write by Lonely Horse
