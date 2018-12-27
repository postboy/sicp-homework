; Exercise 1.35.  Show that the golden ratio y (section 1.2.2) is a fixed point of the transformation x -> 1 + 1/x, and use this fact to compute y by means of the fixed-point procedure.

(load "ch13_common.scm")

; y^2 = y + 1 (see 1.2.2)
; Clearly, y != 0 because in such case 0 != 1. Let's divide both parts of equation on y:
; y = 1 + 1/y
; By definition, function f(x) has fixed-point x0 if x0 = f(x0), and here we have exactly this situation.

; y ~ 1.6180 (see 1.2.2)
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.0) ; 1.6180327868852458
