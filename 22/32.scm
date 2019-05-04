; Exercise 2.32.  We can represent a set as a list of distinct elements, and we can represent the set of all subsets of the set as a list of lists. For example, if the set is (1 2 3), then the set of all subsets is (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)). Complete the following definition of a procedure that generates the set of subsets of a set and give a clear explanation of why it works:

(load "ch22_common.scm")

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (elt)
			    (cons (car s) elt))
			  rest)))))

(assert (subsets '(1 2 3)) '(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)))

; If we have n elements in set then every subset can be represented with n boolean variables, each of which says if i-th element present in this subset. Total number of subsets is 2^n: 2^(n-1) subsets without i-th element and 2^(n-1) subsets with it. First and second halfs are the same except of i-th element absence/presence.

; If set is empty then its subsets set is also empty, else it consists of two parts:
; 1) a set of all subsets that can be made without first element;
; 2) same set as 1), but with first element appended.
