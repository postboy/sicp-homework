; Exercise 3.53.  Without running the program, describe the elements of the stream defined by <...>.

(load "ch35_common.scm")

(define s (cons-stream 1 (add-streams s s)))
; 2^n, where n = 0, 1...
(assert (stream-ref s 0) 1) ; hardcoded
(assert (stream-ref s 1) 2) ; s[0] + s[0] = 2*s[0] = 2^1
(assert (stream-ref s 2) 4) ; 2*s[1] = 2*2 = 2^2
(assert (stream-ref s 3) 8) ; 2*s[2] = 2^3
