; Exercise 2.46.  A two-dimensional vector v running from the origin to a point can be represented as a pair consisting of an x-coordinate and a y-coordinate. Implement a data abstraction for vectors by giving a constructor make-vect and corresponding selectors xcor-vect and ycor-vect. In terms of your selectors and constructor, implement procedures add-vect, sub-vect, and scale-vect that perform the operations vector addition, vector subtraction, and multiplying a vector by a scalar.

(load "ch22_common.scm")

(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (add-vect l r)
  (make-vect
   (+ (xcor-vect l) (xcor-vect r))
   (+ (ycor-vect l) (ycor-vect r))))

(define (sub-vect l r)
  (make-vect
   (- (xcor-vect l) (xcor-vect r))
   (- (ycor-vect l) (ycor-vect r))))

(define (scale-vect s v)
  (make-vect
   (* s (xcor-vect v))
   (* s (ycor-vect v))))

(define v13 (make-vect 1 3))
(define v31 (make-vect 3 1))
(define v26 (make-vect 2 6))

(assert v26 (add-vect v13 v13))
(assert v13 (sub-vect v26 v13))
(assert v26 (scale-vect 2 v13))
