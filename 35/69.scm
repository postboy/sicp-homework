; Exercise 3.69.  Write a procedure triples that takes three infinite streams, S, T, and U, and produces the stream of triples (Si,Tj,Uk) such that i =< j =< k. Use triples to generate the stream of all Pythagorean triples of positive integers, i.e., the triples (i,j,k) such that i =< j and i^2 + j^2 = k^2.

(load "66.scm")

(define (triples s t u)
 (cons-stream
  (list (stream-car s) (stream-car t) (stream-car u))
  (interleave
   (stream-map (lambda (x) (cons (stream-car s) x))
	       ; first element is thrown away because it has been taken into account in (list...) above
	       (stream-cdr (pairs t u)))
   (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define int-triples (triples integers integers integers))
(assert (stream-head int-triples 15) '((1 1 1) (1 1 2) (2 2 2) (1 2 2) (2 2 3) (1 1 3) (3 3 3) (1 2 3) (2 3 3) (1 1 4) (3 3 4) (1 3 3) (2 2 4) (1 1 5) (4 4 4)))

(define pythagorean-triple
  (stream-filter (lambda (list)
		   (eq? (+ (square (car list)) (square (cadr list))) (square (caddr list))))
		 int-triples))
; warning: slow!
(assert (stream-head pythagorean-triple 5) '((3 4 5) (6 8 10) (5 12 13) (9 12 15) (8 15 17)))
