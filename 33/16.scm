; Exercise 3.16.  Ben Bitdiddle decides to write a procedure to count the number of pairs in any list structure. ``It's easy,'' he reasons. ``The number of pairs in any structure is the number in the car plus the number in the cdr plus one more to count the current pair.'' So Ben writes the following procedure:

(load "ch33_common.scm")

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

; Show that this procedure is not correct. In particular, draw box-and-pointer diagrams representing list structures made up of exactly three pairs for which Ben's procedure would return 3; return 4; return 7; never return at all.

(define z1 (list 'a 'b 'c))
(assert (count-pairs z1) 3)

; z1->[|][-]->[|][-]->[|][/]
;      a       b       c

(define x (list 'a))
(define z2 (list x x))
(assert (count-pairs z2) 4)

; z2->[|][-]->[|][/]
;      |       |
;      |  +----+
;  x->[|][/]
;      a

(define y (cons x x))
(define z3 (cons y y))
(assert (count-pairs z3) 7)

; z3->[|][|]
;      |  |
;  y->[|][|]
;      |  |
;  x->[|][/]
;      a

(define z4 (list 'a 'b 'c))
(set-cdr! (cddr z4) z4)
; (count-pairs z4)
; Aborting!: maximum recursion depth exceeded

;      +------------------+
;      |                  |
; z4->[|][-]->[|][-]->[|][|]
;      a       b       c
