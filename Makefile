CLIENT_DIR=certs/client
SERVER_DIR=certs/server

ca:
	openssl genrsa -des3 -out $(SERVER_DIR)/ca.key 4096
	openssl req -new -x509 -days 365 -key $(SERVER_DIR)/ca.key -out $(SERVER_DIR)/ca.crt

client-cert:
	openssl genrsa -des3 -out $(CLIENT_DIR)/client.key 4096
	openssl req -new -key $(CLIENT_DIR)/client.key -out $(CLIENT_DIR)/client.csr
	openssl x509 -req -days 365 -in $(CLIENT_DIR)/client.csr -CA $(SERVER_DIR)/ca.crt -CAkey $(SERVER_DIR)/ca.key -set_serial 01 -out $(CLIENT_DIR)/client.crt

client-cert-fraud:
	openssl genrsa -des3 -out $(CLIENT_DIR)/client.key 2048
	openssl req -new -key $(CLIENT_DIR)/client.key -out $(CLIENT_DIR)/client.csr -sha256
	cp $(CLIENT_DIR)/client.key $(CLIENT_DIR)/client.key.org
	openssl rsa -in $(CLIENT_DIR)/client.key.org -out $(CLIENT_DIR)/client.key
	openssl x509 -req -in $(CLIENT_DIR)/client.csr -signkey $(CLIENT_DIR)/client.key -out $(CLIENT_DIR)/client.crt -sha256

client-pk12:
	openssl pkcs12 -export -clcerts -in $(CLIENT_DIR)/client.crt -inkey $(CLIENT_DIR)/client.key -out $(CLIENT_DIR)/client.p12
	openssl pkcs12 -in $(CLIENT_DIR)/client.p12 -out $(CLIENT_DIR)/client.pem -clcerts

server-cert:
	openssl genrsa -des3 -out $(SERVER_DIR)/server.key 2048
	openssl req -new -key $(SERVER_DIR)/server.key -out $(SERVER_DIR)/server.csr -sha256
	cp $(SERVER_DIR)/server.key $(SERVER_DIR)/server.key.org
	openssl rsa -in $(SERVER_DIR)/server.key.org -out $(SERVER_DIR)/server.key
	openssl x509 -req -in $(SERVER_DIR)/server.csr -signkey $(SERVER_DIR)/server.key -out $(SERVER_DIR)/server.crt -sha256