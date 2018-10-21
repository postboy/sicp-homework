; Exercise 1.10.  The following procedure computes a mathematical function called Ackermann's function.

(load "ch1_common.scm")

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

; What are the values of the following expressions?

(assert (A 1 10) 1024)
; (A 0 (A 1 9))
; (A 0 (A 0 (A 1 8)))
; (A 0 x3 (A 1 7))
; (A 0 x9 (A 1 0))
; (A 0 x9 2)
; 1024 = 2^10

(assert (A 2 4) 65536)
; (A 1 (A 1 (A 1 (A 2 1))))
; (A 1 (A 1 (A 1 2))) ; 2^2 = 4
; (A 1 (A 1 4)) ; 2^4 = 16
; (A 1 16)
; 2^16 = 65536

(assert (A 3 3) 65536)
; (A 2 (A 2 (A 3 1)))
; (A 2 (A 2 2))
; (A 2 (A 1 (A 2 1)))
; (A 2 (A 1 2))
; (A 2 4) ; see previous expression

; Consider the following procedures, where A is the procedure defined above: <...>. Give concise mathematical definitions for the functions computed by the procedures f, g, and h for positive integer values of n. For example, (k n) computes 5*n^2.

(define (f n) (A 0 n))
; 2*n

(define (g n) (A 1 n))
; 2^n

(define (h n) (A 2 n))
; 2[(^2) repeats (n-1) times], i.e. for n=1 it's 2, for n=4 it's 2^2^2^2

(assert (A 2 4) 65536) ; 2^16 = (2^8)^2 = ((2^4)^2)^2 = (((2^2)^2)^2)^2
(assert (A 2 3) 16) ; 2^4 = (2^2)^2
(assert (A 2 2) 4) ; 2^2 = (2^1)^2
(assert (A 2 1) 2) ; 2^1
(assert (A 2 0) 0)
