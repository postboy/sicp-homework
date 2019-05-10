; Exercise 2.39.   Complete the following definitions of reverse (exercise 2.18) in terms of fold-right and fold-left from exercise 2.38:

(load "38.scm")

(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(assert '(25 16 9 4 1) (reverse '(1 4 9 16 25)))
(assert '() (reverse '()))

(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))

(assert '(25 16 9 4 1) (reverse '(1 4 9 16 25)))
(assert '() (reverse '()))
