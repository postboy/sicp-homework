#!/bin/sh

assert () {
    arg=$1
    expect=$2
    result=`./lisp "$arg"`
    if [ "$result" != "$expect" ]; then
	echo "error: $arg: $expect != $result"
    fi
}

# test of this test:
#assert 0 1
#assert '"a"' '"b"'
# are multiline reference values possible here?

# tests that pass
# several arguments at once
assert 0 0
assert 123 123
assert '"abc"' '"abc"'
assert "'6" 6
assert "'x" 'x'
assert "'()" "()"
assert "'(1)" "(1)"
assert "'(1 2)" "(1 2)"
assert "'(1 \"aaa\")" "(1 \"aaa\")"
assert "''a" "(quote a)"
assert "'''a" "(quote (quote a))"
assert "'(1 2)" "(1 2)"
assert "'(1 2 3)" "(1 2 3)"

# tests that don't pass yet. provide extra arguments to this script to run them
if [ "$#" -ne 0 ]; then
# (quote a a), (quote 1 1), (quote 1)?
assert "'(1 '\"aaa\")" "(1 (quote \"aaa\"))"
assert "(quote a)" "a"
assert "(quote (quote a))" "(quote a)"
assert "'(\"a\" \"b\" \"c\")" '("a" "b" "c")'

assert "1 1" "multiline"
assert '"aa" "aa"' "multiline"

assert "(cons 1 (cons 2 '()))" "(1 2)"

# unpaired brackets, other incomplete and incorrect constructions

assert if error
assert x error
fi
