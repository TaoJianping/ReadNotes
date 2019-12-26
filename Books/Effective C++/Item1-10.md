## Item 1: View C++ as a federation of languages

c++语言是多范式的。



## Item 2: Prefer `const`s, `enum`s, and  `inline`s to `#define`s



## Item 3: Use `const` whenever possible

用`const`的好处

- It allows you to communicate to both compilers and other programmers that a  value should remain invariant.



```c++
char greeting[] = "hello";

// situation 1
//      non-const pointer
//      non-const data
char *p = greeting;

// situation 2
//      non-const pointer
//      const data
const char *p = greeting;
*p = "fuck";		// error

// situation 3
//      const pointer
//      non-const data
char * const p = greeting;
p = "fuck";     // error

// situation 4
//      const pointer
//      const data
const char * const p = greeting;
```

上面写了const在不同地方可能产生的不同影响。

- If the word `const` appears to the left of the asterisk, what's pointed to is constant; 

- if the word `const`  appears to the right of the asterisk, the pointer  itself is constant;
- if `const` appears on both sides, both are  constant.



When what's pointed to is constant, some programmers list `const` before  the type. Others list it after the type but before the asterisk. There is no  difference in meaning, so the following functions take the same parameter type:

```c++
void f1(const Widget *pw);         // f1 takes a pointer to a
                                   // constant Widget object

void f2(Widget const *pw);         // so does f2
```

> 注意，`const`放在type前后是没有区别的。



STL iterators are modeled on pointers, so an `iterator` acts much like a  `T*` pointer. Declaring an `iterator const` is like declaring a  pointer `const` (i.e., declaring a `T* const` pointer): the  `iterator` isn't allowed to point to something different, but the thing  it points to may be modified. If you want an iterator that points to something  that can't be modified (i.e., the STL analogue of a `const T*` pointer),  you want a `const_iterator`:

```c++
std::vector<int> vet{1, 2, 3, 4, 5};

const std::vector<int>::iterator iter = vet.begin();
// iter = vet.begin();      error

std::vector<int>::const_iterator iterator = vet.begin();
// *iterator = 1;       error
```

> 在stl容器里面也有这样的东西，比如迭代器，可以仔细观察一下const和const_iterator的区别



TODO



## Item 4: Make sure that objects are initialized before  they're used

没有正确初始化的对象，你读操作是undefined。



### member initialization list

当你对一个instance of class进行初始化的时候，无非就是调用default constructor 进行初始化，但是可能还是有细微的差别。

```c++
class PhoneNumber {
};

class ABEntry {                       // ABEntry = "Address Book Entry"
public:
    ABEntry(const std::string &name, const std::string &address,
            const std::vector<PhoneNumber> &phones);
private:
    std::string theName;
    std::string theAddress;
    std::vector<PhoneNumber> thePhones;
    int numTimesConsulted;
};

ABEntry::ABEntry(const std::string &name, const std::string &address,
                 const std::vector<PhoneNumber> &phones) {
    theName = name;                       // these are all assignments,
    theAddress = address;                 // not initializations
    thePhones = phones;
    numTimesConsulted = 0;
}
```

注意这个constructor，他是先对theName, theAddress, thePhones调用他们default constructor进行初始化，然后再调用operator assignment进行赋值。这就不efficient。所以要用**member initialization list**来进行初始化。

```c++
ABEntry::ABEntry(const std::string& name, const std::string& address,
                 const std::list<PhoneNumber>& phones)
: theName(name),
  theAddress(address),                  // these are now all initializations
  thePhones(phones),
  numTimesConsulted(0)
{}                                      // the ctor body is now empty
```

这样就会只调用一次copy constructor。避免了浪费。

这样虽然对POD数据其实是没什么区别的，但是我们要保持一致性。



