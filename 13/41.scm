; Exercise 1.41.  Define a procedure double that takes a procedure of one argument as argument and returns a procedure that applies the original procedure twice. For example, if inc is a procedure that adds 1 to its argument, then (double inc) should be a procedure that adds 2. What value is returned by

(load "ch13_common.scm")

(define (double f) (lambda (x) (f (f x))))

(assert 2 ((double inc) 0))
(assert 4 (((double double) inc) 0))
(assert 16 (((double (double double)) inc) 0))
(assert 256 (((double (double (double double))) inc) 0))

(assert 21 (((double (double double)) inc) 5))
; This expression will expand to (((double (double (double (double inc))))) 5).
; Overall number of increments will be 2^4 = 16.
; 5 + 16*1 = 21
