; Exercise 1.21.  Use the smallest-divisor procedure to find the smallest divisor of each of the following numbers: 199, 1999, 19999.

(load "ch1_common.scm")

(define (divides? a b)
  (= (remainder b a) 0))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (smallest-divisor n)
  (find-divisor n 2))

; easy enough!
(assert 199 (smallest-divisor 199))
(assert 1999 (smallest-divisor 1999))
(assert 7 (smallest-divisor 19999))

; crosschecked: https://github.com/ivanjovanovic/sicp/blob/master/1.2/e-1.21.scm
