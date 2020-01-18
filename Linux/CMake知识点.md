## 内部构建与外部构建

内部构建就是直接在主目录执行构建程序生成程序，但是会产生很多的中间文件。所以我们会mkdir一个build目录，然后在build文件夹里面构建整个程序，这个就叫做外部构建。



- 首先，请清除t1目录中除main.c CmakeLists.txt 之外的所有中间文件，最关键
  的是CMakeCache.txt。
- 在 t1目录中建立build 目录，当然你也可以在任何地方建立build目录，不一定必
  须在工程目录中。
- 进入 build目录，运行cmake ..(注意,..代表父目录，因为父目录存在我们需要的
  CMakeLists.txt，如果你在其他地方建立了build目录，需要运行cmake <工程的全
  路径>)，查看一下build目录，就会发现了生成了编译需要的Makefile以及其他的中间
  文件.
- 运行 make 构建工程，就会在当前目录(build目录)中获得目标文件 hello。



## 换个地方保存目标二进制

不论是SUBDIRS还是 ADD_SUBDIRECTORY指令(不论是否指定编译输出目录)，我们都可以通过SET指令重新定义EXECUTABLE_OUTPUT_PATH 和LIBRARY_OUTPUT_PATH 变量来指定最终的目标二进制的位置(指最终生成的hello或者最终的共享库，不包含编译生成的中间文件)

```cmake
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
```

在第一节我们提到了\<projectname>_BINARY_DIR和PROJECT_BINARY_DIR 变量，他们指的编译发生的当前目录，如果是内部编译，就相当于 PROJECT_SOURCE_DIR 也就是工程代码所在目录，如果是外部编译，指的是外部编译所在目录，也就是本例中的 build目录。
所以，上面两个指令分别定义了：可执行二进制的输出路径为build/bin 和库的输出路径为build/lib.



## 如何指定lib的输出目录

如果你要指定libhello.so生成的位置，可以通过在主工程文件CMakeLists.txt 中修改ADD_SUBDIRECTORY(lib)指令来指定一个编译输出位置或者在lib/CMakeLists.txt 中添加SET(LIBRARY_OUTPUT_PATH <路径>)来指定一个新的位置。



## cmake 调用环境变量的方式

使用`$ENV{NAME}`指令就可以调用系统的环境变量了。

比如:

```cmake
MESSAGE(STATUS “HOME dir: $ENV{HOME}”)
```

设置环境变量的方式是：

```cmake
SET(ENV{变量名} 值)
```



## gtest和gtest_main的区别

如果你要自己写main函数入口，用gtest_main，不然就是用gtest

https://stackoverflow.com/questions/6457856/whats-the-difference-between-gtest-lib-and-gtest-main-lib



## 如何解决 find_package(GTest REQUIRED)失败

https://stackoverflow.com/questions/24295876/cmake-cannot-find-googletest-required-library-in-ubuntu

https://blog.csdn.net/chengde6896383/article/details/88888064



## CMake 常用变量

### CMAKE_INCLUDE_PATH



### CMAKE_LIBRARY_PATH



### CMAKE_BINARY_DIR

和他相同的有：

- PROJECT_BINARY_DIR
- \<projectname\>\_BINARY_DIR

这三个变量指代的内容是一致的，如果是 in source 编译，指得就是工程顶层目录，如果是out-of-source 编译，指的是工程编译发生的目录。PROJECT_BINARY_DIR跟其他指令稍有区别，现在，你可以理解为他们是一致的。



### CMAKE_SOURCE_DIR

和他相同的有：

- PROJECT_SOURCE_DIR
- \<projectname\>\_SOURCE_DIR

这三个变量指代的内容是一致的，不论采用何种编译方式，都是工程顶层目录。也就是在in source 编译时，他跟 CMAKE_BINARY_DIR 等变量一致。PROJECT_SOURCE_DIR 跟其他指令稍有区别，现在，你可以理解为他们是一致的。



### CMAKE_CURRENT_SOURCE_DIR

指的是当前处理的CMakeLists.txt 所在的路径，比如上面我们提到的 src 子目录。



### CMAKE_CURRRENT_BINARY_DIR

如果是in-source 编译，它跟 CMAKE_CURRENT_SOURCE_DIR 一致，如果是out-of-source 编译，他指的是target编译目录。使用我们上面提到的ADD_SUBDIRECTORY(src bin)可以更改这个变量的值。使用SET(EXECUTABLE_OUTPUT_PATH <新路径>)并不会对这个变量造成影响，它仅仅修改了最终目标文件存放的路径。



### CMAKE_CURRENT_LIST_FILE

输出调用这个变量的CMakeLists.txt 的完整路径



### CMAKE_CURRENT_LIST_LINE

输出这个变量所在的行



### CMAKE_MODULE_PATH

这个变量用来定义自己的cmake 模块所在的路径。如果你的工程比较复杂，有可能会自己编写一些cmake 模块，这些cmake模块是随你的工程发布的，为了让cmake 在处理CMakeLists.txt 时找到这些模块，你需要通过SET 指令，将自己的cmake模块路径设置一下。
比如

```cmake
SET(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
```

这时候你就可以通过INCLUDE指令来调用自己的模块了。



### EXECUTABLE_OUTPUT_PATH 和 LIBRARY_OUTPUT_PATH

分别用来重新定义最终结果的存放目录，前面我们已经提到了这两个变量。



### PROJECT_NAME

返回通过PROJECT指令定义的项目名称。