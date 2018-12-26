; Exercise 1.33.  You can obtain an even more general version of accumulate (exercise 1.32) by introducing the notion of a filter on the terms to be combined. That is, combine only those terms derived from values in the range that satisfy a specified condition. The resulting filtered-accumulate abstraction takes the same arguments as accumulate, together with an additional predicate of one argument that specifies the filter. Write filtered-accumulate as a procedure. Show how to express the following using filtered-accumulate:
; a. the sum of the squares of the prime numbers in the interval a to b (assuming that you have a prime? predicate already written)

(load "../12/ch12_common.scm")
(load "ch13_common.scm")

(define (filtered-accumulate combine? combiner null-value term a next b)
  (define (iter a result)
    (cond ((> a b) result)
	  ((combine? a) (iter (next a) (combiner (term a) result)))
	  (else (iter (next a) result))))
  (iter a null-value))

(define (sum-of-sqares-of-primes a b)
  (filtered-accumulate prime? + 0 square a inc b))

(assert (sum-of-sqares-of-primes 0 1) 0)
(assert (sum-of-sqares-of-primes 0 2) 4)
(assert (sum-of-sqares-of-primes 0 3) 13)
(assert (sum-of-sqares-of-primes 2 3) 13)
(assert (sum-of-sqares-of-primes 0 5) 38)

; b. the product of all the positive integers less than n that are relatively prime to n (i.e., all positive integers i < n such that GCD(i,n) = 1). 

(define (prod-of-relative-primes-less-than n)
  (define (relatively-prime? i)
    (= (gcd i n) 1))
  (filtered-accumulate relatively-prime? * 1 identity 1 inc n))

(assert (prod-of-relative-primes-less-than 0) 1)
(assert (prod-of-relative-primes-less-than 1) 1)
(assert (prod-of-relative-primes-less-than 2) 1)
(assert (prod-of-relative-primes-less-than 3) 2)
(assert (prod-of-relative-primes-less-than 4) 3)
(assert (prod-of-relative-primes-less-than 5) 24)
(assert (prod-of-relative-primes-less-than 6) 5)
