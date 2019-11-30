
[![CircleCI](https://circleci.com/gh/cyber-dojo/custom.svg?style=svg)](https://circleci.com/gh/cyber-dojo/custom-start-points)

Specifies the start-points used to create the custom start-points image
* [cyberdojo/custom-start-points](https://hub.docker.com/r/cyberdojo/custom-start-points)

```bash
#!/bin/bash
set -e
# The script to run
GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
REPO=commander
BRANCH=master
SCRIPT=cyber-dojo
curl -O --silent --fail "${GITHUB_ORG}/${REPO}/${BRANCH}/${SCRIPT}"
chmod 700 ./${SCRIPT}
# The name of the image to create...
IMAGE_NAME=cyberdojo/custom-start-points:latest
# From this repo's url
GIT_REPO_URL=https://github.com/cyber-dojo/custom-start-points.git
# Exposed on this port
CYBER_DOJO_CUSTOM_PORT=4536 \
./${SCRIPT} start-point create \
    "${IMAGE_NAME}" \
      --custom \
        "${GIT_REPO_URL}"
```

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
