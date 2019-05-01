; Exercise 2.9.  The width of an interval is half of the difference between its upper and lower bounds. The width is a measure of the uncertainty of the number specified by the interval. For some arithmetic operations the width of the result of combining two intervals is a function only of the widths of the argument intervals, whereas for others the width of the combination is not a function of the widths of the argument intervals. Show that the width of the sum (or difference) of two intervals is a function only of the widths of the intervals being added (or subtracted). Give examples to show that this is not true for multiplication or division.

(load "8.scm")

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

; Let's find out formula for addition using substitution:
; (width (add-interval x y))
; First, let's substitute width definition:
; (/ (- (upper-bound (add-interval x y))
;       (lower-bound (add-interval x y)))
;    2)
; Remember that add-interval is (make-interval lower-bound upper-bound), so:
; (/ (- (+ (upper-bound x) (upper-bound y))
;       (+ (lower-bound x) (lower-bound y)))
;    2)
; We can reorder this as follows:
; (/ (+ (- (upper-bound x) (lower-bound x))
;       (- (upper-bound y) (lower-bound y)))
;    2)
; We can split it on two parts:
; (+ (/ (- (upper-bound x) (lower-bound x))
;       2)
;    (/ (- (upper-bound y) (lower-bound y))
;       2))
; By definition of width this is equivalent to
; (+ (width x) (width y))

; Let's find out formula for substraction using substitution:
; (width (sub-interval x y))
; First, let's substitute width definition:
; (/ (- (upper-bound (sub-interval x y))
;       (lower-bound (sub-interval x y)))
;    2)
; Remember that sub-interval is (make-interval lower-bound upper-bound), so:
; (/ (- (- (upper-bound x) (lower-bound y))
;       (- (lower-bound x) (upper-bound y)))
;    2)
; We can reorder this as follows:
; (/ (+ (- (upper-bound x) (lower-bound x))
;       (- (upper-bound y) (lower-bound y)))
;    2)
; This formula is the same as in previous example.

(assert (width add-result) (+ (width sample-int)
			      (width sample-int)))
(assert (width sub-result) (+ (width sample-int)
			      (width sample-int)))

(assert (+ (width mul-result) 0.0) (+ (width sample-int)
				      (width sample-int)
				      0.5))
(assert (width div-result) (+ (width sample-int)
			      (width sample-int)
			      -0.25))
