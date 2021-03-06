; Exercise 3.4.  Modify the make-account procedure of exercise 3.3 by adding another local state variable so that, if an account is accessed more than seven consecutive times with an incorrect password, it invokes the procedure call-the-cops.

(load "ch31_common.scm")

; To simplify tests, let's change task to "more than one consecutive times" without losing generality.

(define (make-account balance password)
  (let ((consec-failed-attempts 0))
    (define (withdraw amount)
      (if (>= balance amount)
	  (begin (set! balance (- balance amount))
		 balance)
	  "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)
    (define (call-the-cops unused) "Cops are called")
    (define (should-call-the-cops?) (> consec-failed-attempts 1))
    (define (correct-password) (set! consec-failed-attempts 0))
    (define (incorrect-password unused)
      ; here we assume that overflow is impossible
      (set! consec-failed-attempts (inc consec-failed-attempts))
      (if (should-call-the-cops?)
	  (call-the-cops 0)
	  "Incorrect password"))
    (define (dispatch p m)
      (cond ((should-call-the-cops?) call-the-cops)
	    ((not (eq? p password)) incorrect-password)
	    (else (correct-password)
		  (cond ((eq? m 'withdraw) withdraw)
			((eq? m 'deposit) deposit)
			(else (error "Unknown request -- MAKE-ACCOUNT" m))))))
    dispatch))

(define acc (make-account 100 'secret-password))
(assert ((acc 'secret-password 'withdraw) 40) 60)
(assert ((acc 'some-other-password 'deposit) 40) "Incorrect password")
(assert ((acc 'secret-password 'deposit) 40) 100)
(assert ((acc 'some-other-password 'withdraw) 40) "Incorrect password")
(assert ((acc 'secret-password 'withdraw) 40) 60)
(assert ((acc 'some-other-password 'deposit) 1) "Incorrect password")
(assert ((acc 'some-other-password 'deposit) 1) "Cops are called")
(assert ((acc 'secret-password 'deposit) 1) "Cops are called")
