; Exercise 2.73.  Section 2.3.2 described a program that performs symbolic differentiation:

(cd "../23")
(load "56.scm")
(cd "../24")
(load "ch24_common.scm")

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ; <more rules can be added here>
        (else (error "unknown expression type -- DERIV" exp))))

; We can regard this program as performing a dispatch on the type of the expression to be differentiated. In this situation the ``type tag'' of the datum is the algebraic operator symbol (such as +) and the operation being performed is deriv. We can transform this program into data-directed style by rewriting the basic derivative procedure as

(define (deriv exp var)
  (define (operator exp) (car exp))
  (define (operands exp) (cdr exp))
  (cond ((number? exp) 0)
	((variable? exp) (if (same-variable? exp var) 1 0))
	(else ((get 'deriv (operator exp)) (operands exp) var))))

; a.  Explain what was done above. Why can't we assimilate the predicates number? and same-variable? into the data-directed dispatch?

; Essentially we're doing the same actions, but now they're expressed in more abstract manner. Previously we used to explicitly check for known expression types and handle them in place appropriately. Now if we have an expression then we get appropriate function from a table (determined by type of operator) and call it with all the needed arguments. This way we build useful abstraction barrier because all operation-specific logic is located in special-purpose function, while generic differentiation logic isn't cluttered with details of specific expression types.

; With such functions we can't assimilate this predicates simply because numbers and variables aren't lists, so we can't call car and cdr with them as arguments. In fact, operator and operands functions can be defined in a way that handles both atoms and lists, but this would be rather ugly.

; b.  Write the procedures for derivatives of sums and products, and the auxiliary code required to install them in the table used by the program above.

; Let's make the simplest implementation where all expressions have only two operands.

(define (sum-derive operands var)
  (define addend (car operands))
  (define augend (cadr operands))
  (make-sum (deriv addend var)
	    (deriv augend var)))

(define (product-derive operands var)
  (define multiplier (car operands))
  (define multiplicand (cadr operands))
  (make-sum
   (make-product multiplier
		 (deriv multiplicand var))
   (make-product (deriv multiplier var)
		 multiplicand)))

(put 'deriv '+ sum-derive)
(put 'deriv '* product-derive)

(assert (get 'deriv '+) sum-derive)
(assert (get 'deriv '*) product-derive)

(assert (deriv '(+ x 3) 'x) 1)
(assert (deriv '(* x y) 'x) 'y)
(assert (deriv '(* (* x y) (+ x 3)) 'x) '(+ (* x y) (* y (+  x 3))))

; c.  Choose any additional differentiation rule that you like, such as the one for exponents (exercise 2.56), and install it in this data-directed system.

(define (exponentiation-derive operands var)
  (define base (car operands))
  (define exponent (cadr operands))
  (make-product
   (make-product exponent
		 (make-exponentiation base
				      (- exponent 1)))
   (deriv base var)))

(put 'deriv '** exponentiation-derive)
(assert (get 'deriv '**) exponentiation-derive)

(assert (deriv '(** x 5) 'x) '(* 5 (** x 4)))
(assert (deriv '(** 5 5) 'x) 0)
(assert (deriv '(** x 5) 'y) 0)
(assert (deriv '(** x 0) 'x) 0)
(assert (deriv '(** x 1) 'x) 1)
(assert (deriv '(* (** x 1) (** x 1)) 'x) '(+ (** x 1) (** x 1)))

; d.  In this simple algebraic manipulator the type of an expression is the algebraic operator that binds it together. Suppose, however, we indexed the procedures in the opposite way, so that the dispatch line in deriv looked like ((get (operator exp) 'deriv) (operands exp) var). What corresponding changes to the derivative system are required?

(define (deriv exp var)
  (define (operator exp) (car exp))
  (define (operands exp) (cdr exp))
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get (operator exp) 'deriv) (operands exp) var))))

(put '+ 'deriv sum-derive)
(put '* 'deriv product-derive)
(put '** 'deriv exponentiation-derive)

(assert (get '+ 'deriv) sum-derive)
(assert (get '* 'deriv) product-derive)
(assert (get '** 'deriv) exponentiation-derive)

(assert (deriv '(+ x 3) 'x) 1)
(assert (deriv '(* x y) 'x) 'y)
(assert (deriv '(* (* x y) (+ x 3)) 'x) '(+ (* x y) (* y (+  x 3))))

(assert (deriv '(** x 5) 'x) '(* 5 (** x 4)))
(assert (deriv '(** 5 5) 'x) 0)
(assert (deriv '(** x 5) 'y) 0)
(assert (deriv '(** x 0) 'x) 0)
(assert (deriv '(** x 1) 'x) 1)
(assert (deriv '(* (** x 1) (** x 1)) 'x) '(+ (** x 1) (** x 1)))
