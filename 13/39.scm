; Exercise 1.39.  A continued fraction representation of the tangent function was published in 1770 by the German mathematician J.H. Lambert: <...> where x is in radians. Define a procedure (tan-cf x k) that computes an approximation to the tangent function based on Lambert's formula. K specifies the number of terms to compute, as in exercise 1.37.

(load "37.scm")

(define (tan-cf x k)
  (define (n i)
    (if (= i 1)
	x
	(- (square x))))
  (define (d i)
    (+ (* i 2) -1.0))
  (cont-frac n d k))

(assert (tan-cf 0 10) 0)
(assert (tan-cf 1 10) 1.557407724654902)
(assert (tan-cf 3 10) -0.1425465438397583)
(assert (tan-cf 9 15) -0.4523402017392058)
