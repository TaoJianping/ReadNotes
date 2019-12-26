# Chapter 1: Object Lessons

## 1.1 The C++ Object Model

Model

- Data Member

  - Nonstatic data members: Nonstatic data members are allocated directly within each class object.
  - Static data members: Static data members are stored outside the individual class object.

- Member Function

  - Static function members: Static and nonstatic function members are also hoisted outside the class object.

  - Nonstatic function members: Static and nonstatic function members are also hoisted outside the class object.

  - Virtual functions:

    - A table of pointers to virtual functions is generated for each class (this is called the virtual table).

      > 每个类都有一个virtual table，虚函数表

    - A single pointer to the associated virtual table is inserted within each class object (traditionally, this has been called the **vptr**). 

    - The setting, resetting, and not setting of the **vptr** is handled automatically through code generated within each class constructor, destructor, and copy assignment operator (this is discussed in Chapter 5). 

    - The type_info object associated with each class in support of runtime type identification (**RTTI**) is also addressed within the virtual table, usually within the table's first slot.



### Example

```c++
class Point {
public:
    Point(float xval);

    virtual ~Point();

    float x() const;

    static int PointCount();

protected:
    virtual std::ostream &print(std::ostream &os) const;

    float _x;
    static int _point_count;
};
```

![image](https://tvax4.sinaimg.cn/large/005wgNfbgy1g9szbs9f1yj30o60ek76a.jpg)

