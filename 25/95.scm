; Exercise 2.95.  Define P1, P2, and P3 to be the polynomials <...>. Now define Q1 to be the product of P1 and P2 and Q2 to be the product of P1 and P3, and use greatest-common-divisor (exercise 2.94) to compute the GCD of Q1 and Q2. Note that the answer is not the same as P1. This example introduces noninteger operations into the computation, causing difficulties with the GCD algorithm. To understand what is happening, try tracing gcd-terms while computing the GCD or try performing the division by hand.

; Tracing is there:
(load "ch25_common.scm")

(define p1-terms (adjoin-term (make-term 2 1)
			      (adjoin-term (make-term 1 -2)
					   (adjoin-term (make-term 0 1)
							(the-empty-termlist)))))
(define p2-terms (adjoin-term (make-term 2 11)
			      (adjoin-term (make-term 0 1)
					   (the-empty-termlist))))
(define p3-terms (adjoin-term (make-term 1 13)
			      (adjoin-term (make-term 0 5)
					   (the-empty-termlist))))
(define result-terms (adjoin-term (make-term 2 (/ 444 169))
				  (adjoin-term (make-term 1 (- (/ 888 169)))
					       (adjoin-term (make-term 0 (/ 444 169))
							    (the-empty-termlist)))))
(define p1 (make-polynomial 'x p1-terms))
(define p2 (make-polynomial 'x p2-terms))
(define p3 (make-polynomial 'x p3-terms))
(define q1 (mul p1 p2))
(define q2 (mul p1 p3))
(define result (make-polynomial 'x result-terms))

(assert (greatest-common-divisor q1 q2) result)

; [Entering #[compound-procedure 14 mul-terms]
;     Args: (sparse (3 13) (2 -21) (1 3) (0 5))
;           (sparse (1 11/13))]
; [Entering #[compound-procedure 14 mul-terms]
;     Args: (sparse (2 -21) (1 3) (0 5))
;           (sparse (1 11/13))]
; [Entering #[compound-procedure 14 mul-terms]
;     Args: (sparse (1 3) (0 5))
;           (sparse (1 11/13))]
; [Entering #[compound-procedure 14 mul-terms]
;     Args: (sparse (0 5))
;           (sparse (1 11/13))]
; [Entering #[compound-procedure 14 mul-terms]
;     Args: (sparse)
;           (sparse (1 11/13))]
; [(sparse)
;       <== #[compound-procedure 14 mul-terms]
;     Args: (sparse)
;           (sparse (1 11/13))]
; [(sparse (1 55/13))
;       <== #[compound-procedure 14 mul-terms]
;     Args: (sparse (0 5))
;           (sparse (1 11/13))]
; [(sparse (2 33/13) (1 55/13))
;       <== #[compound-procedure 14 mul-terms]
;     Args: (sparse (1 3) (0 5))
;           (sparse (1 11/13))]
; [(sparse (3 -231/13) (2 33/13) (1 55/13))
;       <== #[compound-procedure 14 mul-terms]
;     Args: (sparse (2 -21) (1 3) (0 5))
;           (sparse (1 11/13))]
; [(sparse (4 11) (3 -231/13) (2 33/13) (1 55/13))
;       <== #[compound-procedure 14 mul-terms]
;     Args: (sparse (3 13) (2 -21) (1 3) (0 5))
;           (sparse (1 11/13))]

; And so on, and so on, and so on. Those lines produce rational coefficients:
; (let ((new-c (div (coeff t1) (coeff t2)))
;       (new-o (- (order t1) (order t2))))
; ...
; (adjoin-term (make-term new-o new-c)
