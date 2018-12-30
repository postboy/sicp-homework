; Exercise 2.1.  Define a better version of make-rat that handles both positive and negative arguments. Make-rat should normalize the sign so that if the rational number is positive, both the numerator and denominator are positive, and if the rational number is negative, only the numerator is negative. 

(load "ch21_common.scm")

(assert (print-rat (make-rat -1 1)) (/ (- 1) 1))
(assert (print-rat (make-rat 1 -1)) (/ (- 1) 1))
(assert (print-rat (make-rat -1 -1)) (/ 1 1))
(assert (print-rat (make-rat 10 -20)) (/ (- 1) 2))
