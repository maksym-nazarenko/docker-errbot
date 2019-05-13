#!/bin/sh

set -e -o pipefail

ERRBOT_CONFIG_FILE="/app/config.py"
CONFIG_PROVIDER="${CONFIG_PROVIDER:-default}"


prepare_config() {
    case "${CONFIG_PROVIDER}" in
        env)
        ;;
        *)
            echo "WARNING: invalid or unsupported config provider '${CONFIG_PROVIDER}'. Using default one."
            CONFIG_PROVIDER=default
    esac

    custom_config_provider="/app/config_${CONFIG_PROVIDER}_provider.py"
    echo "Using '${custom_config_provider}' instead."
    cp ${custom_config_provider} ${ERRBOT_CONFIG_FILE}

}

if [ ! -e "${ERRBOT_CONFIG_FILE}" ]; then
    echo "No '${ERRBOT_CONFIG_FILE}' file found. Trying to get the best available provider."
    prepare_config
fi

if [ "${1::1}" = "-" ]; then
    set -- errbot "$@"
fi

exec "$@"
