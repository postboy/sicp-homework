; Exercise 1.18.  Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps.

(load "17.scm")

; quite simple procedure, but it uses substraction

(define (fast-mul-iter a b sum)
  (cond ((= b 0) sum)
        ((even? b) (fast-mul-iter (double a) (halve b) sum))
        (else (fast-mul-iter a (- b 1) (+ sum a)))))

(define (fast-mul-i a b)
  (fast-mul-iter a b 0))

(test-mul fast-mul-i)

; But what about Russian peasant algorithm? Honestly, I didn't managed to reinvent it by myself, so googling helped me one more time. It still uses substraction though, but in very subtle way.

(define (fast-mul-iter a b sum)
  (cond ((= b 0) sum)
        ((even? b) (fast-mul-iter (double a) (halve b) sum))
        (else (fast-mul-iter (double a) (halve (- b 1)) (+ sum a)))))

(test-mul fast-mul-i)

; With the following definition of halve we can define function without substraction:
(define (halve n)
  (quotient n 2))

(define (fast-mul-iter a b sum)
  (cond ((= b 0) sum)
        ((even? b) (fast-mul-iter (double a) (halve b) sum))
        (else (fast-mul-iter (double a) (halve b) (+ sum a)))))

; Isn't this beautiful?

(test-mul fast-mul-i)
