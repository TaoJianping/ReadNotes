# Chapter 3: Moving to Modern C++

## Item 7: Distinguish between () and {} when creating objects.

initialization values 有三种类型：

- initializer is in parentheses

  ```c++
  int x(0);
  ```

- initializer follows "="

  ```c++
  int y = 0;
  ```

- initializer is in braces

  ```c++
  int z{ 0 };
  ```

- initializer uses "=" and braces

  ```c++
  int z = { 0 }; 
  ```



### uniform initialization(braced initialization)

> To address the confusion of multiple initialization syntaxes, as well as the fact that
> they don’t cover all initialization scenarios, C++11 introduces uniform initialization:
> a single initialization syntax that can, at least in concept, be used anywhere and
> express everything. It’s based on braces, and for that reason I prefer the term braced
> initialization. “Uniform initialization” is an idea. “Braced initialization” is a syntactic
> construct.

braced initialization能用的地方非常多，比如

```c++
std::vector<int> v{ 1, 3, 5 }; // v's initial content is 1, 3, 5

class Widget {
private:
    int x{ 0 }; // fine, x's default value is 0
    int y = 0; // also fine
    int z(0); // error!
};
```



#### 注意事项

- 大括号内部无法隐式转换
- 解决most vexing parse



#### 缺点

只要有`Widget(std::initializer_list<long double> il);`初始化构造方法，会优先匹配他，他的优先级是最高的。哪怕发生`narrowing convertion`，他会直接报错。除非无法转换，比如string到bool。



#### Things to Remember

- Braced initialization is the most widely usable initialization syntax, it prevents narrowing conversions, and it’s immune to C++’s most vexing parse.
- During constructor overload resolution, braced initializers are matched to std::initializer_list parameters if at all possible, even if other constructors offer seemingly better matches.

- An example of where the choice between parentheses and braces can make a significant difference is creating a std::vector<numeric type> with two arguments.

- Choosing between parentheses and braces for object creation inside templates can be challenging.



## Item 8: Prefer nullptr to 0 and NULL .

0和NULL终究不是指针的类型，哪怕0在某些极端情况下可以看作一个指针。

```c++
void f(int); 	// three overloads of f
void f(bool);
void f(void*);

f(0); 			// calls f(int), not f(void*)
f(NULL); 		// might not compile, but typically calls
				// f(int). Never calls f(void*)
```

可以看到对编译器来说，如果传过来NULL，一般会用int来调用，而不是指针。



### nullptr 

而如果我们用`nullptr `，那么他肯定是个指针，这也是他最大的优点。

> nullptr’s advantage is that it doesn’t have an integral type. To be honest, it doesn’t
> have a pointer type, either, but you can think of it as a pointer of all types. nullptr’s
> actual type is std::nullptr_t, and, in a wonderfully circular definition,
> std::nullptr_t is defined to be the type of nullptr. The type std::nullptr_t
> implicitly converts to all raw pointer types, and that’s what makes nullptr act as if it
> were a pointer of all types.

这里详解了`nullptr `，总归他肯定是个指针。



TODO Mutex不懂



## Item 9:Prefer alias declarations to typedef s.

这个主要讲的是类型别名，有时候可能你想定义的类型名很长，比如

```c++
std::unique_ptr<std::unordered_map<std::string, std::string>>
```

这个时候就需要类型别名定义了。有两种方法：

- `typedef`

  ```c++
  typedef std::unique_ptr<std::unordered_map<std::string, std::string>> UPtrMapSS;
  ```

- `alias declarations`

  ```c++
  using UPtrMapSS = std::unique_ptr<std::unordered_map<std::string, std::string>>;
  ```



所以问题就是为什么`alias declarations`要比`typedef`好？

答案是模板，对`alias declarations`来说它可以很方便的用在模板里面：

```c++
template<typename T> 							// MyAllocList<T>
using MyAllocList = std::list<T, MyAlloc<T>>; 	// is synonym for
												// std::list<T,MyAlloc<T>>
MyAllocList<Widget> lw; 						// client code
```

可以看到他办一个模板类型用很方便的方法表示出来了，但是typedef不能这样做。这个语法不支持，你必须用很trick的方式写出来：

