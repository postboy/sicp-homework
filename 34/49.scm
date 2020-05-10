; Exercise 3.49.  Give a scenario where the deadlock-avoidance mechanism described above does not work. (Hint: In the exchange problem, each process knows in advance which accounts it will need to get access to. Consider a situation where a process must get access to some shared resources before it can know which additional shared resources it will require.)

; Consider the banking system where users can setup automatic payments. Alice configures her account to send some money to Bob on first day of every month; Bob configures his account to send some money to Alice on first day of every month. Banking system runs automatic payments in parallel for the sake of efficiency.

; First day of some month. First process wants to read and modify (specifically, decrease balance and log an operation) Alice's account, so it acquires lock on it and reads it. Similarly, second process wants to read and modify Bob's account, so it acquires lock on it and reads it.

; Alice's account is configured to send money to Bob, i.e. to modify Bob's account. First process tries to acquire lock for Bob's account and can't do it because another process were already acquired it, so this process waits.

; Bob's account is configured to send money to Alice, i.e. to modify Alice's account. Second process tries to acquire lock for Alice's account and can't do it because another process were already acquired it, so this process waits.

; Deadlock happens because neither of those processes can proceed. Reader can correctly argue that we could avoid deadlock by releasing locks after say withdrawing money (see 3.44). However, main point is still valid: it doesn't matter if accounts are numbered for cases where we don't know the list of all needed locks at the start of serialized operation. Above you can see a (maybe contrived) example of such operation.
