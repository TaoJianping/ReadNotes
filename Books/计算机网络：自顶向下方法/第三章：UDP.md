# UDP

#### 多路复用和多路分解

> 多路复用：从源主机的不同套接字中收集数据块，并为每个数据块封装上首部信息（这将在多路分解时使用）从而生成报文段，然后将报文段传递到网络层的工作称为多路复用。
>
> 多路分解：将运输层报文段中的数据交付到正确的套接字的工作称为多路分解。
>
> 多路传输/多路分解让TCP/IP协议栈较低层的协议不必关心哪个程序在传输数据。与应用程序相关的操作都由传输层完成了，数据通过一个与应用程序无关的管道在传输层与网际层之间传递。



### UDP 和 TCP的区别

1. 是否面向连接
2. udp的开销小，报文首部开销只有８个字节，而TCP有２０个字节
3. UDP是报文，TCP是流



## UDP

#### 定义

UDP基本上定义了运输层能干的最少的事情。只有基本的复用、分解和少量的差错检查。并且他是无连接的，即它只是单纯的发送报文，并没有握手挥手来维持连接的行为。



#### 特点

1. **无连接的**，即发送数据之前不需要建立连接，因此减少了开销和发送数据之前的时延。
2. **不保证可靠交付**，因此主机不需要为此复杂的连接状态表
3. **面向报文的**，意思是 UDP 对应用层交下来的报文，既不合并，也不拆分，而是保留这些报文的边界，在添加首部后向下交给 IP 层。
4. **没有阻塞控制**，因此网络出现的拥塞不会使发送方的发送速率降低。
5. **支持一对一、一对多、多对一和多对多的交互通信**，也即是提供广播和多播的功能。
6. **首部开销小**，首部只有 8 个字节，分为四部分。



#### 报文结构

![image](https://wx3.sinaimg.cn/large/005wgNfbgy1fzb6myzv49j309v07nab2.jpg)

UDP的报文，首部有４个字段

1. 源端口：主要是回信的时候会用到
2. 目的端口号：交付到具体的端口
3. 报文的长度：是首部＋数据，在只有首部的情况，其最小值是 8
4. 检验和：用于确定是否报文的比特即数据发生了变化

每个字段都是16 bit，即２个字节。所以整个报文的长度是 64 + 数据的长度。



#### 如何进行检验和？

> UDP 数据报首部中检验和的计算方法比较特殊。  在计算检验和时，要在数据报之前增加 12 个字节的伪首部，用来计算校验和。  伪首部并不是数据报真正的首部，是为了计算校验和而临时添加在数据报前面的，在真正传输的时候并不会把伪首部一并发送。

![image](https://ws1.sinaimg.cn/large/005wgNfbgy1fzb7bgyqrzj30k10fodhe.jpg)

伪首部各个字段的含义

1. 第一字段，源 IP 地址
2. 第二字段，目的 IP 地址
3. 第三字段，字段全 0
4. 第四字段，IP 首部中的协议字段的值，对于 UDP，此字段值为 17
5. 第五字段，UDP 用户数据报的长度













[参考文章](https://segmentfault.com/a/1190000008543293)



## 参考

https://jerryc8080.gitbooks.io/understand-tcp-and-udp/

