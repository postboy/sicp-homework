; Exercise 2.93.  Modify the rational-arithmetic package to use generic operations, but change make-rat so that it does not attempt to reduce fractions to lowest terms. Test your system by calling make-rational on two polynomials to produce a rational function

; Solution is there:
(load "ch25_common.scm")
; Unfortunately, it will temporarily (until 2.97) break old tests due to disabled simplification.

; After 2.90 we have to use constructors.
(define p1 (make-polynomial 'x (adjoin-term (make-term 2 1)
					    (adjoin-term (make-term 0 1)
							 (the-empty-termlist)))))
(define p2 (make-polynomial 'x (adjoin-term (make-term 3 1)
					    (adjoin-term (make-term 0 1)
							 (the-empty-termlist)))))
(define rf (make-rational p2 p1))

(define res-numer-t (adjoin-term (make-term 5 2)
				 (adjoin-term (make-term 3 2)
					      (adjoin-term (make-term 2 2)
							   (adjoin-term (make-term 0 2)
									(the-empty-termlist))))))
(define res-denom-t (adjoin-term (make-term 4 1)
				 (adjoin-term (make-term 2 2)
					      (adjoin-term (make-term 0 1)
							   (the-empty-termlist)))))
(define result (make-rational (make-polynomial 'x res-numer-t) (make-polynomial 'x res-denom-t)))

; Now add rf to itself, using add. You will observe that this addition procedure does not reduce fractions to lowest terms.

(assert (add rf rf) result)
