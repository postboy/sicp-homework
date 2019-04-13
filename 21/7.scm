; Exercise 2.7.  Alyssa's program is incomplete because she has not specified the implementation of the interval abstraction. Here is a definition of the interval constructor: <...>. Define selectors upper-bound and lower-bound to complete the implementation.

(load "ch21_common.scm")

(define (make-interval a b) (cons a b))

; According to section 2.1.4, make-interval's arguments are always lower bound and upper bound, in that order. It simplifies an implementation of selectors. More reliable selectors are easy to implement too, but if we want to pursuit reliability, it would be better to implement make-interval in more reliable way instead.

(define (lower-bound i) (car i))
(define (upper-bound i) (cdr i))

(define sample-int (make-interval 1 2))
(assert (lower-bound sample-int) 1)
(assert (upper-bound sample-int) 2)
