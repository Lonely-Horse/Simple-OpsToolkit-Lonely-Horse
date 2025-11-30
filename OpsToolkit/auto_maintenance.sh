#!/bin/bash
#自动化系统维护

WHO=$(whoami)
LOG_FILE="/home/$WHO/OpsToolkit/log/maintenance.log"
BACKUP_DIR="/home/$WHO/backup/$(date +%y%m%d)"

#确保该目录存在
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_FILE"
chmod 755 "$BACKUP_DIR" 2>/dev/null || true
chmod 755 "$LOG_FILE" 2>/dev/null || true

#日志函数
log(){
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

#1.备份重要配置
backup_configs(){
	log "开始备份系统配置...."
	mkdir -p "$BACKUP_DIR"

	#备份重要的配置文件
	tar -czf "$BACKUP_DIR/etc_backup.tar.gz" /etc/ 2>/dev/null
	tar -czf "$BACKUP_DIR/nginx_backup.tar.gz" /etc/nginx/ /var/log/nginx/ 2>/dev/null

	#备份cron任务
	crontab -l > "$BACKUP_DIR/cron_backup.txt" 2>/dev/null

	log "配置备份完成: $BACKUP_DIR"
}

#2.日志清理
clean_logs(){
	log "开始清理日志文件...."

	#清理七天前的日志
	find /tmp -type f -mtime +3 -exec rm -f {} \; 2>/dev/null
	find /var/tmp -type f -mtime +3 -exec rm -f {} \; 2>/dev/null

	log "日志清理完成"
}

#3.系统检查
system_health_check(){
	log "开始系统健康检查...."

	#磁盘空间检查
	disk_usage=$(df / | awk 'NR==2{print $5}' | cut -d'%' -f1)
	if [ "$disk_usage" -gt 85 ]; 
	then
		log "警告: 根分区使用率 ${disk_usage}%"
	fi

	#内存检查
	mem_usage=$(free | awk 'NR==2{printf "%.0f",$3*100/$2}')
	if [ "$mem_usage" -gt 90 ];
	then
		log "警告: 内存使用率 ${mem_usage}%"
	fi

	#服务状态检查
	for service in nginx sshd crond; do
		if ! systemctl is-active "$service" >/dev/null;
		then
			log "警告: 服务 $service 未运行"
		fi
	done

	log "系统健康检查完毕"
}

#主程序
main(){
	log "=== 开始系统维护 ==="

	echo "  "
	backup_configs
	clean_logs
	system_health_check
	echo "  " 

	log "=== 系统维护完成 ==="
}

#执行主程序

main

#write by Lonely Horse

