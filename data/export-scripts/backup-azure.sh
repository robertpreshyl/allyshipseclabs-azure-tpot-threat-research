#!/bin/bash

# Azure T-Pot Honeypot Backup Script
# This script creates comprehensive backups of the T-Pot honeypot deployment
# including configuration, logs, and research data

# Configuration
BACKUP_DIR="/opt/backups/tpot-honeypot"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="tpot-backup-$DATE"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
LOG_FILE="/var/log/tpot-backup.log"
RETENTION_DAYS=30

# Azure Storage Configuration
AZURE_STORAGE_ACCOUNT="tpotbackups"
AZURE_CONTAINER="honeypot-backups"
AZURE_SAS_TOKEN="your-sas-token-here"

# Email Configuration
EMAIL_RECIPIENT="admin@yourdomain.com"
EMAIL_SUBJECT="T-Pot Honeypot Backup Report"

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Error handling function
handle_error() {
    log_message "ERROR: $1"
    send_notification "Backup Failed" "Backup failed: $1"
    exit 1
}

# Send notification function
send_notification() {
    local subject="$1"
    local message="$2"
    
    if command -v mail >/dev/null 2>&1; then
        echo "$message" | mail -s "$subject" "$EMAIL_RECIPIENT"
    fi
    
    log_message "NOTIFICATION: $subject - $message"
}

# Create backup directory
create_backup_directory() {
    log_message "Creating backup directory: $BACKUP_PATH"
    mkdir -p "$BACKUP_PATH" || handle_error "Failed to create backup directory"
}

# Backup T-Pot configuration
backup_tpot_config() {
    log_message "Backing up T-Pot configuration..."
    
    # Backup T-Pot configuration files
    if [ -d "/opt/tpot/etc" ]; then
        cp -r /opt/tpot/etc "$BACKUP_PATH/tpot-config" || handle_error "Failed to backup T-Pot configuration"
    fi
    
    # Backup Docker Compose files
    if [ -f "/opt/tpot/docker-compose.yml" ]; then
        cp /opt/tpot/docker-compose.yml "$BACKUP_PATH/" || handle_error "Failed to backup Docker Compose file"
    fi
    
    # Backup environment files
    if [ -f "/opt/tpot/.env" ]; then
        cp /opt/tpot/.env "$BACKUP_PATH/" || handle_error "Failed to backup environment file"
    fi
    
    log_message "T-Pot configuration backup completed"
}

# Backup system configuration
backup_system_config() {
    log_message "Backing up system configuration..."
    
    # Backup network configuration
    if [ -d "/etc/netplan" ]; then
        cp -r /etc/netplan "$BACKUP_PATH/system-config/" || handle_error "Failed to backup network configuration"
    fi
    
    # Backup firewall rules
    if command -v ufw >/dev/null 2>&1; then
        ufw status numbered > "$BACKUP_PATH/system-config/ufw-rules.txt" || handle_error "Failed to backup UFW rules"
    fi
    
    if command -v iptables >/dev/null 2>&1; then
        iptables-save > "$BACKUP_PATH/system-config/iptables-rules.txt" || handle_error "Failed to backup iptables rules"
    fi
    
    # Backup system services
    systemctl list-units --type=service --state=active > "$BACKUP_PATH/system-config/active-services.txt" || handle_error "Failed to backup active services"
    
    # Backup system information
    uname -a > "$BACKUP_PATH/system-config/system-info.txt" || handle_error "Failed to backup system information"
    lscpu > "$BACKUP_PATH/system-config/cpu-info.txt" || handle_error "Failed to backup CPU information"
    free -h > "$BACKUP_PATH/system-config/memory-info.txt" || handle_error "Failed to backup memory information"
    df -h > "$BACKUP_PATH/system-config/disk-info.txt" || handle_error "Failed to backup disk information"
    
    log_message "System configuration backup completed"
}

# Backup NetBird configuration
backup_netbird_config() {
    log_message "Backing up NetBird configuration..."
    
    # Create NetBird backup directory
    mkdir -p "$BACKUP_PATH/netbird-config"
    
    # Backup NetBird configuration files
    if [ -d "/etc/netbird" ]; then
        cp -r /etc/netbird "$BACKUP_PATH/netbird-config/" || handle_error "Failed to backup NetBird configuration"
    fi
    
    # Backup NetBird status
    if command -v netbird >/dev/null 2>&1; then
        netbird status > "$BACKUP_PATH/netbird-config/netbird-status.txt" || handle_error "Failed to backup NetBird status"
        netbird policy list > "$BACKUP_PATH/netbird-config/netbird-policies.txt" || handle_error "Failed to backup NetBird policies"
        netbird network list > "$BACKUP_PATH/netbird-config/netbird-networks.txt" || handle_error "Failed to backup NetBird networks"
    fi
    
    log_message "NetBird configuration backup completed"
}

