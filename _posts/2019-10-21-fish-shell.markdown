---
layout: default
title:  "Fish Shell"
banner: fish
date:   2019-10-21 16:00:00 +0000
---
# Fish Shell

## a command line shell for the 90s!

> tl;dr - sudo apt install fish; fish; fish_config

The Fish shell looks like bash but has a couple nice features.

* auto complete - fish will give recomended auto completion
* try to cd /etc and look around your directories, use tab and arrow keys

### Make your own fish functions

You can make any fish function if you write it in a .fish file under ~/.config/fish/*

Here is my favorite git helper function written in fish

> function commit --description "add, commit, and push in one line"   
>     git add --all
>     git commit -m "$argv"
>     git push
> end

### Helpful Articles

Git Prompt:

https://medium.com/@joshuacrass/git-fish-prompt-faa389fff07c

Bash git prompt also has a fish prompt:

https://github.com/magicmonty/bash-git-prompt

Awesome Fish:

https://github.com/jorgebucaran/awesome-fish
