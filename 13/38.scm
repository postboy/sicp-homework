; Exercise 1.38.  In 1737, the Swiss mathematician Leonhard Euler published a memoir De Fractionibus Continuis, which included a continued fraction expansion for e - 2, where e is the base of the natural logarithms. In this fraction, the Ni are all 1, and the Di are successively 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, .... Write a program that uses your cont-frac procedure from exercise 1.37 to approximate e, based on Euler's expansion.

(load "37.scm")

(define (e-approx k)
  (define (n i) 1.0)
  (define (d i)
    (if (= (remainder (inc i) 3) 0)
	(* 2 (/ (inc i) 3))
	1))
  (+ (cont-frac n d k) 2))

; e ~ 2,7182818284590452353602874713527
(e-approx 1)  ; 3.
(e-approx 10) ; 2.7182817182817183
