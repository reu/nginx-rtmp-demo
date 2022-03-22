# NGINX RTMP example

Simple example of using NGINX RTMP module to play HLS and DASH.

1 - Build the image: `docker build -t nginx-rtmp-demo .`

2 - You can run the image mounting an example HTML player using: 
```
docker run \
  -p 1935:1935 \
  -p 80:80 \
  -p 443:443 \
  --detach \
  --name nginx-rtmp-demo \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
  -v $(pwd)/player/:/usr/local/nginx/html/ \
  -v $(pwd)/letsencrypt/:/etc/letsencrypt/ \
  nginx-rtmp-demo
```

3 - To request an SSL certificate from LetsEncrypt run the following command with an email (which will be registered at LetsEncrypt) and the domain name you wish to use:
```
docker exec nginx-rtmp-demo certbot -n \
  --agree-tos \
  --nginx \
  --redirect \
  --reinstall \
  --email your@email.com \
  -d yourdomain.com
```

Ps: To automatically renew the certificate you just need to schedule the previous command to run daily on your crontab.

4 - Push the stream (using OBS for example) to `rtmp://0.0.0.0/live` using the a stream key named `stream`

5 - Access https://<your domain> on your browser
