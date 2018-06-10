Exercise 1.7.  The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))

; does not evaluates at all with old procedures
(sqrt 4000000000000000000000)

; evaluates to ~.0313 with old procedures, and this is totally wrong
(sqrt 0.000004)

; evaluates to .03125 - wrong
(sqrt 0)

; Floating-point division by zero
(sqrt -1)

Due to the nature of floating-point numbers, representation precision of big numbers will make old test inadequate: every new guess will be just equal to the old one, so computation process won't converge. Old test isn't adequate for small numbers either because it can produce results with computational error bigger than result itself.

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

; does the improvement of guess changed it less than on 0.1%?
(define (good-enough? guess x)
  (< (abs (- (improve guess x)
	     guess))
     (* 0.001 guess)))

(define (sqrt x)
  (if (> x 0)
      (sqrt-iter 1.0 x)
      0))

; this operations work right after algorithm change

(sqrt 4000000000000000000000)
(sqrt 0.000004)
(sqrt 1)
(sqrt 0)
(sqrt -1)
