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

You can configure the Errbot using:
  * custom `config.py`
    ```shell
    $ docker run -v $PWD/custom-config.py:/app/config.py:ro mnazarenko/errbot:alpine
    ```
  * command line swtiches
    ```shell
    $ docker run mnazarenko/errbot:alpine --config /mount/custom.py --merge-backend '' ...
    ```
  * environment variables (see detailed description below)
    ```shell
    $ docker run -e CONFIG_PROVIDER=env -e ERRBOT_CONFIG_BOT_LOG_FILE='None' -e ERRBOT_CONFIG_BOT_ADMINS='("admin@localhost",)'  mnazarenko/errbot:alpine
    ```

## Environment variables

**CONFIG_PROVIDER**

  Currently, only `env` provider is supported. If this variable is omitted, the `default` provider will be used

  Available config providers:
  * `env` - parses the environment variables which starts with fixed prefix `ERRBOT_CONFIG_` and populates the module namespace with Errbot config variables.
  Example: `ERRBOT_CONFIG_BOT_ADMINS='("admin@localhost",)'` becomes `BOT_ADMINS=("admin@localhost",)`, `ERRBOT_CONFIG_BOT_LOG_FILE='None'` becomes `BOT_LOG_FILE=None` and so on.

    **NOTE:** string -> value parsing is based on the [ast.literal_eval](https://docs.python.org/3/library/ast.html#ast.literal_eval)
  * `default` - simply copies the default config file if `/app/config.py` is missed.
