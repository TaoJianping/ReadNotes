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