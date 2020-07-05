; Exercise 4.4.  Recall the definitions of the special forms and and or from chapter 1:
; - and: The expressions are evaluated from left to right. If any expression evaluates to false, false is returned; any remaining expressions are not evaluated. If all the expressions evaluate to true values, the value of the last expression is returned. If there are no expressions then true is returned.
; - or: The expressions are evaluated from left to right. If any expression evaluates to a true value, that value is returned; any remaining expressions are not evaluated. If all expressions evaluate to false, or if there are no expressions, then false is returned.
; Install and and or as new special forms for the evaluator by defining appropriate syntax procedures and evaluation procedures eval-and and eval-or. Alternatively, show how to implement and and or as derived expressions.

(load "ch41_common.scm")

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
	((and? exp) (eval-and exp env))
	((or? exp) (eval-or exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

(define (and? exp) (tagged-list? exp 'and))
(define (or? exp) (tagged-list? exp 'or))

; Strictly speaking, most of the time we should return "value of some expression" instead of "true" in functions below. In case of special forms, it's not hard but still adds some complexity. In case of derived expressions, it looks pretty hard because we don't want to re-evaluate "value of some expression". I don't want to do this now.

(define (eval-and exp env)
  (define (loop exps)
    (cond ((null? exps) true)
	  ((eval (car exps) env) (loop (cdr exps)))
	  (else false)))
  (loop (cdr exp)))

(define (eval-or exp env)
  (define (loop exps)
    (cond ((null? exps) false)
	  ((eval (car exps) env) true)
	  (else (loop (cdr exps)))))
  (loop (cdr exp)))

(define (and-tests)
  (A (eval '(and) the-global-environment) true)
  (A (eval '(and false) the-global-environment) false)
  (A (eval '(and true) the-global-environment) true)
  (A (eval '(and true true) the-global-environment) true)
  (A (eval '(and true false) the-global-environment) false)
  (A (eval '(and false (should-not-be-called)) the-global-environment) false))

(define (or-tests)
  (A (eval '(or) the-global-environment) false)
  (A (eval '(or false) the-global-environment) false)
  (A (eval '(or true) the-global-environment) true)
  (A (eval '(or false false) the-global-environment) false)
  (A (eval '(or false true) the-global-environment) true)
  (A (eval '(or true (should-not-be-called)) the-global-environment) true))

(and-tests)
(or-tests)

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
	((and? exp) (eval (and->if exp) env))
	((or? exp) (eval (or->if exp) env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

(define (and->if exp)
  (define (loop exps)
    (if (null? exps)
	'true
	(make-if (car exps)
		 (loop (cdr exps))
		 'false)))
  (loop (cdr exp)))

(define (or->if exp)
  (define (loop exps)
    (if (null? exps)
	'false
	(make-if (car exps)
		 'true
		 (loop (cdr exps)))))
  (loop (cdr exp)))

(and-tests)
(or-tests)
