; Exercise 2.68.  The encode procedure takes as arguments a message and a tree and produces the list of bits that gives the encoded message.

(load "67.scm")

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

; Encode-symbol is a procedure, which you must write, that returns the list of bits that encodes a given symbol according to a given tree. You should design encode-symbol so that it signals an error if the symbol is not in the tree at all. Test your procedure by encoding the result you obtained in exercise 2.67 with the sample tree and seeing whether it is the same as the original sample message.

(define (encode-symbol symbol tree)
  (define (contains-symbol? tree)
    (memq symbol (symbols tree)))
  (cond ((leaf? tree) nil)
	((contains-symbol? (left-branch tree))
	 (cons '0 (encode-symbol symbol (left-branch tree))))
        ((contains-symbol? (right-branch tree))
	 (cons '1 (encode-symbol symbol (right-branch tree))))
        (else (error "bad symbol -- CHOOSE-BRANCH-SYMBOL" symbol))))

(assert (encode sample-decoded sample-tree) sample-message)
(assert (encode nil sample-tree) nil)

; bad symbol -- CHOOSE-BRANCH-SYMBOL e
; (encode '(E) sample-tree)
