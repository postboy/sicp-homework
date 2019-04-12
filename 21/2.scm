; Exercise 2.2.  Consider the problem of representing line segments in a plane. Each segment is represented as a pair of points: a starting point and an ending point. Define a constructor make-segment and selectors start-segment and end-segment that define the representation of segments in terms of points. Furthermore, a point can be represented as a pair of numbers: the x coordinate and the y coordinate. Accordingly, specify a constructor make-point and selectors x-point and y-point that define this representation. Finally, using your selectors and constructors, define a procedure midpoint-segment that takes a line segment as argument and returns its midpoint (the point whose coordinates are the average of the coordinates of the endpoints). To try your procedures, you'll need a way to print points:

(load "ch21_common.scm")

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (print-point p)
  (newline)
  (display-all "(" (x-point p) ", " (y-point p) ")")
  p)

(define (make-segment start end) (cons start end))
(define (start-segment s) (car s))
(define (end-segment s) (cdr s))

(define (segment-length s)
  (let ((start (start-segment s))
	(end (end-segment s)))
    (sqrt (+ (square (- (x-point start)
			(x-point end)))
	     (square (- (y-point start)
			(y-point end)))))))

(define (midpoint-segment s)
  (make-point
   (average
    (x-point (start-segment s))
    (x-point (end-segment s))
    )
   (average
    (y-point (start-segment s))
    (y-point (end-segment s))
    )))

(define zero (make-point 0 0))
(define minus-half (make-point -1/2 -1/2))
(define minus-one (make-point -1 -1))

(define two (make-point 2 2))
(define six (make-point 6 6))
(define ten (make-point 10 10))

(define tricky-zero (make-point 0 10))
(define tricky-ten (make-point 10 -10))

(define two-to-ten (make-segment two ten))
(define zero-to-minus-one (make-segment zero minus-one))

(define tricky-zero-to-ten (make-segment tricky-zero ten))
(define ten-to-tricky-ten (make-segment ten tricky-ten))
(define tricky-ten-to-tricky-ten (make-segment tricky-ten tricky-ten))

(assert (segment-length two-to-ten) 11.313708498984761) ; sqrt(128)
(assert (segment-length zero-to-minus-one) 1.4142135623730951) ; sqrt(2)
(assert (segment-length tricky-ten-to-tricky-ten) 0)

(assert (print-point (midpoint-segment two-to-ten)) six)
(assert (print-point (midpoint-segment zero-to-minus-one)) minus-half)
(assert (print-point (midpoint-segment tricky-ten-to-tricky-ten)) tricky-ten)
