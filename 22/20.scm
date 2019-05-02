; Exercise 2.20.  The procedures +, *, and list take arbitrary numbers of arguments. One way to define such procedures is to use define with dotted-tail notation. In a procedure definition, a parameter list that has a dot before the last parameter name indicates that, when the procedure is called, the initial parameters (if any) will have as values the initial arguments, as usual, but the final parameter's value will be a list of any remaining arguments. <...> Use this notation to write a procedure same-parity that takes one or more integers and returns a list of all the arguments that have the same even-odd parity as the first argument.

(load "ch22_common.scm")

(define (same-parity first . rest)
  (define (wanted-parity? num)
    (eq? (even? num) (even? first)))
  (define (sp-internal l)
    (cond ((null? l) l)
	  ((wanted-parity? (car l)) (cons (car l) (sp-internal (cdr l))))
	  (else (sp-internal (cdr l)))))
  (cons first (sp-internal rest)))

(assert (list 1 3 5 7) (same-parity 1 2 3 4 5 6 7))
(assert (list 2 4 6) (same-parity 2 3 4 5 6 7))
(assert (list 2) (same-parity 2))
