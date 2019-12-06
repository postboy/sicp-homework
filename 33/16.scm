; Exercise 3.16.  Ben Bitdiddle decides to write a procedure to count the number of pairs in any list structure. ``It's easy,'' he reasons. ``The number of pairs in any structure is the number in the car plus the number in the cdr plus one more to count the current pair.'' So Ben writes the following procedure:

(load "ch33_common.scm")

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))

; Show that this procedure is not correct. In particular, draw box-and-pointer diagrams representing list structures made up of exactly three pairs for which Ben's procedure would return 3; return 4; return 7; never return at all.

(assert (count-pairs '(a b c)) 3)

; z1->[|][-]->[|][-]->[|][/]
;      a       b       c

(define x (list 'a))
(assert (count-pairs (list x x)) 4)

; z2->[|][-]->[|][/]
;      |       |
;      |  +----+
;  x->[|][/]
;      a

(define x (list 'a))
(define y (cons x x))
(assert (count-pairs (cons y y)) 7)

; z3->[|][|]
;      |  |
;  y->[|][|]
;      |  |
;  x->[|][/]
;      a

(define x (list 'a 'b 'c))
(set-cdr! (cddr x) x)
; (count-pairs x)
; Aborting!: maximum recursion depth exceeded

;      +------------------+
;      |                  |
; z4->[|][-]->[|][-]->[|][|]
;      a       b       c
