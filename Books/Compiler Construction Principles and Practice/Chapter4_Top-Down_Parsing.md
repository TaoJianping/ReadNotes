## 4.3 FIRST AND FOLLOW SETS

Let X be a grammar symbol (a terminal or nonterminal) or $\varepsilon$. Then the set **First(X)** consisting of terminals, and possibly $\varepsilon$, is defined as follows.

1. If X is a terminal or $\varepsilon$ , then $First(X) = \{X\}$.
2. If X is a nonterminal, then for each production choice $X \rightarrow X_1X_2X_3...X_n$, First(X) contains $First(X_1) - \varepsilon$. If also for some $i < n$, all the sets $First(X_1),...,First(X_i)$ contain $\varepsilon$, then $First(X)$ contains $First(X_{i+1}) - \{\varepsilon\}$. If all the sets $First(X_1),...,First(X_n)$ contain $\varepsilon$, then $First(X)$ also  contains $\varepsilon$.

针对上面的两个定义，扩展一下。

我们用$First(X)$来表示X的一个First set. $X \in \{terminal, nonterminal, \varepsilon\}$:

1. 当$X \in \{terminal, \varepsilon\}$ 的时候，$First(X) = \{X\}$.
2. 当$ X \in \{nonterminal\}$的时候，对于X的每一个production choice $X \rightarrow X_1X_2X_3...X_n$ 我们要分几种production的情况来讨论
   1.  最普通的情况下，$First(X) \ \bigcup=\ First(X_1) - {\varepsilon}$，即$First(X)$的First set 就是他第一个production choice 的First set集合，并去掉$\varepsilon$
   2. If also for some $i < n​$, all the sets $First(X_1),...,First(X_i)​$ contain $\varepsilon​$, then $First(X)​$ contains $First(X_{i+1}) - \{\varepsilon\}​$. 这个中文比较难描述，我觉得这个英文描述最准确。比如前面的$First(X_1)​$如果包含了$\varepsilon​$, 就要顺延到下个production choice，直到不包含$\varepsilon​$.
   3. 如果所有的production choice 都包含了$\varepsilon$, 那么也就是说这个$First(X)$ 本生包含了空串。