#!/usr/bin/env python3
from pprint import pprint
import os, json, uuid, toml, pprint
from shutil import copyfile

ASSISTANT_DIR = "/usr/share/snips/assistant/"
ASSISTANT_JSON = ASSISTANT_DIR + 'assistant.json'
if os.path.isfile(ASSISTANT_JSON):
    copyfile(ASSISTANT_JSON, ASSISTANT_JSON + '.bak')
    with open(ASSISTANT_JSON, 'r') as f:
        data = json.load(f)
        data['language'] = 'pl'
        f.close()
    with open(ASSISTANT_JSON, 'w') as f:
        json.dump(data, f, indent=2)

# Change TTS
TOML_PATH = '/etc/snips.toml'
try:
    TOML_CONFIG = toml.load(TOML_PATH)
except (KeyError, ValueError):
    print("Cannot load " + TOML_PATH)

try:
    provider = TOML_CONFIG['snips-tts']['provider']
except (KeyError, ValueError):
    provider = ""

if not provider == 'customtts':
    tts_value = ["/scripts/custom_tts/snipsGoogle.sh", "%%OUTPUT_FILE%%", "pl", "%%TEXT%%", "httpie"]
    try:
        TOML_STRING = toml.dumps(TOML_CONFIG)
        TOML_STRING = TOML_STRING + "['snips-tts.customtts']"
        TOML_CONFIG = toml.loads(TOML_STRING)
        TOML_CONFIG['snips-tts']['provider'] = 'customtts'
        TOML_CONFIG['snips-tts.customtts']['command'] = tts_value
        with open(TOML_PATH, 'w') as f:
            toml.dump(TOML_CONFIG, f)
        print("TTS engine changed.")
    except (KeyError, ValueError):
        print("Changing TTS engine in snips.toml failed!")
else:
    print("TTS engine already changed.")

