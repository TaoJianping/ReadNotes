# explicit关键字

`explicit`的作用是用来声明类构造函数是显示调用的，而非隐式调用，所以只用于修饰单参构造函数。因为无参构造函数和多参构造函数本身就是显示调用的。再加上`explicit`关键字也没有什么意义。



`explicit`关键字的官方解释：

> This keyword is a declaration specifier that can only be applied to in-class constructor declarations . An explicit constructor cannot take part in implicit conversions. It can only be used to explicitly construct an object 。



作用：

- 只能用来修饰类构造函数
- `explicit`修饰的构造函数不能被隐式调用
- 禁止类对象之间的隐式转换



实例：

```c++
class Explicit
{
private:

public:
    Explicit(int x) {
    	std::cout << "using x param" << std::endl;
	}
};

int main() {
    Explicit test0(15);
    Explicit test1 = 10;// 隐式调用Explicit(int x)
}
```

这边可以看到有个隐式调用构造函数的例子，可以，但是实际上这个很不清晰，不推荐这么做。而多参的构造函数是不会出现这种情况的。所以我们需要用`explicit`来申明这个构造函数必须是显式声明的。

```c++
class Explicit
{
private:

public:
    explicit Explicit(int x) {
    	std::cout << "using x param" << std::endl;
	}
};


int main() {
    Explicit test0(15);
    Explicit test1 = 10;	// error, 编译时期报错，隐式调用Explicit(int size)
}
```

当我们在构造函数前面加上`explicit`关键字之后，在编译时期就把这种隐式构造给error掉了。应该属于能用就用的那种关键字。