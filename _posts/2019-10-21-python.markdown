---
layout: default
banner: main
title:  "Python"
date:   2019-10-21 16:00:00 +0000
---
# Python

You should always use python3, as python2 is being depricated in [january 2020](https://www.python.org/dev/peps/pep-0373/). 

Pythons name originates because Guido van Rossum (python's creator) was reading the script of Monty Python's Flying Circus when he began implementing python. [source](https://docs.python.org/2/faq/general.html#why-is-it-called-python)

#### Python peps

peps are the official refference for documentation, style and all things python. I will try to reference peps when I can. 

#### Cheese shop

Pip is the package manager for python. You can view (and submit) pip packages on [pypi.org](pypi.org). pipy.org is refered to as the cheese shop after the [monty python sketch](https://www.youtube.com/watch?v=Hz1JWzyvv8A). Why name your package manager's website after that sketch, I haven't found a [definitive answer](https://wiki.python.org/moin/CheeseShop).

When using pip use python3 -m pip install <packageName> so that you don't have to deal with environment misalignments (did you install/upgrade the package in the global space? the user space? the directory/package space?)

#### Type checking 

Suprisingly, you can put type checking in an interpreted language. Check out https://mypy.readthedocs.io/en/latest/cheat_sheet_py3.html for a cheat sheet.

#### virtual environments

https://code.visualstudio.com/docs/python/environments

Python virtual environments are a way of managing your dependencies across projects. There is a default or global environment that can easily get cluttered every time you pip install another package. Sometimes projects requre conflicting versions of a module. 
A python virtual environment is a directory, usually in the ~/.enviroments folder, that stores a list of modules that enviroment has. Tools like vscode can automatically detect the virtual enviroments in your machine to run their debuggers. Whenever you use python in production you should run it in a virtual environment.  

to switch to a virtual environment run
python3 -m venv EnviromentDirectory

