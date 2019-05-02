; Exercise 2.17.  Define a procedure last-pair that returns the list that contains only the last element of a given (nonempty) list:

(load "ch22_common.scm")

(define (last-pair l)
  (if (null? (cdr l))
      l
      (last-pair (cdr l))))

(assert (list 34) (last-pair (list 23 72 149 34)))