# Backup Elastic Fleet configuration
backup_elastic_fleet_config() {
    log_message "Backing up Elastic Fleet configuration..."
    
    # Create Elastic Fleet backup directory
    mkdir -p "$BACKUP_PATH/elastic-fleet-config"
    
    # Backup Elastic Agent configuration
    if [ -d "/etc/elastic-agent" ]; then
        cp -r /etc/elastic-agent "$BACKUP_PATH/elastic-fleet-config/" || handle_error "Failed to backup Elastic Agent configuration"
    fi
    
    # Backup Elastic Agent status
    if command -v elastic-agent >/dev/null 2>&1; then
        elastic-agent status > "$BACKUP_PATH/elastic-fleet-config/elastic-agent-status.txt" || handle_error "Failed to backup Elastic Agent status"
    fi
    
    log_message "Elastic Fleet configuration backup completed"
}

# Backup SSL certificates
backup_ssl_certificates() {
    log_message "Backing up SSL certificates..."
    
    # Create SSL backup directory
    mkdir -p "$BACKUP_PATH/ssl-certificates"
    
    # Backup Let's Encrypt certificates
    if [ -d "/etc/letsencrypt" ]; then
        cp -r /etc/letsencrypt "$BACKUP_PATH/ssl-certificates/" || handle_error "Failed to backup Let's Encrypt certificates"
    fi
    
    # Backup system certificates
    if [ -d "/etc/ssl" ]; then
        cp -r /etc/ssl "$BACKUP_PATH/ssl-certificates/system-ssl/" || handle_error "Failed to backup system SSL certificates"
    fi
    
    log_message "SSL certificates backup completed"
}

# Backup Docker volumes
backup_docker_volumes() {
    log_message "Backing up Docker volumes..."
    
    # Create Docker backup directory
    mkdir -p "$BACKUP_PATH/docker-volumes"
    
    # List Docker volumes
    docker volume ls > "$BACKUP_PATH/docker-volumes/volume-list.txt" || handle_error "Failed to list Docker volumes"
    
    # Backup T-Pot data volume
    if docker volume inspect tpot_data >/dev/null 2>&1; then
        docker run --rm -v tpot_data:/data -v "$BACKUP_PATH/docker-volumes":/backup alpine tar czf /backup/tpot-data.tar.gz -C /data . || handle_error "Failed to backup T-Pot data volume"
    fi
    
    # Backup Elasticsearch data volume
    if docker volume inspect elasticsearch_data >/dev/null 2>&1; then
        docker run --rm -v elasticsearch_data:/data -v "$BACKUP_PATH/docker-volumes":/backup alpine tar czf /backup/elasticsearch-data.tar.gz -C /data . || handle_error "Failed to backup Elasticsearch data volume"
    fi
    
    log_message "Docker volumes backup completed"
}

# Backup research data
backup_research_data() {
    log_message "Backing up research data..."
    
    # Create research data backup directory
    mkdir -p "$BACKUP_PATH/research-data"
    
    # Backup anonymized attack data
    if [ -f "/opt/tpot/data/anonymized-attack-data.json" ]; then
        cp /opt/tpot/data/anonymized-attack-data.json "$BACKUP_PATH/research-data/" || handle_error "Failed to backup anonymized attack data"
    fi
    
    # Backup research findings
    if [ -d "/opt/tpot/research-findings" ]; then
        cp -r /opt/tpot/research-findings "$BACKUP_PATH/research-data/" || handle_error "Failed to backup research findings"
    fi
    
    # Backup attack statistics
    if [ -f "/opt/tpot/statistics/attack-stats.json" ]; then
        cp /opt/tpot/statistics/attack-stats.json "$BACKUP_PATH/research-data/" || handle_error "Failed to backup attack statistics"
    fi
    
    log_message "Research data backup completed"
}

# Backup system logs
backup_system_logs() {
    log_message "Backing up system logs..."
    
    # Create logs backup directory
    mkdir -p "$BACKUP_PATH/system-logs"
    
    # Backup system logs (last 7 days)
    journalctl --since "7 days ago" > "$BACKUP_PATH/system-logs/system-journal.log" || handle_error "Failed to backup system journal"
    
    # Backup authentication logs
    if [ -f "/var/log/auth.log" ]; then
        tail -n 10000 /var/log/auth.log > "$BACKUP_PATH/system-logs/auth.log" || handle_error "Failed to backup authentication logs"
    fi
    
    # Backup syslog
    if [ -f "/var/log/syslog" ]; then
        tail -n 10000 /var/log/syslog > "$BACKUP_PATH/system-logs/syslog" || handle_error "Failed to backup syslog"
    fi
    
    # Backup T-Pot logs
    if [ -d "/var/log/tpot" ]; then
        cp -r /var/log/tpot "$BACKUP_PATH/system-logs/" || handle_error "Failed to backup T-Pot logs"
    fi
    
    log_message "System logs backup completed"
}

