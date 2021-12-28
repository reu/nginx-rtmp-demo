# NGINX RTMP example

Simple example of using NGINX RTMP module to play HLS and DASH.

1 - Build the image: `docker build -t nginx-rtmp-demo .`

2 - You can run the image mounting an example HTML player using: `docker run -ti --rm -p 1935:1935 -p 8080:80 -v $(pwd)/player/:/usr/local/nginx/html/ nginx-rtmp-demo`.

3 - Push the stream (using OBS for example) to `rtmp://0.0.0.0/live` using the a stream key named `stream`

4 - Access http://localhost:8080 on your browser
