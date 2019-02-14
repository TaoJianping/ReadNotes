#### 往返时间的估计和超时

因为TCP协议是用超时/重传协议来处理数据报文丢失的问题的。所以这个超时时间的设定就是重中之重。那我们应该如何设置这个超时时间呢？或者说我们应该通过哪些数据来组成这个超时时间呢？

首先要明确，我们这个超时时间要尽量大于RTT的时间，因为如果小于的话会造成频i繁的重传，但是也不能超过太多，也就是过分大于RTT的时间，这样的话会造成不必要的等待时间的浪费。 

所以确定这个RTT的大概时间是非常重要的。怎么求呢？

1. 大部分TCP的实现不会记录每份报文的RTT的时间，而只会记录某一刻一个报文的RTT时间，规范的说，就是仅为一个发送且尚未被确认的报文段记录一个RTT时间，记作SampleRTT

2. $$
   EstimatedRTT = ( 1 - α ) * EstimatedRTT + α * SampleRTT
   $$

   这个公式就是TCP维持的一个估计的RTT时间，其中SampleRTT的时间就是第一步中记录的数字，而α是个值，你可以自己在实现TCP的时候设置，但是根据[ RFC 6298 ]中的提议，通常α的值会被设置成0.125。

3. 除了SampleRTT和EstimatedRTT这两个数据，还需要求一个数据，就是每次SampleRTT记录的值的变化情况，我记得统计学里面是叫做偏差？早知道真的好好学了。[ RFC 6298 ] 定义了RTT偏差DevRTT，用于估算SampleRTT一般会偏离EstimatedRTT的程度
   $$
   DevRTT = ( 1- β ) * DevRTT + β * | SampleRTT - EstimatedRTT |
   $$
   注意到DevRTT是一个SampleRTT和EstimatedRTT之间差值的EWMA( Exponential Weighted Moving Average, EWMA )。代表的含义就是，如果SampleRTT的波动小，则DevRTT的值就小，反之就会很大。另外β的推荐值为0.25。

4. 好的，我们现在已经能够得到两个关键的数据，一个是EstimatedRTT，另一个是DevRTT。那我们如何设置超时间隔呢？很简单，首先，我们要尽量大于EstimatedRTT，不然会造成频繁的重传，毕竟EstimatedRTT某种程度上代表这EstimatedRTT的平均值，另外，也不能过大，这样会造成不必要的浪费。看，就像我们一开始提到的那样，好的，我们正好有DevRTT可以用，来避免这种状况。在上面这些想法之后，我们列出公式：
   $$
   TimeoutInterval = EstimatedRTT + 4 * DevRTT
   $$
   初始值我们推荐设置为1，随后超时直接加倍，只要收到报文段并更新EstimatedRTT，就使用上述公式再次计算TimeoutInterval。

