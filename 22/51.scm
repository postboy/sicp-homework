; Exercise 2.51.  Define the below operation for painters. Below takes two painters as arguments. The resulting painter, given a frame, draws with the first painter in the bottom of the frame and with the second painter in the top. Define below in two different ways -- first by writing a procedure that is analogous to the beside procedure given above, and again in terms of beside and suitable rotation operations (from exercise 2.50).

(load "50.scm")

(define device (make-graphics-device (car (enumerate-graphics-types))))

(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-down
           (transform-painter painter1
			      (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
			      split-point))
	  (paint-up
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.5)
                              (make-vect 0.0 1.0))))
      (lambda (frame)
        (paint-up frame)
        (paint-down frame)))))

(graphics-clear device)
((below wave (flip-vert wave)) miniframe)

(define (below painter1 painter2)
  (rotate90 (beside (rotate270 painter1)
		    (rotate270 painter2))))

(graphics-clear device)
((below wave (flip-vert wave)) miniframe)

(graphics-close device)
