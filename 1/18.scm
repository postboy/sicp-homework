; Exercise 1.18.  Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps.

(load "17.scm")

; quite simple procedure, but it uses substraction

(define (fast-mul-iter a b sum)
  (cond ((= b 0) 0)
	((= b 1) (+ a sum))
        ((even? b) (fast-mul-iter (double a) (halve b) sum))
        (else (fast-mul-iter a (- b 1) (+ sum a)))))

; TODO: version without substraction

;(define (fast-mul-iter a b count res)
;  (cond ((= count b) res)
;	((> b (double count))) (fast-mul-iter a b (double count) (+ res (double a))))
;	((= b 2) (fast-mul-iter a 0 (+ res (double a))))
;        ((even? b) 
;        (else (fast-mul-iter a b (+ count 1) (+ res a)))))

(define (fast-mul-i a b)
  (fast-mul-iter a b 0))

(test-mul fast-mul-i)
