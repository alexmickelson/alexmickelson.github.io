---
layout: default
banner: main
title:  "Railway Pattern"
---

# Railway Pattern

Also Know as Railway Oriented Programming

## What is it?

The Railway Pattern is when every function in your code has 2 paths: A happy path, and a failure path.

Requirements for Railway Pattern:
- Every function recieves both happy and failure input
- Failure input returned unchanged
- Buisness is performed on happy input

Imagine two parallel railways

<!-- ![[Two Railways](https://fsharpforfunandprofit.com/rop/)](/assets/images/railway_pattern.png "Two Railways") -->
<img src="/assets/images/railway_pattern.png"
     alt="Two Railways https://fsharpforfunandprofit.com/rop/"
     class="articleImage" />

If you are ever on the green railway and detect some error or invalid state you can move to the red railway. Now you can handle errors elegantly without throwing exceptions!







## Excersize

Write a function to handle the registration of a new user.

According to *Secure by Design*, by Sawano, Johnsson, Deogun, there are 4 levels of validation that should happen on data. 

- Origin — Is the data from a legitimate sender?
- Size — Is it reasonably big?
- Lexical content — Does it contain the right characters and encoding?
- Syntax — Is the format right?
- Semantics — Does the data make sense?





#### Additional Resources

https://fsharpforfunandprofit.com/rop/

https://medium.com/@naveenkumarmuguda/railway-oriented-programming-a-powerful-functional-programming-pattern-ab454e467f31

https://proandroiddev.com/railway-oriented-programming-in-kotlin-f1bceed399e5

https://github.com/ecourtenay/ROP


https://en.wikipedia.org/wiki/Template_method_pattern