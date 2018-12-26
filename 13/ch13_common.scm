(load "../common.scm")

; s-integral

(define (cube x) (* x x x))

(define (s-integral f a b n)
  (define h (/ (- b a) n))
  (define (y k) (f (+ a (* k h))))
  (define (term k)
    (cond ((or (= k 0) (= k n)) (y k))
	  ((even? k) (* 2 (y k)))
	  (else (* 4 (y k)))))
  (* (/ h 3) (sum term 0 inc n)))

; factorial

(define (inc n) (+ n 1))

(define (identity x) x)

(define (factorial n)
  (product identity 1 inc n))

; test-factorial

(define (test-factorial f)
  (assert (f 0) 1)
  (assert (f 1) 1)
  (assert (f 2) 2)
  (assert (f 3) 6)
  (assert (f 4) 24)
  (assert (f 5) 120))
