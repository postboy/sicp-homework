; Exercise 2.3.  Implement a representation for rectangles in a plane. (Hint: You may want to make use of exercise 2.2.) In terms of your constructors and selectors, create procedures that compute the perimeter and the area of a given rectangle. Now implement a different representation for rectangles. Can you design your system with suitable abstraction barriers, so that the same perimeter and area procedures will work using either representation?

(load "2.scm")

; a and b are segments defining the adjacent sides of rectangle. In better implementation we could check if sides are defined correctly and/or construct a rectangle from any two sides.
(define (make-rect a b) (cons a b))
(define (a-side r) (car r))
(define (b-side r) (cdr r))

; length and width are slightly more complex terms because length >= width
(define (a-length r) (segment-length (a-side r)))
(define (b-length r) (segment-length (b-side r)))

(define (rect-perimeter r) (* 2 (+ (a-length r)
				   (b-length r))))
(define (rect-area r) (* (a-length r) (b-length r)))

(define tricky-rect (make-rect tricky-zero-to-ten ten-to-tricky-ten))

(assert (rect-perimeter tricky-rect) 60)
(assert (rect-area tricky-rect) 200)

; Point is leftest and lowest point of rectangle *before* n degrees rotation. In better implementation we could check if data is defined correctly. This function can be defined via successive cons.
(define (make-rect point x-length y-length rotation) (list point x-length y-length rotation))
(define (point r) (car r))
(define (x-length r) (cadr r))
(define (y-length r) (caddr r))
(define (rotation r) (cadddr r))

; only restriction on a and b is that they are adjacent sides
(define (a-length r) (x-length r))
(define (b-length r) (y-length r))

(define tricky-rect (make-rect ten 10 20 180))

(assert (rect-perimeter tricky-rect) 60)
(assert (rect-area tricky-rect) 200)
