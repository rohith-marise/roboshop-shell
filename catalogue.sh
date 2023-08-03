log=/tmp/roboshop.log
echo -e "\e[35m >>>>>> Create Catalogue Service <<<<< \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
echo -e "\e[35m >>>>>> Create MongoDB Repo <<<<< \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
echo -e "\e[35m >>>>>> Install Nodejs Repo <<<<< \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
echo -e "\e[35m >>>>>> Install Nodejs <<<<< \e[0m"
yum install nodejs -y &>>${log}
echo -e "\e[35m >>>>>> Create Application User <<<<< \e[0m"
useradd roboshop &>>${log}
echo -e "\e[35m >>>>>> >>>>>> Removing Existing APP Content <<<<< \e[0m"
rm -rf /app &>>${log}
echo -e "\e[35m >>>>>> Create App directory <<<<< \e[0m"
mkdir /app &>>${log}
echo -e "\e[35m >>>>>> Download Application content <<<<< \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
echo -e "\e[35m >>>>>> Extract Application Content <<<<< \e[0m"
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
cd /app &>>${log}
echo -e "\e[35m >>>>>> Download Nodejs Dependencies <<<<< \e[0m"
npm install &>>${log}
echo -e "\e[35m >>>>>> Install Mongo Client <<<<< \e[0m"
yum install mongodb-org-shell -y &>>${log}
echo -e "\e[35m >>>>>> Load Catalogue Schema <<<<< \e[0m"
mongo --host mongodb.devrohiops.online </app/schema/catalogue.js &>>${log}
echo -e "\e[35m >>>>>> Start Catalogue Service <<<<< \e[0m"
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}