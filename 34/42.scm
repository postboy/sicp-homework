; Exercise 3.42.  Ben Bitdiddle suggests that it's a waste of time to create a new serialized procedure in response to every withdraw and deposit message. He says that make-account could be changed so that the calls to protected are done outside the dispatch procedure. That is, an account would return the same serialized procedure (which was created at the same time as the account) each time it is asked for a withdrawal procedure.

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (let ((protected-withdraw (protected withdraw))
          (protected-deposit (protected deposit)))
      (define (dispatch m)
        (cond ((eq? m 'withdraw) protected-withdraw)
              ((eq? m 'deposit) protected-deposit)
              ((eq? m 'balance) balance)
              (else (error "Unknown request -- MAKE-ACCOUNT"
                           m))))
      dispatch)))

; Is this a safe change to make? In particular, is there any difference in what concurrency is allowed by these two versions of make-account?

; The question is, does same serialized procedure instance can run concurrently in different processes?

; Let's look to our definition of serialization: "Serialization creates distinguished sets of procedures such that only one *execution* of a procedure in each serialized set is permitted to happen at a time. If some procedure in the set is being executed, then a process that attempts to execute *any* procedure in the set will be forced to wait until the first execution has finished." The answer is "no".

; It's a safe change to make. There's no difference in concurrency variants allowed by those two versions of make-account.
