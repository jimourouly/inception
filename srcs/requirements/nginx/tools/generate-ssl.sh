#!/bin/bash

# generate ssl certificat if doesnt exist

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	echo "Generating SSL certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
	echo "SSL certificate generated."
fi
