; Exercise 2.96.  a.    Implement the procedure pseudoremainder-terms, which is just like remainder-terms except that it multiplies the dividend by the integerizing factor described above before calling div-terms. Modify gcd-terms to use pseudoremainder-terms, and verify that greatest-common-divisor now produces an answer with integer coefficients on the example in exercise 2.95.

(load "95.scm")
; solution is in ch25_common.scm

; we can't use assert here because b) will change the result
; (polynomial x sparse (2 444) (1 -888) (0 444))
(greatest-common-divisor q1 q2)
(assert (mul q1 sample-poly) q1)
(assert (mul sample-poly q1) q1)
(assert (greatest-common-divisor empty-poly empty-poly) empty-poly)

; b.    The GCD now has integer coefficients, but they are larger than those of P1. Modify gcd-terms so that it removes common factors from the coefficients of the answer by dividing all the coefficients by their (integer) greatest common divisor.

(assert (greatest-common-divisor q1 q2) p1)
