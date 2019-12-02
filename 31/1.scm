; Exercise 3.1.  An accumulator is a procedure that is called repeatedly with a single numeric argument and accumulates its arguments into a sum. Each time it is called, it returns the currently accumulated sum. Write a procedure make-accumulator that generates accumulators, each maintaining an independent sum. The input to make-accumulator should specify the initial value of the sum; for example <...>.

(load "ch31_common.scm")

(define (make-accumulator sum)
  (lambda (addition)
    (set! sum (+ sum addition))
    sum))

(define A (make-accumulator 5))
(define B (make-accumulator 5))
(assert (A 10) 15)
(assert (A 10) 25)
(assert (B 10) 15)
(assert (B 10) 25)
