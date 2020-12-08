#php-errors

This repository contains the smallest possible testcase used for demonstrating getting errors into Cloudwatch logs

1. Install fcgi on your local machine
```
brew install fcgi
```

2. Build the docker file

```
docker build --no-cache .

Sending build context to Docker daemon  45.06kB
Step 1/6 : FROM php:7.3-fpm-alpine
 ---> 3441e5a5ed18
Step 2/6 : COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
 ---> 1bcacaf533f4
Step 3/6 : COPY phpinfo.php /phpinfo.php
 ---> 5024dbb2218d
Step 4/6 : COPY error.php /error.php
 ---> 22b2ced2526e
Step 5/6 : RUN apk update && apk add bash
 ---> Running in 14f17070684b
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/community/x86_64/APKINDEX.tar.gz
v3.12.1-74-g54165f73d3 [http://dl-cdn.alpinelinux.org/alpine/v3.12/main]
v3.12.1-78-g8ca0a357ed [http://dl-cdn.alpinelinux.org/alpine/v3.12/community]
OK: 12746 distinct packages available
(1/2) Installing readline (8.0.4-r0)
(2/2) Installing bash (5.0.17-r0)
Executing bash-5.0.17-r0.post-install
Executing busybox-1.31.1-r19.trigger
OK: 13 MiB in 32 packages
Removing intermediate container 14f17070684b
 ---> 74c560d25ee2
Step 6/6 : CMD ["php-fpm", "-F"]
 ---> Running in 2e0ac151abf9
Removing intermediate container 2e0ac151abf9
 ---> d496c6db0332
Successfully built d496c6db0332
```

3. Run it, exposing port 9000
```
docker run -p 9000:9000 d496c6db0332
```

4. Test 

There are two scripts - error.php (That throws an error) and phpinfo.php, which calls the phpinfo() function

```
SCRIPT_NAME=/phpinfo.php \
SCRIPT_FILENAME=/phpinfo.php \
REQUEST_METHOD=GET \
cgi-fcgi -bind -connect 127.0.0.1:9000
```

```
SCRIPT_NAME=/error.php \
SCRIPT_FILENAME=/error.php \
REQUEST_METHOD=GET \
cgi-fcgi -bind -connect 127.0.0.1:9000
```

To get a terminal on the instance first find the name of the container:

```docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
cd39bb6b12be        d496c6db0332        "docker-php-entrypoi…"   3 seconds ago       Up 1 second         0.0.0.0:9000->9000/tcp   gracious_kepler
```

Then exec a bash shell:

```
docker exec -it gracious_kepler /bin/bash
```
