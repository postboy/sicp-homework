; Exercise 3.50.  Complete the following definition, which generalizes stream-map to allow procedures that take multiple arguments, analogous to map in section 2.2.3, footnote 12.

(load "ch35_common.scm")

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define 0to2 (stream-enumerate-interval 0 2))
(define 1to3 (stream-enumerate-interval 1 3))
(define result (stream-map * 0to2 1to3))
(assert (stream-to-list result) '(0 2 6))
