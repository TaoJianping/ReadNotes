Object slicing is used to describe the situation when you assign an object of a derived class to an instance of a base class. This causes a loss of methods and member variables for the derived class object. This is termed as information being sliced away. For example,

```c++
class Foo {
public:
    int a;
};

class Bar : public Foo {
public:
    int b;
};

int main(int argc, char *argv[]) {
    Bar bar;
    Foo foo = bar;
    // you can only use the property a of the base class
    foo.a;
    // you can not use the property b
    // foo.b
}
```

Since Bar extends Foo, it now has 2 member variables, a and b. So if you create a variable bar of type Bar and then create a variable of type Foo and assign bar, you'll lose the member variable b in the process. For example,

```c++
Bar bar;
Foo foo = bar;
// you can only use the property a of the base class
foo.a;
// you can not use the property b
// foo.b
```

In this case, the information in for about b is lost in a bar. This is known as member slicing.