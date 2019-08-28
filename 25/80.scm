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

(define comp00 (make-complex-from-real-imag 0 0))
(define comp01 (make-complex-from-real-imag 0 1))
(define comp10 (make-complex-from-real-imag 1 0))
(assert (=zero? comp00) #t)
(assert (=zero? comp01) #f)
(assert (=zero? comp10) #f)
