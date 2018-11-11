; Exercise 1.13.  Prove that Fib(n) is the closest integer to a^n/5, where a = (1 + sqrt(5))/2. Hint: Let b = (1 - sqrt(5))/2. Use induction and the definition of the Fibonacci numbers (see section 1.2.2) to prove that Fib(n) = (a^n - b^n)/sqrt(5).

; f(n) = (a^n - b^n)/sqrt(5)
; c = sqrt(5)
; f(n) = ( ( (1+c)/2 )^n - ( (1-c)/2 )^n ) / c = ( (1+c)^n - (1-c)^n ) / (2^n * c)

; Let's prove that f(n) = f(n-1) + f(n-2) analogous to Fib(n) = Fib(n-1) + Fib(n-2) for n > 1.
; f(n-1) = ( (1+c)^(n-1) - (1-c)^(n-1) ) / (2^(n-1) * c) = 2 * ( (1+c)^(n-1) - (1-c)^(n-1) ) / (2^n * c)
; f(n-2) = ( (1+c)^(n-2) - (1-c)^(n-2) ) / (2^(n-2) * c) = 4 * ( (1+c)^(n-2) - (1-c)^(n-2) ) / (2^n * c)
; ( (1+c)^n - (1-c)^n ) / (2^n * c) = 2 * ( (1+c)^(n-1) - (1-c)^(n-1) ) / (2^n * c) + 4 * ( (1+c)^(n-2) - (1-c)^(n-2) ) / (2^n * c)
; 2^n * c != 0, so let's divide both parts of equation on it:
; (1+c)^n - (1-c)^n = 2 * ( (1+c)^(n-1) - (1-c)^(n-1) ) + 4 * ( (1+c)^(n-2) - (1-c)^(n-2) )
; (1+c)^n - (1-c)^n = 2 * (1+c)^(n-1) - 2 * (1-c)^(n-1) + 4 * (1+c)^(n-2) - 4 * (1-c)^(n-2)
; (1+c)^n - 2*(1+c)^(n-1) - 4*(1+c)^(n-2) = (1-c)^n - 2*(1-c)^(n-1) - 4*(1-c)^(n-2)
; (1+c)^(n-2) * ( (1+c)^2 - 2*(1+c) - 4  ) = (1-c)^(n-2) * ( (1-c)^2 - 2*(1-c) - 4  )
; (1+c)^2 - 2*(1+c) - 4 = 1 + 2c + c^2 - 2 - 2c - 4 = -5 + c^2 = -5 + 5 = 0
; (1-c)^2 - 2*(1-c) - 4 = 1 - 2c + c^2 - 2 + 2c - 4 = -5 + c^2 = 0
; (1+c)^(n-2) * 0 = (1-c)^(n-2) * 0
; 0 = 0
; Voila, that's true for any n! Step of induction is proved.

; All we have to do now is to prove that this formula uses right initial values at the bottom of recursion. If f(0) = Fib(0) = 0 and f(1) = Fib(1) = 1 then for any n > 0 f(n) = Fib(n).
; f(0) = (a^0 - b^0)/sqrt(5) = (1 - 1)/sqrt(5) = 0
; f(1) = (1 + c - 1 + c) / (2^1 * c) = 2c / 2c = 1
; Initial values are right. It means that overall the formula is right!

; TODO: prove that Fib(n) is the closest integer to a^n/5
