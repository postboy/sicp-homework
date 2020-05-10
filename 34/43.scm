; Exercise 3.43.  Suppose that the balances in three accounts start out as $10, $20, and $30, and that multiple processes run, exchanging the balances in the accounts. Argue that if the processes are run sequentially, after any number of concurrent exchanges, the account balances should be $10, $20, and $30 in some order. Draw a timing diagram like the one in figure 3.29 to show how this condition can be violated if the exchanges are implemented using the first version of the account-exchange program in this section. On the other hand, argue that even with this exchange program, the sum of the balances in the accounts will be preserved. Draw a timing diagram to show how even this condition would be violated if we did not serialize the transactions on individual accounts.

; Process A aka pA: (exchange a1 a2)
; Process B aka pB: (exchange a2 a3)
; Process C aka pC: (exchange a1 a3)

; Processes run sequentially:
; a1	a2	a3	pA			pB			pC
; 10	20	30	a1 balance = 10
;			a2 balance = 20
;			difference = -10
;			a1 withdraw -10
; 20			a2 deposit -10
;	10
;						a2 balance = 10
;						a3 balance = 30
;						difference = -20
;						a2 withdraw -20
;	30					a3 deposit -20
;		10
;									a1 balance = 20
;									a3 balance = 10
;									difference = 10
;									a1 withdraw 10
; 10									a3 deposit 10
;		20

; If processes run sequentially then exchange invariant holds: if acc1 = A and acc2 = B before transaction then acc1 = B and acc2 = A after transaction. This means that if we have accounts with A, B, C balances and sequentially run any number of exchange operations then resulting balances will be A, B, C in some order. After each transaction, there is cases where their ordering changes, there is no cases where their balances get different values except A, B, C in some order.

; Processes run in parallel, first version of exchange is used:
; a1	a2	a3	pA			pB
; 10	20	30	a1 balance = 10
;						a2 balance = 20
;			a2 balance = 20
;						a3 balance = 30
;			difference = -10
;						difference = -10
;			a1 withdraw -10
; 20						a2 withdraw -10
;	30		a2 deposit -10
;	20					a3 deposit -10
;		20

; If processes run in parallel with first version of exchange then exchange invariant does not necesserily holds. On the other hand, the sum of the balances in the accounts is preserved. Each exchange operation is implemented as "withdraw N from one account and deposit N to another account". If this operations are atomic then when series of this two actions are complete, the sum of the balances in the accounts is unchanged.

; Processes run in parallel, unserialized version of exchange is used:
; a1	a2	a3	pA			pB
; 10	20	30	a1 balance = 10
;						a2 balance = 20
;			a2 balance = 20
;						a3 balance = 30
;			difference = -10
;						difference = -10
;			a1 new-balance = 20
;			a1 write 20
; 20						a2 new-balance = 30
;			a2 new-balance = 10
; 20						a2 write 30
;	30		a2 write 10
;	10					a3 new-balance = 20
;						a3 write 20
;		20

; Here we divide withdraw and deposit operations in two suboperaions: calculation of new balance and writing it. Without serialization, this operations can intersperse. As a result, in this case the sum of the balances in the accounts can change: (10 + 20 + 30 =) 60 != 50 (= 20 + 10 + 20).
