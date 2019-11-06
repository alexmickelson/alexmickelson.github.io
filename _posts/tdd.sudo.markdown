---
layout: default
banner: practice
title:  "Test Drive Development"
date:   2019-10-21 16:00:00 +0000
---

# Test Driven Development

> "Legacy code is any code that does not have tests"
> \- Jonathan Allen

<img src="/assets/images/basil-blur-cheese-546945.jpg" alt="Picture of Spaghetti, by Maurijn Pach - pexels.com" />

> "The only thing standing between your code and the spaghetti it desires to be, are your tests"
> \- Alex Mickelson

"one of the things I have found really valuble for tests is that it makes your code flexible. [wiht TDD] you have a suite of tests you can run to check if your program works correctly. You are one click away from knowing if you logic was right"
\- Diego Vanegas

"The slowest way to check if your program is working is the debugger"
\- Heber Allen

It is really easy, like REALLY easy, to 


#### Terminology

* Unit test - A mini-program that checks the functionality of a unit of code.
* Integration test - A program that checks the combined functionality of multiple units of code
* TDD - Acronym for Test Driven Development
* Red, Green, Refactor - The TDD lifecycle
    * Red: You have a failing test, you cannot implement features/functionality unless you have a failing test. Code that does not compile is 'Red'.
    * Green: All your tests are passing. At this stage you are not allowed to add functionality to your code.
    * Refactor: Once your tests pass you should refactor your code. Your tests will tell you if you broke something. You are only allowed to change (refactor) existing code, not implement new code.



#### common pitfalls while testing


#### how to setup tests in each language

##### C++

Due to its age, C++ has the least support out of the box for unit testing. We will be using [Doctest](https://github.com/onqtam/doctest), an open source framework. 








