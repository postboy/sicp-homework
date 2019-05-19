; Exercise 2.55.  Eva Lu Ator types to the interpreter the expression <...>. To her surprise, the interpreter prints back quote. Explain.

(load "ch22_common.scm")

(assert 'quote (car ''abracadabra))

; Let's see reductions for this expression:
; (car ''abracadabra)
; Let's translate syntactic sugar into function calls:
; (car (quote (quote abracadabra)))
; What is (quote (quote abracadabra))? Surprisingly, interpreter says that (quote abracadabra).

(assert '(quote abracadabra) ''abracadabra)

; Turns out that quote is executed immediately after it is found in expression, in contrast to other functions. In other words, quote is a special form. How to explain this?
; First of all, note how easy we can represent "quote" element in the list. I'm sure this can be very useful. Now, let's imagine that quote works like any other function.
; (quote (quote abracadabra-as-expression))
; (quote abracadabra-as-object)
; What's next, abracadabra-as-object again? Maybe, but it's not very useful. On the other hand, this way we have a problem with representing a "quote" element in the list: how to do it now? Looks like there's no easy answer.
