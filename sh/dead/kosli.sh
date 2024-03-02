#!/usr/bin/env bash
set -Eeu

export KOSLI_ORG=cyber-dojo
export KOSLI_FLOW=custom-start-points-ci
export KOSLI_TRAIL="$(git rev-parse HEAD)"

# KOSLI_ORG is set in CI
# KOSLI_API_TOKEN is set in CI
# KOSLI_API_TOKEN_STAGING is set in CI
# KOSLI_HOST_STAGING is set in CI
# KOSLI_HOST_PRODUCTION is set in CI
# SNYK_TOKEN is set in CI

# - - - - - - - - - - - - - - - - - - -
kosli_begin_trail()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli create flow "${KOSLI_FLOW}" \
    --description="Custom exercises choices" \
    --host="${hostname}" \
    --api-token="${api_token}" \
    --template-file="$(repo_root)/.kosli.yml" \
    --visibility=public

  kosli begin trail "${KOSLI_TRAIL}" \
    --host="${hostname}" \
    --api-token="${api_token}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_attest_artifact()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli attest artifact "$(artifact_name)" \
    --artifact-type=docker \
    --host="${hostname}" \
    --api-token="${api_token}" \
    --name=custom-start-points \
    --repo-root="$(repo_root)"
}

# - - - - - - - - - - - - - - - - - - -
kosli_attest_snyk()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli attest snyk "$(artifact_name)" \
    --artifact-type=docker \
    --host="${hostname}" \
    --api-token="${api_token}" \
    --attachments="$(repo_root)/.snyk" \
    --name=custom-start-points.snyk-scan \
    --scan-results="$(repo_root)/snyk.json"
}

# - - - - - - - - - - - - - - - - - - -
kosli_assert_artifact()
{
  local -r hostname="${1}"
  local -r api_token="${2}"

  kosli assert artifact "$(artifact_name)" \
    --artifact-type=docker \
    --host="${hostname}" \
    --api-token="${api_token}"
}

# - - - - - - - - - - - - - - - - - - -
artifact_name()
{
  source "$(repo_root)/sh/echo_versioner_env_vars.sh"
  export $(echo_versioner_env_vars)
  echo "${CYBER_DOJO_CUSTOM_START_POINTS_IMAGE}:${CYBER_DOJO_CUSTOM_START_POINTS_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
repo_root()
{
  git rev-parse --show-toplevel
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CI:-}" ]
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_begin_trail()
{
  if on_ci ; then
    kosli_begin_trail "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_begin_trail "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_attest_artifact_creation()
{
  if on_ci ; then
    kosli_attest_artifact "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_attest_artifact "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_attest_snyk_scan_evidence()
{
  if on_ci; then
    set +e
    snyk container test "$(artifact_name)" \
      --file=Dockerfile \
      --sarif \
      --sarif-file-output=snyk.json \
      --policy-path="$(repo_root)/.snyk"
    set -e

    kosli_attest_snyk "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_attest_snyk "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}

# - - - - - - - - - - - - - - - - - - -
on_ci_kosli_assert_artifact()
{
  if on_ci ; then
    kosli_assert_artifact "${KOSLI_HOST_STAGING}"    "${KOSLI_API_TOKEN_STAGING}"
    kosli_assert_artifact "${KOSLI_HOST_PRODUCTION}" "${KOSLI_API_TOKEN}"
  fi
}


