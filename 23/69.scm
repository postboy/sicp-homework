; Exercise 2.69.  The following procedure takes as its argument a list of symbol-frequency pairs (where no symbol appears in more than one pair) and generates a Huffman encoding tree according to the Huffman algorithm.

(load "67.scm")

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)    ; symbol
                               (cadr pair))  ; frequency
                    (make-leaf-set (cdr pairs))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

; Make-leaf-set is the procedure given above that transforms the list of pairs into an ordered set of leaves. Successive-merge is the procedure you must write, using make-code-tree to successively merge the smallest-weight elements of the set until there is only one element left, which is the desired Huffman tree. (This procedure is slightly tricky, but not really complicated. If you find yourself designing a complex procedure, then you are almost certainly doing something wrong. You can take significant advantage of the fact that we are using an ordered set representation.)

(define (successive-merge set)
  (cond ((null? set) nil)
	((null? (cdr set)) (car set))
	(else (successive-merge (adjoin-set (make-code-tree
					     (car set)
					     (cadr set))
					    (cddr set))))))

(define sample-list '((A 4) (B 2) (C 1) (D 1)))

(assert (make-leaf-set sample-list) '((leaf D 1) (leaf C 1) (leaf B 2) (leaf A 4)))

(assert (generate-huffman-tree nil) nil)
(assert (generate-huffman-tree '((A 4))) '(leaf A 4))
(assert (generate-huffman-tree sample-list) sample-tree)
