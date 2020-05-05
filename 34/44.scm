; Exercise 3.44.  Consider the problem of transferring an amount from one account to another. Ben Bitdiddle claims that this can be accomplished with the following procedure, even if there are multiple people concurrently transferring money among multiple accounts, using any account mechanism that serializes deposit and withdrawal transactions, for example, the version of make-account in the text above.

(define (transfer from-account to-account amount)
  ((from-account 'withdraw) amount)
  ((to-account 'deposit) amount))

; Louis Reasoner claims that there is a problem here, and that we need to use a more sophisticated method, such as the one required for dealing with the exchange problem. Is Louis right? If not, what is the essential difference between the transfer problem and the exchange problem? (You should assume that the balance in from-account is at least amount.)

; There's no problem here. Withdraw and deposit operations are serialized, so there's clearly no problem with them per se. Is there any problem with transfer procedure as a combination of those procedures? No, because this operation is nothing more than their combination. If withdraw and deposit work right then the whole operation works right.

; This is the essential difference from exchange problem because the latter is more than a combination of two operations. We expect that one more invaraint should hold: if acc1 = A and acc2 = B before transaction then acc1 = B and acc2 = A after transaction. To make this invariant hold, we had to make complex serialiazed-exchange procedure.