```c++
template<typename T> 						// MyAllocList<T>::type
struct MyAllocList { 						// is synonym for
	typedef std::list<T, MyAlloc<T>> type; 	// std::list<T,
}; 											// MyAlloc<T>>
MyAllocList<Widget>::type lw; 				// client code

template<typename T>
class Widget { 								// Widget<T> contains
    private: 								// a MyAllocList<T>
    typename MyAllocList<T>::type list; 	// as a data member
    …
};
```

注意，当你在另一个模板类里面如此使用我们定义的类，你必须用`typename`关键字把他定义，不然可能会由问题的，编译器无法知道这个到底是不是个类。这就牵涉到`typename`关键字存在的原因了，下面由两个链接，讲的很清楚：

> http://feihu.me/blog/2014/the-origin-and-usage-of-typename/
>
> https://stackoverflow.com/questions/610245/where-and-why-do-i-have-to-put-the-template-and-typename-keywords

所以这个就有点多余了，还不如直接用`alias declarations`：

```c++
template<typename T>
using MyAllocList = std::list<T, MyAlloc<T>>; 	// as before
template<typename T>
class Widget {
    private:
    MyAllocList<T> list; 						// no "typename",
    … 											// no "::type"
};
```

这就很自然了。	

同时看一个标准库的应用。这里牵涉到一个`type_traits`，简单来说，他给你个类型，它能帮你去掉某些属性，看代码：

```c++
// remove_const example
#include <iostream>
#include <type_traits>

int main() {
      typedef const char cc;
      std::remove_const<cc>::type a;             // char a
      std::remove_const<const char*>::type b;    // const char* b
      std::remove_const<char* const>::type c;    // char* c

      a = 'x';
      b = "remove_const";
      c = new char[10];

      std::cout << b << std::endl;

      return 0;
}
```

```c++
std::remove_const<T>::type 				// yields T from const T
std::remove_reference<T>::type 			// yields T from T& and T&&
std::add_lvalue_reference<T>::type 		// yields T& from T
```

这里要注意，因为`::type`的原因，所以你还是要在模板类前面加上`typename`关键字。所以，c++又给我们提供了：

```c++
std::remove_const<T>::type 				// C++11: const T → T
std::remove_const_t<T> 					// C++14 equivalent
    
std::remove_reference<T>::type 			// C++11: T&/T&& → T
std::remove_reference_t<T> 				// C++14 equivalent
    
std::add_lvalue_reference<T>::type 		// C++11: T → T&
std::add_lvalue_reference_t<T> 			// C++14 equivalent
```

加了后缀之后，就可以省去`typename`和`::type`了，他的实现就是简单的`alias declarations`：

```c++
template <class T>
using remove_const_t = typename remove_const<T>::type;

template <class T>
using remove_reference_t = typename remove_reference<T>::type;

template <class T>
using add_lvalue_reference_t = typename add_lvalue_reference<T>::type;
```



## Item 10:Prefer scoped enum s to unscoped enum s.

这里介绍`enum class`和`enum`的区别。

```c++
enum class Color { black, white, red };		// enum class
	
enum Color { black, white, red };			// enum
```



### 优势一：reduction in namespace pollution

当你使用enum的时候，里面定义的变量会leak出来，污染命名空间，所以：

```c++
enum Color { black, white, red }; 	// black, white, red are
									// in same scope as Color
auto white = false; 				// error! white already
									// declared in this scope
```

你可以等价的把`enum Color { black, white, red };`看成一个宏展开，即：

```c++
enum Color { black, white, red };

#define black 0
#define white 1
#define red 2
```

所以传动的C语言的`enum`其实就是帮你帮你简写了些宏，但是确实会实实在在的污染你的命名空间。

而在c++11之后的关键字`enum class`就没有这个问题，更加像现在高级语言的`enum`了

```c++
enum class Color { black, white, red }; 	// black, white, red
											// are scoped to Color
auto white = false; 						// fine, no other
 											// "white" in scope
Color c = white; 							// error! no enumerator named
											// "white" is in this scope
Color c = Color::white; 					// fine
auto c = Color::white;					 	// also fine (and in accord
											// with Item 5's advice)
```



