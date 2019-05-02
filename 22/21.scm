; Exercise 2.21.  The procedure square-list takes a list of numbers as argument and returns a list of the squares of those numbers. Here are two different definitions of square-list. Complete both of them by filling in the missing expressions.

(load "ch22_common.scm")

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (square-list-1 items)
  (if (null? items)
      nil
      (cons (* (car items) (car items))
	    (square-list (cdr items)))))

(define (square-list-2 items)
  (map (lambda (x) (* x x)) items))

(assert (list 1 4 9 16) (square-list-1 (list 1 2 3 4)))
(assert (list 1 4 9 16) (square-list-2 (list 1 2 3 4)))
