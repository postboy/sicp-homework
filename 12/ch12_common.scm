(load "../common.scm")

; gcd

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

; smallest-divisor

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

; timed-prime-test

(define (prime? n)
  (and (> n 1) (= n (smallest-divisor n))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

; expmod

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))
