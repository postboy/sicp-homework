; Exercise 3.58.  Give an interpretation of the stream computed by the following procedure: <...>. (Quotient is a primitive that returns the integer quotient of two integers.) What are the successive elements produced by (expand 1 7 10)? What is produced by (expand 3 8 10)?

(load "ch35_common.scm")

(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

(define a (expand 1 7 10))
(assert (stream-part-to-list a 12) '(1 4 2 8 5 7 1 4 2 8 5 7))
(assert (/ 1.0 7) 0.14285714285714285)

(define b (expand 3 8 10))
(assert (stream-part-to-list b 6) '(3 7 5 0 0 0))
(assert (/ 3.0 8) 0.375)

(define c (expand 10 1 10))
(assert (stream-part-to-list c 3) '(100 0 0))
(assert (/ 10.0 1) 10.)

(define d (expand -1 3 10))
(assert (stream-part-to-list d 3) '(-3 -3 -3))
(assert (/ -1.0 3) -0.33333333333333333)

; Rational number is a number which can be represented as m/n, where m is integer and n is natural number.

; This stream is digits of real representation in given radix of rational number num/den. Procedure works flawlessly for numbers in interval [0;1). Procedure works weirdly for numbers whose modulus is >= 1 because first digit is number of 1/radix parts in the result (see c). Procedure works weirdly for negative numbers because all digits have same sign as the whole number (see d).
