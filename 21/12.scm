; Exercise 2.12.  Define a constructor make-center-percent that takes a center and a percentage tolerance and produces the desired interval. You must also define a selector percent that produces the percentage tolerance for a given interval. The center selector is the same as the one shown above.

(load "9.scm")

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (make-center-percent c p)
  (make-center-width c (/ (* c p) 100)))
(define (percent i)
  (* (/ (width i) (center i)) 100))

(define one-to-three (make-interval 1 3))
(define percent-int (make-center-percent 2 50))
(assert one-to-three percent-int)
(assert 2 (center percent-int))
(assert 50 (percent percent-int))
