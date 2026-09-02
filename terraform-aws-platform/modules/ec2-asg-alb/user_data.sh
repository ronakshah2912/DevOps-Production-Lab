#!/bin/bash
set -e

dnf update -y
dnf install -y nginx

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /usr/share/nginx/html/index.html <<EOF
<html>
  <head>
    <title>DevOps Production Lab</title>
  </head>
  <body>
    <h1>DevOps Production Lab Application</h1>
    <p>Status: Healthy</p>
    <p>Instance ID: ${INSTANCE_ID}</p>
    <p>Availability Zone: ${AZ}</p>
  </body>
</html>
EOF

cat > /usr/share/nginx/html/health <<EOF
healthy
EOF

systemctl enable nginx
systemctl start nginx