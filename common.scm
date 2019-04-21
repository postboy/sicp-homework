; assert

(define (display-all . vs)
  (for-each display vs))

; display-all can be changed to error for debugging convenience
(define (assert exp act)
  (cond ((equal? exp act) #t)
	(else (display-all "assert failed: " exp " != " act) #f)))

; average

(define (average x y)
  (/ (+ x y) 2))

; gcd

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
