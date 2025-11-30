#!/bin/bash

#主菜单，以用于直接使用脚本

#先移动到文件夹位置
WHO=$(whoami)
mkdir /home/$WHO/OpsToolkit
cd /home/$WHO/OpsToolkit

#main_)menu函数的组成
main_menu(){
	echo "1.集合工具包"
	echo "2.紧急救援修补"
	echo "3.自动巡查日志"
	echo "4.退出"
	echo -n "请选择:"
}

#循环判断用户的选择
while true;do
	main_menu
	read choice

	case $choice in
		1)./diagnostic_toolkit.sh ;;
		2)./security_check.sh ;;
		3)cat log/maintenance.log ;;
		4)echo "退出";break ;;
		*)echo "无效选择" ;;
	esac

	echo 
	read -p "按回车继续...."
done

#write by Lonely Horse

