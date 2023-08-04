yum install nginx -y
echo $?

cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo $?

rm -rf /usr/share/nginx/html/*
echo $?
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo $?
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo $?

systemctl enable nginx
systemctl restart nginx
echo $?


