; Exercise 3.18.  Write a procedure that examines a list and determines whether it contains a cycle, that is, whether a program that tried to find the end of the list by taking successive cdrs would go into an infinite loop. Exercise 3.13 constructed such lists.

(load "16.scm")

; As far as I understand, here we try to detect cycles only in high-level list. Leafs of high-level list can be lists too, but we will not detect cycles that involve them.

(define (is-cyclic? x)
  (define (is-cyclic-internal x seen)
    (cond ((null? x) #f)
	  ((memq x seen) #t)
	  (else (is-cyclic-internal (cdr x) (cons x seen)))))
  (is-cyclic-internal x nil))

(assert (is-cyclic? nil) #f)
(assert (is-cyclic? z1) #f)
(assert (is-cyclic? z2) #f)
(assert (is-cyclic? z3) #f)
(assert (is-cyclic? z4) #t)
