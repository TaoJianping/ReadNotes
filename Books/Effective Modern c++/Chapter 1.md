# Chapter 1: Deducing Types



## Item 1:  Understand template type deduction

```c++
template<typename T>
void f(ParamType param);

f(expr);		// call f with some expression
```

在compile期间，compiler会用expr来推导出下面两个类型：

- **T** 
- **ParamType**

T和ParamType常常不同的，T更像是这个对象是属于哪个类的，而ParamType有更多的adornment，比如const属性或者reference属性。举个例子：

```c++
template<typename T>
void f(const T& param); // ParamType is const T&

int x = 0;
f(x);
```

T is deduced to be **int**, but ParamType is deduced to be **const int&**.



对T的类型推导不仅仅是要看expr，同时也要看ParamType，把ParamType分成3个类型讨论：

- ParamType is a pointer or reference type, but not a universal reference.
- ParamType is a universal reference.
- ParamType is neither a pointer nor a reference.



### Case 1: ParamType is a pointer or reference type, but not a universal reference.

The simplest situation is when ParamType is a reference type or a pointer type, but
not a universal reference. In that case, type deduction works like this:

1. If expr’s type is a reference, ignore the reference part.
2. Then pattern-match expr’s type against ParamType to determine T.

> 当ParamType是一个reference或者pointer，为了推导T：
>
> - 先看expr的类型有没有引用或指针，如果有，就去除掉reference属性或指针属性。
> - 如果ParamType还有一些如const之类的adornment，也要看expr有没有这类属性，重叠的去掉。

For example, if this is our template,

```c++
template<typename T>
void f(T& param); // ParamType is `T&`

int x = 27; 			// x is an int
const int cx = x; 		// cx is a const int
const int& rx = x; 		// rx is a reference to x as a const int

f(x); // T is int, param's type is int&
f(cx); // T is const int, param's type(expr) is const int&
f(rx); // T is const int, param's type(expr) is const int&
```

```c++
template<typename T>
void f(const T& param); // param is now a ref-to-const

int x = 27; // as before
const int cx = x; // as before
const int& rx = x; // as before

f(x); // T is int, param's type is const int&
f(cx); // T is int, param's type is const int&
f(rx); // T is int, param's type is const int&
```

These examples all show lvalue reference parameters, but type deduction works
exactly the same way for rvalue reference parameters.

> 不止左值的引用参数这样，右值的引用参数也这样。



### Case 2: ParamType is a Universal **Reference**

- If expr is an lvalue, both T and ParamType are deduced to be lvalue references.
-  If expr is an rvalue, the “normal” (i.e., Case 1) rules apply.

```c++
template<typename T>
void f(T&& param); // param is now a universal reference

int x = 27; // as before
const int cx = x; // as before
const int& rx = x; // as before

f(x); // x is lvalue, so T is int&, param's type is also int&
f(cx); // cx is lvalue, so T is const int&, param's type is also const int&
f(rx); // rx is lvalue, so T is const int&, param's type is also const int&
f(27); // 27 is rvalue, so T is int, param's type is therefore int&&
```

太鬼畜了

Todo item 24解释了详尽的原因。



### Case 3: ParamType is Neither a Pointer nor a Reference

When ParamType is neither a pointer nor a reference, we’re dealing with pass-by-
value.

That means that param will be a copy of whatever is passed in—a completely new
object. The fact that param will be a new object motivates the rules that govern how T
is deduced from expr:

1. As before, if expr’s type is a reference, ignore the reference part.
2. If, after ignoring expr’s reference-ness, expr is const, ignore that, too. If it’s
volatile, also ignore that.

> 因为我们实际上是得到了一个全新的对象，所以原来传进来的值不用管他自己的属性，无论是reference或者const。

```c++
template<typename T>
void f(T param); // param is now passed by value

int x = 27; // as before
const int cx = x; // as before
const int& rx = x; // as before

f(x); // T's and param's types are both int
f(cx); // T's and param's types are again both int
f(rx); // T's and param's types are still both int
```



### Array Arguments

```c++
const char name[] = "J. P. Briggs";
```

