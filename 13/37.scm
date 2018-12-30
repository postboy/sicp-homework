; Exercise 1.37.  a. An infinite continued fraction is an expression of the form <...>. As an example, one can show that the infinite continued fraction expansion with the Ni and the Di all equal to 1 produces 1/y, where y is the golden ratio (described in section 1.2.2). One way to approximate an infinite continued fraction is to truncate the expansion after a given number of terms. Such a truncation -- a so-called k-term finite continued fraction -- has the form <...>.
; Suppose that n and d are procedures of one argument (the term index i) that return the Ni and Di of the terms of the continued fraction. Define a procedure cont-frac such that evaluating (cont-frac n d k) computes the value of the k-term finite continued fraction. Check your procedure by approximating 1/y using <...> for successive values of k. How large must you make k in order to get an approximation that is accurate to 4 decimal places?

(load "ch13_common.scm")

(define (cont-frac n d k)
  (define (iter i delta)
    (if (= i 0)
	delta
	(iter (dec i) (/ (n i) (+ (d i) delta)))))
  (iter k 0))

; y ~ 1.6180 (see 1.2.2)
(assert (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 1)) 1.)
(assert (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 5)) 1.6)
(assert (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 10)) 1.6181818181818184) ; 1.6181
(assert (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 11)) 1.6179775280898876) ; 1.6180
; That was our goal! We've got it on 11 iterations.

; b. If your cont-frac procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

(define (cont-frac n d k)
  (define (delta i)
    (if (> i k)
	0
	(/ (n i) (+ (d i) (delta (inc i))))))
  (/ (n 1) (+ (d 1) (delta 2))))

(assert (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 1)) 1.)
(assert (/ 1 (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) 11)) 1.6179775280898876) ; 1.6180
