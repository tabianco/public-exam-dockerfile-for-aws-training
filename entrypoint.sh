#!/bin/sh

result="success"
mysql_result="success"
redis_result="success"
s3_result="success"

mysql -u "$DB_USERNAME" -h "$DB_HOST" -p"${DB_PASSWORD}" -e 'select 1;'
if [ $? -ne 0 ]; then
  result="failure"
  mysql_result="failure"
fi

redis-cli -h "$REDIS_HOST" PING
if [ $? -ne 0 ]; then
  result="failure"
  redis_result="failure"
fi

aws s3 ls "s3://${BUCKET_NAME}"
if [ $? -ne 0 ]; then
  result="failure"
  s3_result="failure"
fi

export RESULT=$result
export MYSQL_RESULT=$mysql_result
export REDIS_RESULT=$redis_result
export S3_RESULT=$s3_result

cat /var/www/html/index.template.html | mo > /var/www/html/index.html

nginx -g "daemon off;"
