; Exercise 2.88.  Extend the polynomial system to include subtraction of polynomials. (Hint: You may find it helpful to define a generic negation operation.)

; Solution is there:
(load "ch25_common.scm")

; If we'll define a generic negation operation then we can trivially implement subtraction via addition, which is great!

(assert (sub sn1 sn1) sn0)
(assert (sub rat1 rat1) rat0)
(assert (sub comp11 comp11) comp00)

(assert (sub sample-poly sample-poly) empty-poly)
(assert (sub empty-poly empty-poly) empty-poly)
(assert (sub sample-poly empty-poly) sample-poly)
