; Exercise 3.7.  Consider the bank account objects created by make-account, with the password modification described in exercise 3.3. Suppose that our banking system requires the ability to make joint accounts. Define a procedure make-joint that accomplishes this. Make-joint should take three arguments. The first is a password-protected account. The second argument must match the password with which the account was defined in order for the make-joint operation to proceed. The third argument is a new password. Make-joint is to create an additional access to the original account using the new password. For example, if peter-acc is a bank account with password open-sesame, then <...> will allow one to make transactions on peter-acc using the name paul-acc and the password rosebud. You may wish to modify your solution to exercise 3.3 to accommodate this new feature.

(load "3.scm")

(define (make-joint parent parent-password password)
  ; As we've seen in 3.4, invalid password handling can be quite sophisticated. Let's delegate as much as we can to parent account.
  (define invalid-password '***SPECIAL-VALUE-INVALID-PASSWORD***)
  (define (dispatch p m)
    (if (eq? p password)
	(parent parent-password m)
	(parent invalid-password invalid-password)))
  dispatch)

(define peter-acc (make-account 100 'open-sesame))
(assert ((peter-acc 'open-sesame 'withdraw) 40) 60)
(define paul-acc (make-joint peter-acc 'open-sesame 'rosebud))
(assert ((paul-acc 'wrong-password 'withdraw) 10) "Incorrect password")
(assert ((paul-acc 'rosebud 'withdraw) 10) 50)
(assert ((peter-acc 'open-sesame 'withdraw) 10) 40)
