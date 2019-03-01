Docker images with Errbot
=========================


# Quick start
```shell
docker run --rm -v $PWD/config.py:/app/config.py:ro mnazarenko/errbot:alpine
```

# Build own images

The image can be customized during the build in a number of ways.

By default, only Errbot core components are installed.
If you need, for example, `slack` integration, you can do something like this:
```shell
$ docker build -t my-errbot:slack-xmpp --build-arg ERRBOT_EXTRA_MODULES=slack -f alpine/Dockerfile
```
or several extras at a time:
```shell
$ docker build -t my-errbot:slack --build-arg ERRBOT_EXTRA_MODULES=slack,xmpp -f alpine/Dockerfile
```

You can do pretty the same with OS packages:
```shell
$ docker build -t my-errbot --build-arg ERRBOT_OS_EXTRA_PACKAGES='curl wget' -f alpine/Dockerfile
```
`ERRBOT_EXTRA_MODULES` and `ERRBOT_OS_EXTRA_PACKAGES` are passed "as is" so be note the difference - comma delimited vs space delimited.

## Custom configuration

The only way to configure the Errbot is via command line switches (env vars should be implemented in the future):
```shell
$ docker run -v $PWD/custom-config.py:/app/config.py:ro mnazarenko/errbot:alpine
```
