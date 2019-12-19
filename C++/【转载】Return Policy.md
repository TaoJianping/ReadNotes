# Return Policy

其实主要讲的就是 [“return value optimization”](https://en.wikipedia.org/wiki/Return_value_optimization) (RVO).

[原文地址](https://abseil.io/tips/11)

这边做节选



RVO is a long-standing feature of almost all C++ compilers.

> RVO 是一个很长时间就存在的东西，c++98之后就有了。



```c++
class SomeBigObject {
 public:
  SomeBigObject() { ... }
  SomeBigObject(const SomeBigObject& s) {
    printf("Expensive copy …\n", …);
    …
  }
  SomeBigObject& operator=(const SomeBigObject& s) {
    printf("Expensive assignment …\n", …);
    …
    return *this;
  }
  ~SomeBigObject() { ... }
  …
};

static SomeBigObject SomeBigObjectFactory(...) {
  SomeBigObject local;
  ...
  return local;
}

SomeBigObject obj = SomeBigObject::SomeBigObjectFactory(...);
```

What happens if we run the following?

Simple answer: You probably expect there to be at least two objects created: the object returned from the called function, and the object in the calling function. Both are copies, so the program prints two messages about expensive operations. Real-world answer: No message is printed – because the copy constructor and assignment operator were never called!

How’d that happen? A lot of C++ programmers write “efficient code” that creates an object and passes that object’s address to a function, which uses that pointer or reference to operate on the original object. Well, under the circumstances described below, the compiler can transform such “an inefficient copy” into that “efficient code”!

> 这边不会有任何消息的打印，因为RVO的关系compiler会自动进行优化。

When the compiler sees a variable in the calling function (that will be constructed from the return value), and a variable in the called function (that will be returned), it realizes it doesn’t need both variables. Under the covers, the compiler passes the address of the calling function’s variable to the called function.

To quote the C++98 standard, **“Whenever a temporary class object is copied using a copy constructor … an implementation is permitted to treat the original and the copy as two different ways of referring to the same object and not perform a copy at all, even if the class copy constructor or destructor have side effects. For a function with a class return type, if the expression in the return statement is the name of a local object … an implementation is permitted to omit creating the temporary object to hold the function return value …**” (Section 12.8 [class.copy], paragraph 15 of the C++98 standard. The C++11 standard has similar language in section 12.8, paragraph 31, but it’s more complicated.)

> 如果一个临时对象创建了，compiler可以把源对象和拷贝对象看作是一个对象而不需要进行拷贝，哪怕是这个copy constructor会有side effect.
>
> 对一个函数来说就是这个local object如果直接返回了，就把他看作是返回值，而不需要进行copy constructor。

Worried that “permitted” isn’t a very strong promise? Fortunately, all modern C++ compilers perform RVO by default, even in debug builds, even for non-inlined functions.

> 这个permitted可能会造成疑虑，但事实任何的默认版本的c++ compiler都会进行这种优化，包括debug模式和non-inlined functions.



## How Can You Ensure the Compiler Performs RVO?

The called function should define a single variable for the return value:

```c++
SomeBigObject SomeBigObject::SomeBigObjectFactory(...) {
  SomeBigObject local;
  …
  return local;
}
```

The calling function should assign the returned value to a new variable:

```c++
// No message about expensive operations:
SomeBigObject obj = SomeBigObject::SomeBigObjectFactory(...);
```

> 这个是第一种状况
>
> - 被调用的函数只定义一个局部变量作为返回的值
> - 这个返回的值会赋予一个新的变量

The compiler can’t do RVO if the calling function reuses an existing variable to store the return value (though move semantics would apply for move-enabled types in this case):

```c++
// RVO won’t happen here; prints message "Expensive assignment ...":
obj = SomeBigObject::SomeBigObjectFactory(s2);
```

> 如果是一个已经存在的变量，则不会触发RVO。

The compiler also can’t do RVO if the called function uses more than one variable for the return value:

```c++
// RVO won’t happen here:
static SomeBigObject NonRvoFactory(...) {
  SomeBigObject object1, object2;
  object1.DoSomethingWith(...);
  object2.DoSomethingWith(...);
  if (flag) {
    return object1;
  } else {
    return object2;
  }
}
```

> 如果有超过一个的变量来返回，则也不会除法RVO

But it’s okay if the called function uses one variable and returns it in multiple places:

```c++
// RVO will happen here:
SomeBigObject local;
if (...) {
  local.DoSomethingWith(...);
  return local;
} else {
  local.DoSomethingWith(...);
  return local;
}
```

> 但是如果返回的value是同一个，则会触发RVO，哪怕是在多行返回。



## One More Thing: Temporaries

RVO works with temporary objects, not just named variables. You can benefit from RVO when the called function returns a temporary object:

```c++
// RVO works here:
SomeBigObject SomeBigObject::ReturnsTempFactory(...) {
  return SomeBigObject::SomeBigObjectFactory(...);
}
```

> 临时对象也会有RVO的优化。

You can also benefit from RVO when the calling function immediately uses the returned value (which is stored in a temporary object):

```c++
// No message about expensive operations:
EXPECT_EQ(SomeBigObject::SomeBigObjectFactory(...).Name(), s);
```

> 右值？

A final note: If your code needs to make copies, then make copies, whether or not the copies can be optimized away. Don’t trade correctness for efficiency.

> 如果你需要拷贝，就去做，不要为了效率牺牲正确性。