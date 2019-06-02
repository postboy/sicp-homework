(define (display-all . vs)
  (for-each display vs))

; display-all can be changed to error for debugging convenience
(define (assert a b)
  (cond ((equal? a b) #t)
	(else (display-all "assert failed: " a " != " b) #f)))

(define (identity x) x)

(define (average x y)
  (/ (+ x y) 2))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (inc n) (+ n 1))

(define (dec n) (- n 1))

(define (divides? a b)
  (= (remainder b a) 0))

(define (next n)
  (+ n 1))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (prime? n)
  (and (> n 1) (= n (smallest-divisor n))))

(define nil '())
