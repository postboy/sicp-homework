; Exercise 3.15.  Draw box-and-pointer diagrams to explain the effect of set-to-wow! on the structures z1 and z2 above.

(load "ch33_common.scm")

(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)

(assert z1 '((a b) a b))
(assert (set-to-wow! z1) '((wow b) wow b))

; z1->[|][|]
;      |  |
;  x->[|][-]->[|][/]
;     wow      b

(assert z2 '((a b) a b))
(assert (set-to-wow! z2) '((wow b) a b))

; z1->[|][-]->[|][-]->[|][/]
;      |       a       |
;      |               |
;     [|][-]->[|][/]   |
;     wow      b-------+
