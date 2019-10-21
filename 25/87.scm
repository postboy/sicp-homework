; Exercise 2.87.  Install =zero? for polynomials in the generic arithmetic package. This will allow adjoin-term to work for polynomials with coefficients that are themselves polynomials.

; Solution is there:
(load "ch25_common.scm")

(assert (=zero? empty-poly) #t)
(assert (=zero? sample-poly) #f)

(define empty-poly-term-list (adjoin-term empty-term (the-empty-termlist)))
(define empty-poly-inside-poly (make-polynomial 'y empty-poly-term-list))
(assert (=zero? empty-poly-inside-poly) #t)
