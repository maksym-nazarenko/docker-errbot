# ----- Build environment -----
FROM python:3.7-alpine3.7 as build_image

ENV ERRBOT_VENV_DIR=/app-venv

RUN mkdir $ERRBOT_VENV_DIR && python -mvenv $ERRBOT_VENV_DIR

# a space-delimited list
ARG ERRBOT_OS_EXTRA_PACKAGES=""
RUN apk add --update \
    gcc \
    libffi-dev \
    musl-dev \
    openssl-dev ${ERRBOT_OS_EXTRA_PACKAGES}

# a comma-delimited list
ARG ERRBOT_EXTRA_MODULES=""

# build image with specific ERRBOT version, e.g. `5.2.0`
ARG ERRBOT_VERSION=""
ENV ERRBOT_VERSION="${ERRBOT_VERSION}"

RUN ${ERRBOT_VENV_DIR}/bin/pip install errbot[${ERRBOT_EXTRA_MODULES}]${ERRBOT_VERSION:+"=="${ERRBOT_VERSION}}

# ----- Production -----
FROM python:3.7-alpine3.7

LABEL maintainer=maks.nazarenko@gmail.com

ARG PROJECT_APP_USER_UID=10000
ARG PROJECT_APP_USER_GID=10000

ENV ERRBOT_VENV_DIR=/app-venv
ENV ERRBOT_APP_DIR=/app
ENV ERRBOT_USER=errbot
ENV ERRBOT_GROUP=errbot
ENV ERRBOT_DATA_DIR=${ERRBOT_APP_DIR}/data

RUN addgroup -g $PROJECT_APP_USER_GID $ERRBOT_GROUP
RUN adduser \
    -u $PROJECT_APP_USER_UID \
    -D \
    -H \
    -s /sbin/nologin \
    -G $ERRBOT_GROUP \
    $ERRBOT_USER

COPY --from=build_image ${ERRBOT_VENV_DIR}/ ${ERRBOT_VENV_DIR}/

RUN mkdir -p ${ERRBOT_APP_DIR} ${ERRBOT_DATA_DIR} && chown -R ${ERRBOT_USER}:${ERRBOT_GROUP} ${ERRBOT_APP_DIR} ${ERRBOT_DATA_DIR}


WORKDIR $ERRBOT_APP_DIR
USER $ERRBOT_USER

ENV PATH="${ERRBOT_VENV_DIR}/bin:${PATH}"

COPY docker-entrypoint.sh /usr/local/bin/
COPY config_*_provider.py ${ERRBOT_APP_DIR}/

VOLUME ${ERRBOT_DATA_DIR}/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["errbot"]
