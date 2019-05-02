; Exercise 2.18.  Define a procedure reverse that takes a list as argument and returns a list of the same elements in reverse order:

(load "ch22_common.scm")

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(define (reverse l)
  (if (null? l)
      l
      (append (reverse (cdr l)) (list (car l)))))

(assert (list 25 16 9 4 1) (reverse (list 1 4 9 16 25)))
(assert (list) (reverse (list)))
