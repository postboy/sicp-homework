Exercise 1.4.  Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

To evaluate the body of the procedure we should evaluate the only expression in it, ((if (> b 0) + -) a b).
To evaluate this expression we should evaluate all subexpressions in it, i.e. evaluate (if (> b 0) + -) subexpression, which determines kind of operand to be applied to a and b.
After this evaluation, operand is either + or -, operands are a and b, so we should apply operand to operands. Result of this evaluation is the result of the expression and of the procedure.
