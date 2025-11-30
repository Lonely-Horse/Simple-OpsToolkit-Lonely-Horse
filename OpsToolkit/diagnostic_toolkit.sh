#!/bin/bash
#系统故障诊断工具包


show_menu(){
	echo "=== 系统诊断工具包 ==="
	echo
	echo "1.性能问题诊断"
	echo "2.网络问题诊断"
	echo "3.磁盘问题诊断"
	echo "4.服务问题诊断"
	echo "5.综合检查报告"
	echo "0.退出"
	echo -n "请选择: "
}

performance_diagnose(){
	echo "=== 性能问题诊断 ==="

	echo
	echo -e "\n1.系统负载严重"
	uptime
	echo

	echo -e "\n2.CPU使用TOP10:"
	ps aux --sort=-%cpu | head -11 | awk '{printf "%-8s %-6s %s\n",$2,$3"%",$11}'

	echo -e "\n3.内存使用TOP10:"
	ps aux --sort=-%mem | head -11 | awk '{printf "%-8s %-6s %s\n",$2,$4"%",$11}'
	echo -e "\n4.IO等待:"
	iostat -x 1 1 | grep -A1 "Device"
}

network_diagnose(){
	echo "=== 网路问题诊断 ==="
	echo
	echo -e "\n1.网络连接:"
	ss -tunlp

	echo -e "\n2.路由跟踪:"
	ip route show

	echo -e "\n3.端口监听:"
	netstat -tunlp | grep LISTEN

	echo -e "\n4.防火墙状态:"
	sudo firewall-cmd --list-all 2>/dev/null || echo "firewalld未运行"
}

#主循环
while true;do
	show_menu
	read choice

	case $choice in
		1) performance_diagnose ;;
		2) network_diagnose ;;
		3) ./system_monitor.sh | grep -A10 "磁盘" ;;
		4) ./system_monitor.sh | grep -A10 "服务状态" ;;
		5) ./system_monitor.sh ;;
		0) echo "退出"; break ;;
		*) echo "无效选择" ;;
	esac

	echo
	read -p "按回车继续...."
done

#write by Lonely Horse


