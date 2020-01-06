# decltype

#### Syntax

```c++
decltype ( entity )				// (since C++11)
decltype ( expression )			// (since C++11)
```

他是个关键字，用来查询表达式的类型。



#### Rule

- If the argument is an unparenthesized id-expression naming a structured binding, then decltype yields the referenced type (described in the specification of the structured binding declaration).(since C++17)

  > 啥玩意？

- If the argument is an unparenthesized id-expression naming a non-type template parameter, then decltype yields the type of the template parameter (after performing any necessary type deduction if the template parameter is declared with a placeholder type).(since C++20)

  > 啥玩意？

- If the argument is an unparenthesized id-expression or an unparenthesized class member access expression, then decltype yields the type of the entity named by this expression. If there is no such entity, or if the argument names a set of overloaded functions, the program is ill-formed.

  > 啥玩意？

- If the argument is any other expression of type T, and：

  - if the value category of *expression* is *xvalue*, then decltype yields `T&&`;
  - if the value category of *expression* is *lvalue*, then decltype yields `T&`;
  - if the value category of *expression* is *prvalue*, then decltype yields `T`.
  - If *expression* is a function call which returns a prvalue of class type or is a [comma expression](https://en.cppreference.com/w/cpp/language/operator_other) whose right operand is such a function call, a temporary object is not introduced for that prvalue.
  - If *expression* is a prvalue other than a (possibly parenthesized) [immediate invocation](https://en.cppreference.com/w/cpp/language/consteval) (since C++20), a temporary object is not [materialized](https://en.cppreference.com/w/cpp/language/implicit_cast#Temporary_materialization) from that prvalue: such prvalue has no result object.



```c++
const int&& foo();
int i;
struct A { double x; };
const A* a = new A();

decltype(foo())  x1;  // const int&&      (1)
decltype(i)      x2;  // int              (2)
decltype(a->x)   x3;  // double           (3)
decltype((a->x)) x4;  // double&          (4)
```



这是一些例子，总的来说就是可以在编译时期推导出expression表达的类型。以后看看有什么妙用没有。