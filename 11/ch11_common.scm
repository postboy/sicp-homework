(load "../common.scm")

; sqrt

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (sqrt-good-enough? guess x)
      guess
      (sqrt-iter (sqrt-improve guess x)
                 x)))

(define (sqrt-good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))
