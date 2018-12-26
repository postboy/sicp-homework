; Exercise 1.31.  a.  The sum procedure is only the simplest of a vast number of similar abstractions that can be captured as higher-order procedures. Write an analogous procedure called product that returns the product of the values of a function at points over a given range. Show how to define factorial in terms of product. Also use product to compute approximations to using the formula <...>

(load "ch13_common.scm")

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(test-factorial
 factorial)

(define (pi-approx n)
  (define (term k)
    (if (even? k)
	(/ (+ k 2) (+ k 3))
	(/ (+ k 3) (+ k 2))))
  (* (product term 0 inc n) 4.0))

; pi ~ 3.14159265359
(pi-approx 10)    ; 3.023170192001361
(pi-approx 100)   ; 3.1263793980429817
(pi-approx 1000)  ; 3.140026946105016
(pi-approx 10000) ; 3.1414356249917024

; b.  If your product procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

(define (product term a next b)
  (define (iter a result)
    (if (> a b)
	result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(test-factorial factorial)
