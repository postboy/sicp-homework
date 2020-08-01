#!/bin/sh

# -rdynamic for stacktraces, -g for debugging
gcc -g -rdynamic runtime.c primitives.c evaluator.c interpreter.c -o lisp
