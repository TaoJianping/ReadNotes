# Bottom-Up Parsing

- Overview of Bottom-Up Parsing
- Finite Automata of LR(0) Items and LR(0) Parsing
- SLR(1) Parsing
- General LR(1) and LALR(1) Parsing
- Yacc: An LALR(1) Parser Generator
- Generation of a TINY Parser Using Yacc
- Error Recovery in Bottom-Up Parsers



## 5.1 Overview of Bottom-Up Parsing

A bottom-up parser uses an explicit stack to perform a parse.

A Parsing actions of a bottom-up parser for the grammar of:
$$
S' \rightarrow S \\
S \rightarrow (S) \ S \  | \ \varepsilon
$$

| line | Parsing stack | Input | Action                             |
| ---- | ------------- | ----- | ---------------------------------- |
| 1    | $             | ( ) $ | shift                              |
| 2    | $ (           | ) $   | reduce $S \rightarrow \varepsilon$ |
| 3    | $ ( S         | ) $   | shift                              |
| 4    | $ ( S )       | $     | reduce $S \rightarrow \varepsilon$ |
| 5    | $ ( S ) S     | $     | reduce $S \rightarrow (\ S\ )\ S$  |
| 6    | $ S           | $     | reduce $S \rightarrow S'$          |
| 7    | $ S'          | $     | accept                             |

where the parsing stack is on the left, the input is in the center, and the actions of the parser are on the right.

A bottom-up parser has two possible actions:

- **Accept**: finish.
- **Shift**: a terminal from the front of the input to the top of the stack.
- **Reduce**: a string $\alpha$ at the top of the stack to a nonterminal A, given the BNF choice $A \rightarrow \alpha$.

A bottom-up parser is thus sometimes called a ***shift-reduce parser***.

A bottom-up parser may need to look deeper into the stack than just the top in order to determine what actions to perform. Thus, bottom-up parsing requires **arbitrary "stack lookahead"**.

A shift-reduce parser traces out a rightmost derivation of the input string, but the steps of the derivation occur in reverse order. 
$$
S' \Rightarrow S \Rightarrow (\ S\ )\ S\Rightarrow (\ S\ ) \Rightarrow ()
$$
Each of the intermediate strings of terminals and nonterminals in such a derivation is called a **right sentential from**.

The sequence of symbols on the parsing stack is called a **viable prefix** of the right sentential form. Thus, E, E +, and E + n are all viable prefixes of the right sentential form E + n.

The string, together with the position in the right sentential form where it occurs, and the production used to reduce it, is called the **handle** of the right sentential form.

Determining the next handle in a parse is the main task of a shif-reduce parser.