# alpine-php-builder docker image

Download and build php extension from source codes.
The results saved into the folder '/build'.

Usage:
```
mkdir build
docker run --rm \
  -v /`pwd`/build:/build \
  -e "GIT_REPO=<url>" \
  -e "GIT_VER=<tag|branch>" \
  chazer/alpine-php-builder
cp build/*.so /usr/lib/php/modules/
echo "extension=__module__.so" >> /etc/php/conf.d/__module__.ini
```

```
docker run -ti chazer/alpine-php-builder <command>
```
