
# curled by https://github.com/dpolivaev/cyber-dojo-k8s-install/blob/master/install.sh

helm_upgrade()
{
  local -r namespace="${1}"
  local -r image="${2}"
  local -r tag="${3}"
  local -r port="${4}"
  local -r values="${5}"
  local -r repo="${6}"
  local -r helm_repo="${7}"

  helm upgrade \
    --install \
    --namespace=${namespace} \
    --set-string containers[0].image=${image} \
    --set-string containers[0].tag=${tag} \
    --set service.port=${port} \
    --set containers[0].livenessProbe.port=${port} \
    --set containers[0].readinessProbe.port=${port} \
    --set-string service.annotations."prometheus\.io/port"=${port} \
    --values ${values} \
    ${namespace}-${repo} \
    ${helm_repo}
}
