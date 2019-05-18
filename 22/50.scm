; Exercise 2.50.  Define the transformation flip-horiz, which flips painters horizontally, and transformations that rotate painters counterclockwise by 180 degrees and 270 degrees.

(load "49.scm")

(define device (make-graphics-device (car (enumerate-graphics-types))))

(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(graphics-clear device)
((flip-horiz wave) miniframe)

(define (rotate180 painter)
  (transform-painter painter
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 0.0)))

(graphics-clear device)
((rotate180 wave) miniframe)

(define (rotate270 painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(graphics-clear device)
((rotate270 wave) miniframe)

(graphics-close device)
