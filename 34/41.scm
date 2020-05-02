; Exercise 3.41.  Ben Bitdiddle worries that it would be better to implement the bank account as follows (where the commented line has been changed): <...> because allowing unserialized access to the bank balance can result in anomalous behavior. Do you agree? Is there any scenario that demonstrates Ben's concern?

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
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
            ((eq? m 'deposit) (protected deposit))
            ((eq? m 'balance)
             ((protected (lambda () balance)))) ; serialized
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))

; That's a difficult question. In general, Ben is right; in this particular case, Ben is probably right.

; As text says, "An even worse failure for this system could occur if the two set! operations attempt to change the balance simultaneously, in which case the actual data appearing in memory might end up being a random combination of the information being written by the two processes. Most computers have interlocks on the primitive memory-write operations, which protect against such simultaneous access."

; Imagine two parallel processes: first process changes balance from 65535 to 0 while another process reads it. Can second process read, say, 255? In other words, do setting and reading a variable are atomic operations in Scheme? I didn't found an answer via Google. If they are then Ben's change is excessive; if they aren't then it makes sense. In this case, it's better to be too pessimistic than to be too optimistic!

; Interesting fact: if we implement Ben's change then parallel reads will no longer be possible due to serialization, despite any conflict between them wasn't possible anyway. This is "readers–writers problem" which can be solved via two different locks: one for writing (blocks other writes and reads) and one for reading (blocks only writes).
