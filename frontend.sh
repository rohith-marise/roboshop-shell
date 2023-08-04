log=/tmp/roboshop.log
echo -e "\e[35m >>>>>> Installing Nginx Server <<<<< \e[0m"
yum install nginx -y &>>${log}
echo $?

echo -e "\e[35m >>>>>> Adding Reverse proxy configuration <<<<< \e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
echo $?

echo -e "\e[35m >>>>>> Removing Existing content <<<<< \e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
echo $?
echo -e "\e[35m >>>>>> Downloading the Application content <<<<< \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
echo $?

echo -e "\e[35m >>>>>> Unzipping the content <<<<< \e[0m"
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}
echo $?

echo -e "\e[35m >>>>>> Restarting The Services <<<<< \e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
echo $?


