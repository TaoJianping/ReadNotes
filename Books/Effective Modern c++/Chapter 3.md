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