数组这东西就是如果是当值传入，则是个指针，但是如果是引用，则会是个array。

```c++
template<typename T>
void f(T param); // template with by-value parameter

f(name); // name is array, but T deduced as const char*
```

```c++
template<typename T>
void f(T& param); // template with by-reference parameter

f(name); // pass array to f
```



### Function Arguments

Function Arguments和Array Arguments一样的，如果是个值类型，那么会函数会退化成指针，但是如果是引用类型，则函数不会退化。

```c++
void someFunc(int, double); // someFunc is a function;
							// type is void(int, double)
template<typename T>
void f1(T param); 			// in f1, param passed by value
template<typename T>
void f2(T& param); 			// in f2, param passed by ref

f1(someFunc); 				// param deduced as ptr-to-func;
							// type is void (*)(int, double)
f2(someFunc); 				// param deduced as ref-to-func;
							// type is void (&)(int, double)
```



> Things to Remember
>
> - During template type deduction, arguments that are references are treated as non-references, i.e., their reference-ness is ignored.
> - When deducing types for universal reference parameters, lvalue arguments get special treatment.
> - When deducing types for by-value parameters, const and/or volatile arguments are treated as non-const and non-volatile.
> - During template type deduction, arguments that are array or function names decay to pointers, unless they’re used to initialize references.



## Item 2:Understand auto type deduction.

在item1里面，是用expr来推导T和ParamType

```c++
template<typename T>
void f(ParamType param);

f(expr); // call f with some expression
```

而在auto类型推导里面，auto就是上面的T，而`type specifier`就是上面的ParamType。

对于auto type deduction来说，规则和item1 的template type deduction一样，分成三个情况：

-  Case 1: The type specifier is a pointer or reference, but not a universal reference.
- Case 2: The type specifier is a universal reference.
- Case 3: The type specifier is neither a pointer nor a reference.

```c++
auto x = 27; 			// case 3 (x is neither ptr nor reference)
const auto cx = x; 		// case 3 (cx isn't either)
const auto& rx = x; 	// case 1 (rx is a non-universal ref.)

auto&& uref1 = x; 		// x is int and lvalue,
						// so uref1's type is int&
auto&& uref2 = cx; 		// cx is const int and lvalue,
						// so uref2's type is const int&
auto&& uref3 = 27; 		// 27 is int and rvalue,
						// so uref3's type is int&&

const char name[] = "R. N. Briggs";	
auto arr1 = name; 			// arr1's type is const char*
auto& arr2 = name; 			// arr2's type is const char (&)[13]

void someFunc(int, double); // someFunc is a function;
							// type is void(int, double)
auto func1 = someFunc; 		// func1's type is
							// void (*)(int, double)
auto& func2 = someFunc; 	// func2's type is
							// void (&)(int, double)
```



Things to Remember

- auto type deduction is usually the same as template type deduction, but auto
  type deduction assumes that a braced initializer represents a `std::initial
  izer_list`, and template type deduction doesn’t.
- auto in a function return type or a lambda parameter implies template type
  deduction, not auto type deduction.



## Item 3:Understand decltype 

TODO 没咋看懂



## Item 4：Know how to view deduced types.

就是教我们怎么看自动推导出的类型。



### IDE Editors

把鼠标移上去自动提示



### compiler Diagnostics

编译时的报错信息，太鬼畜了



### Runtime Output

```c++
cout << "T = " << typeid(T).name() << '\n';
cout << "param = " << typeid(param).name() << '\n';
```

事实上这个不但有时候是不准确的，连格式都不一致，书里给了个另外的解决办法，就是用boost的`boost::typeindex::type_id_with_cvr`

```c++
// show T
cout << "T = "
<< type_id_with_cvr<T>().pretty_name()
<< '\n';
// show param's type
cout << "param = "
<< type_id_with_cvr<decltype(param)>().pretty_name()
<< '\n';
```



Things to Remember

- Deduced types can often be seen using IDE editors, compiler error messages,
  and the Boost TypeIndex library.
- The results of some tools may be neither helpful nor accurate, so an under‐
  standing of C++’s type deduction rules remains essential.