### 优势二：much more strongly typed.

`enum`里面的就是int类型，但是在`enum class`里面，你可以指定他的类型, 不然的话默认就是int类型：

```c++
enum class Status: std::uint32_t; 	// underlying type for
									// Status is std::uint32_t
									// (from <cstdint>)
```

同时，只要设计到隐式转换，编译器就能报错，除非你显示转换：

```c++
enum class Color { black, white, red }; 	// enum is now scoped
Color c = Color::red; 						// as before, but with scope qualifier	
if (c < 14.5) { 							// error! can't compare Color and double
 	auto factors = primeFactors(c); 		// error! can't pass Color to
											// function expecting std::size_t
}
```

```c++
if (static_cast<double>(c) < 14.5) { 						// odd code, but
															// it's valid
auto factors = primeFactors(static_cast<std::size_t>(c));	// suspect, but
 															// it compiles
}
```



### 优势三：enum class forward declaration

```c++
enum Color; 		// error!
enum class Color; 	// fine
```



实际上更复杂点，`enum`实际上是编译器决定的，有时候它觉得char类型够了就用这个了。但是提前声明的时候这种就会有问题。

具体看这个

- https://zhuanlan.zhihu.com/p/21722362



> Things to Remember**
>
> - C++98-style enums are now known as unscoped enums.
> - Enumerators of scoped enums are visible only within the enum. They convert
>   to other types only with a cast.
> - Both scoped and unscoped enums support specification of the underlying type.
>   The default underlying type for scoped enums is int. Unscoped enums have no
>   default underlying type.
> -  Scoped enums may always be forward-declared. Unscoped enums may be
>   forward-declared only if their declaration specifies an underlying type.



## Item 11:Prefer deleted functions to private undefined ones.
### Things to Remember

-  Prefer deleted functions to private undefined ones.
- Any function may be deleted, including non-member functions and template instantiations.



## Item 12:Declare overriding functions override .

### Things to Remember

-  Declare overriding functions override.
-  Member function reference qualifiers make it possible to treat lvalue and
  rvalue objects (*this) differently.



## Item 13:Prefer const_iterator s to iterator s.

### Things to Remember

- Prefer const_iterators to iterators.
-  In maximally generic code, prefer non-member versions of begin, end, rbegin, etc., over their member function counterparts.



## Item 14:Declare functions noexcept if they won’t emit exceptions.

注意`noexcept `也是函数签名的一部分。



### Things to Remember

- noexcept is part of a function’s interface, and that means that callers may depend on it.
- noexcept functions are more optimizable than non-noexcept functions.
- noexcept is particularly valuable for the move operations, swap, memory deallocation functions, and destructors.
- Most functions are exception-neutral rather than noexcept.



## Item 15:Use constexpr whenever possible.

`constexpr` 关键词是 C++11 引入的；C++14 中放宽了对 constexpr 函数的语法要求；而 C++17 则复用了该关键字，引入了 constexpr if。

`constexpr` 主要为 C++03 引入了以下变动：

- 拓展了「常量表达式」的概念
- 提供了「强制要求」表达式在编译时求值（compile-time evaluation）的方法
- 提供了编译时的 `if` 条件判断



### 作用

#### 拓展了「常量表达式」的概念

这个主要是强制说明这个变量是编译时计算的：

> constexpr indicates a value that’s not only constant, it’s known during compilation

在一些编译时需要确定长度的地方很有用，比如：

```c++
int sz; 								// non-constexpr variable
…
constexpr auto arraySize1 = sz; 		// error! sz's value not known at compilation
std::array<int, sz> data1; 				// error! same problem

constexpr auto arraySize2 = 10; 		// fine, 10 is a compile-time constant
std::array<int, arraySize2> data2; 		// fine, arraySize2 is constexpr
```



#### 提供了「强制要求」表达式在编译时求值（compile-time evaluation）的方法

当一个函数被`constexpr`标注的时候，编译器在一些情况下可以做一些优化：

> Such functions produce compile-time constants when they are called with compile-time constants. If they’re called with values not known until runtime, they produce runtime values.

