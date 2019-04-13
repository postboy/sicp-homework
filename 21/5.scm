; Exercise 2.5.  Show that we can represent pairs of nonnegative integers using only numbers and arithmetic operations if we represent the pair a and b as the integer that is the product 2^a*3^b. Give the corresponding definitions of the procedures cons, car, and cdr.

(load "../12/ch12_common.scm")

(define (cons x y)
  (* (expt 2 x)
     (expt 3 y)))

(define (contains-nth-power a b power)
  (if (= (remainder a b) 0)
      (contains-nth-power (quotient a b) b (+ power 1))
      power))

(define (car z)
  (contains-nth-power z 2 0))

(define (cdr z)
  (contains-nth-power z 3 0))

(assert (car (cons 0 0)) 0)
(assert (cdr (cons 0 5)) 5)
(assert (car (cons 11 4)) 11)
