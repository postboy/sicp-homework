(load "../common.scm")

; inc

(define (inc n) (+ n 1))

; test-factorial

(define (test-factorial f)
  (assert (f 0) 1)
  (assert (f 1) 1)
  (assert (f 2) 2)
  (assert (f 3) 6)
  (assert (f 4) 24)
  (assert (f 5) 120))
