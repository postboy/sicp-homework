; Exercise 1.24.  Modify the timed-prime-test procedure of exercise 1.22 to use fast-prime? (the Fermat method), and test each of the 12 primes you found in that exercise.

(load "22.scm")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

; I suppose that choosing "times" argument for fast-prime? is a nontrivial question
(define (start-prime-test n start-time)
  (if (fast-prime? n 1000)
      (report-prime (- (runtime) start-time))))

(timed-prime-test 100000007) ; .09000000000000341
(timed-prime-test 100000037) ; .0899999999999963
(timed-prime-test 100000039) ; .0899999999999963

(timed-prime-test 1000000007) ; .10999999999999943
(timed-prime-test 1000000009) ; .10000000000000142
(timed-prime-test 1000000021) ; .11999999999999744

(timed-prime-test 10000000019) ; .12000000000000455
(timed-prime-test 10000000033) ; .12000000000000455
(timed-prime-test 10000000061) ; .13000000000000256

(timed-prime-test 100000000003) ; .14999999999999858
(timed-prime-test 100000000019) ; .14000000000000057
(timed-prime-test 100000000057) ; .14999999999999858

(timed-prime-test 1000000000039) ; .14999999999999858
(timed-prime-test 1000000000061) ; .15000000000000568
(timed-prime-test 1000000000063) ; .1599999999999966

(timed-prime-test 10000000000037) ; .1600000000000037
(timed-prime-test 10000000000051) ; .1700000000000017
(timed-prime-test 10000000000099) ; .1700000000000017

; Since the Fermat test has O(log n) growth, how would you expect the time to test primes near 1,000,000 to compare with the time needed to test primes near 1000? Do your data bear this out? Can you explain any discrepancy you find?

; I'd suppose that if size of the task will be multiplied by 1000 then computation time will grow much much less. As you can see, results shows exactly this situation.
