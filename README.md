
[![CircleCI](https://circleci.com/gh/cyber-dojo/custom-start-points.svg?style=svg)](https://circleci.com/gh/cyber-dojo/custom-start-points)

- A docker-containerized micro-service for [https://cyber-dojo.org](http://cyber-dojo.org).

- The data source for the [https://cyber-dojo.org/creator/choose_custom_problem?type=group](https://cyber-dojo.org/creator/choose_custom_problem?type=group) page.

<img width="75%" src="https://user-images.githubusercontent.com/252118/97069640-7a560680-15c9-11eb-8bd6-8309c87df764.png">

- To contribute a new custom problem
  - Create your new start-point in [https://cyber-dojo-org](https://cyber-dojo-org)
  - Clone this repo.
  - Add the files from your cyber-dojo session. You will need to know the `"image_name"` entry for your
    `manifest.json` file. To find this, add the command `env|grep CYBER_DOJO_IMAGE_NAME` to the top of your
    `cyber-dojo.sh` file, press `[test]`, read it from the output.
  - Run `./build_test_publish.sh`
  - Issue a pull request.
  - Thanks.
