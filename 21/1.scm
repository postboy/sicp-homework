; Exercise 2.1.  Define a better version of make-rat that handles both positive and negative arguments. Make-rat should normalize the sign so that if the rational number is positive, both the numerator and denominator are positive, and if the rational number is negative, only the numerator is negative. 

(load "../12/ch12_common.scm")

; rat: make, numer, denom, print

(define (make-rat n d)
  (let ((g (abs (gcd n d))))
    (define n-red (/ n g))
    (define d-red (/ d g))
    (if (> d 0)
	(cons (+ n-red) (+ d-red))
	(cons (- n-red) (- d-red)))))

(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
  (let ((n (numer x))
	(d (denom x)))
    (newline)
    (display n)
    (display "/")
    (display d)
    (/ n d)))

(assert (print-rat (make-rat -1 1)) (/ (- 1) 1))
(assert (print-rat (make-rat 1 -1)) (/ (- 1) 1))
(assert (print-rat (make-rat -1 -1)) (/ 1 1))
(assert (print-rat (make-rat 10 -20)) (/ (- 1) 2))
