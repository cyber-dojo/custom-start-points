[![Github Action (main)](https://github.com/cyber-dojo/custom-start-points/actions/workflows/main.yml/badge.svg)](https://github.com/cyber-dojo/custom-start-points/actions)

- A [docker-containerized](https://registry.hub.docker.com/r/cyberdojo/custom-start-points) micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).
- The data source for the `choose a custom problem` page.
- Demonstrates a [Kosli](https://www.kosli.com/) instrumented [GitHub CI workflow](https://app.kosli.com/cyber-dojo/flows/custom-start-points-ci/trails/) 
  deploying, with Continuous Compliance, to its [staging](https://app.kosli.com/cyber-dojo/environments/aws-beta/snapshots/) AWS environment.
- Deployment to its [production](https://app.kosli.com/cyber-dojo/environments/aws-prod/snapshots/) AWS environment is via a separate [promotion workflow](https://github.com/cyber-dojo/aws-prod-co-promotion).
- Uses attestation patterns from https://www.kosli.com/blog/using-kosli-attest-in-github-action-workflows-some-tips/
- How to [contribute a new custom problem](CONTRIBUTING.md).

<img width="75%" src="https://user-images.githubusercontent.com/252118/97069640-7a560680-15c9-11eb-8bd6-8309c87df764.png">
