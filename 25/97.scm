; Exercise 2.97.  a. Implement this algorithm as a procedure reduce-terms that takes two term lists n and d as arguments and returns a list nn, dd, which are n and d reduced to lowest terms via the algorithm given above. Also write a procedure reduce-poly, analogous to add-poly, that checks to see if the two polys have the same variable. If so, reduce-poly strips off the variable and passes the problem to reduce-terms, then reattaches the variable to the two term lists supplied by reduce-terms.

; b. Define a procedure analogous to reduce-terms that does what the original make-rat did for integers <...> and define reduce as a generic operation that calls apply-generic to dispatch to either reduce-poly (for polynomial arguments) or reduce-integers (for scheme-number arguments). You can now easily make the rational-arithmetic package reduce fractions to lowest terms by having make-rat call reduce before combining the given numerator and denominator to form a rational number. The system now handles rational expressions in either integers or polynomials. To test your program, try the example at the beginning of this extended exercise: <...> See if you get the correct answer, correctly reduced to lowest terms.

; Solution is there:
(load "ch25_common.scm")

(assert (make-rational 1 2) (make-rational 2 4))

; After 2.90 we have to use constructors.
(define p1 (make-polynomial 'x (adjoin-term (make-term 1 1)
					    (adjoin-term (make-term 0 1)
							 (the-empty-termlist)))))
(define p2 (make-polynomial 'x (adjoin-term (make-term 3 1)
					    (adjoin-term (make-term 0 -1)
							 (the-empty-termlist)))))
(define p3 (make-polynomial 'x (adjoin-term (make-term 1 1)
					    (the-empty-termlist))))
(define p4 (make-polynomial 'x (adjoin-term (make-term 2 1)
					    (adjoin-term (make-term 0 -1)
							 (the-empty-termlist)))))
(define res-divident-t (adjoin-term (make-term 3 1)
				    (adjoin-term (make-term 2 2)
						 (adjoin-term (make-term 1 3)
							      (adjoin-term (make-term 0 1)
									   (the-empty-termlist))))))
(define res-divisor-t (adjoin-term (make-term 4 1)
				   (adjoin-term (make-term 3 1)
						(adjoin-term (make-term 1 -1)
							     (adjoin-term (make-term 0 -1)
									  (the-empty-termlist))))))

(define p1-mul (mul p1 (make-polynomial 'x (make-termlist-from-coeff 10))))
(define p2-mul (mul p2 (make-polynomial 'x (make-termlist-from-coeff 10))))
(define p3-mul (mul p3 (make-polynomial 'x (make-termlist-from-coeff 9))))
(define p4-mul (mul p4 (make-polynomial 'x (make-termlist-from-coeff 9))))

(define rf1 (make-rational p1 p2))
(define rf2 (make-rational p3 p4))
(define rf1-mul (make-rational p1-mul p2-mul))
(define rf2-mul (make-rational p3-mul p4-mul))
(define result (make-rational (make-polynomial 'x res-divident-t)
			      (make-polynomial 'x res-divisor-t)))

(assert (add rf1 rf2) result)
(assert (add rf1-mul rf2-mul) result)
