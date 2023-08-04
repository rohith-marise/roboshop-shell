component=payment
source common.sh
rabbitmq_app_password=$1
if [ -z ${rabbitmq_app_password} ] ; then
  echo -e "\e[31m RabbitMQ AppUser Password Missing \e[0m"
  exit 1
fi
func_python