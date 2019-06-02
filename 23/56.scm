; Exercise 2.56.  Show how to extend the basic differentiator to handle more kinds of expressions. For instance, implement the differentiation rule <...> by adding a new clause to the deriv program and defining appropriate procedures exponentiation?, base, exponent, and make-exponentiation. (You may use the symbol ** to denote exponentiation.) Build in the rules that anything raised to the power 0 is 1 and anything raised to the power 1 is the thing itself.

(load "ch23_common.scm")

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base p) (cadr p))

(define (exponent p) (caddr p))

(define (make-exponentiation base exp)
  (cond ((=number? base 0) 0)
        ((=number? base 1) 1)
	((=number? exp 0) 1)
	((=number? exp 1) base)
        ((and (number? base) (number? exp)) (expt base exp))
        (else (list '** base exp))))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
	((exponentiation? exp)
	 (make-product
	  (make-product (exponent exp)
			(make-exponentiation (base exp)
					     (- (exponent exp) 1)))
	  (deriv (base exp) var)))
        (else
         (error "unknown expression type -- DERIV" exp))))

(assert (deriv '(** x 5) 'x) '(* 5 (** x 4)))
(assert (deriv '(** 5 5) 'x) 0)
(assert (deriv '(** x 5) 'y) 0)
(assert (deriv '(** x 0) 'x) 0)
(assert (deriv '(** x 1) 'x) 1)

; answer is definitely not properly simplified, but it's right
(assert (deriv '(* (** x 1) (** x 1)) 'x) '(+ (** x 1) (** x 1)))

; this expressions require more complex logic in deriv:
; (assert (deriv '(** 0 x) 'x) 0)
; (assert (deriv '(** 1 x) 'x) 1)
