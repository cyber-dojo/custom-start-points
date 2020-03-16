g++ -std=c++2a -c countdown.cpp
if [ $? != 0 ]; then
  echo
  echo ">>> Score = 0"
  echo ">>> [countdown.cpp does not compile]"
  echo
  exit
fi

g++ -std=c++2a scorer.cpp -o scorer
./scorer countdown.cpp
