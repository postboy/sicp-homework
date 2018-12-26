; Exercise 1.29.  Simpson's Rule is a more accurate method of numerical integration than the method illustrated above. Using Simpson's Rule, the integral of a function f between a and b is approximated as <...> where h = (b - a)/n, for some even integer n, and yk = f(a + kh). (Increasing n increases the accuracy of the approximation.) Define a procedure that takes as arguments f, a, b, and n and returns the value of the integral, computed using Simpson's Rule. Use your procedure to integrate cube between 0 and 1 (with n = 100 and n = 1000), and compare the results to those of the integral procedure shown above.

(load "ch13_common.scm")

(define (cube x) (* x x x))

(define (inc n) (+ n 1))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (s-integral f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (term k)
    (cond ((or (= k 0) (= k n)) (y k))
	  ((even? k) (* 2 (y k)))
	  (else (* 4 (y k)))))
  (* (/ h 3) (sum term 0 inc n)))

; assert don't work here
(s-integral cube 0 1 100)  ; 1/4
(s-integral cube 0 1 1000) ; 1/4
; Indeed, this results are more exact than those we've got from an integral routine.
