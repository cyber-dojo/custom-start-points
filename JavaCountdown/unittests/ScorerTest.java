import org.junit.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.*;

public class ScorerTest {

    Scorer scorer = new Scorer();
    List<String> threeLineProgram = Arrays.asList("class A {", "  int x = 0", "}");
    List<String> programWithMain = Arrays.asList("class A {", "  public static void(String[] args) {", "  ", "}");
    List<String> programWithAllTokens = Arrays.asList("class A {", "  protected void m1() {", "  ", "  }", "}");

    @Test
    public void lineSize() {
        assertThat(scorer.lineSize(""), is(0));
        assertThat(new Scorer().lineSize("   "), is(0));
        assertThat(new Scorer().lineSize(" public void"), is(10));
        assertThat(new Scorer().lineSize(" public void m1() { "), is(15));
    }

    @Test
    public void isSpace() {
        assertTrue(scorer.isSpace(' '));
        assertFalse(scorer.isSpace('g'));
        assertFalse(scorer.isSpace('.'));
    }

    @Test
    public void linesSize() {
        assertThat(scorer.linesSize(threeLineProgram), is(14));
        assertThat(scorer.linesSize(Collections.<String>emptyList()), is(0));
    }

    @Test
    public void hr() {
        assertThat(scorer.hr(0), is("------|"));
        assertThat(scorer.hr(5), is("------|-----"));
    }

    @Test
    public void printProgramSize() {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        scorer.printProgramSize(programWithMain, new PrintStream(outputStream));
        assertEquals("------|------------------------------------------------------------\n" +
                     "   7  |class A {\n" +
                     "  31  |  public static void(String[] args) {\n" +
                     "   0  |  \n" +
                     "   1  |}\n" +
                     "------|------------------------------------------------------------\n" +
                     "   39 == CountDown.java.size\n", outputStream.toString());
    }

    @Test
    public void tokensSize() {
        assertThat(scorer.tokensSize(programWithMain), is(10));
    }

    @Test
    public void missingTokens() {
        assertTrue(scorer.missingTokens(programWithMain));
        assertFalse(scorer.missingTokens(programWithAllTokens));
    }

    @Test
    public void printsTokenBonuses() {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        scorer.printTokenBonuses(programWithMain, new PrintStream(outputStream));
        assertEquals("------|--------------------\n" +
                     "   5  |class\n" +
                     "   4  |void\n" +
                     "   1  |(\n" +
                     "   0  |protected\n" +
                     "------|--------------------\n" +
                     "  10 == used_tokens.size\n" +
                     "   0 == completion.bonus\n", outputStream.toString());
    }

    @Test
    public void scoresShortProgram() {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        scorer.score(threeLineProgram, new PrintStream(outputStream));
        assertEquals(   ">>> Score = -CountDown.java.size + 5*usedTokens.size + completion.bonus\n" +
                        ">>>       = -14 + 5*5 + 0\n" +
                        ">>>       = 11\n" +
                        "\n" +
                        "------|--------------------\n" +
                        "   5  |class\n" +
                        "   0  |void\n" +
                        "   0  |(\n" +
                        "   0  |protected\n" +
                        "------|--------------------\n" +
                        "   5 == used_tokens.size\n" +
                        "   0 == completion.bonus\n" +
                        "\n" +
                        "------|------------------------------------------------------------\n" +
                        "   7  |class A {\n" +
                        "   6  |  int x = 0\n" +
                        "   1  |}\n" +
                        "------|------------------------------------------------------------\n" +
                "   14 == CountDown.java.size\n",
                outputStream.toString());
    }

    @Test
    public void scoresMainProgram() {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        scorer.score(programWithMain, new PrintStream(outputStream));
        assertEquals(   ">>> Score = -CountDown.java.size + 5*usedTokens.size + completion.bonus\n" +
                        ">>>       = -39 + 5*10 + 0\n" +
                        ">>>       = 11\n" +
                        "\n" +
                        "------|--------------------\n" +
                        "   5  |class\n" +
                        "   4  |void\n" +
                        "   1  |(\n" +
                        "   0  |protected\n" +
                        "------|--------------------\n" +
                        "  10 == used_tokens.size\n" +
                        "   0 == completion.bonus\n" +
                        "\n" +
                        "------|------------------------------------------------------------\n" +
                        "   7  |class A {\n" +
                        "  31  |  public static void(String[] args) {\n" +
                        "   0  |  \n" +
                        "   1  |}\n" +
                        "------|------------------------------------------------------------\n" +
                        "   39 == CountDown.java.size\n",
                outputStream.toString());
    }

    @Test
    public void scoreProgramIncludingAllTokens() {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        scorer.score(programWithAllTokens, new PrintStream(outputStream));
        assertEquals(   ">>> Score = -CountDown.java.size + 5*usedTokens.size + completion.bonus\n" +
                        ">>>       = -27 + 5*19 + 100\n" +
                        ">>>       = 168\n" +
                        "\n" +
                        "------|--------------------\n" +
                        "   5  |class\n" +
                        "   4  |void\n" +
                        "   1  |(\n" +
                        "   9  |protected\n" +
                        "------|--------------------\n" +
                        "  19 == used_tokens.size\n" +
                        " 100 == completion.bonus\n" +
                        "\n" +
                        "------|------------------------------------------------------------\n" +
                        "   7  |class A {\n" +
                        "  18  |  protected void m1() {\n" +
                        "   0  |  \n" +
                        "   1  |  }\n" +
                        "   1  |}\n" +
                        "------|------------------------------------------------------------\n" +
                        "   27 == CountDown.java.size\n",
                outputStream.toString());
    }
}
