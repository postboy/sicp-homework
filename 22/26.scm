; Exercise 2.26.  Suppose we define x and y to be two lists. What result is printed by the interpreter in response to evaluating each of the following expressions?

(load "ch22_common.scm")

(define x (list 1 2 3))
(define y (list 4 5 6))

(assert (append x y) '(1 2 3 4 5 6))
(assert (cons x y)   '((1 2 3) 4 5 6))
(assert (list x y)   '((1 2 3) (4 5 6)))
