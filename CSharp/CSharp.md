## 装箱和拆箱







## 方法的调用和栈

- 方法调用时栈内存的分配
  - 对stack frame 的分析

P9



## 显式和隐式转换是可以自定义的

```c#
namespace LearnCSharp
{
    internal class Program
    {
        public static void Main(string[] args)
        {
            var monster = new Monster();
            var human = (Human) monster;
        }

        enum Level
        {
            Low = 0,
            Middle = 1,
            High = 2,
        }

        public class Animal
        {
            public void Eating()
            {
                Console.WriteLine("I am eating....");
            }
        }

        public class Monster
        {
            // 显式转换
            public static explicit operator Animal(Monster monster)
            {
                Animal a = new Animal();
                return a;
            }
        }
        
        public class Human : Animal
        {
            public void Thinking()
            {
                Console.WriteLine("I am thinking");
            }
            
            // 隐式转换
            public static explicit operator Monster(Human human)
            {
                Monster a = new Monster();
                return a;
            }
        }
    }
}
```



## is和as

```c#
// is 就是判断他是不是一个类型的实例
// as关键字是转换，可以将对象转换为指定类型，与is不同，转换成功将会返回转换后的对象，不成功则不会抛出异常而是返回null 。
// expression as type = expression is type ? (type)expression : (type)null  

```



## ? 和 ?? 和 ?:

```c#
// ?: 就是三元表达式，和js差不多
var str = a > 60 ? true : false
```



## 拓展方法





## 委托

