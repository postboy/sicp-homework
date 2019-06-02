; Exercise 2.57.  Extend the differentiation program to handle sums and products of arbitrary numbers of (two or more) terms. <...> Try to do this by changing only the representation for sums and products, without changing the deriv procedure at all. For example, the addend of a sum would be the first term, and the augend would be the sum of the rest of the terms.

(load "ch23_common.scm")

(define (augend l)
  (define (sum-of l)
    (if (null? (cdr l))
	(car l)
	(make-sum (car l) (sum-of (cdr l)))))
  (sum-of (cddr l)))

(define (multiplicand l)
  (define (product-of l)
    (if (null? (cdr l))
	(car l)
	(make-product (car l) (product-of (cdr l)))))
  (product-of (cddr l)))

(assert (deriv '(+ x x x) 'x) 3)
(assert (deriv '(* x x x) 'x) '(+ (* x (+ x x)) (* x x)))
(assert (deriv '(* x y (+ x 3 1)) 'x) '(+ (* x y) (* y (+ x 3 1))))
