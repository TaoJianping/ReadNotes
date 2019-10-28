## 4.3 FIRST AND FOLLOW SETS

### 4.3.1 First Sets

Let X be a grammar symbol (a terminal or nonterminal) or $\varepsilon$. Then the set **First(X)** consisting of terminals, and possibly $\varepsilon$, is defined as follows.

1. If X is a terminal or $\varepsilon$ , then $First(X) = \{X\}$.
2. If X is a nonterminal, then for each production choice $X \rightarrow X_1X_2X_3...X_n$, First(X) contains $First(X_1) - \varepsilon$. If also for some $i < n$, all the sets $First(X_1),...,First(X_i)$ contain $\varepsilon$, then $First(X)$ contains $First(X_{i+1}) - \{\varepsilon\}$. If all the sets $First(X_1),...,First(X_n)$ contain $\varepsilon$, then $First(X)$ also  contains $\varepsilon$.

针对上面的两个定义，扩展一下。

我们用$First(X)$来表示X的一个First set. $X \in \{terminal, nonterminal, \varepsilon\}$:

1. 当$X \in \{terminal, \varepsilon\}$ 的时候，$First(X) = \{X\}$.
2. 当$ X \in \{nonterminal\}$的时候，对于X的每一个production choice $X \rightarrow X_1X_2X_3...X_n$ 我们要分几种production的情况来讨论
   1.  最普通的情况下，$First(X) \ \bigcup=\ First(X_1) - {\varepsilon}$，即$First(X)$的First set 就是他第一个production choice 的First set集合，并去掉$\varepsilon$
   2.  If also for some $i < n​$, all the sets $First(X_1),...,First(X_i)​$ contain $\varepsilon​$, then $First(X)​$ contains $First(X_{i+1}) - \{\varepsilon\}​$. 这个中文比较难描述，我觉得这个英文描述最准确。比如前面的$First(X_1)​$如果包含了$\varepsilon​$, 就要顺延到下个production choice，直到不包含$\varepsilon​$.
   3.  如果所有的production choice 都包含了$\varepsilon$, 那么也就是说这个$First(X)$ 本生包含了空串。

这里给伪代码描述：

```c
// Algorithm for computing First(A) for all nonterminals A
for all nonterminals A do First(A) := {};
while there are changes to any First(A) do
    for each production choice A -> X1X2...Xn do
        k := 1;
		Continue := true;
		while Continue = true and k <= n do
            add First(Xk) - {varepsilon} to First(A);
			if varepsilon not in First(Xk) then Continue := false;
			k := k + 1;
		if Continue = true then add varepsilon to First A;

// Simplified algorithm of Figure 4.6 in the absence of varepsilon-production
for all nonterminals A do First(A) := {};
while there are changes to any First(A) do
    for each production choice A -> X1X2...Xn do 
        add First(X1) to First(A);
```



***nullable***

> A nonterminal A is nullable if there exists a derivation A =>* varepsilon



### 4.3.2 Follow Sets

Given a nonterminal A, the set **Follow(A)**, consisting of terminals, and possibly $, is defined as follows.

1. If A is the start symbol, then $ is in Follow(A).
2. If there is a production $B \rightarrow \alpha A \gamma$, then $First(\gamma) - \{\varepsilon\}$ is in Follow(A).
3. If there is a production $B \rightarrow \alpha A \gamma$ such that $\varepsilon$ is in $First(\gamma)$, then Follow(A) contains Follow(B).

#### Notice

- $ is used to mark the end of the input, which is a symbol to follow the entire string to be matched.
- The second thing to notice is that the empty "pseudotoken" $\varepsilon$ is never an element of a Follow set.
- Follow sets are defined only for nonterminals.
- The definition of Follow sets works "on the right" in productions, while the definiton of the First sets works "on the left".
- A grammar rule $A \rightarrow \alpha\ B$, Follow(B) will include Follow(A) by case(3) of definition.

```c
Follow(start-symbol) := {$};
for all nonterminals A != start-symbol do Follow(A) := {};
while there are changes to any follow sets do
    for each production A -> X1X2...Xn do
        for each Xi that is a nonterminal do
            add First(Xi+1Xi+2...Xn) - {varepsilon} to Follow(Xi)
            If varepsilon in First(Xi+1Xi+2...Xn) then
            	add Follow(A) to Follow(Xi)
```



### 4.3.3 Constructing LL(1) Parsing Tables

#### Rule

Repeat the following two steps for each nonterminal A and production choice $A \rightarrow \alpha$

1. For each token a in $First(\alpha)$, add $A \rightarrow \alpha$ to the entry M[A, a]
2. If $\varepsilon$ is in $First(\alpha)$ , for each element a of Follow(A) (a token or \$), add $A \rightarrow \alpha$ to M[A, a].

 