set-hostname mysql
cp mysql.repo /etc/yum.repos.d/mqsql.repo
yum module disable mysql -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld
mysql_secure_installation --set-root-pass RoboShop@1