- constexpr functions can be used in contexts that demand compile-time constants. If the values of the arguments you pass to a constexpr function in such a context are known during compilation, the result will be computed during compilation. If any of the arguments’ values is not known during compilation, your code will be rejected.
- When a constexpr function is called with one or more values that are not known during compilation, it acts like a normal function, computing its result at runtime. This means you don’t need two functions to perform the same operation, one for compile-time constants and one for all other values. The constexpr function does it all.



### Things to Remember

- constexpr objects are const and are initialized with values known during compilation.
-  constexpr functions can produce compile-time results when called with arguments whose values are known during compilation.
- constexpr objects and functions may be used in a wider range of contexts than non-constexpr objects and functions.
- constexpr is part of an object’s or function’s interface.



### 参考

- https://www.cnblogs.com/DswCnblog/p/6513310.html

- https://www.jianshu.com/p/34a2a79ea947
- https://www.zhihu.com/question/274323507
- https://www.zhihu.com/question/31123574
- https://www.zhihu.com/question/35614219/answer/63798713
- https://www.zhihu.com/question/29662350
- http://cpptruths.blogspot.com/2011/07/want-speed-use-constexpr-meta.html



## Item 17:Understand special member function generation.
在C++用语中，***the special member functions***代表着那些会自动生成的函数。当然，自动生成只会在需要的时候，而不是一开始就自动生成。

> Generated special member functions are implicitly public and inline, and they’re nonvirtual unless the function in question is a destructor in a derived class inheriting from a base class with a virtual destructor. In that case, the compiler-generated destructor for the derived class is also virtual.

在C++11的时候，类在需要的时候会自动生成6个函数，分别是

- the default constructor,
- the destructor
- the copy constructor
- the copy assignment operator
- the move constructor
-  the move assignment operator



#### move operation 特殊的规则

- 两种copy operation是相互独立的，也就是说如果其中的某个你定义了，但是不会影响另一个的自动生成。但是move operation不是，如果你定义了其中的一个move operation，那么它会阻止另一个的自动生成。
- move operations won’t be generated for any class that explicitly declares a copy operation.
- Declaring a move operation (construction or assignment) in a class causes compilers to disable the copy operations. (The copy operations are disabled by deleting them).
- C++11 does not generate move operations for a class with a user-declared destructor.



#### move operations 的生成规则 

So move operations are generated for classes (when needed) only if these three things
are true:

- No copy operations are declared in the class.
- No move operations are declared in the class.
- No destructor is declared in the class.



#### The C++11 rules governing the special member functions are thus:

- **Default constructor**: Same rules as C++98. Generated only if the class contains no user-declared constructors.
- **Destructor**: Essentially same rules as C++98; sole difference is that destructors are noexcept by default. As in C++98, virtual only if a base class destructor is virtual.
- **Copy constructor**: Same runtime behavior as C++98: memberwise copy construction of non-static data members. Generated only if the class lacks a user-declared copy constructor. Deleted if the class declares a move operation. Generation of this function in  a class with a user-declared copy assignment operator or destructor is deprecated.
- **Copy assignment operator**: Same runtime behavior as C++98: memberwise copy assignment of non-static data members. Generated only if the class lacks a user-declared copy assignment operator. Deleted if the class declares a move operation. Generation of this function in a class with a user-declared copy constructor or destructor is deprecated.
- **Move constructor** and **move assignment operator**: Each performs memberwise
  moving of non-static data members. Generated only if the class contains no user-
  declared copy operations, move operations, or destructor.

>### Things to Remember
>
>- The special member functions are those compilers may generate on their own:
>  default constructor, destructor, copy operations, and move operations.
>- Move operations are generated only for classes lacking explicitly declared
>  move operations, copy operations, and a destructor.
>- The copy constructor is generated only for classes lacking an explicitly
>  declared copy constructor, and it’s deleted if a move operation is declared.
>  The copy assignment operator is generated only for classes lacking an explic‐
>  itly declared copy assignment operator, and it’s deleted if a move operation is
>  declared. Generation of the copy operations in classes with an explicitly
>  declared destructor is deprecated.
>- Member function templates never suppress generation of special member
>  functions.

