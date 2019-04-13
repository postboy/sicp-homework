; Exercise 2.8.  Using reasoning analogous to Alyssa's, describe how the difference of two intervals may be computed. Define a corresponding subtraction procedure, called sub-interval.

(load "7.scm")

; if we substact interval a from interval b, then
; - leftmost possible point is (low(a) - up(b))
; - rightmost possible point is (up(a) - low(b))
(define (sub-interval a b)
  (make-interval (- (lower-bound a) (upper-bound b))
		 (- (upper-bound a) (lower-bound b))))

(define exp-result (make-interval -1 1))
(assert (sub-interval sample-int sample-int) exp-result)
