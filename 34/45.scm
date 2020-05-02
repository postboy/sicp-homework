; Exercise 3.45.  Louis Reasoner thinks our bank-account system is unnecessarily complex and error-prone now that deposits and withdrawals aren't automatically serialized. He suggests that make-account-and-serializer should have exported the serializer (for use by such procedures as serialized-exchange) in addition to (rather than instead of) using it to serialize accounts and deposits as make-account did. He proposes to redefine accounts as follows:

(load "ch34_common.scm")

(define (make-account-and-serializer balance)
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
      (cond ((eq? m 'withdraw) (balance-serializer withdraw))
            ((eq? m 'deposit) (balance-serializer deposit))
            ((eq? m 'balance) balance)
            ((eq? m 'serializer) balance-serializer)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

; Then deposits are handled as with the original make-account:

(define (deposit account amount)
 ((account 'deposit) amount))

; Explain what is wrong with Louis's reasoning. In particular, consider what happens when serialized-exchange is called.

(define hundred (make-account-and-serializer 100))
(define ten (make-account-and-serializer 10))

; Louis is wrong because it's super-easy to add usage of serializer to wrapper function. Message passing should be considered an implementation detail, so clients shouldn't use it directly. For them (as users of wrappers) nothing changes at all.

; Another point: at first we used serializer only internally, then we started to use in only externally. What Louis suggests is error-prone and bad from conceptual point of view: let's use serializer both externally and internally! At best, it's excessive; at worst, it's just wrong.

; Warning: it hangs Scheme!
;(serialized-exchange hundred ten)

; serialized-exchange is executing serialized (under sets hundred, ten) function exchange, which in turn tries to execute serialized (under set hundred) function withdraw. This function can't run because only one serialized function from a set can be run at a time, and now this is exchange function. Boom, deadlock happened: serialized-exchange cannot proceed because it blocks itself.
