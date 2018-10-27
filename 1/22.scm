; Exercise 1.22.  Most Lisp implementations include a primitive called runtime that returns an integer that specifies the amount of time the system has been running (measured, for example, in microseconds). The following timed-prime-test procedure, when called with an integer n, prints n and checks to see if n is prime. If n is prime, the procedure prints three asterisks followed by the amount of time used in performing the test.

; Using this procedure, write a procedure search-for-primes that checks the primality of consecutive odd integers in a specified range. Use your procedure to find the three smallest primes larger than 1000; larger than 10,000; larger than 100,000; larger than 1,000,000. Note the time needed to test each prime. Since the testing algorithm has order of growth of O(sqrt(n)), you should expect that testing for primes around 10,000 should take about sqrt(10) times as long as testing for primes around 1000. Do your timing data bear this out? How well do the data for 100,000 and 1,000,000 support the sqrt(n) prediction? Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation?

(load "21.scm")

; prime? definition

(define (prime? n)
  (= n (smallest-divisor n)))

; timed-prime-test definition

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

; finally, exercise code

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

(search-for-primes 1000 1019)
; 0. 0. 0.
(search-for-primes 10000 10037)
; 0. 0. 0.
(search-for-primes 100000 100043)
; 0. 0. 0.
(search-for-primes 1000000 1000037)
; 1.0000000000000009e-2 9.999999999999981e-3 0.
(search-for-primes 10000000 10000110)
; 0. .00999999999999801 0.
(search-for-primes 100000000 100000039)
; .01999999999999602 3.0000000000001137e-2 2.0000000000003126e-2
(search-for-primes 1000000000 1000000021)
; .05999999999999517 6.0000000000002274e-2 .05999999999999517
(search-for-primes 10000000000 10000000061)
; .21000000000000085 .18999999999999773 .20000000000000284
(search-for-primes 100000000000 100000000057)
; .6099999999999994 .6099999999999994 .7800000000000011
(search-for-primes 1000000000000 1000000000063)
; 1.8900000000000006 2.4399999999999977 2.440000000000005
(search-for-primes 10000000000000 10000000000100)
; 6.659999999999997 6.689999999999998 6.8300000000000125

; sqrt(10) ~ 3.16
; Damn Moore's law! All in all, results quite fit predictions. Of course, the longer the time, the better they fit: timing becomes more and more exact because random errors tend to compensate each other in different tests. Looks like that programs on my machine run in time proportional to the number of steps required for the computation, whew!

; crosschecked: https://github.com/ivanjovanovic/sicp/blob/master/1.2/e-1.22.scm
; I believe that my explanation is a bit clearer.
