; Exercise 2.80.  Define a generic predicate =zero? that tests if its argument is zero, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.

; Solution is there:
(load "ch25_common.scm")

(define sn0 (make-scheme-number 0))
(define sn1 (make-scheme-number 1))
(assert (=zero? sn0) #t)
(assert (=zero? sn1) #f)

(define rat0 (make-rational 0 100))
(define rat1 (make-rational 1 1))
(assert (=zero? rat0) #t)
(assert (=zero? rat1) #f)

(assert (=zero? comp00) #t)
(assert (=zero? comp01) #f)
(assert (=zero? comp10) #f)
