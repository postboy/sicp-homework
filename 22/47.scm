; Exercise 2.47.  Here are two possible constructors for frames: <...>. For each constructor supply the appropriate selectors to produce an implementation for frames.

(load "46.scm")

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame f)
  (car f))

(define (edge1-frame f)
  (cadr f))

(define (edge2-frame f)
  (caddr f))

(define sample-frame (make-frame v26 v13 v31))

(assert v26 (origin-frame sample-frame))
(assert v13 (edge1-frame sample-frame))
(assert v31 (edge2-frame sample-frame))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (edge2-frame f)
  (cddr f))

; we should re-create test data
(define sample-frame (make-frame v26 v13 v31))

(assert v26 (origin-frame sample-frame))
(assert v13 (edge1-frame sample-frame))
(assert v31 (edge2-frame sample-frame))