One aspect of C++ that isn't fickle is the order in which an object's data is  initialized. This order is always the same: base classes are initialized before  derived classes (see also [Item 12](ch02lev1sec8.html#ch02lev1sec8)), and within a class, data  members are initialized in the order in which they are declared. In  `ABEntry`, for example, `theName` will always be initialized  first, `theAddress` second, `thePhones` third, and  `numTimesConsulted` last. This is true even if they are listed in a  different order on the member initialization list (something that's  unfortunately legal). To avoid reader confusion, as well as the possibility of  some truly obscure behavioral bugs, always list members in the initialization  list in the same order as they're declared in the class.

> c++ 初始化member的顺序是对应他初始化的顺序。



不同文件的non-local static objects初始化在不同文件中可能会有初始化的问题，你必须要避免他，因为***initialization of non-local static objects defined in different translation  units is undefined***. 解决方法就是把他放到一个函数里面，返回他自身的引用。因为函数的初始化是可以控制的。类似于下面这个。

```c++
FileSystem& tfs()                   // this replaces the tfs object; it could be
{                                   // static in the FileSystem class
  static FileSystem fs;             // define and initialize a local static object
  return fs;                        // return a reference to it
}
```

当然这个在多线程也可能有问题，自己再写的时候要注意。



### Things to Remember  

- Manually initialize objects of built-in type, because C++ only  sometimes initializes them itself. 
- In a constructor, prefer use of the member initialization list  to assignment inside the body of the constructor. 
- List data members in the  initialization list in the same order they're declared in the class. 
- Avoid initialization order problems across translation units by  replacing non-local static objects with local static objects.



## Item 5: Know what functions C++ silently writes and calls

就是说c++可能会在你不知道的情况下做哪些事情？

### 自动生成函数

If you don't declare functions yourself, compilers will declare their own versions of  a copy constructor, a copy assignment operator, and a destructor. Furthermore,  if you declare no constructors at all, compilers will also declare a default  constructor for you. 

```c++
class Empty{};
```

就等于

```c++
class Empty {
public:
  Empty() { ... }                            // default constructor
  Empty(const Empty& rhs) { ... }            // copy constructor
  ~Empty() { ... }                           // destructor — see below
                                             // for whether it's virtual
  Empty& operator=(const Empty& rhs) { ... } // copy assignment operator
};

```

All these functions will be both `public` and `inline` ；

这些函数不会直接全部生成，编译器会根据哪里用到了，才会生成：

```c++
Empty e1;                               // default constructor;
                                        // destructor
Empty e2(e1);                           // copy constructor
e2 = e1;                                // copy assignment operator
```

当这些function被编译器提供了之后，他具体做了什么？

- the default constructor and the destructor primarily give compilers a  place to put "behind the scenes" code such as invocation of constructors and  destructors of base classes and non-static data members.
- Note that the generated  destructor is non-virtual unless it's for a class  inheriting from a base class that itself declares a virtual destructor (in which  case the function's virtualness comes from the base class).

- As for the copy constructor and the copy assignment operator, the  compiler-generated versions simply copy each non-static data member of the  source object over to the target object.

再看个例子

```c++
template<typename T>
class NamedObject {
public:
  NamedObject(const char *name, const T& value);
  NamedObject(const std::string& name, const T& value);
private:
  std::string nameValue;
  T objectValue;
};
```

Because a constructor is declared in `NamedObject`,  compilers won't generate a default constructor. This is important. It means that  if you've carefully engineered a class to require constructor arguments, you  don't have to worry about compilers overriding your decision by blithely adding  a constructor that takes no arguments.

> 因为你已经声明了constructor，所以不会再帮你生成不需要参数的constructor。

`NamedObject` declares neither copy constructor nor copy  assignment operator, so compilers will generate those functions (if they are  needed). Look, then, at this use of the copy constructor:

> 因为你没有声明copy constructor和copy assignment operator，所以compiler会帮你生成。

但是copy assignment operator在两个情况下默认会把copy assignment operator给delete掉

- 你的成员是引用类型
- 你的成员是const

这个时候compiler是不会生成copy assignment operator的。



### Things to Remember  

- Compilers may implicitly generate a class's default  constructor, copy constructor, copy assignment operator, and destructor. 



## Item 6: Explicitly disallow the use of  compiler-generated functions you do not want

在某些情况下你不希望compiler去自动生成一些代码，比如copy constructor和copy assignment constructor，你就可以采取一些行动

- 把这些函数设为默认私有
- 只声明不实现
- 父类把这些函数设为私有并且不实现，然后继承他
- 设置`=delete`关键字



## Item 7: Declare destructors virtual in polymorphic  base classes

