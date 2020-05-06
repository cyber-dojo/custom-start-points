#! /bin/bash
set -e

cd ${CYBER_DOJO_SANDBOX}

CLASSES=.:`ls /junit/*.jar | tr '\n' ':'`

if javac --enable-preview --release 14 -Xlint:preview -Xlint:unchecked -Xlint:deprecation -cp $CLASSES *.java; then
  java --enable-preview -jar /junit/junit-platform-console-standalone-1.6.2.jar \
      --disable-banner \
      --disable-ansi-colors \
      --details=tree \
      --details-theme=ascii \
      --class-path . \
      --scan-class-path
fi
