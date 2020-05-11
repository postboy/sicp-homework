; Exercise 4.1.  Notice that we cannot tell whether the metacircular evaluator evaluates operands from left to right or from right to left. Its evaluation order is inherited from the underlying Lisp: If the arguments to cons in list-of-values are evaluated from left to right, then list-of-values will evaluate operands from left to right; and if the arguments to cons are evaluated from right to left, then list-of-values will evaluate operands from right to left.

; Write a version of list-of-values that evaluates operands from left to right regardless of the order of evaluation in the underlying Lisp. Also write a version of list-of-values that evaluates operands from right to left.

(load "ch41_common.scm")

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((first-result (eval (first-operand exps) env)))
	(cons first-result
	      (list-of-values (rest-operands exps) env)))))

(define a 0)
(assert (list-of-values '((set! a 1) (set! a 2)) user-initial-environment) '(0 1))
(assert a 2)

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((rest-results (list-of-values (rest-operands exps) env)))
	(cons (eval (first-operand exps) env)
	      rest-results))))

(define a 0)
(assert (list-of-values '((set! a 1) (set! a 2)) user-initial-environment) '(2 0))
(assert a 1)
