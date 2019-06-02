; Exercise 2.59.  Implement the union-set operation for the unordered-list representation of sets.

(load "ch22_common.scm")

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((element-of-set? (car set1) set2)
         (union-set (cdr set1) set2))
        (else (cons (car set1)
		    (union-set (cdr set1) set2)))))

(assert (union-set '() '()) '())
(assert (union-set '() '(a)) '(a))
(assert (union-set '(a) '()) '(a))
(assert (union-set '(a) '(a)) '(a))
(assert (union-set '(a) '(b)) '(a b))
