rm -f *.class
javac CountDown.java
if [ $? != 0 ]; then 
  echo 
  echo ">>> Score = 0"
  echo ">>> [CountDown.java does not compile]"
  echo
  exit
fi

javac Tokens.java Scorer.java
java -cp . Scorer CountDown.java