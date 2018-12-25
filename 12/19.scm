; Exercise 1.19.   There is a clever algorithm for computing the Fibonacci numbers in a logarithmic number of steps. Recall the transformation of the state variables a and b in the fib-iter process of section 1.2.2: a <- a + b and b <- a. Call this transformation T, and observe that applying T over and over again n times, starting with 1 and 0, produces the pair Fib(n + 1) and Fib(n). In other words, the Fibonacci numbers are produced by applying T^n, the nth power of the transformation T, starting with the pair (1,0). Now consider T to be the special case of p = 0 and q = 1 in a family of transformations Tpq, where Tpq transforms the pair (a,b) according to a <- bq + aq + ap and b <- bp + aq. Show that if we apply such a transformation Tpq twice, the effect is the same as using a single transformation Tp'q' of the same form, and compute p' and q' in terms of p and q. This gives us an explicit way to square these transformations, and thus we can compute T^n using successive squaring, as in the fast-expt procedure. Put this all together to complete the following procedure, which runs in a logarithmic number of steps:

; c = bq + aq + ap
; d = bp + aq
; e = dq + cq + cp
; f = dp + cq

; e = (bp + aq)q + (bq + aq + ap)q + (bq + aq + ap)p = bpq + aq^2 + bq^2 + aq^2 + apq + bpq + apq + ap^2 = 2aq^2 + ap^2 + bq^2 + 2apq + 2bpq = b(q^2 + 2pq) + a(q^2 + 2pq) + a(q^2 + p^2)
; f = (bp + aq)p + (bq + aq + ap)q = bp^2 + apq + bq^2 + aq^2 + apq = b(p^2 + q^2) + a(q^2 + 2pq)

; p' = (q^2 + p^2)
; q' = (q^2 + 2pq)

; now let's substitute it in the procedure

(load "ch12_common.scm")

(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (+ (square q) (square p)) ; p'
                   (+ (square q) (* 2 p q))  ; q'
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

(define (fib n)
  (fib-iter 1 0 0 1 n))

(assert 0 (fib 0))
(assert 1 (fib 1))
(assert 1 (fib 2))
(assert 2 (fib 3))
(assert 3 (fib 4))
(assert 5 (fib 5))
(assert 8 (fib 6))
(assert 13 (fib 7))
