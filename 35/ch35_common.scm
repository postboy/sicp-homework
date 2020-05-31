(load "../common.scm")

; stream constructors

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

; specific streams

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

; stream operations

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; stream operations for testing

(define (stream-part-for-each proc s n)
  (if (or (stream-null? s) (= n 0))
      'done
      (begin (proc (stream-car s))
             (stream-part-for-each proc (stream-cdr s) (- n 1)))))

(define (list-to-stream list)
  (if (null? list)
      the-empty-stream
      (cons-stream (car list)
		   (list-to-stream (cdr list)))))

(define (display-line x)
  (newline)
  (display x))

(define (display-stream s)
  (stream-for-each display-line s))

(define (sign-change-detector cur prev)
  (cond ((and (>= prev 0) (< cur 0)) -1)
	((and (>= cur 0) (< prev 0)) 1)
	(else 0)))

; test data

(define sense-data (list-to-stream '(1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4 -1)))
