# 2.3 REGULAR EXPRESSIONS

The **set of words** accepted by a finite automaton, **F**, forms a **language**, denoted **L(F)**. 
$$
F \rightarrow Words
$$

$$
L(F)\rightarrow Language
$$

For any **FA**, we can also describe its language using a notation called a **regular expression (RE)**. The language described by an **RE** is called a **regular language**.



## 2.3.1 Formalizing the Notation

### Alternation

The alternation, or union, of two sets of strings, R and S, denoted **R | S**, is {x | x ∈ R or x ∈ S}.

### Concatenation

The concatenation of two sets R and S, denoted **RS**, contains all strings formed by prepending an element of R onto one from S, or {xy | x ∈ R and y ∈ S}.

### Closure

- **Kleene closure**

  The Kleene closure of a set R. This is just the union of the concatenations of R with itself, zero or more times.

- **Finite closure**

  For any integer i, the RE Ri designates one to i occurrences of R.

- **Positive closure**

  The RE $R^+$ denotes one or more occurrences of R.

> As a convenient shorthand, we will specify ranges of characters with the first and the last element connected by an ellipsis, “. . . ”. To make this abbreviation stand out, we surround it with a pair of square brackets. Thus, [0. . . 9] represents the set of decimal digits. It can always be rewritten as
> (0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9).

### Precedence

To eliminate any ambiguity, parentheses have highest precedence, followed by closure, concatenation, and alternation, in that order.

- parentheses
- closure
- concatenation
- alternation