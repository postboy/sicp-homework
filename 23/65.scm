; Exercise 2.65.  Use the results of exercises 2.63 and 2.64 to give O(n) implementations of union-set and intersection-set for sets implemented as (balanced) binary trees.

(load "62.scm")
(load "63.scm")
(load "64.scm")

(define (union-set-tree set1 set2)
  (list->tree (union-set (tree->list set1)
			 (tree->list set2))))

(define (intersection-set-tree set1 set2)
  (list->tree (intersection-set (tree->list set1)
				(tree->list set2))))

(define sample-set1 (list->tree '(1 2 3)))
(define sample-set2 (list->tree '(2 3 5)))

(assert (union-set-tree sample-set1 sample-set1) sample-set1)
(assert (union-set-tree sample-set1 sample-set2) (list->tree '(1 2 3 5)))
(assert (intersection-set-tree sample-set1 sample-set1) sample-set1)
(assert (intersection-set-tree sample-set1 sample-set2) (list->tree '(2 3)))
