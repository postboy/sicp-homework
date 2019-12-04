; Exercise 2.92.  By imposing an ordering on variables, extend the polynomial package so that addition and multiplication of polynomials works for polynomials in different variables. (This is not easy!)

; As you already noted, this book rarely offers easy exercises.

; We need apply-generic version that coerces it's arguments to same type.
; Solution is in ch25_common.scm and there:
(load "82.scm")

; It's really hard to solve this problem in most user-friendly way, so let's impose some limitations. Polynomials can have coefficients that are polynomials itself, but coefficient polynomials are restricted in choice of variables. Their variables should be located after variable of higher-level polynomial in lexicographically-sorted list. For example, it means that coefficients of polynomial with x variable can be polynomials with y or z variable. This rule is applied recursively: coefficients of polynomial with x variable can be polynomials with y variable, whose coefficients can be polynomials with z variable. User is responsible for creating only polynomials that satisfy this limitations, otherwise system can work incorrectly.

; In production code we would check if this limitations are indeed respected and we would try to simplify polynomials after operations: (poly x (0 (poly y (0 1)))) can be simplified to (poly y (0 1)) or even to just 1, (poly x (1 0) (0 1)) can be simplified to (poly x (0 1)) or even to just 1.

(define z (make-polynomial 'z (adjoin-term (make-term 3 5)
					    (adjoin-term (make-term 0 6)
							 (the-empty-termlist)))))
(define y (make-polynomial 'y (adjoin-term (make-term 2 3)
					    (adjoin-term (make-term 0 4)
							 (the-empty-termlist)))))
(define x (make-polynomial 'x (adjoin-term (make-term 2 z)
					   (adjoin-term (make-term 1 y)
							(adjoin-term (make-term 0 1)
								     (the-empty-termlist))))))
(define res-coeff (make-polynomial 'y (adjoin-term (make-term 2 3)
					       (adjoin-term (make-term 0 5)
							    (the-empty-termlist)))))
(define result (make-polynomial 'x (adjoin-term (make-term 2 z)
						(adjoin-term (make-term 1 y)
							     (adjoin-term (make-term 0 res-coeff)
									  (the-empty-termlist))))))

(assert (add x 0) x)
(assert (add 0 x) x)
(assert (add x y) result)
(assert (add y x) result)
(assert (sub x 0) x)
(assert (sub 0 x) (minus x))
(assert (mul 2 x) (add x x))
(assert (mul x 2) (add x x))

; In div-terms we get a list with two polys here: (let ((new-c (div (coeff t1) (coeff t2))), then =zero? doesn't work for such data. I don't know how to fix this without crutches.
; (assert (div x 1) x)
