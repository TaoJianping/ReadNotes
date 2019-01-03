```shell
# 变量定义的时候=号两边不能空格
a=10
b=20

# shell 的if语句，注意，判断语句里面都是要加空格的，大于小于号用-gt之类的代替
if [ $a -gt $b ]
then
	echo $a
else
	echo $b
fi

# 关于字符串的比较
s="hello"
if [ -z s]		# 判断字符为空
if [ -n s]		# 判断字符飞空
if [ $s = $s]	# 判断字符是否相等，用单等于号
if [ $s != $s]	# 判断字符不相等


# shell的输入
echo "enter a"
read a		# 就是scanf

echo 'enter b'
read b

c=`expr $a + $b`		# 数字运算的时候要用`expr `
echo $c	

# 全局变量
HOME		# 主目录
USER 		# 用户名

# 设置环境变量
PATH=$PATH:/home/...

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

