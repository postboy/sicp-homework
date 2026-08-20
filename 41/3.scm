; Exercise 4.3.  Rewrite eval so that the dispatch is done in data-directed style. Compare this with the data-directed differentiation procedure of exercise 2.73. (You may use the car of a compound expression as the type of the expression, as is appropriate for the syntax implemented in this section.) .

(load "ch41_common.scm")

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
	((get 'eval (car exp)) ((get 'eval (operator exp)) exp env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))


(put 'eval 'quote (lambda (exp env) (text-of-quotation exp)))
(put 'eval 'set! (lambda (exp env) (eval-assignment exp env)))
(put 'eval 'define (lambda (exp env) (eval-definition exp env)))
(put 'eval 'if (lambda (exp env) (eval-if exp env)))
(put 'eval 'lambda (lambda (exp env) (make-procedure (lambda-parameters exp) (lambda-body exp) env)))
(put 'eval 'begin (lambda (exp env) (eval-sequence (begin-actions exp) env)))
(put 'eval 'cond (lambda (exp env) (eval (cond->if exp) env)))

(A (eval '(define x 3) the-global-environment) 'ok)
(A (eval '(define x 3) the-global-environment) 'ok)
(A (eval '(+ 1 2) the-global-environment) '3)
