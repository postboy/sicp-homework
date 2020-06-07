; Exercise 3.65.  Use the series <...> to compute three sequences of approximations to the natural logarithm of 2, in the same way we did above for pi. How rapidly do these sequences converge?

(load "55.scm")
(load "64.scm")

(define (alternating-stream-from n)
  (define (set-alternating-sign n)
    (if (even? n) (- n) n))
  (cons-stream (/ 1 (set-alternating-sign n))
	       (alternating-stream-from (+ n 1))))

(define ln2-summands (alternating-stream-from 1))
(assert (stream-head ln2-summands 5) '(1 -1/2 1/3 -1/4 1/5))

; ln(2) ~ 0.69314718056

(define ln2-first (partial-sums ln2-summands))
(assert (stream-head ln2-first 5) '(1 1/2 5/6 7/12 47/60))
(assert (stream-iters ln2-first 0.0001) 10000)

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))           ; Sn-1
        (s1 (stream-ref s 1))           ; Sn
        (s2 (stream-ref s 2)))          ; Sn+1
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

(define ln2-second (euler-transform ln2-first))
(assert (stream-head ln2-second 5) '(7/10 29/42 25/36 457/660 541/780))
(assert (stream-iters ln2-second 0.0001) 13)

(define (make-tableau transform s)
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))

(define ln2-third (accelerated-sequence euler-transform ln2-first))
(assert (stream-head ln2-third 5) '(1 7/10 165/238 380522285/548976276 755849325680052062216639661/1090460049411856348776491380))
(assert (stream-iters ln2-third 0.0001) 5)
