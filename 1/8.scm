; Exercise 1.8.  Newton's method for cube roots is based on the fact that if y is an approximation to the cube root of x, then a better approximation is given by the value <...>

; Use this formula to implement a cube-root procedure analogous to the square-root procedure. (In section 1.3.4 we will see how to implement Newton's method in general as an abstraction of these square-root and cube-root procedures.)

(load "ch11_common.scm")

(define (improve guess x)
  (/ (+ (/ x (square guess))
	(* 2 guess))
     3))

; does the improvement of guess changed it less than on 0.1%?
(define (good-enough? guess x)
  (< (abs (- (improve guess x)
	     guess))
     (* 0.001 guess)))

(define (crt-iter guess x)
  (if (good-enough? guess x)
      guess
      (crt-iter (improve guess x)
                 x)))

(define (crt x)
  (if (> x 0)
      (crt-iter 1.0 x)
      0))

(crt 4000000000000000000000) ; ~1.59 * 10^7
(crt 0.000008) ; 0.02
(crt 27) ; 3
(crt 8) ; 2
(crt 1) ; 1
(assert 0 (crt 0))
(assert 0 (crt -1))
