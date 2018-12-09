; Exercise 1.27.  Demonstrate that the Carmichael numbers listed in footnote 47 really do fool the Fermat test. That is, write a procedure that takes an integer n and tests whether a^n is congruent to a modulo n for every a<n, and try your procedure on the given Carmichael numbers.

(load "ch1_common.scm")

(define (prime-for-fermat-iter n a)
  (cond ((= n a) #t)
	((not (= (expmod a n n) a)) #f)
	(else (prime-for-fermat-iter n (+ a 1)))))

(define (prime-for-fermat? n)
  (prime-for-fermat-iter n 0))

(assert #t (prime-for-fermat? 0))
(assert #t (prime-for-fermat? 1))
(assert #t (prime-for-fermat? 2))
(assert #t (prime-for-fermat? 3))
(assert #f (prime-for-fermat? 4))
(assert #t (prime-for-fermat? 5))
(assert #f (prime-for-fermat? 6))
(assert #t (prime-for-fermat? 7))
(assert #f (prime-for-fermat? 8))

(assert #t (prime-for-fermat? 561))
(assert #t (prime-for-fermat? 1105))
(assert #t (prime-for-fermat? 1729))
(assert #t (prime-for-fermat? 2465))
(assert #t (prime-for-fermat? 2821))
(assert #t (prime-for-fermat? 6601))
