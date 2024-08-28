#!/bin/bash

NODES_YAML=/app/jenkins_scripts/prep/Installation/perf_nodes.yml
# read yaml file
. /app/jenkins_scripts/prep/Installation/parse_yaml.sh
echo eval $(parse_yaml $NODES_YAML "config_")
