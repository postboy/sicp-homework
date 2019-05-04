; Exercise 2.29.  A binary mobile consists of two branches, a left branch and a right branch. Each branch is a rod of a certain length, from which hangs either a weight or another binary mobile. We can represent a binary mobile using compound data by constructing it from two branches (for example, using list). A branch is constructed from a length (which must be a number) together with a structure, which may be either a number (representing a simple weight) or another mobile.

; a.  Write the corresponding selectors left-branch and right-branch, which return the branches of a mobile, and branch-length and branch-structure, which return the components of a branch.

(load "ch22_common.scm")

(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (cadr mobile))
(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (cadr branch))

(define sample-lbr (make-branch 1 42))
(define balanced-mb (make-mobile sample-lbr sample-lbr))
(define sample-rbr (make-branch 2 balanced-mb))
(define unbalanced-mb (make-mobile sample-lbr sample-rbr))

(assert sample-lbr (left-branch unbalanced-mb))
(assert sample-rbr (right-branch unbalanced-mb))
(assert 1 (branch-length sample-lbr))
(assert 42 (branch-structure sample-lbr))

; b.  Using your selectors, define a procedure total-weight that returns the total weight of a mobile.

(define (total-weight mobile)
  (define (branch-weight b)
    (if (= 1 (branch-length b))
	(branch-structure b)
	(total-weight (branch-structure b))))
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))

(assert 84 (total-weight balanced-mb))
(assert 126 (total-weight unbalanced-mb))

; c.  A mobile is said to be balanced if the torque applied by its top-left branch is equal to that applied by its top-right branch (that is, if the length of the left rod multiplied by the weight hanging from that rod is equal to the corresponding product for the right side) and if each of the submobiles hanging off its branches is balanced. Design a predicate that tests whether a binary mobile is balanced.

(define (torque b)
  (if (= (branch-length b) 1)
      (branch-structure b)
      (* (total-weight (branch-structure b)) (branch-length b))))

(define (is-balanced? mobile)
  (define lb (left-branch mobile))
  (define rb (right-branch mobile))
  (and (= (torque lb) (torque rb))
       (or (= (branch-length lb) 1) (is-balanced? (branch-structure lb)))
       (or (= (branch-length rb) 1) (is-balanced? (branch-structure rb)))))

(assert (torque sample-lbr) 42)
(assert (torque sample-rbr) 168)

(assert #t (is-balanced? balanced-mb))
(assert #f (is-balanced? unbalanced-mb))

; d.  Suppose we change the representation of mobiles so that the constructors are <...>. How much do you need to change your programs to convert to the new representation?

(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))

; (list <a1> <a2> ... <an>) = (cons <a1> (cons <a2> (cons ... (cons <an> nil) ...))), so (list a b) = (cons a (cons b nil)).
; When we use (list (a) (b)), we construct list with elements a and b: ((a) (b)).
; When we use (cons (a) (b)), we append element a to list with element b: ((a) b).

(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (cdr mobile))
(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (cdr branch))

; we must re-create mobiles for testing because they will have different structure
(define sample-lbr (make-branch 1 42))
(define balanced-mb (make-mobile sample-lbr sample-lbr))
(define sample-rbr (make-branch 2 balanced-mb))
(define unbalanced-mb (make-mobile sample-lbr sample-rbr))

; for testing we can call highest-level function is-balanced?
(assert #t (is-balanced? balanced-mb))
(assert #f (is-balanced? unbalanced-mb))
