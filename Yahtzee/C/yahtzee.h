#ifndef YAHZTEE_INCLUDED
#define YAHTZEE_INCLUDED

#include <stdbool.h>

int Chance(int d1, int d2, int d3, int d4, int d5);
int yahtzee(int dice[]);
int Ones(int d1, int d2, int d3, int d4, int d5);
int Twos(int d1, int d2, int d3, int d4, int d5);
int Threes(int d1, int d2, int d3, int d4, int d5);
int Fours(int * dice);
int Fives(int d1, int d2, int d3, int d4, int d5);
int sixes(int d1, int d2, int d3, int d4, int d5);
int ScorePair(int d1, int d2, int d3, int d4, int d5);
int TwoPair(int d1, int d2, int d3, int d4, int d5);
int FourOfAKind(int _1, int _2, int d3, int d4, int d5);
int ThreeOfAKind(int d1, int d2, int d3, int d4, int d5);
int SmallStraight(int d1, int d2, int d3, int d4, int d5);

int LargeStraight(int d1, int d2, int d3, int d4, int d5);
    int FullHouse(int d1, int d2, int d3, int d4, int d5);

#endif
