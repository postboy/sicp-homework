; Exercise 2.66.  Implement the lookup procedure for the case where the set of records is structured as a binary tree, ordered by the numerical values of the keys.

(load "ch23_common.scm")

; Let's represent record as a list. Let's suppose that key is first element of the list.
(define (make-record key value) (list key value))
(define (key record) (car record))
(define (value record) (cadr record))
(define (set-value! record value) (set-car! (cdr record) value))

(define (lookup given-key set)
  (cond ((null? set) false)
        ((= given-key (key (entry set))) (entry set))
        ((< given-key (key (entry set)))
         (lookup given-key (left-branch set)))
        (else
         (lookup given-key (right-branch set)))))

(define sample-tree
  (make-tree '(5 abc)
	     (make-tree '(1 def) nil nil)
	     (make-tree '(10 hjk) nil nil)))

(assert (lookup 5 sample-tree) '(5 abc))
(assert (lookup 1 sample-tree) '(1 def))
(assert (lookup 10 sample-tree) '(10 hjk))
(assert (lookup 0 sample-tree) #f)
