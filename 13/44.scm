; Exercise 1.44.  The idea of smoothing a function is an important concept in signal processing. If f is a function and dx is some small number, then the smoothed version of f is the function whose value at a point x is the average of f(x - dx), f(x), and f(x + dx). Write a procedure smooth that takes as input a procedure that computes f and returns a procedure that computes the smoothed f. It is sometimes valuable to repeatedly smooth a function (that is, smooth the smoothed function, and so on) to obtained the n-fold smoothed function. Show how to generate the n-fold smoothed function of any given function using smooth and repeated from exercise 1.43.

(load "43.scm")

(define (average x y z)
  (/ (+ x y z) 3))

(define dx 0.001)

(define (smooth f)
  (lambda (x) (average (f (- x dx)) (f x) (f (+ x dx)))))

(assert 8 (cube 2))
((smooth cube) 2) ; 8.000004

(define (nsmooth f n)
  ((repeated smooth n) f))

((nsmooth cube 2) 2) ; 8.000008000000001
