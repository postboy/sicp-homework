; Exercise 2.58.  Suppose we want to modify the differentiation program so that it works with ordinary mathematical notation, in which + and * are infix rather than prefix operators. Since the differentiation program is defined in terms of abstract data, we can modify it to work with different representations of expressions solely by changing the predicates, selectors, and constructors that define the representation of the algebraic expressions on which the differentiator is to operate.

(load "ch23_common.scm")

; a. Show how to do this in order to differentiate algebraic expressions presented in infix form, such as (x + (3 * (x + (y + 2)))). To simplify the task, assume that + and * always take two arguments and that expressions are fully parenthesized.

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))

(define (augend s) (caddr s))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

(define (multiplicand p) (caddr p))

(assert (deriv '(x + (3 * (x + (y + 2)))) 'x) 4)

; b. The problem becomes substantially harder if we allow standard algebraic notation, such as (x + 3 * (x + y + 2)), which drops unnecessary parentheses and assumes that multiplication is done before addition. Can you design appropriate predicates, selectors, and constructors for this notation such that our derivative program still works?

(define (operation expr)
  (if (memq '+ expr)
      '+
      '*))

(define (sum? expr)
  (eq? '+ (operation expr)))

(define (product? expr)
  (eq? '* (operation expr)))

(define (elt-or-list l)
  (if (null? (cdr l))
      (car l)
      l))

(define (list-until separator l)
  (define (iter l result)
    (if (eq? (car l) separator)
	result
	(iter (cdr l) (append result (list (car l))))))
  (iter l nil))

(define (list-after separator l)
  (cdr (memq separator l)))

(define (addend expr)
  (elt-or-list (list-until '+ expr)))

(define (augend expr)
  (elt-or-list (list-after '+ expr)))

(define (multiplier expr)
  (elt-or-list (list-until '* expr)))

(define (multiplicand expr)
  (elt-or-list (list-after '* expr)))

(assert (deriv '(x * x * x) 'x) '((x * (x + x)) + (x * x)))
(assert (deriv '(x * (x * x)) 'x) '((x * (x + x)) + (x * x)))
(assert (deriv '(x + x + x) 'x) 3)
(assert (deriv '(x + (x + x)) 'x) 3)
(assert (deriv '(x + x * x + x) 'x) '(1 + ((x + x) + 1)))
(assert (deriv '(x + (x * x) + x) 'x) '(1 + ((x + x) + 1)))
(assert (deriv '(x + 3 * (x + y + 2)) 'x) 4)
(assert (deriv '((x + x) * (x + x)) 'x) '(((x + x) * 2) + (2 * (x + x))))
