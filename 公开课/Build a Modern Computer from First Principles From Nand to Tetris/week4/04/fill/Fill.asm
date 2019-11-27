// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.


// initial parameter
@8192
D=A
@R0
M=D  

// set start address
@SCREEN
D=A
@StartAddress
M=D

(ListenKeyOn)
    // set start address
    @SCREEN
    D=A
    @StartAddress
    M=D
    @KBD
    D=M
    @ListenKeyOn
    D;JEQ
    @FillOutScreen
    0;JMP

// if KBD != 0 loop
(ListenKeyOFF)
    // set start address
    @SCREEN
    D=A
    @StartAddress
    M=D
    @KBD
    D=M
    @ListenKeyOFF
    D;JNE
    @ClearScreen
    0;JMP




(FillOutScreen)
    // set i
    @i
    M=0

    // set n = 8192
    @R0
    D=M
    @n
    M=D

(StartFill)
    // if n < 0 goto @END
    @n
    M=M-1
    D=M
    @ListenKeyOFF
    D;JLT
    // else

    @StartAddress
    A=M
    M=-1

    @StartAddress
    M=M+1

    @StartFill
    0;JMP


(ClearScreen)
    // set i
    @i
    M=0

    // set n = 8192
    @R0
    D=M
    @n
    M=D


(StartClear)
    // if n < 0 goto @END
    @n
    M=M-1
    D=M
    @ListenKeyOn
    D;JLT
    // else

    @StartAddress
    A=M
    M=0

    @StartAddress
    M=M+1

    @StartClear
    0;JMP


(END)
    @END 
    0;JMP