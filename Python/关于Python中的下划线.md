# Python 下划线 _ 和__

在第一家公司面试的时候，面试官就问过我这个问题，我当时的回答是

> 1. _代表着私有变量，from xxx import * 的时候不会载入
> 2. 如上，也是如此，并且它会自动重写这个变量的名称为 **_module__name**

```python
class Parent(object):
    def __test(self):
        print("test func")

    def _haha(self):
        self.__test()
        print("haha")

    def foo(self):
        print("foo func")

        
p = Parent()
p._haha()		# 可以调用，但不支持你调用
p.__test()		# 就报错了
p._Parent__test()		# 原因就是名字被重写成_module__name了
```



#### 设计思想

那既然他们都是私有的，他们真正的差别是什么呢？其实是在于

1. _name 代表着他是类的私有方法不对外暴露
2. __name 除了他是私有的之外，更重要的是，他是受保护的，当有子类继承时，这个方法是不能被重写的。

```python
class Parent(object):
    def __test(self):
        print("test func")

    def _haha(self):
        self.__test()
        print("haha")

    def fuck(self):
        self.foo()
        print("parent fuck func")

    def foo(self):
        print("parent foo func")


class Child(Parent):

    # def _haha(self):
        # self.__test()
        # print("child call __test")
        
    def __test(self):
        print("child __test func")

    # def fuck(self):
    #     print("child fuck func")

    def foo(self):
        print("child foo func")

        
p = Parent()
c = Child()

c.fuck()		# 你发现子类中的foo函数被调用了
c._haha()		# 你会发现调用的仍然父类中的__test,他并没有被重写

```

