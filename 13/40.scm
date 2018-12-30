; Exercise 1.40.  Define a procedure cubic that can be used together with the newtons-method procedure in expressions of the form <...> to approximate zeros of the cubic x^3 + a*x^2 + b*x + c.

(load "ch13_common.scm")

(define (cubic a b c)
  (lambda (x) (+ (cube x) (* (square x) a) (* b x) c)))

(assert (newtons-method (cubic 1 1 -3) 1) 1)
(assert (newtons-method (cubic 1 1 1) 1) -0.9999999999997796)
(assert (newtons-method (cubic 10 20 30) 1) -7.961132876317207)
