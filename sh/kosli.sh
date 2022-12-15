#!/usr/bin/env bash
set -Eeu

export KOSLI_OWNER=cyber-dojo
export KOSLI_PIPELINE=custom-start-points

readonly KOSLI_HOST_STAGING=https://staging.app.kosli.com
readonly KOSLI_HOST_PRODUCTION=https://app.kosli.com

# - - - - - - - - - - - - - - - - - - -
kosli_declare_pipeline()
{
  local -r hostname="${1}"

  kosli pipeline declare \
    --description "Custom exercises choices" \
    --visibility public \
    --template artifact \
    --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_report_artifact_creation()
{
  local -r hostname="${1}"

  cd "$(root_dir)"  # So we don't need --repo-root flag

  kosli pipeline artifact report creation \
    "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_assert_artifact()
{
  local -r hostname="${1}"

  kosli assert artifact \
    "$(artifact_name)" \
      --artifact-type docker \
      --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_expect_deployment()
{
  local -r environment="${1}"
  local -r hostname="${2}"

  # In .github/workflows/main.yml deployment is its own job
  # and the image must be present to get its sha256 fingerprint.
  docker pull "$(artifact_name)"

  kosli expect deployment \
    "$(artifact_name)" \
    --artifact-type docker \
    --description "Deployed to ${environment} in Github Actions pipeline" \
    --environment "${environment}" \
    --host "${hostname}"
}

# - - - - - - - - - - - - - - - - - - -
artifact_name() {
  source "$(root_dir)/sh/echo_versioner_env_vars.sh"
  export $(echo_versioner_env_vars)
  echo "${CYBER_DOJO_CUSTOM_START_POINTS_IMAGE}:${CYBER_DOJO_CUSTOM_START_POINTS_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
root_dir()
{
  # Functions in this file are called after sourcing (not including)
  # this file so root_dir() cannot use the path of this script.
  git rev-parse --show-toplevel
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CI:-}" ]
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_declare_pipeline()
{
  if on_ci ; then
    kosli_declare_pipeline "${KOSLI_HOST_STAGING}"
    kosli_declare_pipeline "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_report_artifact_creation()
{
  if on_ci ; then
    kosli_report_artifact_creation "${KOSLI_HOST_STAGING}"
    kosli_report_artifact_creation "${KOSLI_HOST_PRODUCTION}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_assert_artifact()
{
  if on_ci ; then
    kosli_assert_artifact "${KOSLI_HOST_STAGING}"
    kosli_assert_artifact "${KOSLI_HOST_PRODUCTION}"
  fi
}



