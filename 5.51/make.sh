#!/bin/sh

# -rdynamic for stacktraces, -g for debugging
gcc -Werror -g -rdynamic runtime.c primitives.c combinations.c interpreter.c evaluator.c -o lisp
