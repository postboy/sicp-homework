; Exercise 2.38.  The accumulate procedure is also known as fold-right, because it combines the first element of the sequence with the result of combining all the elements to the right. There is also a fold-left, which is similar to fold-right, except that it combines elements working in the opposite direction.

(load "ch22_common.scm")

(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(assert 3/2 (fold-right / 1 '(1 2 3)))
(assert 1/6 (fold-left / 1 '(1 2 3)))
(assert '(1 (2 (3 ()))) (fold-right list nil '(1 2 3)))
(assert '(((() 1) 2) 3) (fold-left list nil '(1 2 3)))

; Give a property that op should satisfy to guarantee that fold-right and fold-left will produce the same values for any sequence.

; Op should be commutativite and associative for guaranteeing that (fold-right op init seq) = (fold-left op init seq).
; Let's suppose that op is not commutative, i.e. in general (op x y) != (op y x). It means that if seq = (x), then (fold-right op init seq) = (op x init) != (op init x) = (fold-left op init seq), and we have a contradiction.
; Let's suppose that op is not associative, i.e. in general (op x (op y z)) != (op (op x y) z). It means that if seq = (x y), then (fold-right op init seq) = (op x (y init)) != (op (op init x) y) = (fold-left op init seq), and we have a contradiction.

(assert 6 (fold-left * 1 '(1 2 3)))
(assert 6 (fold-right * 1 '(1 2 3)))
