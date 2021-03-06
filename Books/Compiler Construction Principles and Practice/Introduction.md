## 1.2 Programs Related To Compilers

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



## 1.3 THE TRANSLATION PROCESS

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



#### THE PARSER

The parser receives the source code in the form of tokens from the scanner and performs ***syntax analysis***, which determines the structure of the program.

The results of syntax analysis are usually represented as a ***parse tree*** or a ***syntax tree***.

> **Expression**: a structural element

> **what is the difference between parse tree and syntax tree ?**
>
> A syntax tree is a condensation of the information contained in the parse tree.
>
> The parse tree is a concrete representation of the input. The parse tree retains all of the information of the input. The empty boxes represent whitespace, i.e. end of line.
>
> https://stackoverflow.com/questions/5026517/whats-the-difference-between-parse-tree-and-ast
>
> https://www.cnblogs.com/xiaomiao/p/3146390.html
>
> https://cloud.tencent.com/developer/ask/109053



#### THE SEMANTIC ANALYZER

The semantic of a program are its "meaning" as opposed to its syntax, or structure. 

The semantics of a program determine its runtime behavior, but most programming languages have features that can be determined prior to execution and yet cannot be conveniently expressed as syntax and analyzed by the parser.

> **static semantics** & **dynamic semantics**（静态语义和动态语义）
>
> Static semantics means you can do something before executing.
>
> Dynamic semantics means the properties of a program that can only be determined by executing it.



#### THE SOURCE CODE OPTIMIZER

Compilers often include a number of code improvement, or optimization, steps.

After semantic analysis we can perform most optimization steps depending only on the source code.

> three-address code & P-code & intermediate representation(IR)
>
> 1. What is the three-address code? 
> 2. What is the P-code?
> 3. What is the intermediate representation(IR)?

TODO



#### THE CODE GENERATOR

The code generator takes the intermediate code or IR and generates code for the target machine.

Not only is it necessary to use instructions as they exist on the target machine but decisions about the representation of data will now also play a major role, such as how many bytes or words variables of integer and floating-point data types occupy in memory.



#### THE TARGET CODE OPTIMIZER

In this phase, the compiler attempts to improve the target code generated by the code generator.

在从中间语言到目标语言生成的过程中，仍然会进行很多的优化的。



## 1.4 MAJOR DATA STRUCTURES IN A COMPILER

#### TOKENS

A Token which collects characters represents a meaningful element.



#### THE SYNTAX TREE

If the parser does generate a syntax tree, it is usually constructed as a standard pointer-based structure that is dynamically allocated as parsing proceeds.



#### THE SYMBOL TABLE

This data structure keeps information associated with identifiers: functions, variables, constants and data types. 



#### THE LITERAL TABLE

The literal table stores constants and strings used in a program.

###### Advantages

- Reduce the size of a program in memory by allowing the reuse of constants and strings.
- Code generator need it to construct symbolic addresses for literals.
- Entering data definitions in the target code file.



#### INTERMEDIATE CODE

...



#### TEMPORARY FILE

Historically, computers did not possess enough memory for an entire program to be kept in memory during compilation.

This problem was solved by using temporary files to hold the products of intermediate steps during translation or by compiling "on the fly", that is, keeing only enough information from earlier parts of the source program to enable translation to proceed.

> What is **backpatch address** ?
>
> TODO



## 1.5 OTHER ISSUES IN COMPILER STRUCTURE

The structure of a compiler may be viewed from many different angles.

#### ANALYSIS AND SYNTHESIS

###### analysis part of the compiler

Analyze the source program to compute its properties

- lexical analysis
- syntax analysis

- semantic analysis

###### synthesis part of the compiler

producing translated code

- code generation

> Optimization steps may involve both analysis and synthesis



#### FRONT END AND BACK END

This view regards the compiler as separated into those operations that depend only on the source language (the **front end**) and those operations that depend only on the target language (the **back end**).

###### Front end

- scanner
- parser

- semantic analyzer

###### Back end

- code generator



#### PASSES

A compiler often finds it convenient to process the entire source program several times before generating code. These repetitions are referred to as passes.

After initial pass, which constructs a syntax tree or intermediate code from the source, a pass consists of processing the intermediate representation, adding information to it, altering its structure, or producing a different representation.



