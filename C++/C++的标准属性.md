# C++ Attribute

attribute是在基本程序代码中加入的辅助信息，编译器可以利用这些辅助信息来帮助自己CG（code generation），譬如用来优化或者产生特定代码（DLL，OpenMP等）。相比于其他语言（e.g. C#)，C++中的Meta information是由编译器决定的，你没有办法添加自己制定的attributes。而在C#中，我们可以从`System.Attribute`派生出来。



| 属性指示符名称                           | 用途                                                         | 引入版本 |
| :--------------------------------------- | :----------------------------------------------------------- | :------- |
| [[noreturn]]                             | 表示函数不返回值,并只能应用在函数上面, 如果函数真的有返回值，那么该属性无效,并且会给出警告 | c++11    |
| [[carries_dependency]]                   | 表示消耗释放模式的依赖链在函数内外传播,允许编译器跳过一些不必要的栅栏指令 | c++11    |
| [[deprecated]]  [[deprecated("reason")]] | 表示某些实体已经废弃，或者因为某些原因废弃，可以用在类，定义类型名，变量，非静态数据成员，枚举，模板实例 | c++14    |
| [[nodiscard]]                            | 表示被修饰的函数的返回值十分重要，或者枚举类型，对象类型十分重要不能被废弃 | c++17    |
| [[maybe_unused]]                         | 抑制一下未使用变量的警告                                     | c++17    |
| [[fallthrough]]                          | 出现在`switch`语句中，抑制上一句`case`没有`break`而引起的`fallthrough`的警告 |          |



#### [[noreturn]]

`[[noreturn]]`只能用于函数声明，其告诉编译器这个函数不会返回，也就是说，这个函数要么抛出异常，要么在所有执行路径上调用类似`exit`、`terminate`这些不会返回的函数。`[[noreturn]]`可以让编译器在CG的时候进行优化，也可以用来抑制编译器的warning。

```c++
void fatal_error() {
    throw "error";
}

int sw( int v) {
    switch (v) {
        case 1:
            return 0;
        default:
            fatal_error();		// warning: control reaches end of non-void function
    }
}
```

注意，上面的这个default分支是可能运行到的，但是他不会返回值，而函数是要求返回值的，所以编译器就会产生warnning。你这个时候就可以给`fatal_error`函数加上[[noreturn]]，表示这里的确不会返回值，程序运行到这里的时候就会直接终止掉，调用这个函数并不会返回。

```c++
[[noreturn]] void fatal_error() {
    throw "error";
}

int sw( int v) {
    switch (v) {
        case 1:
            return 0;
        default:
            fatal_error();
    }
}
```



#### [[nodiscard]]

如果函数被声明为`[[nodiscard]]`，或者函数by value地返回了一个被声明为`[[nodiscard]]`的enumeration/class的对象。那么，当这个函数的返回值被抛弃时，编译器会给出警告。

```c++
[[nodiscard]] int get_number() {
    return 10;
}

int main() {
    get_number();
}
```

如果不加[[nodiscard]]就不会有编译时的报错信息，加了就会有报错信息。

```c++
C:\Users\taojianping\Documents\PeronalProjects\CPPPrime\main.cpp:14:15: warning: ignoring return value of 'int get_number()', declared with attribute nodiscard [-Wunused-result]
     get_number();
     ~~~~~~~~~~^~
C:\Users\taojianping\Documents\PeronalProjects\CPPPrime\main.cpp:9:19: note: declared here
 [[nodiscard]] int get_number() {
                   ^~~~~~~~~~
```



#### [[deprecated]]  & [[deprecated("reason")]]

```c++
[[deprecated("this function has canceled")]] int get_number() {
    return 10;
}

int main() {
    get_number();
}
```

```c++
warning: 'int get_number()' is deprecated: this function has canceled
```

其实就是能指示这个函数要被deprecated掉了，最好不要使用。还能用括号显示具体的原因。



#### [[carries_dependency]]

TODO



#### [[fallthrough]]

TODO