# C++ 类型转换

C风格的强制类型转换(Type Cast)很简单，不管什么类型的转换统统是：

``` c
int a = (double) b
```

C++对类型转换进行了分类，并添加了四个关键字来支持

| 关键字           | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| static_cast      | 用于良性转换，一般不会导致意外发生，风险很低。               |
| const_cast       | 用于 const 与非 const、volatile 与非 volatile 之间的转换。   |
| reinterpret_cast | 高度危险的转换，这种转换仅仅是对二进制位的重新解释，不会借助已有的转换规则对数据进行调整，但是可以实现最灵活的 C++ 类型转换。 |
| dynamic_cast     | 借助 RTTI，用于类型安全的向下转型（Downcasting）。           |

这四个关键字的语法格式都是一样的，具体为：

```c++
xxx_cast<newType>(data)
```

 newType 是要转换成的新类型，data 是被转换的数据。

举个例子：

**C version**

```c
double a = 99.5;
int b = (double) a;
```

**C++ version** 

```c++
double a = 99.5;
int b = static_cast<int>(a);
```



## static_cast

- 用于类层次结构中基类和子类之间指针或引用的转换。进行上行转换（把子类的指针或引用转换成基类表示）是安全的；进行下行转换（把基类指针或引用转换成子类指针或引用）时，由于没有动态类型检查，所以是不安全的。 (基类和子类之间的动态类型转换建议用dynamic_cast) 
- 用于基本数据类型之间的转换，如把int转换成char，把int转换成enum。这种转换的安全性也要开发人员来保证。
- 把void指针转换成目标类型的指针(不安全!!)
- 把任何类型的表达式转换成void类型。

 注意：static_cast不能转换掉expression的const、volitale、或者__unaligned属性。 