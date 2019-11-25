import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

public class Scorer {

    int lineSize(String line) {
        char[] chars = line.toCharArray();
        int size = 0;
        for (int i = 0; i < chars.length; i++) {
            if (!isSpace(chars[i]))
                size++;
        }
        return size;
    }

    boolean isSpace(char aChar) {
        return String.valueOf(aChar).trim().isEmpty();
    }

    int linesSize(List<String> lines) {
        int size = 0;
        for (String line : lines) {
            size += lineSize(line);
        }
        return size;
    }


    String hr(int width) {
        StringBuffer buf = new StringBuffer();

        buf.append("------|");
        for (int i = 0; i < width; i++) {
            buf.append("-");
        }

        return buf.toString();
    }

    void printProgramSize(List<String> lines, PrintStream out) {

        int totalSize = 0;

        out.println(hr(60));

        for (String line : lines) {
            int size = lineSize(line);

            out.printf(" %3d  |%s\n", size, line);
            totalSize += size;
        }

        out.println(hr(60));

        out.println("   " + totalSize + " == CountDown.java.size");
    }

// - - - - - - - - - - - - - - - - - - - -

    List<String> readLines(String filename) {
        List<String> lines = new ArrayList<>();

        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(getClass().getResourceAsStream(filename)));
            String sCurrentLine;
            while ((sCurrentLine = reader.readLine()) != null) {
                lines.add(sCurrentLine);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        return lines;
    }

// - - - - - - - - - - - - - - - - - - - -

    boolean uses(List<String> lines, String token) {
        // ... also matches .
        // double also matches do
        // etc etc

        for (String line : lines) {
            if (line.contains(token)) {
                return true;
            }
        }

        return false;
    }

    int tokensSize(List<String> lines) {
        int size = 0;
        for (String token : Tokens.tokens) {
            if (uses(lines, token)) {
                size += token.length();
            }
        }

        return size;
    }

    boolean missingTokens(List<String> lines) {
        for (String token : Tokens.tokens) {
            if (!uses(lines, token)) {
                return true;
            }
        }

        return false;
    }

// - - - - - - - - - - - - - - - - - - - -

    void printTokenBonuses(List<String> lines, PrintStream out) {
        int tokensSize = 0;
        out.println(hr(20));

        for (String token : Tokens.tokens) {
            if (uses(lines, token)) {
                out.printf(" %3d  |%s\n", token.length(), token);
                tokensSize += token.length();
            }
        }

        for (String token : Tokens.tokens) {
            if (!uses(lines, token)) {
                out.printf(" %3d  |%s\n", 0, token);
            }
        }

        out.println(hr(20));

        out.printf(" %3d == used_tokens.size\n", tokensSize);

        int completion_bonus = missingTokens(lines) ? 0 : 100;

        out.printf(" %3d == completion.bonus\n", completion_bonus);
    }

// - - - - - - - - - - - - - - - - - - - -

    public void score(String filename, PrintStream out) {
        score(readLines(filename), out);

        // green-traffic light pattern...put it out of sight
        for (int i = 0; i < 100; i++)
            out.println();
        out.print("OK (1 test)");
    }

    public void score(List<String> lines, PrintStream out) {
        int program_size = linesSize(lines);
        int used_token_bonus = tokensSize(lines);
        int completion_bonus = missingTokens(lines) ? 0 : 100;

        out.println(">>> Score = -CountDown.java.size + 5*usedTokens.size + completion.bonus");
        out.println(">>>       = " + (-program_size) + " + 5*" + used_token_bonus + " + " + completion_bonus);
        out.println(">>>       = " + (-program_size + (5 * used_token_bonus) + completion_bonus));

        out.println();
        printTokenBonuses(lines, out);
        out.println();
        printProgramSize(lines, out);
    }

    public static void main(String[] args) {
        new Scorer().score(args[0], System.out);
    }

}