; Exercise 3.52.  Consider the sequence of expressions <...>. What is the value of sum after each of the above expressions is evaluated? What is the printed response to evaluating the stream-ref and display-stream expressions? Would these responses differ if we had implemented (delay <exp>) simply as (lambda () <exp>) without using the optimization provided by memo-proc? Explain.

(load "ch35_common.scm")

(define sum 0)
(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
; enum: 1
; seq: 1
(assert sum 1)

(define y (stream-filter even? seq))
; enum: 1 2 3
; seq:  1 3 6
; y: 6
(assert sum 6)

(define z (stream-filter (lambda (x) (= (remainder x 5) 0))
                         seq))
; enum: 1 2 3  4
; seq:  1 3 6 10
; z: 10
(assert sum 10)

(assert (stream-ref y 7) 136)
; enum: 1 2 3  4  5  6  7  8  9 10 11 12 13  14  15  16
; seq:  1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136
; y: 6 10 28 36 66 78 120 136
(assert sum 136)

; display-stream is sort of equivalent to stream->list
(assert (stream->list z) '(10 15 45 55 105 120 190 210))
; enum: 1 2 3  4  5  6  7  8  9 10 11 12 13  14  15  16  17  18  19  20
; seq:  1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171 190 210
; z: see above
(assert sum 210)

; Printed responses to evaluating the stream-ref and display-stream expressions would differ if we had implemented (delay <exp>) simply as (lambda () <exp>). That's because without the optimization provided by memo-proc, all lists would be recalculated from scratch. What's wrong with that beyond of simple inefficiency? enum list would have exactly the same values. On the other hand, sum variable would contain different values during repeating calculations due to side-effects of assignment operator. It means that seq, y and z lists which depend on sum value would get another values too.
