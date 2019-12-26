#!/bin/bash
set -e

readonly TMP_DIR=$(mktemp -d /tmp/cyber.custom-start-points.XXXXXXXXX)
trap "rm -rf ${TMP_DIR} > /dev/null" INT EXIT
readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly IMAGE=cyberdojo/custom-start-points
readonly SHA=$(cd "${ROOT_DIR}" && git rev-parse HEAD)
readonly TAG="${SHA:0:7}"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_the_image()
{
  if on_ci; then
    build_image_on_ci
  else
    build_image_locally
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_the_image_on_ci()
{
  cd ${TMP_DIR}
  curl_script
  chmod 700 ./$(script_name)
  ./$(script_name) start-point create \
    ${IMAGE} \
      --custom \
        https://github.com/cyber-dojo/custom-start-points.git
}

# - - - - - - - - - - - - - - - - - - - - - - - -
curl_script()
{
  local -r GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
  local -r REPO_NAME=commander
  local -r BRANCH_NAME=master
  curl -O --silent --fail "${GITHUB_ORG}/${REPO_NAME}/${BRANCH_NAME}/$(script_name)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
script_name()
{
  echo cyber-dojo
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_image_locally()
{
  local -r SCRIPT_NAME="${ROOT_DIR}/../commander/$(script_name)"
  ${SCRIPT_NAME} start-point create \
    ${IMAGE} \
      --custom \
        "${ROOT_DIR}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_the_image()
{
  docker tag ${IMAGE}:latest ${IMAGE}:${TAG}
  echo "${SHA}"
  echo "${TAG}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CIRCLECI}" ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_images()
{
  if ! on_ci; then
    echo 'not on CI so not publishing tagged images'
    return
  fi
  echo 'on CI so publishing tagged images'
  # DOCKER_USER, DOCKER_PASS are in ci context
  echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
  docker push ${IMAGE}:latest
  docker push ${IMAGE}:${TAG}
  docker logout
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_the_image
tag_the_image
on_ci_publish_tagged_images
