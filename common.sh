log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ] ; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILED \e[0m"
  fi

}
func_apppreq() {

   echo -e "\e[35m >>>>>> Create ${component} Service <<<<< \e[0m"
   cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
   func_exit_status
   echo -e "\e[35m >>>>>> Create Application User <<<<< \e[0m"
   id roboshop &>>${log}
   if [ $? -ne 0 ] ; then
   useradd roboshop &>>${log}
   fi
   func_exit_status

   echo -e "\e[35m >>>>>> Clean Up Existing App Content <<<<< \e[0m"
   rm -rf /app &>>${log}
   func_exit_status
   echo -e "\e[35m >>>>>> Create App Directory <<<<< \e[0m"
   mkdir /app &>>${log}
   func_exit_status
   echo -e "\e[35m >>>>>> Download Application Content <<<<< \e[0m"
   curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
   func_exit_status
   echo -e "\e[35m >>>>>> Extract Application Content <<<<< \e[0m"
   cd /app &>>${log}
   unzip /tmp/${component}.zip &>>${log}
   cd /app &>>${log}
   func_exit_status
}

func_systemd() {
  echo -e "\e[35m >>>>>> Start ${component} Service <<<<< \e[0m"
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}
    func_exit_status
}

func_schema_steup() {

  if [ "${schema_type}" == "mongodb" ] ; then
    echo -e "\e[35m >>>>>> Install Mongo Client <<<<< \e[0m"
    yum install mongodb-org-shell -y &>>${log}
    func_exit_status
    echo -e "\e[35m >>>>>> Load ${component} Schema <<<<< \e[0m"
    mongo --host mongodb.devrohiops.online </app/schema/${component}.js &>>${log}
    func_exit_status
   fi

   if [ "{schema_type}" == "mysql" ] ; then
      echo -e "\e[35m >>>>>> Install Mysql Client <<<<< \e[0m"
      #Mysql comes with centos default for client we can install any version
      yum install mysql -y &>>${log}
      func_exit_status
      echo -e "\e[35m >>>>>> Load ${component} Schema <<<<< \e[0m"
      mysql -h mysql.devrohiops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
      func_exit_status
      fi
}

func_nodejs() {
    echo -e "\e[35m >>>>>> Create MongoDB Repo <<<<< \e[0m"
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
    func_exit_status
    echo -e "\e[35m >>>>>> Install Nodejs Repo <<<<< \e[0m"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
    func_exit_status
    echo -e "\e[35m >>>>>> Install Nodejs <<<<< \e[0m"
    yum install nodejs -y &>>${log}
    func_exit_status

    func_apppreq

    echo -e "\e[35m >>>>>> Download Nodejs Dependencies <<<<< \e[0m"
    npm install &>>${log}
    func_exit_status

    func_schema_steup

    func_systemd
}

func_java() {

 echo -e "\e[35m >>>>>> Install Maven <<<<< \e[0m"
 yum install maven -y &>>${log}
 func_exit_status

 func_apppreq

 echo -e "\e[35m >>>>>> build ${component} Service <<<<< \e[0m"
 mvn clean package &>>${log}
 mv target/${component}-1.0.jar ${component}.jar &>>${log}
 func_exit_status
 func_schema_steup

 func_systemd

}

func_python() {

  echo -e "\e[35m >>>>>> Install Python Packages <<<<< \e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_exit_status

  func_apppreq

  echo -e "\e[35m >>>>>> Build ${component}  <<<<< \e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status

  func_systemd
}

func_golang() {
  echo -e "\e[35m >>>>>> Install Golang Packages <<<<< \e[0m"
  yum install golang -y &>>${log}
  func_exit_status

  func_apppreq

  sed -i "s/rabbitmq_app_password/${rabbitmq_app_password}/" /etc/systemd/system/${component}.service
  echo -e "\e[35m >>>>>> Build Golang  <<<<< \e[0m"
  go mod init ${component} &>>${log}
  go get &>>${log}
  go build &>>${log}
  func_exit_status
  
  func_systemd

}