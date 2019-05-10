; Exercise 2.41.  Write a procedure to find all ordered triples of distinct positive integers i, j, and k less than or equal to a given integer n that sum to a given integer s.

(load "ch22_common.scm")

(define (unique-triples n)
  (flatmap
   (lambda (i)
     (flatmap (lambda (j)
	    (map (lambda (k) (list k j i))
		 (enumerate-interval 1 (- j 1))))
	  (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(assert (unique-triples 0) '())
(assert (unique-triples 1) '())
(assert (unique-triples 2) '())
(assert (unique-triples 3) '((1 2 3)))
(assert (unique-triples 4) '((1 2 3) (1 2 4) (1 3 4) (2 3 4)))

(define (triples-that-sum s n)
  (filter (lambda (x) (eq? (+ (car x) (cadr x) (caddr x)) s))
	  (unique-triples n)))

(assert (triples-that-sum 0 0) '())
(assert (triples-that-sum 1 1) '())
(assert (triples-that-sum 2 2) '())
(assert (triples-that-sum 3 3) '())
(assert (triples-that-sum 4 4) '())
(assert (triples-that-sum 5 5) '())
(assert (triples-that-sum 6 3) '((1 2 3)))
(assert (triples-that-sum 6 2) '())
(assert (triples-that-sum 7 7) '((1 2 4)))
(assert (triples-that-sum 8 8) '((1 3 4) (1 2 5)))
