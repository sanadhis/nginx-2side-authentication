# Two Sided Authentication with Nginx
Simulate how nginx can be used to provide two-sided authentication, respectively from client side and from nginx to upstreams.

## Prerequisites
* Install docker.
* Install docker-compose.
* Familiarity with nginx.
* Openssl installed.

## 1. Create Certificate Authority (CA) for client authentication
```bash
make ca
```

## 2. Create Client Certificate (.cert) based on CA from previous step
```bash
make client-cert
```

## 3. Create Self-Signed Server Certificate (.cert)
```bash
make server-cert
```

## 4. Bring the cluster up
```bash
docker-compose -f cluster.yml up
```
Note: Add -d flag at the end of the command to start the containers in the background.

## 5. Test connection and client-side authentication
```bash
# this should be rejected
curl localhost:443/web1

# provide cert and key when performing the request
# this should be successful 
curl localhost:443/web1 \
    --insecure \ # ignore server cert credibility
    --cert certs/client/client.crt
    --key certs/client/client.key
```

## 6. Extra: Repeat the test with fraud certificate from client side (not signed with CA)
```bash
make client-cert-fraud

# provide cert and key when performing the request
# you should receive: 400 The SSL certificate error
curl localhost:443/web1 \
    --insecure \ # ignore server cert credibility
    --cert certs/client/client.crt
    --key certs/client/client.key
```

# License
MIT.