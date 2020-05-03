; Exercise 3.46.  Suppose that we implement test-and-set! using an ordinary procedure as shown in the text, without attempting to make the operation atomic. Draw a timing diagram like the one in figure 3.29 to demonstrate how the mutex implementation can fail by allowing two processes to acquire the mutex at the same time.

(define (test-and-set! cell)
  (if (car cell)
      true
      (begin (set-car! cell true)
             false)))

; Here we have two distinct fragments:
; R: (read (car cell))
; W: (set-car! cell true)

; W may go or not go after R.

; (car cell)	A		B
; false
;		read false
;				read false
;		write true
; true				write true
; true
