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

; rat: add, sub, mul, div, equal?

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))
