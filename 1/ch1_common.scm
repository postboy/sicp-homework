; common code for this chapter

(define (display-all . vs)
  (for-each display vs))

(define (assert exp act)
  (cond ((eq? exp act) #t)
	(else (display-all "assert failed: " exp " != " act) #f)))

; function that computes square roots

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
