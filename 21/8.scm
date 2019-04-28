; Exercise 2.8.  Using reasoning analogous to Alyssa's, describe how the difference of two intervals may be computed. Define a corresponding subtraction procedure, called sub-interval.

(load "7.scm")

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

; if we substact interval x from interval y, then
; - leftmost possible point is (low(x) - up(y))
; - rightmost possible point is (up(x) - low(y))
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
		 (- (upper-bound x) (lower-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

(define add-result (make-interval 2 4))
(assert (add-interval sample-int sample-int) add-result)

(define sub-result (make-interval -1 1))
(assert (sub-interval sample-int sample-int) sub-result)

(define mul-result (make-interval 1 4))
(assert (mul-interval sample-int sample-int) mul-result)

(define div-result (make-interval 0.5 2.0))
(assert (div-interval sample-int sample-int) div-result)
