#!/bin/sh
# Script básico para generar full backups de múltiples bases de datos MySQL
# @source: /sh_scripts/
# @author: Gonzalo Chacaltana Buleje

# Directorio donde se almacenarán los backups
backup_parent_dir = '/backup_storage_01/master/'

# Cuenta de acceso a servidor MySQL
mysql_user = '**********************'
mysql_pass = '**********************'

# Check Mysql Password
echo exit | mysql --user=${mysql_user} --password=${mysql_pass} -B 2>/dev/null
if [ "$?" -gt 0 ]; then
    echo "MySQL user ${mysql_user} is incorrect."
else
    echo "MySQL user ${mysql_user} is correct."
fi

# Crear directorio para almacenar archivo backup
backup_date=`date +%Y_%m_%d_%H_%M`
backup_dir="${backup_parent_dir}/${backup_date}"
echo "Backup directory: ${backup_dir}"
mkdir -p "${backup_dir}"
chmod 700 "${backup_dir}"

# Obtener bases de datos del servidor
mysql_databases=`echo "show databases like 'dbxzv_mst_001%'" | mysql --user=${mysql_user} --password=${mysql_pass} -B`

# Realizamos backup de base de datos y comprimimos ficheros
for database in $mysql_databases
do
    if [ "${database}" != "Database" ] && [ "${database}" != "(dbxzv_mst_001%)" ]; then
        echo "Creando backup de \"${database}\" database"
        mysqldump ${additional_mysqldump_params} --user=${mysql_user} --password=${mysql_pass} --routines ${database} | gzip > "${backup_dir}/${database}.gz"
        chmod 600 "${backup_dir}/${database}.gz"
    fi
done