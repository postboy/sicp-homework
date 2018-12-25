; Exercise 1.28.  One variant of the Fermat test that cannot be fooled is called the Miller-Rabin test (Miller 1976; Rabin 1980). This starts from an alternate form of Fermat's Little Theorem, which states that if n is a prime number and a is any positive integer less than n, then a raised to the (n - 1)st power is congruent to 1 modulo n. To test the primality of a number n by the Miller-Rabin test, we pick a random number a<n and raise a to the (n - 1)st power modulo n using the expmod procedure. However, whenever we perform the squaring step in expmod, we check to see if we have discovered a ``nontrivial square root of 1 modulo n,'' that is, a number not equal to 1 or n - 1 whose square is equal to 1 modulo n. It is possible to prove that if such a nontrivial square root of 1 exists, then n is not prime. It is also possible to prove that if n is an odd number that is not prime, then, for at least half the numbers a<n, computing a^(n-1) in this way will reveal a nontrivial square root of 1 modulo n. (This is why the Miller-Rabin test cannot be fooled.) Modify the expmod procedure to signal if it discovers a nontrivial square root of 1, and use this to implement the Miller-Rabin test with a procedure analogous to fermat-test. Check your procedure by testing various known primes and non-primes. Hint: One convenient way to make expmod signal is to have it return 0.

(load "ch12_common.scm")

(define (check-nontrivial base square m)
  (if (and (= square 1)
	   (not (= base 1))
	   (not (= base (- m 1))))
      0
      square))

(define (square-and-check-nontrivial base m)
  (check-nontrivial base (remainder (square base) m) m))

(define (mr-expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (square-and-check-nontrivial (mr-expmod base (/ exp 2) m) m))
        (else (remainder
	       (* base (mr-expmod base (- exp 1) m))
	       m))))

(define (mr-prime-iter n)
  (define (try-it a)
    (= (mr-expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (mr-prime? n times)
  (cond ((= times 0) true)
        ((mr-prime-iter n) (mr-prime? n (- times 1)))
        (else false)))

; I suppose that choosing "times" argument for mr-prime? is a nontrivial question
(define (run-prime-test n)
  (mr-prime? n 1000))

(assert #t (run-prime-test 2))
(assert #t (run-prime-test 3))
(assert #f (run-prime-test 4))
(assert #t (run-prime-test 5))
(assert #f (run-prime-test 6))
(assert #t (run-prime-test 7))
(assert #f (run-prime-test 8))

(assert #f (run-prime-test 561))
(assert #f (run-prime-test 1105))
(assert #f (run-prime-test 1729))
(assert #f (run-prime-test 2465))
(assert #f (run-prime-test 2821))
(assert #f (run-prime-test 6601))

(assert #t (run-prime-test 100000007))
(assert #t (run-prime-test 100000037))
(assert #t (run-prime-test 100000039))

(assert #t (run-prime-test 1000000007))
(assert #t (run-prime-test 1000000009))
(assert #t (run-prime-test 1000000021))

(assert #t (run-prime-test 10000000019))
(assert #t (run-prime-test 10000000033))
(assert #t (run-prime-test 10000000061))

(assert #t (run-prime-test 100000000003))
(assert #t (run-prime-test 100000000019))
(assert #t (run-prime-test 100000000057))

(assert #t (run-prime-test 1000000000039))
(assert #t (run-prime-test 1000000000061))
(assert #t (run-prime-test 1000000000063))

(assert #t (run-prime-test 10000000000037))
(assert #t (run-prime-test 10000000000051))
(assert #t (run-prime-test 10000000000099))
