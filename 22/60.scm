; Exercise 2.60.  We specified that a set would be represented as a list with no duplicates. Now suppose we allow duplicates. For instance, the set {1,2,3} could be represented as the list (2 3 2 1 3 2 2). Design procedures element-of-set?, adjoin-set, union-set, and intersection-set that operate on this representation. How does the efficiency of each compare with the corresponding procedure for the non-duplicate representation? Are there applications for which you would use this representation in preference to the non-duplicate one?

(load "ch22_common.scm")

; element-of-set? is unchanged
(assert (element-of-set? 'a '(a a)) #t)
(assert (element-of-set? 'b '(a a)) #f)

; complexity: O(1) vs. O(n) without duplicates
(define (adjoin-set x set)
  (cons x set))

(assert (adjoin-set 'a '()) '(a))
(assert (adjoin-set 'a '(b)) '(a b))
(assert (adjoin-set 'a '(a)) '(a a))

; complexity: O(n) (given that we use append as defined in 2.18) vs. O(n^2) without duplicates
(define (union-set set1 set2)
  (append set1 set2))

(assert (union-set '() '()) '())
(assert (union-set '() '(a)) '(a))
(assert (union-set '(a) '()) '(a))
(assert (union-set '(a) '(a)) '(a a))
(assert (union-set '(a) '(b)) '(a b))
(assert (union-set '(a a) '(b b)) '(a a b b))

; intersection-set is unchanged
(assert (intersection-set '(a a) '(b b)) '())
(assert (intersection-set '(a a) '(a a a)) '(a a))

; This representation allows to achieve much cheaper adjoin-set and union-set operations. But what is the cost? First of all, in general it's additional memory for storing sets. Secondly, element-of-set? and intersection-set are generaly work slower with this representation because duplicates are producing extra work.

; Consequently, this representation is better for some settings.
; a) Setting where duplicates are really unlikely.
; b) Setting where simultaneously:
; - adjoin-set and union-set are used much more intensively than element-of-set? and intersection-set;
; - extra memory usage is not a problem.
