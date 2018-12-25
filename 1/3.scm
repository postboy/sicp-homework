; Exercise 1.3.  Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

(load "ch11_common.scm")

(define (square x) (* x x))

(define (sum-of-squares x y)
	(+ (square x) (square y)))

(define (sum-of-largest-squares a b c)
	(cond ((and (< a b) (< a c)) (sum-of-squares b c))
	      ((and (< b a) (< b c)) (sum-of-squares a c))
	      (else (sum-of-squares a b))))

(assert 1 (square -1))
(assert 0 (square 0))
(assert 1 (square 1))
(assert 4 (square 2))

(assert 2 (sum-of-squares 1 -1))
(assert 13 (sum-of-squares -2 -3))

(assert 2 (sum-of-largest-squares 1 1 1))
(assert 13 (sum-of-largest-squares 1 2 3))
(assert 13 (sum-of-largest-squares 1 3 2))
(assert 13 (sum-of-largest-squares 2 1 3))
(assert 13 (sum-of-largest-squares 2 3 1))
(assert 13 (sum-of-largest-squares 3 1 2))
(assert 13 (sum-of-largest-squares 3 2 1))
