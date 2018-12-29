; Exercise 1.36.  Modify fixed-point so that it prints the sequence of approximations it generates, using the newline and display primitives shown in exercise 1.22. Then find a solution to x^x = 1000 by finding a fixed point of x -> log(1000)/log(x). (Use Scheme's primitive log procedure, which computes natural logarithms.) Compare the number of steps this takes with and without average damping. (Note that you cannot start fixed-point with a guess of 1, as this would cause division by log(1) = 0.)

(load "ch13_common.scm")

(fixed-point-dbg (lambda (x) (/ (log 1000) (log x))) 2.0)             ; 4.555532270803653, 34 iterations
(fixed-point-dbg (lambda (x) (average (/ (log 1000) (log x)) x)) 2.0) ; 4.555537551999825, 9 iterations
