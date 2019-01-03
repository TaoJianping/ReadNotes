```shell
# 显示时间
date

# 显示日历
cal [int->int] [year->int]
cal 1 2019

# 当前目录
pwd

# 显示当前目录
ls [-lah]
	-l		# 显示详细信息
	-a		# 现实全部
	
# 清除当前终端的信息
clear

# 新建文件夹 or 文件
mkdir

# 删除文件夹
rmdir

# 新建文件
touch file.txt

# 删除文件
rm [file_name]

# 修改和移动文件
mv [源文件] [复制过去的文件名称或路径]

# 复制文件
cp [源文件] [复制过去的文件名称或路径]

# 比较文件差异
diff [file_a] [file_b]

# 查看文件
cat 
head -n [i->int]		# 看前i行
tail -n [i->int]		# 看后i行
less					# 能够上下移动文本

# 统计文本
wc		# words calculate		line_number  words_number char_number file_name
	-l		# 只计算行数
	-w		# 看多少个单词
	-c		# 只看多少个字符
	
# 更改权限
chmod [i->int] file_name
chmod 444 file_name	
chmod ug-r file_name		# user和小组减去读权限

# 查找字符
grep [要查找的字符] [file_name]		# grep xxx xxx, 注意中间的可以是正则
```



#### Linux 权限

![image](https://wx3.sinaimg.cn/large/005wgNfbgy1fyr17l98mxj30hn0bpq4t.jpg)