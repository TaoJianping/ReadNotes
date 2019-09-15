## Programs Related To Compilers

这边会介绍一些跟Compilers相关的程序。

#### Interpreters

解释器



#### ASSEMBLERS



#### LINKERS

应该就是链接器，功能有

- Linkers collects code separately compiled or assembled in different object files into a file that is directly executable.
- A linker also connects an object program to the code for standard library functions and to resources supplied by the operating system of the computer.



#### LOADERS

- A loader will resolve all relocatable addresses relative to a given base, or base, or address.



#### PREPROCESSORS

预处理器

- delete comments
- include other files
- perform macro substitutions



#### EDITORS

就是编辑器啦，输出一些符合规范的文件，包括正确的编码，当然发展到后期就出现了集成整个应用环境的IDE了。



#### DEBUGGERS

调试器

- A debugger is a program that can be used to determine execution errors in a compiled program.

- breakpoints：断点



#### PROFILERS

 描述器

- A profiler is a program that collects statistics on the behavior of an object program during execution.



#### PROJECT MANAGERS

组织项目的工具，毕竟现在的项目都很大了。



## THE TRANSLATION PROCESS

![image](https://wx3.sinaimg.cn/large/005wgNfbgy1g70fs6zvw1j30oh0csjsg.jpg)

A compiler consists internally of a number of steps, or phases, that perform distinct logical operation. Upper Figure shows the phases of a compiler.

We will briefly describe each phase here:

#### THE SCANNER

This phase of the compiler does the actual reading of the source program.

The scanner performs what is called  ***lexical analysis***: it collects sequences of characters into meaningful units call ***tokens***.

A scanner may perform other operations along with the recognition of tokens.

- Enter identifiers into the symbol table 
- Enter ***literals*** into literal table
- ...

> literals include numeric constants such as PI and quoted strings of text such as "Hello World"



