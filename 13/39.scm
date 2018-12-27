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

(tan-cf 0 10) ; actual 0, expected 0
(tan-cf 1 10) ; 1.56, 1.56
(tan-cf 3 10) ; -0.14, -0.14
(tan-cf 9 10) ; -0.62, -0.45
(tan-cf 9 15) ; -0.45, -0.45
