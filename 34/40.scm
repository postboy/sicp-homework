; Exercise 3.40.  Give all possible values of x that can result from executing

(load "ch34_common.scm")

(define x 10)
(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (* x x x))))
; Unfortunately, I always get 10^6 here.
; (display x)

; Here we have seven distinct fragments:
; RA: (read x)
; RA: (read x)
; RB: (read x)
; RB: (read x)
; RB: (read x)
; W1: (set! x (* RA RA))
; W2: (set! x (* RB RB RB))
; Order of argument evaluation is unspecified, but in our case it doesn't matter. RA stands for "one of reads in process A", results of such reads are do not necesserily the same.

; RA goes after RA.
; RB goes after RB.
; RB goes after RB.
; W1 goes after its prerequisites RA, RA.
; W2 goes after its prerequisites RB, RB, RB.

; 1. (RA RA) W1 (RB  RB   RB) W2 = (10^2)^3 = 10^6
; 2. (RA RA  RB) W1 (RB   RB) W2 = 10*10^2*10^2 = 10^5
; 3. (RA RA  RB  RB) W1  (RB) W2 = 10*10*10^2 = 10^4
; 4. (RA RA  RB  RB  RB)  W1  W2 = 10^3
; 5. (RA RA  RB  RB  RB)  W2  W1 = 10^2
; 6. (RA RB  RB  RB) W2  (RA) W1 = 10*10^3 = 10^4
; 7. (RB RB  RB) W2 (RA   RA) W1 = (10^3)^2 = 10^6
; Here parens mean "those in any possible order between them". As we can see, possible values are 10^2, 10^3, 10^4, 10^5, 10^6.

; Which of these possibilities remain if we instead use serialized procedures:

(define x 10)
(define s (make-serializer))
(parallel-execute (s (lambda () (set! x (* x x))))
                  (s (lambda () (set! x (* x x x)))))
; (display x)

; Only 10^6, because it's the result of 1st and 7th orders of execution, which are now the only possible orders thanks to serializer.
