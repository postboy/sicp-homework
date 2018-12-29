; Exercise 1.46.  Several of the numerical methods described in this chapter are instances of an extremely general computational strategy known as iterative improvement. Iterative improvement says that, to compute something, we start with an initial guess for the answer, test if the guess is good enough, and otherwise improve the guess and continue the process using the improved guess as the new guess. Write a procedure iterative-improve that takes two procedures as arguments: a method for telling whether a guess is good enough and a method for improving a guess. Iterative-improve should return as its value a procedure that takes a guess as argument and keeps improving the guess until it is good enough. Rewrite the sqrt procedure of section 1.1.7 and the fixed-point procedure of section 1.3.3 in terms of iterative-improve.

(load "../11/ch11_common.scm")
(load "ch13_common.scm")

(define (iterative-improve good-enough? improve-guess)
  (define (ii-internal x)
    (let ((next (improve-guess x)))
      (if (good-enough? next x)
	  next
	  (ii-internal next))))
    (lambda (x)
      (ii-internal x)))

(define (sqrt x)
  ((iterative-improve
    fp-close-enough?
    (lambda (guess) (sqrt-improve guess x)))
   1.0))

(sqrt 256) ; 16.00000000000039

(define (fixed-point f first-guess)
  ((iterative-improve
    fp-close-enough?
    f)
   first-guess))

(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0) ; 1.6180327868852458
