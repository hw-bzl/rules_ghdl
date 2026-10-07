#!/usr/bin/env bash
# GENERATED FILE DO NOT EDIT.
#
# Library name:  {{LIBRARY_NAME}}
# Entity:        {{ENTITY}}
# VHDL Standard: {{VHDL_STANDARD}}
set -eo pipefail

export GHDL_PREFIX="{{GHDL_PREFIX}}"

readonly analyzer="{{ANALYZER}}"
readonly workdir="{{WORKDIR}}"
readonly wave_file="${TEST_UNDECLARED_OUTPUTS_DIR}/{{WAVE_FILE}}"

exec "$analyzer" -r \
    --workdir="$workdir" \
    --work="{{LIBRARY_NAME}}" \
    --std="{{VHDL_STANDARD}}" \
    {{LIBRARY_PATHS}} \
    "{{ENTITY}}" \
    --vcd="$wave_file" \
    {{EXTRA_ARGS}} \
    "$@"
