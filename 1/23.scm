; Exercise 1.23.  The smallest-divisor procedure shown at the start of this section does lots of needless testing: After it checks to see if the number is divisible by 2 there is no point in checking to see if it is divisible by any larger even numbers. This suggests that the values used for test-divisor should not be 2, 3, 4, 5, 6, ..., but rather 2, 3, 5, 7, 9, .... To implement this change, define a procedure next that returns 3 if its input is equal to 2 and otherwise returns its input plus 2. Modify the smallest-divisor procedure to use (next test-divisor) instead of (+ test-divisor 1). With timed-prime-test incorporating this modified version of smallest-divisor, run the test for each of the 12 primes found in exercise 1.22. Since this modification halves the number of test steps, you should expect it to run about twice as fast. Is this expectation confirmed? If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2?

(load "ch1_common.scm")

(define (next n)
  (if (= n 2) 3 (+ n 2)))

(timed-prime-test 100000007) ; .00999999999999801
(timed-prime-test 100000037) ; .01999999999999602
(timed-prime-test 100000039) ; 2.0000000000003126e-2

(timed-prime-test 1000000007) ; .03999999999999915
(timed-prime-test 1000000009) ; .05000000000000426
(timed-prime-test 1000000021) ; .04000000000000625

(timed-prime-test 10000000019) ; .17999999999999972
(timed-prime-test 10000000033) ; .1700000000000017
(timed-prime-test 10000000061) ; .1700000000000017

(timed-prime-test 100000000003) ; .4100000000000037
(timed-prime-test 100000000019) ; .4200000000000017
(timed-prime-test 100000000057) ; .4199999999999946

(timed-prime-test 1000000000039) ; 1.6999999999999957
(timed-prime-test 1000000000061) ; 1.740000000000002
(timed-prime-test 1000000000063) ; 1.740000000000002

(timed-prime-test 10000000000037) ; 5.519999999999996
(timed-prime-test 10000000000051) ; 5.510000000000005
(timed-prime-test 10000000000099) ; 5.480000000000004

; On small numbers algorithm really runs about two times faster, but this ratio fastly decreases as the numbers get bigger. Why? Let's have a look on our functions again.

;(define (divides? a b)
;  (= (remainder b a) 0))

;(define (find-divisor n test-divisor)
;  (cond ((> (square test-divisor) n) n)
;        ((divides? test-divisor n) test-divisor)
;        (else (find-divisor n (next test-divisor)))))

; Clearly, find-divisor runs only half of the times it ran before. But what exactly are the actions we got rid of?
; 1. Squaring even number, comparison between result and a number. This is equally expensive problems for both even and odd numbers.
; 2. Check if an even number divides another number without remainder. Well, well, well: if another number is odd then the immediate answer is no! GNU/MIT Scheme is fairly complex project, so I suppose that some optimizations under the hood could exploit this property.
; 3. Adding a constant to an even number. This is equally expensive problem for both even and odd numbers.

; So, my idea is that calling find-divisor with even argument was faster than call with an odd argument.
