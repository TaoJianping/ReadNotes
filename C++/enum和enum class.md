要了解enum class的出现，则需要首先了解enum，方才知道为何有这东西。那么Meyers首先举出一个例子来阐述：

```c++
enum Color {black, white, red};

auto white = false; // error
```

其缘由在于black, white, red等并没有属于Color这个枚举体的作用域，而是与Color在一个作用域中。而为何会这样呢？若再追踪于到C，追踪到enum没出现之前，enum的功能则需要需要一系列的#define来完成，而enum则完成了这一系列#define的“打包收集”，所以我想你可以这样来理解enum，即“解包”。所以说你可以理解为他帮你做了一些宏的拓展。

```c++
#define black 0
#define white 1
#define red 2

auto white = false
```

也正是如此，对于两个不一样的枚举体，它们即使枚举体的名字不同，里面的内容也不能重名。因为他已经定义过了。如：

```c++
enum Direction {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT};

// error!
enum WindowsCorner {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT};
```

这对于我用户来说，这是不可理解的，因为在我心中，WindowsCorner的TOP_LEFT和Direction的TOP_LEFT是不同的。所以，在完成C的#define -> enum的进化后，那么如何更进一步的约束enum，即对于不同的枚举体有更好的类型安全与约束，就成为了C++11的任务，而C++11的答案则是enum class。

而在进入C++11 enum class的时候，我想再稍微提一下C和C++在enum的不同。在一些C代码中，会有这样的用法：

```c++
enum Direction {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT};

int main()
{
  enum Direction d = 1;
}
```

C是允许的，而C++是不允许的，C++只允许Direction d 由枚举体的TOP_RIGHT等值或者另外一个枚举体变量赋值，所以你可以认为C++的enum比C的enum更加类型安全。



enum class的用法非常简单，如上文Meyers的例子：

```c++
enum class Color {black, white, red};

auto white = false; // OK!
```

引入了这样的语法后，black, white, red等则隶属于Color这个enum class的作用域，那么下面的auto white的white则与enum class的white是不同的作用域，所以是OK的了。而我们的Direction和WindowsCorner也是可以有同名的TOP_LEFT等值了。

但是，需要注意的一个使用点在于，你若想要赋值一个enum class，你需要指定枚举体作用域，如：

```c++
Color c = Color::white; // not white
```



原帖地址更详细，这边只摘录对自己有用的部分

[原帖地址](https://zhuanlan.zhihu.com/p/21722362)

