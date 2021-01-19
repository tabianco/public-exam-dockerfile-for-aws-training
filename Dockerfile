FROM ubuntu:18.04

COPY entrypoint.sh /

RUN  apt-get update -y \
    && apt-get install -y curl unzip mysql-client redis-server nginx \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && curl -sSL https://git.io/get-mo -o mo \
    && chmod +x mo \
    && mv mo /usr/local/bin/ \
    && chmod +x entrypoint.sh

COPY index.template.html /var/www/html

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["/entrypoint.sh"]
