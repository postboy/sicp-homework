; Exercise 3.3.  Modify the make-account procedure so that it creates password-protected accounts. That is, make-account should take a symbol as an additional argument, as in <...>. The resulting account object should process a request only if it is accompanied by the password with which the account was created, and should otherwise return a complaint:

(load "ch31_common.scm")

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (cond ((not (eq? p password)) (lambda (amount) "Incorrect password"))
	  ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT" m))))
  dispatch)

(define acc (make-account 100 'secret-password))
(assert ((acc 'secret-password 'withdraw) 40) 60)
(assert ((acc 'some-other-password 'deposit) 50) "Incorrect password")
