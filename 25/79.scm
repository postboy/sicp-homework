; Exercise 2.79.  Define a generic equality predicate equ? that tests the equality of two numbers, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.

; Solution is there:
(load "ch25_common.scm")

(define sn0 (make-scheme-number 0))
(define sn1 (make-scheme-number 1))
(assert (equ? sn0 sn1) #f)
(assert (equ? sn0 sn0) #t)

(define rat05 (make-rational 1 2))
(define rat0-first (make-rational 0 1))
(define rat0-second (make-rational 0 2))
(define rat1-first (make-rational 1 1))
(define rat1-second (make-rational 2 2))
(assert (equ? rat1-first rat05) #f)
(assert (equ? rat0-first rat1-first) #f)
(assert (equ? rat0-first rat0-second) #t)
(assert (equ? rat1-first rat1-second) #t)

(define comp01 (make-complex-from-real-imag 0 1))
(define comp10 (make-complex-from-real-imag 1 0))
(define comp11 (make-complex-from-real-imag 1 1))
(assert (equ? comp01 comp11) #f)
(assert (equ? comp10 comp11) #f)
(assert (equ? comp11 comp11) #t)
