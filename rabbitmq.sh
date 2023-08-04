log=/tmp/roboshop.log
source common.sh
rabbitmq_app_password=$1
if [ -z ${rabbitmq_app_password} ] ; then
  echo -e "\e[31m RabbitMQ AppUser Password Missing \e[0m"
  exit 1
fi
echo -e "\e[35m >>>>>> Installing RabbitMQ Repos <<<<< \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
func_exit_status
echo -e "\e[35m >>>>>> Installing RabbitMQ Server <<<<< \e[0m"
yum install rabbitmq-server -y
func_exit_status
echo -e "\e[35m >>>>>> Starting RabbitMQ services <<<<< \e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
func_exit_status
echo -e "\e[35m >>>>>> Adding RabbitMQ USER and Password <<<<< \e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_app_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
func_exit_status