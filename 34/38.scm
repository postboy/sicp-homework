; Exercise 3.38.  Suppose that Peter, Paul, and Mary share a joint bank account that initially contains $100. Concurrently, Peter deposits $10, Paul withdraws $20, and Mary withdraws half the money in the account, by executing the following commands:

; A aka Peter: (set! balance (+ balance 10))
; B aka Paul:  (set! balance (- balance 20))
; C aka Mary:  (set! balance (- balance (/ balance 2)))

; a. List all the different possible values for balance after these three transactions have been completed, assuming that the banking system forces the three processes to run sequentially in some order.

; ABC: $45
; BAC: same
; ACB: $35
; BCA: $50
; CAB: $40
; CBA: same

; b. What are some other values that could be produced if the system allows the processes to be interleaved? Draw timing diagrams like the one in figure 3.29 to explain how these values can occur.

; $110
; Bank	C		B		A
; 100
;	read 100
;			read 100
;					read 100
;	new = 50
;			new = 80
;					new = 110
;	write 50
; 50			write 80
; 80					write 110
; 110

; $30
; Bank	C		B		A
; 100
;	read 100
;					read 100
;	new = 50
;					new = 110
;	write 50
; 50			read 50
;					write 110
; 110			new = 30
;			write 30
; 30
