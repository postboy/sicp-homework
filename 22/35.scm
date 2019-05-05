; Exercise 2.35.  Redefine count-leaves from section 2.2.2 as an accumulation.

(load "ch22_common.scm")

(define (count-leaves t)
  (accumulate +
	      0
	      (map (lambda (x) 1) (enumerate-tree t))))

(assert 4 (count-leaves '((((1) (2)) () 3) (4))))
