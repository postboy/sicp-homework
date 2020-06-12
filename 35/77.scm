; Exercise 3.77.  The integral procedure used above was analogous to the ``implicit'' definition of the infinite stream of integers in section 3.5.2. Alternatively, we can give a definition of integral that is more like integers-starting-from (also in section 3.5.2): <...> When used in systems with loops, this procedure has the same problem as does our original version of integral. Modify the procedure so that it expects the integrand as a delayed argument and hence can be used in the solve procedure shown above.

(load "ch35_common.scm")

(define (integral delayed-integrand initial-value dt)
  (cons-stream initial-value
	       (let ((integrand (force delayed-integrand)))
		 (if (stream-null? integrand)
		     the-empty-stream
		     (integral (delay (stream-cdr integrand))
			       (+ (* dt (stream-car integrand))
				  initial-value)
			       dt)))))

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(assert (stream-ref (solve (lambda (y) y) 1 0.001) 1000) 2.716923932235896)
