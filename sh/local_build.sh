#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly UNCLEAN="$(cd "${ROOT_DIR}" && git status -s)"

if [[ -n "${UNCLEAN}" ]]; then
  echo
  echo '  WARNING'
  echo "  There is are uncommitted files in ${ROOT_DIR}."
  echo '  The image is created from HEAD and will not see these changes.'
  echo
fi

readonly SCRIPT_PATH=${ROOT_DIR}/../commander/cyber-dojo

export SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)
export CYBER_DOJO_CUSTOM_PORT=4526

readonly IMAGE_NAME=cyberdojo/custom-start-points

${SCRIPT_PATH} start-point create \
  ${IMAGE_NAME} \
    --custom \
      file://${ROOT_DIR}