# Create backup archive
create_backup_archive() {
    log_message "Creating backup archive..."
    
    # Create compressed archive
    tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME" || handle_error "Failed to create backup archive"
    
    # Calculate archive size
    ARCHIVE_SIZE=$(du -h "$BACKUP_PATH.tar.gz" | cut -f1)
    log_message "Backup archive created: $BACKUP_PATH.tar.gz ($ARCHIVE_SIZE)"
}

# Upload to Azure Storage
upload_to_azure() {
    log_message "Uploading backup to Azure Storage..."
    
    # Check if Azure CLI is available
    if ! command -v az >/dev/null 2>&1; then
        log_message "WARNING: Azure CLI not available, skipping Azure upload"
        return 0
    fi
    
    # Upload to Azure Storage
    az storage blob upload \
        --account-name "$AZURE_STORAGE_ACCOUNT" \
        --container-name "$AZURE_CONTAINER" \
        --file "$BACKUP_PATH.tar.gz" \
        --name "$BACKUP_NAME.tar.gz" \
        --sas-token "$AZURE_SAS_TOKEN" \
        --overwrite || handle_error "Failed to upload backup to Azure Storage"
    
    log_message "Backup uploaded to Azure Storage successfully"
}

# Cleanup old backups
cleanup_old_backups() {
    log_message "Cleaning up old backups..."
    
    # Remove local backups older than retention period
    find "$BACKUP_DIR" -name "tpot-backup-*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; || handle_error "Failed to cleanup old local backups"
    find "$BACKUP_DIR" -name "tpot-backup-*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete || handle_error "Failed to cleanup old backup archives"
    
    log_message "Old backups cleaned up successfully"
}

# Generate backup report
generate_backup_report() {
    log_message "Generating backup report..."
    
    # Create backup report
    cat > "$BACKUP_PATH/backup-report.txt" << EOF
T-Pot Honeypot Backup Report
============================

Backup Date: $(date)
Backup Name: $BACKUP_NAME
Backup Path: $BACKUP_PATH

Backup Contents:
- T-Pot Configuration
- System Configuration
- NetBird Configuration
- Elastic Fleet Configuration
- SSL Certificates
- Docker Volumes
- Research Data
- System Logs

Backup Size: $(du -sh "$BACKUP_PATH" | cut -f1)
Archive Size: $(du -sh "$BACKUP_PATH.tar.gz" | cut -f1)

System Information:
- Hostname: $(hostname)
- OS: $(lsb_release -d | cut -f2)
- Kernel: $(uname -r)
- Uptime: $(uptime -p)

T-Pot Status:
- Docker Status: $(systemctl is-active docker)
- T-Pot Status: $(docker-compose -f /opt/tpot/docker-compose.yml ps --services --filter "status=running" | wc -l) services running

NetBird Status:
- NetBird Status: $(netbird status --json | jq -r '.connected' 2>/dev/null || echo "Unknown")
- NetBird Peers: $(netbird status --json | jq -r '.peers | length' 2>/dev/null || echo "Unknown")

Elastic Fleet Status:
- Elastic Agent Status: $(systemctl is-active elastic-agent 2>/dev/null || echo "Unknown")

Backup completed successfully at $(date)
EOF
    
    log_message "Backup report generated: $BACKUP_PATH/backup-report.txt"
}

# Main backup function
main() {
    log_message "Starting T-Pot honeypot backup process..."
    
    # Create backup directory
    create_backup_directory
    
    # Perform backups
    backup_tpot_config
    backup_system_config
    backup_netbird_config
    backup_elastic_fleet_config
    backup_ssl_certificates
    backup_docker_volumes
    backup_research_data
    backup_system_logs
    
    # Create backup archive
    create_backup_archive
    
    # Upload to Azure Storage
    upload_to_azure
    
    # Generate backup report
    generate_backup_report
    
    # Cleanup old backups
    cleanup_old_backups
    
    log_message "T-Pot honeypot backup process completed successfully"
    
    # Send success notification
    send_notification "Backup Completed Successfully" "T-Pot honeypot backup completed successfully. Archive: $BACKUP_NAME.tar.gz"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    handle_error "This script must be run as root"
fi

# Check if required commands are available
for cmd in tar gzip docker systemctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        handle_error "Required command not found: $cmd"
    fi
done

# Run main function
main "$@"

