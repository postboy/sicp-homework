; Exercise 3.62.  Use the results of exercises 3.60 and 3.61 to define a procedure div-series that divides two power series. Div-series should work for any two series, provided that the denominator series begins with a nonzero constant term. (If the denominator has a zero constant term, then div-series should signal an error.) Show how to use div-series together with the result of exercise 3.59 to generate the power series for tangent.

(load "61.scm")

; 1. S*X = 1, where S has a constant term 1 => X = 1/S.
; 2. What if Y has some constant term c that is not zero? Y = c*S => S = Y/c.
; 3. Combine steps 1 and 2: Y/c*X = 1 => Y*(X/c) = 1 => 1/Y = X/c.
; 4. N/D = N*(1/D), and we can use step 3 to compute 1/D via invert-unit-series.

(define (div-series num denom)
  (define denom-const-term (stream-car denom))
  (if (= denom-const-term 0)
      (error "denominator has a zero constant term")
      (mul-series num
		  (scale-stream (invert-unit-series (scale-stream denom
								  (/ 1 denom-const-term)))
				(/ 1 denom-const-term)))))

(define tangent-stream (div-series sine-series cosine-series))
(define res-first-10 '(0 1 0 1/3 0 2/15 0 17/315 0 62/2835))
(assert (stream-head tangent-stream 10) res-first-10)

; this call produces an error message
;(div-series sine-series (list->stream '(0)))
