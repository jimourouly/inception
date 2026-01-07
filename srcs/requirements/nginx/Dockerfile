FROM Debian:12

#install nginx and openssl

RUN apt-get update && \ apt-get install -y nginx openssl && \ rm -rf /var/lib/apt/lists/*

#create certificate ssl folder
RUN mkdir -p /etc/nginx/ssl

#copy nginx conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

#copy generate script 
COPY tools/generate-ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/generate-ssl.sh

#expose https ports
EXPOSE 443

# gengerate cert. and launch nginx
CMD ["/bin/bash", "-c", "/usr/local/bin/generate-ssl.sh && nginx -g 'daemon off;'"]

