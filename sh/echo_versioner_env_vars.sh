#!/usr/bin/env bash
set -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
echo_versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_CUSTOM_START_POINTS_SHA="$(git_commit_sha)"
  echo CYBER_DOJO_CUSTOM_START_POINTS_TAG="$(git_commit_tag)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  git rev-parse HEAD
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_CUSTOM_START_POINTS_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  docker run --entrypoint='' --rm "$(image_name):$(git_commit_tag)" sh -c 'echo ${SHA}'
}

