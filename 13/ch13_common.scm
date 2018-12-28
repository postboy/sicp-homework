(load "../common.scm")

; s-integral

(define (cube x) (* x x x))

(define (sum term a next b)
  (accumulate + 0 term a next b))

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

(define (product term a next b)
  (accumulate * 1 term a next b))

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

; fixed-point

(define tolerance 0.00001)

(define (fixed-point-internal f first-guess print?)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess i)
    (let ((next (f guess)))
      (cond (print?
	     (display-all i ": " next) (newline)))
      (if (close-enough? guess next)
          next
          (try next (inc i)))))
  (try first-guess 1))

(define (fixed-point f first-guess)
  (fixed-point-internal f first-guess #f))

(define (fixed-point-dbg f first-guess)
  (fixed-point-internal f first-guess #t))

; newtons-method

(define dx 0.00001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))
