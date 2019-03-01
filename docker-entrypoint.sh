#!/bin/sh

set -e -o pipefail

if [ "${1::1}" = "-" ]; then
    set -- errbot "$@"
fi

exec "$@"
