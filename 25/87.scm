; Exercise 2.87.  Install =zero? for polynomials in the generic arithmetic package. This will allow adjoin-term to work for polynomials with coefficients that are themselves polynomials.

(load "ch25_common.scm")

(define empty-poly (make-polynomial 'x (the-empty-termlist)))
(assert (=zero? empty-poly) #t)

(define sample-term-list (adjoin-term (make-term 1 1) (the-empty-termlist)))
(define sample-poly (make-polynomial 'y sample-term-list))
(assert (=zero? sample-poly) #f)

(define empty-poly-term-list (adjoin-term (make-term 1 empty-poly) (the-empty-termlist)))
(define empty-poly-inside-poly (make-polynomial 'y empty-poly-term-list))
(assert (=zero? empty-poly-inside-poly) #t)
