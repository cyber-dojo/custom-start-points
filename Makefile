
SHORT_SHA := $(shell git rev-parse HEAD | head -c7)
IMAGE_NAME := cyberdojo/custom-start-points:${SHORT_SHA}

.PHONY: image snyk-container snyk-code

image:
	${PWD}/sh/build_test_tag.sh

snyk-container: image
	snyk container test ${IMAGE_NAME} \
        --policy-path=.snyk \
		--sarif \
		--sarif-file-output=snyk.container.scan.json

snyk-code:
	snyk code test \
        --policy-path=.snyk \
		--sarif \
		--sarif-file-output=snyk.code.scan.json

