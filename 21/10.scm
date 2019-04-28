; Exercise 2.10.  Ben Bitdiddle, an expert systems programmer, looks over Alyssa's shoulder and comments that it is not clear what it means to divide by an interval that spans zero. Modify Alyssa's code to check for this condition and to signal an error if it occurs.

(load "8.scm")

(define (negative? i) (and (> 0 (lower-bound i)) (> 0 (upper-bound i))))
(define (positive? i) (and (< 0 (lower-bound i)) (< 0 (upper-bound i))))
(define (spans-zero? i) (and (>= 0 (lower-bound i)) (<= 0 (upper-bound i))))

(define (div-interval x y)
  (if (spans-zero? y)
      (display-all "error: second interval spans zero: " y)
      (mul-interval x 
		    (make-interval (/ 1.0 (upper-bound y))
				   (/ 1.0 (lower-bound y))))))

; commented lines cause error messages
(assert (div-interval sample-int sample-int) div-result)
; (div-interval sample-int sub-result)

(define lobound-zero (make-interval 0 1))
; (div-interval sample-int lobound-zero)

(define upbound-zero (make-interval -1 0))
; (div-interval sample-int upbound-zero)
