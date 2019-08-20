docker build -t snips .
CONFIG_DIR=${PWD}/config
mkdir -p $CONFIG_DIR
touch $CONFIG_DIR/snips.toml
