; Exercise 2.37.  Suppose we represent vectors v = (vi) as sequences of numbers, and matrices m = (mij) as sequences of vectors (the rows of the matrix). With this representation, we can use sequence operations to concisely express the basic matrix and vector operations.
; Fill in the missing expressions in the following procedures for computing the other matrix operations.

(load "36.scm")

(define mat '((1 2 3 4) (4 5 6 6) (6 7 8 9)))
(define vect '(1 2 3 4))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(assert (dot-product vect vect) 30)

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

(assert (matrix-*-vector mat vect) '(30 56 80))

(define (transpose mat)
  (accumulate-n cons nil mat))

(assert (transpose mat) '((1 4 6) (2 5 7) (3 6 8) (4 6 9)))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (matrix-*-vector cols row)) m)))

(define small-mat '((1 2) (3 4)))
(assert (matrix-*-matrix small-mat (transpose small-mat)) '((5 11) (11 25)))
