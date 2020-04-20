cd ${CYBER_DOJO_SANDBOX}

javac --enable-preview --release 14 CountDown.java 2>&1
if [ $? != 0 ]; then
  echo
  echo ">>> Score = 0"
  echo ">>> [CountDown.java does not compile]"
  echo
  exit
fi

javac --enable-preview --release 14 Tokens.java Scorer.java
java --enable-preview --class-path . Scorer CountDown.java
