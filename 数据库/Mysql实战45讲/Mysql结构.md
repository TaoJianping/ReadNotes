# MySql 框架体系

![image](https://wx4.sinaimg.cn/large/005wgNfbgy1fza3qti418j30ob0i2jwk.jpg)



#### MySql的更新流程



#### redo log 和 binlog



#### WAL

如果跟新数据每一次都要读写一次磁盘，那么他会非常的慢，所以就出现了wal技术，全称是 write ahead logging，先写日志，再写磁盘。

