import ast
import logging
import os


ENV_PREFIX = 'ERRBOT_CONFIG_'
APP_DIR = '/app'
DATA_DIR = APP_DIR + '/data'


# Defaults

BOT_DATA_DIR = DATA_DIR
BOT_LOG_FILE = None
BOT_LOG_LEVEL = logging.WARNING

# ---------------------------------------


for k, v in os.environ.items():
    if not k.startswith(ENV_PREFIX):
        continue

    export_varname = k[len(ENV_PREFIX):]
    try:
        parsed_value = ast.literal_eval(str(v))
    except ValueError:
        parsed_value = str(v)

    globals()[export_varname] = parsed_value
