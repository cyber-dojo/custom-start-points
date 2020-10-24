
[![CircleCI](https://circleci.com/gh/cyber-dojo/custom-start-points.svg?style=svg)](https://circleci.com/gh/cyber-dojo/custom-start-points)

- The source for the [https://cyber-dojo.org/creator/choose_custom_problem?type=group](https://cyber-dojo.org/creator/choose_custom_problem?type=group) page.

![cyber-dojo.org custom-start-points page](https://github.com/cyber-dojo/custom-start-points/blob/master/docs/screen_shot.png)

- To contribute a new custom problem
  - Create your new start-point in a cyber-dojo.
  - Clone this repo.
  - Add the files from your session. You will need to know the `"image_name"` entry for your `manifest.json` file.
    To find this, add the command `env|grep CYBER_DOJO_IMAGE_NAME` to the top of your `cyber-dojo.sh` file and press `[test]`.
  - Run `./build_test_publish.sh`
  - Issue a pull request.
  - Thanks.
