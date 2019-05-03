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
      (cons (square (car items))
	    (square-list-1 (cdr items)))))

(define (square-list-2 items)
  (map square items))

(assert '(1 4 9 16) (square-list-1 '(1 2 3 4)))
(assert '(1 4 9 16) (square-list-2 '(1 2 3 4)))
