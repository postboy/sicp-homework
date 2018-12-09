; Exercise 1.22.  Most Lisp implementations include a primitive called runtime that returns an integer that specifies the amount of time the system has been running (measured, for example, in microseconds). The following timed-prime-test procedure, when called with an integer n, prints n and checks to see if n is prime. If n is prime, the procedure prints three asterisks followed by the amount of time used in performing the test.

; Using this procedure, write a procedure search-for-primes that checks the primality of consecutive odd integers in a specified range. Use your procedure to find the three smallest primes larger than 1000; larger than 10,000; larger than 100,000; larger than 1,000,000. Note the time needed to test each prime. Since the testing algorithm has order of growth of O(sqrt(n)), you should expect that testing for primes around 10,000 should take about sqrt(10) times as long as testing for primes around 1000. Do your timing data bear this out? How well do the data for 100,000 and 1,000,000 support the sqrt(n) prediction? Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation?

(load "ch1_common.scm")

(define (search-for-primes start end)
  (cond ((> start end) true)
	((even? start)
	 ; proceed to the next odd number
	 (search-for-primes (+ start 1) end))
	(else (timed-prime-test start)
	  ; same
	  (search-for-primes (+ start 2) end))))

(search-for-primes 0 20) ; 1 3 5 7 11 13 17 19
; 2 is skipped despite being prime, and the task has nothing against it

;(search-for-primes 100000000 100000039)
(timed-prime-test 100000007) ; 2.9999999999972715e-2
(timed-prime-test 100000037) ; 2.9999999999972715e-2
(timed-prime-test 100000039) ; 2.9999999999972715e-2

;(search-for-primes 1000000000 1000000021)
(timed-prime-test 1000000007) ; .07999999999998408
(timed-prime-test 1000000009) ; .09000000000003183
(timed-prime-test 1000000021) ; .07999999999998408

;(search-for-primes 10000000000 10000000061)
(timed-prime-test 10000000019) ; .2400000000000091
(timed-prime-test 10000000033) ; .2400000000000091
(timed-prime-test 10000000061) ; .2400000000000091

;(search-for-primes 100000000000 100000000057)
(timed-prime-test 100000000003) ; .7599999999999909
(timed-prime-test 100000000019) ; .7599999999999909
(timed-prime-test 100000000057) ; .7599999999999909

;(search-for-primes 1000000000000 1000000000063)
(timed-prime-test 1000000000039) ; 2.3999999999999773
(timed-prime-test 1000000000061) ; 2.410000000000025
(timed-prime-test 1000000000063) ; 2.390000000000043

;(search-for-primes 10000000000000 10000000000099)
(timed-prime-test 10000000000037) ; 7.509999999999991
(timed-prime-test 10000000000051) ; 7.569999999999993
(timed-prime-test 10000000000099) ; 7.559999999999945

; sqrt(10) ~ 3.16
; Damn Moore's law! All in all, results quite fit predictions. Of course, the longer the time, the better they fit: timing becomes more and more exact because random errors tend to compensate each other in different tests. Looks like that programs on my machine run in time proportional to the number of steps required for the computation, whew!

; crosschecked: https://github.com/ivanjovanovic/sicp/blob/master/1.2/e-1.22.scm
; I believe that my explanation is a bit clearer.
