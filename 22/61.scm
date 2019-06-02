; Exercise 2.61.  Give an implementation of adjoin-set using the ordered representation. By analogy with element-of-set? show how to take advantage of the ordering to produce a procedure that requires on the average about half as many steps as with the unordered representation.

(load "ch22_common.scm")

(define (adjoin-set x set)
  (cond ((or (null? set) (< x (car set))) (cons x set))
        ((= x (car set)) set)
        (else (cons (car set) (adjoin-set x (cdr set))))))

(assert (adjoin-set '1 '()) '(1))
(assert (adjoin-set '1 '(1)) '(1))
(assert (adjoin-set '1 '(2)) '(1 2))
(assert (adjoin-set '2 '(1)) '(1 2))

; All complexity of adjoin-set in unordered representation lies in element-of-set?. If x is element of set then in best case we'll find it out in 1 step, in worst case in n steps, in average case in n/2 steps. Same numbers hold for adjoin-set in ordered representation.

; But what if x isn't an element of set? adjoin-set in unordered representation will find it out in n steps, while ordered representation is analogous to previous case: 1 step in best, n steps in worst, n/2 in average case. Thus, ordered representation requires on average only half of steps required for unordered representation when x is not an element of set.
