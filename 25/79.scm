; Exercise 2.79.  Define a generic equality predicate equ? that tests the equality of two numbers, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.

; Solution is there:
(load "ch25_common.scm")

(assert (equ? sn0 sn1) #f)
(assert (equ? sn0 sn0) #t)

(define rat0-second (make-rational 0 2))
(define rat1-second (make-rational 2 2))
(assert (equ? rat1 rat05) #f)
(assert (equ? rat0 rat1) #f)
(assert (equ? rat0 rat0-second) #t)
(assert (equ? rat1 rat1-second) #t)

(assert (equ? comp01 comp00) #f)
(assert (equ? comp10 comp00) #f)
(assert (equ? comp00 comp00) #t)
