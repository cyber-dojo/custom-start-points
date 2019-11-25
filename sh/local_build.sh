#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)
readonly UNCLEAN="$(cd "${ROOT_DIR}" && git status -s)"

if [[ -n "${UNCLEAN}" ]]; then
  echo
  echo '  WARNING'
  echo "  There is are uncommitted files in ${ROOT_DIR}."
  echo '  The image is created from HEAD and will not see these changes.'
  echo
fi

SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/custom \
      --custom \
        file://${ROOT_DIR}
