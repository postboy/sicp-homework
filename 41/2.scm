; Exercise 4.2.  Louis Reasoner plans to reorder the cond clauses in eval so that the clause for procedure applications appears before the clause for assignments. He argues that this will make the interpreter more efficient: Since programs usually contain more applications than assignments, definitions, and so on, his modified eval will usually check fewer clauses than the original eval before identifying the type of an expression.

; a. What is wrong with Louis's plan? (Hint: What will Louis's evaluator do with the expression (define x 3)?)

(load "ch41_common.scm")

; original eval
(A (eval '(define x 3) the-global-environment) 'ok)
(A (eval '(define x 3) the-global-environment) 'ok)
(A (eval '(+ 1 2) the-global-environment) '3)

; Hugo's eval
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
	((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        (else
         (error "Unknown expression type -- EVAL" exp))))

; Definitions are incorrectly evaluated as procedure applications.

;(A (eval '(define x 3) the-global-environment) 'ok)
; This produces one of two possible errors. Eval tries to apply "define" procedure, so it tries to find...
; 1. ..."x" variable in the environment and fails. We get an "Unbound variable x" error.
; 2. ..."define" procedure in the environment and fails. We get an "Unbound variable define" error.

; b. Louis is upset that his plan didn't work. He is willing to go to any lengths to make his evaluator recognize procedure applications before it checks for most other kinds of expressions. Help him by changing the syntax of the evaluated language so that procedure applications start with call. For example, instead of (factorial 3) we will now have to write (call factorial 3) and instead of (+ 1 2) we will have to write (call + 1 2).

(define (application? exp) (tagged-list? exp 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))

(define (eval exp env)
  (cond ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        (else
         (error "Unknown expression type -- EVAL" exp))))

(A (eval '(define x 3) the-global-environment) 'ok)
(A (eval '(define x 3) the-global-environment) 'ok)
(A (eval '(call + 1 2) the-global-environment) '3)
