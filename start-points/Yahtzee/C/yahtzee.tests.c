#include "yahtzee.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

static void Chance_scores_sum_of_all_dice(void)
{
    int expected = 15;
    int actual = Chance(2,3,4,5,1);
    assert(expected == actual);
    assert(16 == Chance(3,3,4,5,1));
}

static int * ints(int a, int b, int c, int d, int e)
{
    int * r = (int*)malloc(5 * sizeof(int));
    r[0] = a;
    r[1] = b;
    r[2] = c;
    r[3] = d;
    r[4] = e;
    return r;
}

static void Yahtzee_scores_50(void)
{
    int expected = 50;
    int actual = yahtzee(ints(4,4,4,4,4));
    assert(expected == actual);
    assert(50 == yahtzee(ints(6,6,6,6,6)));
    assert(0 == yahtzee(ints(6,6,6,6,3)));
}

static void Test_1s(void)
{
    assert(Ones(1,2,3,4,5) == 1);
    assert(2 == Ones(1,2,1,4,5));
    assert(0 == Ones(6,2,2,4,5));
    assert(4 == Ones(1,2,1,1,1));
}

static void test_2s()
{
    assert(4 == Twos(1,2,3,2,6));
    assert(10 == Twos(2,2,2,2,2));
}

static void test_threes()
{
    assert(6 == Threes(1,2,3,2,3));
    assert(12 == Threes(2,3,3,3,3));
}

static void one_pair()
{
    assert(6 == ScorePair(3,4,3,5,6));
    assert(10 == ScorePair(5,3,3,3,5));
    assert(12 == ScorePair(5,3,6,6,5));
}

static void fours_test()
{
    assert(12 == (Fours(ints(4,4,4,5,5))));
    assert(8 == (Fours(ints(4,4,5,5,5))));
    assert(4 == (Fours(ints(4,5,5,5,5))));
}

static void fives() {
    assert(10 == (Fives(4,4,4,5,5)));
    assert(15 == Fives(4,4,5,5,5));
    assert(20 == Fives(4,5,5,5,5));
}

static void sixes_test()
{
    assert(0 == sixes(4,4,4,5,5));
    assert(6 == sixes(4,4,6,5,5));
    assert(18 == sixes(6,5,6,6,5));
}

static void two_Pair()
{
    assert(16 == TwoPair(3,3,5,4,5));
    assert(0 == TwoPair(3,3,5,5,5));
}

static void four_of_a_knd()
{
    assert(12 == FourOfAKind(3,3,3,3,5));
    assert(20 == FourOfAKind(5,5,5,4,5));
    assert(0  == FourOfAKind(3,3,3,3,3));
}

static void three_of_a_kind()
{
    assert(9 == ThreeOfAKind(3,3,3,4,5));
    assert(15 == ThreeOfAKind(5,3,5,4,5));
    assert(0 == ThreeOfAKind(3,3,3,3,5));
}

static void smallStraight()
{
    assert(15 == SmallStraight(1,2,3,4,5));
    assert(15 == SmallStraight(2,3,4,5,1));
    assert(0 == SmallStraight(1,2,2,4,5));
}

static void largeStraight()
{
    assert(20 == LargeStraight(6,2,3,4,5));
    assert(20 == LargeStraight(2,3,4,5,6));
    assert(0== LargeStraight(1,2,2,4,5));
}




static void fullHouse()
{
    assert(18 == FullHouse(6,2,2,2,6));
    assert(0 == FullHouse(2,3,4,5,6));
}

int main(void)
{
    Chance_scores_sum_of_all_dice();
    Yahtzee_scores_50();
    Test_1s();
    test_2s();
    test_threes();
    fours_test();
    fives();
    sixes_test();
    one_pair();
    two_Pair();
    three_of_a_kind();
    four_of_a_knd();
    smallStraight();
    largeStraight();
    fullHouse();

    // green-traffic light pattern...
    puts("All tests passed");
}
