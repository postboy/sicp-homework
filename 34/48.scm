; Exercise 3.48.  Explain in detail why the deadlock-avoidance method described above, (i.e., the accounts are numbered, and each process attempts to acquire the smaller-numbered account first) avoids deadlock in the exchange problem. Rewrite serialized-exchange to incorporate this idea. (You will also need to modify make-account so that each account is created with a number, which can be accessed by sending an appropriate message.)

; Deadlock happens when two process simultaneously try to acquire two locks in different order. First process acquires first lock and waits for the second lock; second process acquires second lock and waits for the first lock; two processes block each other's execution.

; When we construct processes in such way that they always acquire several locks in the same order, we eliminate the reason why deadlock can happen. If second process waits for the first to release first lock then first process just can't wait for the second to release second lock. If some process acquired N-th lock then it's either acquired or didn't needed every lock with number before N. This way, if some conflict occurs, one process always wins the race and continues execution while another waits for it to complete; the problem with deadlock was that neither of two processes could win the race.

(load "ch34_common.scm")

(define (make-account-and-serializer number balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance)
	    ((eq? m 'number) number)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

(define (balance account)
  (account 'balance))

(define (serialized-exchange account1 account2)
  (let ((number1 (account1 'number))
        (number2 (account2 'number))
	(serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    (cond ((< number1 number2)
	   ((serializer2 (serializer1 exchange))
	    account1
	    account2))
	  ((> number1 number2)
	   ((serializer1 (serializer2 exchange))
	    account1
	    account2))
	  (else
	   (error "account numbers are equal:" number1 number2)))))

(define acc1 (make-account-and-serializer 1 10))
(define acc2 (make-account-and-serializer 2 20))
(assert (balance acc1) 10)
(assert (balance acc2) 20)
(serialized-exchange acc1 acc2)
(assert (balance acc1) 20)
(assert (balance acc2) 10)
(serialized-exchange acc2 acc1)
(assert (balance acc1) 10)
(assert (balance acc2) 20)
; produces error message
; (serialized-exchange acc1 acc1)
