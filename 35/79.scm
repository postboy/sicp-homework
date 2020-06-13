; Exercise 3.79.  Generalize the solve-2nd procedure of exercise 3.78 so that it can be used to solve general second-order differential equations d2y/dt2 = f(dy/dt,y).

(load "77.scm")

(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f y dy))
  y)

(assert (stream-ref (solve-2nd (lambda (y dy) dy) 0.001 1 1) 1000) 2.716923932235896) ; e ~ 2.71828182846
(assert (stream-ref (solve-2nd (lambda (y dy) (- y)) 0.0001 1 0) 10472) 0.5000240628699462) ; cos pi/3 = 0.5
(assert (stream-ref (solve-2nd (lambda (y dy) (- y)) 0.0001 0 1) 5236) 0.5000141490501059) ; sin pi/6 = 0.5
