#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo.custom-start-points.XXXXXXXXX)
trap "rm -rf ${TMP_DIR} > /dev/null" INT EXIT

# - - - - - - - - - - - - - - - - - - - - - - - -
main()
{
  export $(versioner_env_vars)
  echo; remove_old_images
  echo; build_tagged_image
  assert_sha_env_var_inside_image_matches_image_tag
  echo; show_env_vars
  tag_the_image_to_latest
  echo; on_ci_publish_tagged_images
}

# - - - - - - - - - - - - - - - - - - - - - - - -
versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  local -r sha="$(cd "${ROOT_DIR}" && git rev-parse HEAD)"
  local -r tag="${sha:0:7}"
  echo "CYBER_DOJO_CUSTOM_START_POINTS_SHA=${sha}"
  echo "CYBER_DOJO_CUSTOM_START_POINTS_TAG=${tag}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
remove_old_images()
{
  local -r dil=$(docker image ls --format "{{.Repository}}:{{.Tag}}")
  remove_all_but_latest "${dil}" "${CYBER_DOJO_CUSTOM_START_POINTS_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_all_but_latest()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  for image_name in `echo "${docker_image_ls}" | grep "${name}:"`
  do
    if [ "${image_name}" != "${name}:latest" ]; then
      if [ "${image_name}" != "${name}:<none>" ]; then
        docker image rm "${image_name}"
      fi
    fi
  done
  docker system prune --force
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_image()
{
  # GIT_COMMIT_SHA is needed to embed the SHA inside the created image as an env-var
  export GIT_COMMIT_SHA="$(image_sha)"
  $(cyber_dojo) start-point create "$(image_name):$(image_tag)" --custom "${ROOT_DIR}"
  unset GIT_COMMIT_SHA
}

# - - - - - - - - - - - - - - - - - - - - - - - -
assert_sha_env_var_inside_image_matches_image_tag()
{
  local -r expected="$(image_sha)"
  local -r actual="$(docker run --entrypoint='' --rm "$(image_name):$(image_tag)" sh -c 'echo ${SHA}')"
  if [ "${expected}" != "${actual}" ]; then
    echo ERROR
    echo "expected:'${expected}'"
    echo "  actual:'${actual}'"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name() { echo "${CYBER_DOJO_CUSTOM_START_POINTS_IMAGE}"; }
image_sha()  { echo "${CYBER_DOJO_CUSTOM_START_POINTS_SHA}"  ; }
image_tag()  { echo "${CYBER_DOJO_CUSTOM_START_POINTS_TAG}"  ; }

# - - - - - - - - - - - - - - - - - - - - - - - -
cyber_dojo()
{
  local -r name=cyber-dojo
  if [ -x "$(command -v ${name})" ]; then
    >&2 echo "Found executable ${name} on the PATH"
    echo "${name}"
  else
    local -r url="https://raw.githubusercontent.com/cyber-dojo/commander/master/${name}"
    >&2 echo "Did not find executable ${name} on the PATH"
    >&2 echo "Curling it from ${url}"
    curl --fail --output "${TMP_DIR}/${name}" --silent "${url}"
    chmod 700 "${TMP_DIR}/${name}"
    echo "${TMP_DIR}/${name}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_the_image_to_latest()
{
  # Creating a versioner release relies on using :latest holding the SHA
  # env-var which identifies the 7-character image tag.
  docker tag "$(image_name):$(image_tag)" "$(image_name):latest"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
show_env_vars()
{
  echo "CYBER_DOJO_CUSTOM_START_POINTS_SHA=$(image_sha)"
  echo "CYBER_DOJO_CUSTOM_START_POINTS_TAG=$(image_tag)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CIRCLECI:-}" ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_images()
{
  if ! on_ci; then
    echo 'not on CI so not publishing tagged images'
    return
  fi
  echo 'on CI so publishing tagged images'
  docker push "$(image_name):$(image_tag)"
  docker push "$(image_name):latest"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
main
