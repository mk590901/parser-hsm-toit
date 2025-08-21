# Parser HSM TOIT

The application demonstrates the work of a lexical parser based on a __hierarchical state machine__.

## Introduction
A hierarchical state machine allows one to simplify the number of operations on text during lexical parsing of an arithmetic expression and replace the logic of lexeme detection by transitions from state to state under the action of events.

## State Machine
Below is the parser's hierarchical state machine, implement the processing of the source arithmetic expression and extract lexemes (tokens).

![hsm](https://github.com/user-attachments/assets/6e142156-34e8-4bea-9267-674a1c6b6659)

## Implementation HSM
__ParserHelper__ is a set of transfer functions of the hierarchical state machine shown in the diagram above. This class is generated automatically by the HSM editor and developer only needs to comment out unnecessary transitions and add links to the parser functions inside the significant functions. The new version of the HSM graphical editor now generates code with "extra" transfer functions already commented out. This reduces the effort required to further modify the code.

## Description of application
The application is a __Toit__ app with a predefined set of arithmetic expressions. They can be selected using a combo box and parsed by pressing the parse button. The result of parsing is a list of tokens indicating the type and classification.

## Transformation of an infix expression into a postfix one

Actually, parsing, implemented using __HSM__, represented by threaded code, was the purpose of the application. But now I decided to supplement parsing with the operation of transforming an infix expression into a postfix one, or into "Polish" notation. This is not the pure __Shunting Yard Algorithm__ [https://en.m.wikipedia.org/wiki/Shunting_yard_algorithm#:~:text=In%20computer%20science%2C%20the%20shunting,abstract%20syntax%20tree%20(AST)], but some modified version of it that allows detecting some errors.

## Asynchronous processing of events.

Application uses of asynchronous processing of threaded code inside __Runner__ class. This allowed solving the problem of hidden recursion when calling functions. The custom __Queue__ class, builtin __Semaphore__ implements the mechanism of posting of events via the add event operation and processing this event in the __subscribe__ method, which listens for changes of __Semaphore__.




