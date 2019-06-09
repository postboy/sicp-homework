; Exercise 2.64.  The following procedure list->tree converts an ordered list to a balanced binary tree. The helper procedure partial-tree takes as arguments an integer n and list of at least n elements and constructs a balanced tree containing the first n elements of the list. The result returned by partial-tree is a pair (formed with cons) whose car is the constructed tree and whose cdr is the list of elements not included in the tree.

(load "ch23_common.scm")

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

; a. Write a short paragraph explaining as clearly as you can how partial-tree works. Draw the tree produced by list->tree for the list (1 3 5 7 9 11).

; partial-tree takes a list, approximately finds middle element in it and constructs a tree: middle element is current node, left branch is (partial-tree (elts-before-middle)), right branch is (partial-tree (elts-after-middle)). partial-tree processes only first n elements in list, rest of the list is returned as-is. As far as I can see, this implementation strives to achieve best possible performance.

(assert (list->tree '(1 3 5 7 9 11)) '(5
				       (1
					()
					(3 () ()))
				       (9
					(7 () ())
					(11 () ()))))

;          5
;    1          9
; ()   3     7     11
;    () () () () ()  ()

; b. What is the order of growth in the number of steps required by list->tree to convert a list of n elements?

; This is a divide-and-conquer algorithm. Let's say that time required for solving task of size n with this algorithm is T(n). In general, on each step we need to make O(1) work and divide task on two equal subtasks: T(n) = 2*T(n/2) + O(1). According to master theorem for divide-and-conquer recurrences, overall complexity of such algorithm is O(n).
