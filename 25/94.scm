; Exercise 2.94.  Using div-terms, implement the procedure remainder-terms and use this to define gcd-terms as above. Now write a procedure gcd-poly that computes the polynomial GCD of two polys. (The procedure should signal an error if the two polys are not in the same variable.) Install in the system a generic operation greatest-common-divisor that reduces to gcd-poly for polynomials and to ordinary gcd for ordinary numbers. As a test, try <...> and check your result by hand.

; Solution is there:
(load "ch25_common.scm")

; After 2.90 we have to use constructors.
(define p1-terms (adjoin-term (make-term 4 1)
			      (adjoin-term (make-term 3 -1)
					   (adjoin-term (make-term 2 -2)
							(adjoin-term (make-term 1 2)
								     (the-empty-termlist))))))
(define p2-terms (adjoin-term (make-term 3 1)
			      (adjoin-term (make-term 1 -1)
					   (the-empty-termlist))))
(define result-terms (adjoin-term (make-term 2 -1)
				  (adjoin-term (make-term 1 1)
					       (the-empty-termlist))))
(define p1 (make-polynomial 'x p1-terms))
(define p2 (make-polynomial 'x p2-terms))
(define result (make-polynomial 'x result-terms))

(assert (greatest-common-divisor p1 p2) result)
(assert (greatest-common-divisor 6 9) 3)
