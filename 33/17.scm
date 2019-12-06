; Exercise 3.17.  Devise a correct version of the count-pairs procedure of exercise 3.16 that returns the number of distinct pairs in any structure. (Hint: Traverse the structure, maintaining an auxiliary data structure that is used to keep track of which pairs have already been counted.)

(load "16.scm")

(define (count-pairs x)
  (define (unique-pairs x seen)
    (if (or (not (pair? x)) (memq x seen))
	seen
	(unique-pairs (cdr x)
		      (unique-pairs (car x) (cons x seen)))))
  (length (unique-pairs x nil)))

(assert (count-pairs z1) 3)
(assert (count-pairs z2) 3)
(assert (count-pairs z3) 3)
(assert (count-pairs z4) 3)
