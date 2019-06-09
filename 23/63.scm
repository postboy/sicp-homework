; Exercise 2.63.  Each of the following two procedures converts a binary tree to a list.

(load "ch23_common.scm")

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

; a. Do the two procedures produce the same result for every tree? If not, how do the results differ? What lists do the two procedures produce for the trees in figure 2.16?

; Those functions produce the same result for every tree.

(define first-tree
  (make-tree 7
	     (make-tree 3
			(make-tree 1 nil nil)
			(make-tree 5 nil nil))
	     (make-tree 9
			nil
			(make-tree 11 nil nil))))

(define second-tree
  (make-tree 3
	     (make-tree 1 nil nil)
	     (make-tree 7
			(make-tree 5 nil nil)
			(make-tree 9
				   nil
				   (make-tree 11 nil nil)))))

(define third-tree
  (make-tree 5
	     (make-tree 3
			(make-tree 1 nil nil)
			nil)
	     (make-tree 9
			(make-tree 7 nil nil)
			(make-tree 11 nil nil))))

(assert '(1 3 5 7 9 11) (tree->list-1 first-tree))
(assert '(1 3 5 7 9 11) (tree->list-2 first-tree))
(assert '(1 3 5 7 9 11) (tree->list-1 second-tree))
(assert '(1 3 5 7 9 11) (tree->list-2 second-tree))
(assert '(1 3 5 7 9 11) (tree->list-1 third-tree))
(assert '(1 3 5 7 9 11) (tree->list-2 third-tree))

; b. Do the two procedures have the same order of growth in the number of steps required to convert a balanced tree with n elements to a list? If not, which one grows more slowly?

; Those functions have different orders of growth. First function looks simpler and clearer, but for collecting results it uses append (O(n)) and cons (O(1)) for every entry while second uses only cons. For that reason, second functions grows slower.

; Both functions implement a divide-and-conquer algorithms. Let's say that times required for solving task of size n with each of this algorithms are T1(n) and T2(n). In general, on each step we need to make O(n) or O(1) (first or second function) work and divide task on two equal subtasks: T1(n) = 2*T1(n/2) + O(n), T2(n) = 2*T2(n/2) + O(1). According to master theorem for divide-and-conquer recurrences, overall complexities of such algorithms are O(n * log(n)) and O(n).

(define (tree->list tree) (tree->list-2 tree))
