# Shell 脚本


```shell

```

#### 定义变量

```shell
# 变量定义的时候=号两边不能空格
a=10
b=20
```



#### if 语句

```shell
# shell 的if语句，注意，判断语句里面都是要加空格的，大于小于号用-gt之类的代替
if [ $a -gt $b ]
then
	echo $a
else
	echo $b
fi
```



#### 解压和压缩

```shell
# 压缩
tar -zcvf new_file_name file_or_dir
	-z		# 使用gzip
	-c		# 创建目标
	-v		# 显示创建过程
	-f		# 重命名目标文件
	
# 解压
tar -zxvf new_file_name file_or_dir
	-x
```



#### shell输入

```shell
# shell的输入
echo "enter a"
read a		# 就是scanf

echo 'enter b'
read b
```



#### 比较字符串

```shell
# 关于字符串的比较
s="hello"
if [ -z s]		# 判断字符为空
if [ -n s]		# 判断字符飞空
if [ $s = $s]	# 判断字符是否相等，用单等于号
if [ $s != $s]	# 判断字符不相等
```



#### 数字运算

```shell
# 数字运算的格式：`expr 公式 `
# 外面的是反引号
c=`expr $a + $b`		# 数字运算的时候要用`expr `
echo $c

c=`expr $a \* $b`		# 注意，乘号需要被转义
echo $c
```



#### 全局变量

```shell
$HOME		# 主目录
$USER 		# 用户名
$0			# 当前的文件名
$#			# 传递到脚本的参数个数
$* 			# 以一个单字符串显示所有向脚本传递的参数
$$			# 脚本运行的当前进程ID号
$!			# 后台运行的最后一个进程的ID号
$@			# 与$*相同，但是使用时加引号，并在引号中返回每个参数。
$- 			# 显示Shell使用的当前选项，与set命令功能相同。
$?			# 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
```



#### 一些骚操作

```shell
# 设置环境变量
PATH=$PATH:/home/...
```

