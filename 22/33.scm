; Exercise 2.33.  Fill in the missing expressions to complete the following definitions of some basic list-manipulation operations as accumulations.

(load "26.scm")

(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))
(assert '(1 4 9) (map (lambda (x) (* x x)) x))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
(assert (append x y) '(1 2 3 4 5 6))

(define (length sequence)
  (accumulate (lambda (x y) (inc y)) 0 sequence))
(assert 3 (length '((1 2) 3 4)))
