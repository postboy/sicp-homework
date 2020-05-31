; Exercise 3.76.  Eva Lu Ator has a criticism of Louis's approach in exercise 3.75. The program he wrote is not modular, because it intermixes the operation of smoothing with the zero-crossing extraction. For example, the extractor should not have to be changed if Alyssa finds a better way to condition her input signal. Help Louis by writing a procedure smooth that takes a stream as input and produces a stream in which each element is the average of two successive input stream elements. Then use smooth as a component to implement the zero-crossing detector in a more modular style.

(load "ch35_common.scm")

(define (smooth s prev)
  (define cur (stream-car s))
  (cons-stream (/ (+ cur prev) 2)
	       (smooth (stream-cdr s) cur)))

(define (make-zero-crossings input-stream last-value)
  (let ((value (stream-car input-stream)))
    (cons-stream (sign-change-detector value last-value)
		 (make-zero-crossings (stream-cdr input-stream)
				      value))))

(define zero-crossings (make-zero-crossings (smooth sense-data 0) 0))
(assert (stream-head zero-crossings 13) '(0 0 0 0 0 0 -1 0 0 0 0 1 0))
