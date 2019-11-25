#include <algorithm>
#include <cctype>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <vector>

using namespace std;

#include "tokens.cpp"

static void print_compiler_version()
{
    cout << ">>> Compiler is G++ " << __VERSION__ << '\n';
    cout << ">>> Standard C++ " << __cplusplus << '\n';
    cout << ">>>\n";
}

static int line_size(const string & line)
{
    int size = 0;
    for (auto & ch : line)
        if (!isspace(ch))
            size++;
    return size;
}

static int lines_size(const vector<string> & lines)
{
    int size = 0;
    for (auto & line : lines)
        size += line_size(line);
    return size;
}

static void print_program_size(const vector<string> & lines)
{
    const int width = 60;
    cout << endl;
    cout << "-----|" << string(width,'-') << endl;
    int total_size = 0;
    for (auto & line : lines)
    {
        const int size = line_size(line);
        cout << setw(3) << setfill(' ') << size << "  |" << line << endl;
        total_size += size;
    }
    cout << "-----|" << string(width, '-') << endl;
    cout << setw(3) << setfill(' ') << total_size
         << " == countdown.cpp.size" << endl;
    cout << endl;
}

// - - - - - - - - - - - - - - - - - - - -

static vector<string> read_lines(const char * filename)
{
    vector<string> lines;
    ifstream is(filename);
    string line;
    while (getline(is, line))
        lines.push_back(line);
    return lines;
}

// - - - - - - - - - - - - - - - - - - - -

static bool uses(const vector<string> & lines, const string & token)
{
    // ... also matches .
    // double also matches do
    // etc etc

    for (auto & line : lines)
        if (line.find(token) != string::npos)
            return true;
    return false;
}

static int tokens_size(const vector<string> & lines)
{
    int size = 0;
    for (auto & token : tokens)
        if (uses(lines, token))
            size += token.size();

    return size;
}

static bool missing_tokens(const vector<string> & lines)
{
    vector<string> unused;
    for (auto & token : tokens)
        if (!uses(lines, token))
            return true;

    return false;
}

// - - - - - - - - - - - - - - - - - - - -

static void print_token_bonuses(const vector<string> & lines)
{
    const int width = 20;
    int tokens_size = 0;
    cout << "-----|" << string(width,'-') << endl;
    for (auto & token : tokens)
        if (uses(lines, token))
        {
            cout << setw(3) << setfill(' ')  << token.size() << "  |" << token << endl;
            tokens_size += token.size();
        }

    for (auto & token : tokens)
        if (!uses(lines, token))
            cout << setw(3) << setfill(' ') << 0 << "  |" << token << endl;

    cout << "-----|" << string(width,'-') << endl;
    cout << setw(3) << setfill(' ') << tokens_size << " == used_tokens.size" << endl;
    int completion_bonus = missing_tokens(lines) ? 0 : 50;
    cout << setw(3) << setfill(' ') << completion_bonus << " == completion.bonus" << endl;
}

// - - - - - - - - - - - - - - - - - - - -

int main(int, const char * argv[])
{
    print_compiler_version();
    vector<string> lines = read_lines(argv[1]);
    int program_size = lines_size(lines);
    int used_token_bonus = tokens_size(lines);
    int completion_bonus = missing_tokens(lines) ? 0 : 50;

    cout << ">>> Score = -countdown.cpp.size + 3*used_tokens.size + completion.bonus" << endl
         << ">>>       = " << setw(3) << setfill(' ') << -program_size << " + "
                              << "3*" << used_token_bonus << " + "
                              << completion_bonus << endl
         << ">>>       = " << (-program_size + (3*used_token_bonus) + completion_bonus) << endl;

    cout << endl;
    print_token_bonuses(lines);
    cout << endl;
    print_program_size(lines);

    // green-traffic light pattern...put it out of sight
    for(int i = 0; i < 100; i++)
        cout << endl;
    cout << "All tests passed\n";
}
