
# How to contribute a new custom exercise

The simplest way is to:
- Create your new start-point in a cyber-dojo session at [https://cyber-dojo-org](https://cyber-dojo-org)
- Clone this repo.
- Add the files from your cyber-dojo session to the repo, following the existing format.
  You will need to know the [manifest.json format](https://blog.cyber-dojo.org/2016/08/cyber-dojo-start-points-manifestjson.html).
- You will need to know the `"image_name"` entry for your `manifest.json` file.
  To find this, in your cyber-dojo session, add the command `env | grep CYBER_DOJO_IMAGE_NAME` to the top of your
  `cyber-dojo.sh` file, press the `[test]` button, read the output in the 'output' tab (top right).
- Run `./build_test_publish.sh` to check your additions
- Issue a pull request.
- :+1::tada: Thank you. :+1::tada:
