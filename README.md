
[![CircleCI](https://circleci.com/gh/cyber-dojo/custom.svg?style=svg)](https://circleci.com/gh/cyber-dojo/custom-start-points)

- The source for the [cyberdojo/custom](https://hub.docker.com/r/cyberdojo/custom/tags) Docker image.
- A docker-containerized stateless micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- Serves the choices when setting up a custom practice session.

```bash
#!/bin/bash
set -e

SCRIPT=cyber-dojo
GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
curl -O --silent --fail "${GITHUB_ORG}/commander/master/${SCRIPT}"
chmod 700 ./${SCRIPT}

IMAGE_NAME=cyberdojo/custom
GIT_REPO_URL=https://github.com/cyber-dojo/custom-start-points.git

./${SCRIPT} start-point create \
    "${IMAGE_NAME}" \
      --custom \
        "${GIT_REPO_URL}"
```

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
