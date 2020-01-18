## PROJECT 指令

### 语法

PROJECT(projectname [CXX] [C] [Java])



### 作用

- 你可以用这个指令定义工程名称，并可指定工程支持的语言，支持的语言列表是可以忽略的，默认情况表示支持所有语言。

- 这个指令隐式的定义了两个 cmake 变量:
  - \<projectname>\_BINARY_DIR

  - \<projectname>\_SOURCE_DIR



## SET 指令
### 语法

```cmake
SET(VAR [VALUE] [CACHE TYPE DOCSTRING [FORCE]])
```



### 作用

现阶段，你只需要了解SET指令可以用来显式的定义变量即可。



### 示例

比如我们用到的是SET(SRC_LIST main.c)，如果有多个源文件，也可以定义成：

```cmake
SET(SRC_LIST main.c t1.c t2.c)
```



## MESSAGE 指令

### 语法

```cmake
MESSAGE([SEND_ERROR | STATUS | FATAL_ERROR] "message to display"...)
```



### 作用

这个指令用于向终端输出用户定义的信息，包含了三种类型:

- SEND_ERROR，产生错误，生成过程被跳过。
- SATUS，输出前缀为-的信息。
- FATAL_ERROR，立即终止所有cmake 过程.



## ADD_EXECUTABLE

### 语法

```cmake
ADD_EXECUTABLE(hello ${SRC_LIST})
```

定义了这个工程会生成一个文件名为hello 的可执行文件，相关的源文件是 SRC_LIST 中定义的源文件列表， 本例中你也可以直接写成ADD_EXECUTABLE(hello main.c)。



## ADD_SUBDIRECTORY 指令

### 语法

```cmake
ADD_SUBDIRECTORY(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```



### 作用

这个指令用于向当前工程添加存放源文件的子目录，并可以指定中间二进制和目标二进制存
放的位置。EXCLUDE_FROM_ALL参数的含义是将这个目录从编译过程中排除，比如，工程
的example，可能就需要工程构建完成后，再进入 example目录单独进行构建(当然，你
也可以通过定义依赖来解决此类问题)。



## INSTALL

### 目标文件的安装

#### 语法

```cmake
INSTALL(TARGETS targets...
		[[ARCHIVE|LIBRARY|RUNTIME]
				[DESTINATION <dir>]
				[PERMISSIONS permissions...]
				[CONFIGURATIONS
		[Debug|Release|...]]
				[COMPONENT <component>]
				[OPTIONAL]
			] [...])
```



##### TARGETS

参数中的TARGETS后面跟的就是我们通过ADD_EXECUTABLE 或者ADD_LIBRARY 定义的目标文件，可能是可执行二进制、动态库、静态库。目标类型也就相对应的有三种：

- ARCHIVE特指静态库
- LIBRARY特指动态库，
- RUNTIME特指可执行目标二进制。



##### DESTINATION

DESTINATION：定义了安装的路径

- 如果路径以/开头，那么指的是绝对路径，这时候CMAKE_INSTALL_PREFIX其实就无效了
- 如果你希望使用CMAKE_INSTALL_PREFIX来定义安装路径，就要写成相对路径，即不要以/开头，那么安装后的路径就是${CMAKE_INSTALL_PREFIX}/<DESTINATION定义的路径>



#### 示例

举个简单的例子：

```cmake
INSTALL(TARGETS myrun mylib mystaticlib
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib
            ARCHIVE DESTINATION libstatic
)
```

上面的例子会将：

- 可执行二进制myrun 安装到${CMAKE_INSTALL_PREFIX}/bin 目录
- 动态库libmylib安装到${CMAKE_INSTALL_PREFIX}/lib目录
- 静态库libmystaticlib 安装到${CMAKE_INSTALL_PREFIX}/libstatic目录



### 普通文件的安装

#### 语法

```cmake
INSTALL(FILES files... DESTINATION <dir>
            [PERMISSIONS permissions...]
            [CONFIGURATIONS [Debug|Release|...]]
            [COMPONENT <component>]
            [RENAME <name>] [OPTIONAL])
```



### 目录的安装

#### 语法

```cmake
INSTALL(DIRECTORY dirs... DESTINATION <dir>
            [FILE_PERMISSIONS permissions...]
            [DIRECTORY_PERMISSIONS permissions...]
            [USE_SOURCE_PERMISSIONS]
            [CONFIGURATIONS [Debug|Release|...]]
            [COMPONENT <component>]
            [[PATTERN <pattern> | REGEX <regex>]
            [EXCLUDE] [PERMISSIONS permissions...]] [...])
```



## ADD_LIBRARY

### 语法

```cmake
ADD_LIBRARY(libname [SHARED|STATIC|MODULE]
                [EXCLUDE_FROM_ALL]
                source1 source2 ... sourceN)
```



## SET_TARGET_PROPERTIES

### 语法

```cmake
SET_TARGET_PROPERTIES(target1 target2 ...
                        PROPERTIES prop1 value1
                        prop2 value2 ...)
```



#### SOVERSION

#### VERSION

#### CLEAN_DIRECT_OUTPUT

#### OUTPUT_NAME



## INCLUDE_DIRECTORIES

### 语法

```cmake
INCLUDE_DIRECTORIES([AFTER|BEFORE] [SYSTEM] dir1 dir2 ...)
```

这条指令可以用来向工程添加多个特定的头文件搜索路径，路径之间用空格分割，如果路径中包含了空格，可以使用双引号将它括起来，默认的行为是追加到当前的头文件搜索路径的后面，你可以通过两种方式来进行控制搜索路径添加的方式：

- CMAKE_INCLUDE_DIRECTORIES_BEFORE，通过SET这个cmake 变量为on，可以
  将添加的头文件搜索路径放在已有路径的前面。
- 通过AFTER 或者BEFORE参数，也可以控制是追加还是置前。



## LINK_DIRECTORIES

### 语法

```cmake
LINK_DIRECTORIES(directory1 directory2 ...)
```

这个指令非常简单，添加非标准的共享库搜索路径，比如，在工程内部同时存在共享库和可执行二进制，在编译时就需要指定一下这些共享库的路径。这个例子中我们没有用到这个指令。



## TARGET_LINK_LIBRARIES

```cmake
TARGET_LINK_LIBRARIES(target library1
                        <debug | optimized> library2
                        ...)
```



## FIND_PATH

FIND_PATH 用来在指定路径中搜索文件名，比如：

```cmake
FIND_PATH(myHeader NAMES hello.h PATHS /usr/include
					/usr/include/hello)
```

这里我们没有指定路径，但是，cmake 仍然可以帮我们找到hello.h 存放的路径，就是因
为我们设置了环境变量CMAKE_INCLUDE_PATH。



## FIND_LIBRARY



## [ExternalProject](https://cmake.org/cmake/help/latest/module/ExternalProject.html#id1)

### Contents

- [External Project Definition](https://cmake.org/cmake/help/latest/module/ExternalProject.html#external-project-definition)
- [Obtaining Project Properties](https://cmake.org/cmake/help/latest/module/ExternalProject.html#obtaining-project-properties)
- [Explicit Step Management](https://cmake.org/cmake/help/latest/module/ExternalProject.html#explicit-step-management)
- [Examples](https://cmake.org/cmake/help/latest/module/ExternalProject.html#examples)

