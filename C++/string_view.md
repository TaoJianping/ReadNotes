# string_view

※转载：[原文](https://abseil.io/tips/1)

## 前置知识

### c++ string c_str()

const char *c_str();
c_str()函数返回一个指向正规C字符串的指针常量, 内容与本string串相同.（其实它指向的是string对象内部真正的char缓冲区），所以返回const，以防止用户的修改。这是为了与c语言兼容，在c语言中没有string类型，故必须通过string类对象的成员函数c_str()把string 对象转换成c中的字符串样式。



### c++ string c_str() 和data()区别

 看下面的英文解释：

> const char* c_str ( ) const;
> Get C string equivalent
> Generates a null-terminated sequence of characters (c-string) with the same content as the string object and returns it as a pointer to an array of characters.
> A terminating null character is automatically appended.
>
> const char* data() const;
> Get string data
> Returns a pointer to an array of characters with the same content as the string.
> Notice that no terminating null character is appended (see member c_str for such a functionality).

c_str()字符串后有'\0'，而data()没有。



### c++ string c_str()的陷阱

这里有个小陷阱，返回了const char* 的时候，虽然这个指针无法改变指向，但是却可以改变里面的内容的，这跟str这个const char的生命周期及string类的实现有关，string的c_str()返回的指针是由string管理的，因此它的生命期是string对象的生命期，而string类的实现实际上封装着一个char的指针，而c_str()直接返回该指针的引用，因此string对象的改变会直接影响已经执行过的c_str()返回的指针引用。

这里有篇文章，讲的很好[string中的c_str()陷阱](https://www.kancloud.cn/digest/wangshubo123/187814)。简而言之，调用任何 std::string 的非 const 成员函数以后，c_str() 的返回值就不可靠了。



## 什么是string_view

std::string_view是C++ 17标准中新加入的类，正如其名，它提供一个字符串的视图，即可以通过这个类以各种方法“观测”字符串，但不允许修改字符串。由于它只读的特性，它并不真正持有这个字符串的拷贝，而是与相对应的字符串共享这一空间。即——构造时不发生字符串的复制。同时，你也可以自由的移动这个视图，移动视图并不会移动原定的字符串。

正因这些特性，当你不需要改变字符串时，应当抛弃原来使用的const string而采用新的string_view，这样可以避免多余的字符串拷贝。

> An instance of the `string_view` class can be thought of as a “view” into an existing character buffer. Specifically, a `string_view` consists of only a pointer and a length, identifying a section of character data that is not owned by the `string_view` and cannot be modified by the view. Consequently, making a copy of a `string_view` is a shallow operation: no string data is copied.

### constructor

`std::string_view`允许通过C风格的字符串、字符串字面量、`std::string`或者其他的`string_view`进行构造。在构造的同时允许指定“大小”。

```c++
const char* cstr_pointer = "pointer";
char cstr_array[] = "array";
std::string stdstr = "std::string";

// 1. 使用C风格的 const char* 初始化
std::string_view sv1(cstr_pointer, 5);
// 2. 使用C风格的 char数组 初始化
std::string_view sv2(cstr_array);
// 3. 使用字符串字面量构造
std::string_view sv3("12345", 4);
// 4. 使用std::string构造
std::string_view sv4(stdstr);
// ....
```

```c++
std::string_view sv("123456789");
//
for (auto i : sv) {
    // range base loop
    std::cout << i << std::endl;
}

for (auto it = sv.crbegin(); it != sv.crend(); ++it) {
    // iterator
    std::cout << *it << std::endl;
}

```

其他的操作可以看[cppreference](https://en.cppreference.com/w/cpp/string/basic_string_view)。



## What to Do?

Google’s preferred option for accepting such string parameters is through a string_view. This is a “pre-adopted” type from C++17 - in C++17 builds you should use std::string_view, in any code that can’t rely on C++17 yet you should use absl::string_view.

> string_view是c++17的标准，如果你要在17前用这个特性，要用absl::string_view

An instance of the `string_view` class can be thought of as a “view” into an existing character buffer. Specifically, a `string_view` consists of only a pointer and a length, identifying a section of character data that is not owned by the `string_view` and cannot be modified by the view. Consequently, making a copy of a `string_view` is a shallow operation: no string data is copied.

> string_view本质上是对一串字节数组的“view”，他的成员只有一个指向这段内存的指针和长度，他无法修改原来的数据。所以拷贝一份string_view也只是拷贝他里面包含的指针。性能更好。

`string_view` has implicit conversion constructors from both `const char*` and `const string&`, and since `string_view` doesn’t copy, there is no O(n) memory penalty for making a hidden copy. In the case where a `const string&` is passed, the constructor runs in O(1) time. In the case where a `const char*` is passed, the constructor invokes a `strlen()` automatically (or you can use the two-parameter `string_view` constructor).

```c++
void TakesCharStar(const char* s);             // C convention
void TakesString(const std::string& s);        // Old Standard C++ convention
void TakesStringView(absl::string_view s);     // Abseil C++ convention
void TakesStringView(std::string_view s);      // C++17 C++ convention


void AlreadyHasString(const std::string& s) {
    TakesStringView(s); // no explicit conversion; convenient!
}

void AlreadyHasCharStar(const char* s) {
    TakesStringView(s); // no copy; efficient!
}
```

> string_view的constructor可以从`const char*` and `const string&`构造，具体可以看上面和cppreference，重要的是他不会产生O(n)的隐式拷贝字符串，他只是拿到这段数据的头指针而已。稍微要注意的是当`const char*`传过来的时候，还会调用strlen()来得到长度。

Because the `string_view` does not own its data, any strings pointed to by the `string_view` (just like a `const char*`) must have a known lifespan, and must outlast the `string_view` itself. This means that using `string_view` for storage is often questionable: you need some proof that the underlying data will outlive the `string_view`.

> 因为string_view并不拥有数据，所以要注意原有数据的生命周期，保证在string_view存在期间的原有数据的生命周期。同时，这也就意味着不要用string_view来做数据的持久化工作。

If your API only needs to reference the string data during a single call, and doesn’t need to modify the data, accepting a `string_view` is sufficient. If you need to reference the data later or need to modify the data, you can explicitly convert to a C++ string object using `string(my_string_view)`.

> string_view的最佳场景就是在单个函数的调用中，也不需要调整数据。

Adding `string_view` into an existing codebase is not always the right answer: changing parameters to pass by `string_view` can be inefficient if those are then passed to a function requiring a `string` or a NUL-terminated `const char*`. It is best to adopt `string_view` starting at the utility code and working upward, or with complete consistency when starting a new project.

> string_view迁移进现有项目不大好推，最多就是一些工具类应用，还不如重新开个项目。



## A Few Additional Notes

- Unlike other string types, you should pass `string_view` by value just like you would an int or a double because `string_view` is a small value.

- `string_view` is not necessarily NUL-terminated. Thus, it’s not safe to write:

  ```c++
  printf("%s\n", sv.data()); // DON’T DO THIS
  ```

  However, the following is fine:

  ```c++
  printf("%.*s\n", static_cast<int>(sv.size()), sv.data());
  ```

- You can output a `string_view` just like you would a string or a `const char*`:

  ```c++
  std::cout << "Took '" << s << "'";
  ```

- You can convert an existing routine that accepts `const string&` or NUL-terminated `const char*` to `string_view` safely in most cases. The only danger we have encountered in performing this operation is if the address of the function has been taken, this will result in a build break as the resulting function-pointer type will be different.

