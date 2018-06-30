Exercise 1.18.  Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps.

(define (double n)
  (* n 2))

(define (halve n)
  (/ n 2))

(define (even? n)
  (= (remainder n 2) 0))

; quite simple procedure, but it uses substraction

(define (fast-mul-iter a b res)
  (cond ((= b 0) res)
	((= b 2) (fast-mul-iter a 0 (+ res (double a))))
        ((even? b) (fast-mul-iter a (halve b) (+ res (double a))))
        (else (fast-mul-iter a (- b 1) (+ res a)))))

(define (fast-mul a b)
  (fast-mul-iter a b 0))

; TODO: version without substraction

;(define (fast-mul-iter a b count res)
;  (cond ((= count b) res)
;	((> b (double count))) (fast-mul-iter a b (double count) (+ res (double a))))
;	((= b 2) (fast-mul-iter a 0 (+ res (double a))))
;        ((even? b) 
;        (else (fast-mul-iter a b (+ count 1) (+ res a)))))

;(define (fast-mul a b)
;  (fast-mul-iter a b 0 0))

(fast-mul 0 0) ; 0
(fast-mul 0 1) ; 0
(fast-mul 1 0) ; 0
(fast-mul 1 1) ; 1
(fast-mul 1 2) ; 2
(fast-mul 1 3) ; 3
(fast-mul 2 0) ; 0
(fast-mul 2 1) ; 2
(fast-mul 2 2) ; 4
(fast-mul 2 3) ; 6
(fast-mul 3 0) ; 0
(fast-mul 3 1) ; 3
(fast-mul 3 2) ; 6
(fast-mul 3 3) ; 9
(fast-mul 3 4) ; 12
(fast-mul 3 5) ; 15
