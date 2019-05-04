; Exercise 2.31.  Abstract your answer to exercise 2.30 to produce a procedure tree-map with the property that square-tree could be defined as

(load "ch22_common.scm")

(define (square-tree tree) (tree-map square tree))

(define (tree-map func tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (tree-map func sub-tree)
             (func sub-tree)))
       tree))

(assert (square-tree '(1 (2 (3 4) 5) (6 7))) '(1 (4 (9 16) 25) (36 49)))
