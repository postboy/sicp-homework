; Exercise 4.25.  Suppose that (in ordinary applicative-order Scheme) we define unless as shown above and then define factorial in terms of unless as

(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

; What happens if we attempt to evaluate (factorial 5)? Will our definitions work in a normal-order language?

; (factorial 5)
; Aborting!: maximum recursion depth exceeded
; This recursive call will never return because "unless" is not a special form and our language is applicative-order one. When we used "if" special form and evaluated (factorial 1), we lazily didn't evaluated (* n (factorial (- n 1))). Now to evaluate (factorial 1) we first have to evaluate (* n (factorial (- n 1))) as argument of "unless" (despite we won't ever need it), i.e. to evaluate (factorial 0) and subsequent multiplication. This in turn requires evaluation of (factorial -1) and so on. Stack overflow occurs because the process is recursive, so every new "factorial" procedure call allocates additional space on the stack until there is no more space.

; Our definition will work fine in a normal-order language. When computing (factorial 1), evaluator will postpone evaluation of (* n (factorial (- n 1))) expression, then it will determine that expression's result is not needed because condition (= n 1) holds, so expression wouldn't be evaluated at all.
